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

      package JOSE is new JWX.JSON (10000);
      use type JOSE.Match_Type;
      use type JOSE.Index_Type;
      Match_JOSE  : JOSE.Match_Type;
      JOSE_Alg    : JOSE.Index_Type;
      Alg         : Alg_Type;
      JOSE_Length : Natural;

      package Token is new JWX.JWSCS (Data);
   begin
      Result := Result_Invalid;

      if not Token.Valid
      then
         return;
      end if;

      declare
         Jose_Data   : JWX.Byte_Array (1 .. 100);
         Jose_Text   : String (1 .. Jose_Data'Length);
      begin

         -- Decode JOSE header
         Decode_Url (Encoded => Token.JOSE_Data,
                     Length  => JOSE_Length,
                     Result  => JOSE_Data,
                     Padding => Padding_Implicit);
         if JOSE_Length = 0
         then
            return;
         end if;

         -- Parse JOSE header
         Util.To_String (Data   => JOSE_Data (JOSE_Data'First .. JOSE_Data'First + JOSE_Length - 1),
                         Result => JOSE_Text);
         JOSE.Parse (JOSE_Text, Match_JOSE);
         if Match_JOSE /= JOSE.Match_OK
         then
            return;
         end if;
      end;

      JOSE_Alg := JOSE.Query_Object ("alg");
      if JOSE_Alg = JOSE.End_Index
      then
         return;
      end if;

      Alg := Algorithm (JOSE.Get_String (JOSE_Alg));

      declare
         package L is new JWX.Crypto (Payload => Token.Signature_Input,
                                      Auth    => Token.Signature,
                                      Key     => Key_Data);
      begin
         if L.Valid (Alg)
         then
            Result := Result_OK;
            return;
         end if;
      end;

      Result := Result_Fail;

   end Validate_Compact;

end JWX.JWS;
