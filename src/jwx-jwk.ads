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
package JWX.JWK
   with
      SPARK_Mode,
      Abstract_State => State,
      Initializes    => State
is
   type Kind_Type is (Kind_Invalid, Kind_EC);

   type EC_Curve_Type is (Curve_Invalid,
                          Curve_P256,
                          Curve_P384,
                          Curve_P521);

   --  Parse a JWK
   procedure Parse (Input : String);
   
   --  Valid key
   function Valid return Boolean;

   --  Valid key
   function Kind return Kind_Type
   with
      Pre => Valid;

   --  Return key ID
   function ID return String
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

end JWX.JWK;
