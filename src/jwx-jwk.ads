--
--  @author Alexander Senier
--  @date   2018-05-13
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

--  @summary JWK decoding (RFC 7517)
generic
   Data : String;
package JWX.JWK
is
   type Kind_Type is (Kind_Invalid,
                      Kind_EC,
                      Kind_RSA,
                      Kind_OCT);
   --  Type as defined by RFC7518
   --  (6.1, "kty" (Key Type) Parameter Values)
   --
   --  @value Kind_Invalid  Invalid key
   --  @value Kind_EC       Elliptic Curve
   --  @value Kind_RSA      RSA
   --  @value Kind_OCT      Octet sequence

   type Use_Type is (Use_Unknown,
                     Use_Sign,
                     Use_Encrypt);
   --  Key "use" parameter as defined by RFC7517
   --  (4.2, "kty" (Key Type) Parameter Values)
   --
   --  @value Use_Unknown  Unknown usage
   --  @value Use_Sign     Signature
   --  @value Use_Encrypt  Encryption

   type EC_Curve_Type is (Curve_Invalid,
                          Curve_P256,
                          Curve_P384,
                          Curve_P521);
   --  Elliptic curve parameter as defined by RFC7518
   --  (6.2.1.1.  "crv" (Curve) Parameter)
   --
   --  @value Curve_Invalid  Invalid curve
   --  @value Curve_P256     P-256 curve
   --  @value Curve_P384     P-384 curve
   --  @value Curve_P521     P-521 curve

   type Key_Type is private;
   Invalid_Key : constant Key_Type;

   type Key_Array_Type is array (Natural range <>) of Key_Type;
   Empty_Key_Array : constant Key_Array_Type;

   --  Parse keys
   function Parse_Keys return Key_Array_Type
   with
      Pre => Data'First >= 0 and
             Data'First <= Data'Last and
             Data'Last < Natural'Last;

   function Kind (Key : Key_Type) return Kind_Type;
   --  Return kind of key
   --
   --  @param Key  Key

   function ID (Key : Key_Type) return String;
   --  Return key ID
   --
   --  @param Key  Key

   function Private_Key (Key : Key_Type) return Boolean;
   --  Private key
   --
   --  @param Key  Key

   function Usage (Key : Key_Type) return Use_Type;
   --  Key usage
   --
   --  @param Key  Key

   function Algorithm (Key : Key_Type) return Alg_Type;
   --  Algorithm
   --
   --  @param Key  Key

   procedure X (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC,
      Post => Length <= Value'Length;
   --  Return X coordinate of EC key
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

   procedure Y (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC,
      Post => Length <= Value'Length;
   --  Return Y coordinate of EC key
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

   function Curve (Key : Key_Type) return EC_Curve_Type
     with
       Pre => Kind (Key) = Kind_EC;
   --  Return curve type
   --
   --  @param Key  Key

   procedure N (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;
   --  Return modulus N of RSA key
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

   procedure E (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;
   --  Return exponent E of RSA key
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

   procedure D (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_EC or Kind (Key) = Kind_RSA,
      Post => Length <= Value'Length;
   --  Return D value of RSA (private exponent) or EC key (private key)
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

   procedure K (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre  => Kind (Key) = Kind_OCT,
      Post => Length <= Value'Length,
      Global => Data;
   --  Return K value of a plain secret key
   --
   --  @param Key     Key
   --  @param Value   Output array
   --  @param Length  Length of output array

private

   type Key_Type (Key_Kind : Kind_Type := Kind_Invalid) is
      record
         ID    : Range_Type;
         Usage : Range_Type;
         Alg   : Range_Type;
         case Key_Kind is
         when Kind_EC =>
            X     : Range_Type;
            Y     : Range_Type;
            DE    : Range_Type;
            Curve : EC_Curve_Type;
         when Kind_RSA =>
            N     : Range_Type;
            E     : Range_Type;
            DR    : Range_Type;
         when Kind_OCT =>
            K     : Range_Type;
         when Kind_Invalid =>
            null;
         end case;
      end record;
   --  Key
   --
   --  @field Key_Kind  Cryptographic algorithm family use with this key ("kty")
   --  @field ID        ID to match a specific key ("kid")
   --  @field Usage     Intended use of the public key ("use")
   --  @field Alg       Algorithm intended for use with this key ("alg")
   --  @field X         EC x coordinate "x"
   --  @field Y         EC y coordinate "y"
   --  @field DE        EC private key "d"
   --  @field Curve     EC curve "crv"
   --  @field N         RSA modulus "n"
   --  @field E         RSA exponent "e"
   --  @field DR        RSA private exponent "d"
   --  @field K         Secret key value

   Invalid_Key : constant Key_Type :=
     Key_Type'(Key_Kind => Kind_Invalid,
               ID       => Empty_Range,
               Usage    => Empty_Range,
               Alg      => Empty_Range);

   Empty_Key_Array : constant Key_Array_Type := (1 .. 0 => Invalid_Key);

end JWX.JWK;
