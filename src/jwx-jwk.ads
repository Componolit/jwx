--
-- \brief  JWK decoding (RFC 7517)
-- \author Alexander Senier
-- \date   2018-05-13
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic
   Data : String;
package JWX.JWK
is
   type Kind_Type is (Kind_Invalid,
                      Kind_EC,
                      Kind_RSA,
                      Kind_OCT);

   type Use_Type is (Use_Unknown,
                     Use_Sign,
                     Use_Encrypt);

   type EC_Curve_Type is (Curve_Invalid,
                          Curve_P256,
                          Curve_P384,
                          Curve_P521);

   type Key_Type is private;
   Invalid_Key : constant Key_Type;

   type Key_Array_Type is array (Natural range <>) of Key_Type;
   Empty_Key_Array : constant Key_Array_Type;

   -- Parse keys
   function Parse_Keys return Key_Array_Type
   with
      Pre => Data'First >= 0 and
             Data'First <= Data'Last and
             Data'Last < Natural'Last;

   --  Kind
   function Kind (Key : Key_Type) return Kind_Type;

   --  Return key ID
   function ID (Key : Key_Type) return String;

   --  Private key
   function Private_Key (Key : Key_Type) return Boolean;

   --  Key usage
   function Usage (Key : Key_Type) return Use_Type;

   --  Algorithm
   function Algorithm (Key : Key_Type) return Alg_Type;

   --  Return X coordinate of EC key
   procedure X (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC,
      Post => Length <= Value'Length;

   --  Return Y coordinate of EC key
   procedure Y (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC,
      Post => Length <= Value'Length;

   --  Return curve type
   function Curve (Key : Key_Type) return EC_Curve_Type
     with
       Pre => Kind (Key) = Kind_EC;

   --  Return modulus N of RSA key
   procedure N (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;

   --  Return exponent E of RSA key
   procedure E (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;

   --  Return D value of RSA (private exponent) or EC key (private key)
   procedure D (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC or Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;

   --  Return K value of a plain secret key
   procedure K (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_OCT,
      Post => Length <= Value'Length;

private

   type Key_Type (Kind : Kind_Type := Kind_Invalid) is
      record
         ID    : Range_Type;
         Usage : Range_Type;
         Alg   : Range_Type;
         case Kind is
         when Kind_EC =>
            X     : Range_Type;
            Y     : Range_Type;
            DE    : Range_Type;
            Curve : EC_Curve_Type;
         when Kind_RSA =>
            N     : Range_Type;
            E     : Range_Type;
            DR    : Range_Type;
         when Kind_Oct =>
            K     : Range_Type;
         when Kind_Invalid =>
            null;
         end case;
      end record;

   Invalid_Key : constant Key_Type :=
     Key_Type'(Kind  => Kind_Invalid,
               ID    => Empty_Range,
               Usage => Empty_Range,
               Alg   => Empty_Range);

   Empty_Key_Array : constant Key_Array_Type := (1 .. 0 => Invalid_Key);

end JWX.JWK;
