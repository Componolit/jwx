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

with JWX.Base64;
with JWX.JSON;
with JWX.Util;
with JWX.JWK;
with JWX.Crypto;
with JWX.JWSCS;
with JWX.JOSE;
with Ada.Text_IO; use Ada.Text_IO;

with LSC.HMAC_SHA256;

use JWX;

package body JWX.JWS
   with
      SPARK_Mode
is
   ----------------------
   -- Validate_Compact --
   ----------------------

   procedure Validate_Compact (Data     :     String;
                               Key_Data :     String;
                               Result   : out Result_Type)
   is
      use JWX.Base64;

      package Token is new JWX.JWSCS (Data);
   begin
      Result := Result_Invalid;

      if not Token.Valid
      then
         return;
      end if;

      declare
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
            return;
         end if;

         if L.Valid (J.Algorithm)
         then
            Result := Result_OK;
            return;
         end if;
      end;

      Result := Result_Fail;

   end Validate_Compact;

end JWX.JWS;
