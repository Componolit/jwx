--
--  @summary JWT validation (RFC 7519)
--  @author  Alexander Senier
--  @date    2018-06-08
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX.JWS;
with JWX.JSON;
with JWX.Base64;
with JWX.Util;

package body JWX.JWT
is

   function Validate_Compact (Data     : String;
                              Key_Data : String;
                              Audience : String;
                              Issuer   : String;
                              Now      : Long_Integer) return Result_Type
   is
      use JWS;
      R : JWS.Result_Type;
   begin
      if Data'Length >= Integer'Last - 2 or
        Data'Length = 0
      then
         return Result_Invalid;
      end if;

      R := JWS.Validate_Compact (Data, Key_Data);
      if R.Error /= Error_OK
      then
         case R.Error is
            when Error_Invalid     => return Result_Invalid;
            when Error_Invalid_Key => return Result_Invalid_Key;
            when Error_Fail        => return Result_Fail;
            when Error_OK          => null;
         end case;
      end if;

      pragma Assert (Data'Length < Integer'Last);
      declare
         Len : Natural;
         Payload : constant String := Data (R.Payload.First .. R.Payload.Last);
      begin

         if Payload'Length = 0 or
           Payload'Length >= Natural'Last / 9 or
           Payload'Last >= Natural'Last - 4
         then
            return Result_Invalid;
         end if;

         declare
            JSON_Input : String (1 .. Payload'Length + 2);
            Decoded    : Byte_Array (1 .. 3 * ((Payload'Length + 3) / 4));
            use Base64;
         begin

            Decode_Url (Payload, Len, Decoded);
            if Len = 0
            then
               return Result_Invalid_Base64;
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
               pragma Warnings (Off, "unused assignment to ""Offset""");
               Parse (Match);
               pragma Warnings (On, "unused assignment to ""Offset""");
               if Match /= Match_OK
               then
                  return Result_Invalid;
               end if;
               if Get_Kind /= Kind_Object
               then
                  return Result_Invalid_Object;
               end if;

               --  Check issuer
               Value := Query_Object ("iss");
               if Value = Token.End_Index
               then
                  return Result_Invalid_Issuer;
               end if;

               if Get_Kind (Value) /= Kind_String or else
                 Get_String (Value) /= Issuer
               then
                  return Result_Invalid_Issuer;
               end if;

               --  Check audience
               Value := Query_Object ("aud");
               if Value = Token.End_Index
               then
                  return Result_Invalid_Audience;
               end if;

               if Get_Kind (Value) /= Kind_String or else
                 Get_String (Value) /= Audience
               then
                  return Result_Invalid_Audience;
               end if;

               --  Check expiration
               Value := Query_Object ("exp");
               if Value = Token.End_Index
               then
                  return Result_Expired;
               end if;

               if Get_Kind (Value) /= Kind_Integer or else
                 Long_Integer (Get_Integer (Value)) < Now
               then
                  return Result_Expired;
               end if;
            end;
         end;

         return Result_OK;
      end;

   end Validate_Compact;

end JWX.JWT;
