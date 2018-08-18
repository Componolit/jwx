--
--  @summary Cryptographic validation of JWT payload.
--  @author  Alexander Senier
--  @date    2018-06-06
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX.JWK;
with JWX.Base64;
with JWX.Libsparkcrypto;
with JWX.Util;

with LSC.Types;
with LSC.SHA256;
with LSC.HMAC_SHA256;

use type LSC.SHA256.Message_Index;

package body JWX.Crypto
is
   -----------------------
   -- Valid_HMAC_SHA256 --
   -----------------------

   procedure Valid_HMAC_SHA256 (Valid_MAC : out Boolean)
   with
      Pre => Key'First >= 0 and
             Key'Last < Natural'Last and
             Key'First <= Key'Last and
             Payload'Last < Natural'Last - 1 and
             Auth'Length <= Natural'Last - 3;

   procedure Valid_HMAC_SHA256 (Valid_MAC : out Boolean)
   is
      package K is new JWX.JWK (Key);
      Keys : K.Key_Array_Type := K.Parse_Keys;

      Payload_Raw : JWX.Byte_Array (1 .. Payload'Length);
      Key_Raw     : JWX.Byte_Array (1 .. (Key'Length / 4 + 1) * 3);
      Auth_Raw    : JWX.Byte_Array (1 .. 3 * ((Auth'Length + 3) / 4));

      Payload_LSC : Standard.LSC.SHA256.Message_Type (1 .. (Payload_Raw'Length - 1) / 64 + 1);
      Auth_Input  : Standard.LSC.SHA256.SHA256_Hash_Type;
      Auth_Calc   : Standard.LSC.SHA256.SHA256_Hash_Type;
      Key_LSC     : Standard.LSC.SHA256.Block_Type;

      Auth_Length    : Natural;
      Key_Length     : Natural;

      use LSC.Types;
      use type K.Kind_Type;
   begin
      Valid_MAC := False;

      if Keys'Length = 0
      then
         return;
      end if;

      declare
         Auth_Key : constant K.Key_Type := Keys (Keys'First);
      begin
         if K.Algorithm (Auth_Key) /= Alg_HS256 or
            K.Kind (Auth_Key) /= K.Kind_OCT
         then
            return;
         end if;

         K.K (Auth_Key, Key_Raw, Key_Length);
         if (Key_Length = 0 or
             Key_Raw'First >= Integer'Last - 4 * Key_LSC'Length or
             Payload_Raw'Length <= 0 or
             Payload_LSC'Last <= Payload_LSC'First or
             Auth'Length <= 0 or
             Auth'Length >= Natural'Last / 9 or
             Auth'Last >= Natural'Last - 4 or
             Payload_LSC'Length > LSC.SHA256.Message_Index (Integer'Last) / 64) or else
             Payload_Raw'First >= Integer'Last - 64 * Payload_LSC'Length - 64
         then
            return;
         end if;

         --  Convert key into LSC compatible format
         Libsparkcrypto.JWX_Byte_Array_To_LSC_Word32_Array
           (Input  => Key_Raw (Key_Raw'First .. Key_Raw'First + Key_Length - 1),
            Output => Key_LSC);

         --  Convert string to JWX byte array
         JWX.Util.To_Byte_Array (Payload, Payload_Raw);

         --  Convert payload into LSC compatible format
         Libsparkcrypto.JWX_Byte_Array_To_LSC_SHA256_Message
           (Input  => Payload_Raw,
            Output => Payload_LSC);

         --  Decode authenticator
         Base64.Decode_Url (Encoded => Auth,
                            Len     => Auth_Length,
                            Result  => Auth_Raw);
         if Auth_Length /= 32
         then
            return;
         end if;

         --  Convert authenticator LSC compatible format
         Libsparkcrypto.JWX_Byte_Array_To_LSC_Word32_Array
           (Input  => Auth_Raw,
            Output => Auth_Input);

         Auth_Calc := LSC.HMAC_SHA256.Pseudorandom
           (Key     => Key_LSC,
            Message => Payload_LSC,
            Length  => LSC.SHA256.Message_Index (Payload'Length) * 8);

         --  Validate
         if Auth_Input /= Auth_Calc
         then
            return;
         end if;

      end;

      Valid_MAC := True;
   end Valid_HMAC_SHA256;

   -----------
   -- Valid --
   -----------

   procedure Valid (Alg           : Alg_Type;
                    Valid_Payload : out Boolean)
   is
   begin
      Valid_Payload := False;
      if Payload'Last >= Natural'Last - 1 or
         Auth'Length > Natural'Last - 3
      then
         return;
      end if;

      case Alg is
         when Alg_HS256 => Valid_HMAC_SHA256 (Valid_Payload);
         when others    => null;
      end case;
   end Valid;

end JWX.Crypto;
