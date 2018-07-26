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

      if Data'Length >= Integer'Last - 2 or
        Data'Length <= 0
      then
         return;
      end if;

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

      pragma Assert (Data'Length < Integer'Last);
      declare
         Len : Natural;
         Payload : constant String := J.Payload;
      begin

         if Payload'Length <= 0 or
           Payload'Length >= Natural'Last / 9 or
           Payload'Last >= Natural'Last - 4
         then
            return;
         end if;

         declare
            JSON_Input : String (1 .. Payload'Length + 2);
            Decoded    : Byte_Array (1 .. 3 * ((Payload'Length + 3) / 4));
            use Base64;
         begin

            Decode_Url (Payload, Len, Decoded);
            if Len = 0
            then
               Result := Result_Invalid_Base64;
               return;
            end if;

            pragma Assert (JSON_Input'Length >= 3 * ((Payload'Length + 3) / 4));
            Util.To_String (Decoded, JSON_Input);

            declare
               Input : constant String := JSON_Input;
               package Token is new JWX.JSON (Input);
               use Token;
               Match : Match_Type;
               Value : Index_Type;
            begin
               Parse (Match);
               if Match /= Match_OK
               then
                  return;
               end if;
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

               if Get_Kind (Value) /= Kind_String or else
                 Get_String (Value) /= Issuer
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

               if Get_Kind (Value) /= Kind_String or else
                 Get_String (Value) /= Audience
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

               if Get_Kind (Value) /= Kind_Integer or else
                 Long_Integer (Get_Integer (Value)) < Now
               then
                  return;
               end if;
             end;
         end;

         Result := Result_OK;
         return;
      end;

   end Validate_Compact;

end JWX.JWT;
