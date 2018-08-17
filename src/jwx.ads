--
-- @author Alexander Senier
-- @date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

-- @summary JWX main package
package JWX
with
   SPARK_Mode
is
   type UInt6 is mod 2**6
   with Size => 6;

   type Byte is mod 2**8
   with Size => 8;

   type Integer_Type is range -2**46 .. 2**46 - 1;

   type Real_Type is delta 0.00001 range
     Long_Float (Integer_Type'First) .. Long_Float (Integer_Type'Last)
   with Size => 64;

   subtype Array_Index is Natural range Natural'First .. Natural'Last - 1;

   type Byte_Array is array (Array_Index range <>) of Byte
   with Pack;

   subtype Data_Index is Positive range 1 .. Natural'Last / 9 - 1;

   type Range_Type is
   record
      First : Positive;
      Last  : Positive;
   end record;
   -- @field First First element of range (inclusive)
   -- @field Last  Last element of range (inclusive)

   Empty_Range : constant Range_Type := (First => Positive'Last,
                                         Last  => Positive'First);

   function In_Range (R : Range_Type;
                      S : String) return Boolean
   is (R.First >= S'First and
       R.Last  <= S'Last and
       R.First <= R.Last);
   -- Assert whether a range type is in the bounds of a string
   -- @param R Range
   -- @param S String
   -- @return True, iff the range covered by R is withing the string S

   function Length (R : Range_Type) return Positive is (R.Last - R.First + 1)
   with
     Pre => R.Last < Positive'Last and then R.First <= R.Last;
   -- Calculate length of a range type
   -- @param R Range
   -- @return Number of elements covered by range

   type Alg_Type is (Alg_Invalid,
                     Alg_None,
                     Alg_HS256,
                     Alg_HS384,
                     Alg_HS512,
                     Alg_RS256,
                     Alg_RS384,
                     Alg_RS512,
                     Alg_ES256,
                     Alg_ES384,
                     Alg_ES512,
                     Alg_PS256,
                     Alg_PS384,
                     Alg_PS512);
   -- Cryptographics algorithms known (but not necessarily supported) by JWX
   --
   -- @value Alg_Invalid Invalid algorithm
   -- @value Alg_None    No digital signature or MAC performed
   -- @value Alg_HS256   HMAC with SHA256
   -- @value Alg_HS384   HMAC with SHA384
   -- @value Alg_HS512   HMAC with SHA512
   -- @value Alg_RS256   RSASSA-PKCS1-v1_5 with SHA256
   -- @value Alg_RS384   RSASSA-PKCS1-v1_5 with SHA384
   -- @value Alg_RS512   RSASSA-PKCS1-v1_5 with SHA512
   -- @value Alg_ES256   ECDSA using P-256 with SHA-256
   -- @value Alg_ES384   ECDSA using P-384 with SHA-384
   -- @value Alg_ES512   ECDSA using P-521 with SHA-512
   -- @value Alg_PS256   RSASSA-PSS using SHA-256 and MGF1 with SHA-256
   -- @value Alg_PS384   RSASSA-PSS using SHA-384 and MGF1 with SHA-384
   -- @value Alg_PS512   RSASSA-PSS using SHA-512 and MGF1 with SHA-512

   function Algorithm (Alg_String : String) return Alg_Type;
   -- Convert a algorithm string to Alg_Type
   -- @param Alg_String Algorithm string as defined in RFC7518, section 3.1:
   --                   "alg" (Algorithm) Header Parameter Values for JWS
   -- @return JWX algorithm, Alg_Invalid if the input string was invalid

end JWX;
