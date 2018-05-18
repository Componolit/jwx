with Ada.Text_IO; use Ada.Text_IO;
with JWX.JWK;
with JWX.Base64;
with JWX.LSC;

with LSC.Types;
with LSC.SHA256;
with LSC.HMAC_SHA256;

with Interfaces;
use type Interfaces.Unsigned_64;

package body JWX.Crypto
is
   -----------------------
   -- Valid_HMAC_SHA256 --
   -----------------------

   function Valid_HMAC_SHA256 return Boolean
   is
      package K is new JWX.JWK;
      Payload_Raw : JWX.Byte_Array (1 .. (Payload'Length/4 + 1) * 3);
      Auth_Raw    : JWX.Byte_Array (1 .. (Key'Length/4 + 1) * 3);

      Payload_LSC : Standard.LSC.SHA256.Message_Type (1 .. Payload_Raw'Length/64);
      Auth_LSC    : Standard.LSC.HMAC_SHA256.Auth_Type;

      Payload_Length : Natural;
      Auth_Length    : Natural;
   begin
      -- Parse key
      K.Load_Keys (Key);
      K.Select_Key;
      if not K.Valid
      then
         return False;
      end if;
   
      if K.Algorithm /= Alg_Invalid and then
         K.Algorithm /= Alg_HS256
      then
         return False;
      end if;

      --  Decode payload
      Base64.Decode_Url (Encoded => Payload,
                         Length  => Payload_Length,
                         Result  => Payload_Raw,
                         Padding => Base64.Padding_Implicit);
      if Payload_Length = 0
      then
         return False;
      end if;

      --  Convert payload into LSC compatible format
      LSC.JWX_Byte_Array_To_LSC_SHA256_Message
         (Input  => Payload_Raw (Payload_Raw'First .. Payload_Raw'First + Payload_Length),
          Output => Payload_LSC);

      --  Decode authenticator
      Base64.Decode_Url (Encoded => Auth,
                         Length  => Auth_Length,
                         Result  => Auth_Raw,
                         Padding => Base64.Padding_Implicit);
      if Auth_Length = 0
      then
         return False;
      end if;

      return False;
   end Valid_HMAC_SHA256;

   -----------
   -- Valid --
   -----------

   function Valid (Alg : Alg_Type) return Boolean
   is
   begin
      case Alg is
         when Alg_HS256 => return Valid_HMAC_SHA256;
         when others => return False;
      end case;
   end Valid;

end JWX.Crypto;

