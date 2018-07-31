--
-- \brief  JWS validation (RFC 7515)
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX.Crypto;
with JWX.JWSCS;
with JWX.JOSE;

use JWX;

package body JWX.JWS
is

   ----------------------
   -- Validate_Compact --
   ----------------------

   function Validate_Compact (Data     : String;
                              Key_Data : String) return Result_Type
   is
      Valid  : Boolean;
      Result : Result_Type;
      package Token is new JWX.JWSCS (Data);
   begin
      Token.Split (Valid);
      if not Valid
      then
         return Result_Invalid;
      end if;

      declare
         Valid           : Boolean;
         Jose_Data       : constant String := Token.Jose_Data;
         Signature_Input : constant String := Token.Signature_Input;
         Signature       : constant String := Token.Signature;

         package J is new JWX.JOSE (Jose_Data);
         package L is new JWX.Crypto (Payload => Signature_Input,
                                      Auth    => Signature,
                                      Key     => Key_Data);
      begin
         if not J.Valid
         then
            return Result_Invalid;
         end if;

         pragma Warnings (Off, "unused assignment to ""Key_");
         L.Valid (J.Algorithm, Valid);
         pragma Warnings (On, "unused assignment to ""Key_");
         if not Valid then
            return Result_Fail;
         end if;
      end;

      return Result_Type'(Error => Error_OK,
                          First => Token.Payload_First,
                          Last  => Token.Payload_Last);

   end Validate_Compact;

end JWX.JWS;
