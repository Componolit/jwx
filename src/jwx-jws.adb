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

   package Token is new JWX.JWSCS (Data);

   function Valid return Boolean is (Token.Valid);

   ----------------------
   -- Validate_Compact --
   ----------------------

   procedure Validate_Compact (Result : out Result_Type)
   is
   begin
      Result := Result_Invalid;

      if not Token.Valid
      then
         return;
      end if;

      declare
         Valid           : Boolean;
         Jose_Data       : constant JWX.Data_Type := Token.Jose_Data;
         Signature_Input : constant JWX.Data_Type := Token.Signature_Input;
         Signature       : constant JWX.Data_Type := Token.Signature;

         package J is new JWX.JOSE (Jose_Data);
         package L is new JWX.Crypto (Payload => Signature_Input,
                                      Auth    => Signature,
                                      Key     => Key_Data);
      begin
         if not J.Valid
         then
            return;
         end if;

         L.Valid (J.Algorithm, Valid);
         if Valid then
            Result := Result_OK;
            return;
         end if;
      end;

      Result := Result_Fail;

   end Validate_Compact;

   -------------
   -- Payload --
   -------------

   function Payload return String
   is
   begin
      return Token.Payload;
   end Payload;

end JWX.JWS;
