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
   with
      Abstract_State => State,
      Initializes    => State
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

   --  Key object loaded
   function Loaded return Boolean;
   
   --  Valid key
   function Valid return Boolean;

   --  Kind
   function Kind return Kind_Type
   with
      Pre => Valid;

   --  Return key ID
   function ID return String
   with
      Pre => Valid;

   --  Private key
   function Private_Key return Boolean
   with
      Pre => Valid;

   --  Key usage
   function Usage return Use_Type
   with
      Pre => Valid;

   --  Algorithm
   function Algorithm return Alg_Type
   with
      Pre => Valid;

   --  Return X coordinate of EC key
   procedure X (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_EC;

   --  Return Y coordinate of EC key
   procedure Y (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_EC;

   --  Return curve type
   function Curve return EC_Curve_Type
   with
      Pre => Kind = Kind_EC;

   --  Return modulus N of RSA key
   procedure N (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_RSA;

   --  Return exponent E of RSA key
   procedure E (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_RSA;

   --  Return D value of RSA (private exponent) or EC key (private key)
   procedure D (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_EC or
             Kind = Kind_RSA;

   --  Return K value of a plain secret key
   procedure K (Value  : out Byte_Array;
                Length : out Natural)
   with
      Pre => Kind = Kind_OCT;

   --  Is this a keyset
   function Keyset return Boolean
   with
      Pre => Loaded;

   --  Number of keys in key set
   function Num_Keys return Natural
   with
      Pre => Loaded;

   --  Select a key
   procedure Select_Key (Index : Positive := 1)
   with
      Pre => Loaded;

end JWX.JWK;
