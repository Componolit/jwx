--
-- \brief  JWT validation (RFC 7519)
-- \author Alexander Senier
-- \date   2018-06-08
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX.JWS;
with JWX.JSON;
with JWX.Base64;
with JWX.Util;

package body JWX.JWT
is
   procedure Validate_Compact (Result : out Result_Type)
   is
      package J is new JWX.JWS (Data     => Data,
                                Key_Data => Key_Data);
      use J;
      Validate_Result : J.Result_Type;
   begin
      Result := Result_Invalid;

      J.Validate_Compact (Validate_Result);
      if Validate_Result /= J.Result_OK
      then
         case Validate_Result is
            when J.Result_Invalid     => Result := Result_Invalid;
            when J.Result_Invalid_Key => Result := Result_Invalid_Key;
            when J.Result_Fail        => Result := Result_Fail;
            when J.Result_OK          => null;
         end case;
         return;
      end if;

      declare
         Data : constant String := J.Payload;
         use Base64;
         Len   : Natural;
         Decoded    : Byte_Array (1 .. Data'Length);
         JSON_Input : String (1 .. Data'Length);
      begin
         Decode_Url (Data, Len, Decoded);
         if Len = 0
         then
            Result := Result_Invalid_Base64;
            return;
         end if;

         Util.To_String (Decoded, JSON_Input);

         declare
            package Token is new JWX.JSON (JSON_Input);
            use Token;
            Match : Match_Type;
            Value : Index_Type;
         begin
            Parse (Match);
            if Get_Kind /= Kind_Object
            then
               Result := Result_Invalid_Object;
               return;
            end if;

            -- Check issuer
            Result := Result_Invalid_Issuer;
            Value := Query_Object ("iss");
            if Value = End_Index
            then
               return;
            end if;

            if Get_String (Value) /= Issuer
            then
               return;
            end if;

            -- Check audience
            Result := Result_Invalid_Audience;
            Value := Query_Object ("aud");
            if Value = End_Index
            then
               return;
            end if;

            if Get_String (Value) /= Audience
            then
               return;
            end if;

            -- Check expiration
            Result := Result_Expired;
            Value := Query_Object ("exp");
            if Value = End_Index
            then
               return;
            end if;

            if Get_Integer (Value) < Now
            then
               return;
            end if;
         end;

         Result := Result_OK;
         return ;
      end;

   end Validate_Compact;

end JWX.JWT;
