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

with JWX.JSON;
with JWX.Base64;

package body JWX.JWK
   with
      SPARK_Mode,
      Refined_State => (State => (Key_Data.State,
                                  Key_Loaded,
                                  Key_Valid,
                                  Key_Index,
                                  Key_Array,
                                  Key_Kind,
                                  Key_ID,
                                  Key_Curve,
                                  Key_X,
                                  Key_Y,
                                  Key_D,
                                  Key_Use,
                                  Key_Alg))
is

   package Key_Data is new JSON (4096);
   Key_Valid  : Boolean := False;
   Key_Loaded : Boolean := False;
   Key_Kind   : Kind_Type := Kind_Invalid;
   Key_Curve  : EC_Curve_Type := Curve_Invalid;
   Key_Index  : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Array  : Key_Data.Index_Type := Key_Data.End_Index;
   Key_ID     : Key_Data.Index_Type := Key_Data.End_Index;
   Key_X      : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Y      : Key_Data.Index_Type := Key_Data.End_Index;
   Key_D      : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Use    : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Alg    : Key_Data.Index_Type := Key_Data.End_Index;

   -----------------
   -- Validate_EC --
   -----------------

   function Valid_EC return Boolean
   with
      Pre => Key_Kind = Kind_EC;

   function Valid_EC return Boolean
   is
      use Key_Data;
      Crv : Index_Type;
   begin
      --  Retrieve curve type 'crv'
      Crv := Query_Object ("crv", Key_Index);
      if Get_String (Crv) = "P-256"
      then
         Key_Curve := Curve_P256;
      elsif Get_String (Crv) = "P-384"
      then
         Key_Curve := Curve_P384;
      elsif Get_String (Crv) = "P-521"
      then
         Key_Curve := Curve_P521;
      else
         return False;
      end if;

      --  Check for 'x'
      Key_X := Query_Object ("x", Key_Index);
      if Key_X = End_Index then
         return False;
      end if;

      --  Check for 'y'
      Key_Y := Query_Object ("y", Key_Index);
      if Key_Y = End_Index then
         return False;
      end if;

      --  Check for 'd' (optional)
      Key_D := Query_Object ("d", Key_Index);

      case Key_Curve is
         when Curve_P256 =>
            if Get_String (Key_X)'Length /= 43 or
               Get_String (Key_Y)'Length /= 43
            then
               return False;
            end if;
         when Curve_P384 =>
            if Get_String (Key_X)'Length /= 64 or
               Get_String (Key_Y)'Length /= 64
            then
               return False;
            end if;
         when Curve_P521 =>
            if Get_String (Key_X)'Length /= 88 or
               Get_String (Key_Y)'Length /= 88
            then
               return False;
            end if;
         when Curve_Invalid =>
            return False;
      end case;

      return True;
   end Valid_EC;

   ------------------
   -- Validate_RSA --
   ------------------

   function Valid_RSA return Boolean
   with
      Pre => Key_Kind = Kind_RSA;

   function Valid_RSA return Boolean
   is
      use Key_Data;
   begin
      return False;
   end Valid_RSA;

   ---------------
   -- Load_Keys --
   ---------------

   procedure Load_Keys (Input : String)
   is
      use Key_Data;
      Match : Match_Type;
   begin
      Key_Valid := False;
      Key_Array := End_Index;
      Key_Index := End_Index;
      Parse (Input, Match);
      if Match /= Match_OK
      then
         Key_Loaded := False;
         return;
      end if;
      Key_Loaded := True;

   end Load_Keys;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is (Key_Valid);

   ------------
   -- Loaded --
   ------------

   function Loaded return Boolean is (Key_Loaded);

   ----------
   -- Kind --
   ----------

   function Kind return Kind_Type is (Key_Kind);

   ------------
   -- Key_ID --
   ------------

   function ID return String
   is
      use Key_Data;
   begin
      return Get_String (Key_ID);
   end ID;

   -------
   -- X --
   -------

   procedure X (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
      use Key_Data;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_X),
                         Length  => Length,
                         Result  => Value,
                         Padding => Base64.Padding_Implicit);
   end X;

   -------
   -- Y --
   -------

   procedure Y (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
      use Key_Data;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_Y),
                         Length  => Length,
                         Result  => Value,
                         Padding => Base64.Padding_Implicit);
   end Y;


   -----------------
   -- Private_Key --
   -----------------

   function Private_Key return Boolean
   is
      use Key_Data;
   begin
      case Key_Kind is
         when Kind_EC      => return Key_D /= Key_Data.End_Index;
         when Kind_RSA     => return False;
         when Kind_Invalid => return False;
      end case;
   end Private_Key;

   -----------
   -- Usage --
   -----------

   function Usage return Use_Type
   is
      use Key_Data;
   begin
      if Key_Use = End_Index
      then
         return Use_Unknown;
      end if;

      if Get_String (Key_Use) = "enc"
      then
         return Use_Encrypt;
      elsif Get_String (Key_Use) = "sig"
      then
         return Use_Sign;
      end if;

      return Use_Unknown;
   end Usage;

   ---------------
   -- Algorithm --
   ---------------

   function Algorithm return Alg_Type
   is
      use Key_Data;
   begin
      if Key_Alg = End_Index
      then
         return Alg_Invalid;
      end if;

      if Get_String (Key_Alg) = "none"
      then
         return Alg_None;
      elsif Get_String (Key_Alg) = "HS256"
      then
         return Alg_HS256;
      elsif Get_String (Key_Alg) = "HS384"
      then
         return Alg_HS384;
      elsif Get_String (Key_Alg) = "HS512"
      then
         return Alg_HS512;
      elsif Get_String (Key_Alg) = "HS256"
      then
         return Alg_HS256;
      elsif Get_String (Key_Alg) = "RS384"
      then
         return Alg_RS384;
      elsif Get_String (Key_Alg) = "RS512"
      then
         return Alg_RS512;
      elsif Get_String (Key_Alg) = "ES256"
      then
         return Alg_ES256;
      elsif Get_String (Key_Alg) = "ES384"
      then
         return Alg_ES384;
      elsif Get_String (Key_Alg) = "ES512"
      then
         return Alg_ES512;
      elsif Get_String (Key_Alg) = "PS256"
      then
         return Alg_PS256;
      elsif Get_String (Key_Alg) = "PS384"
      then
         return Alg_PS384;
      elsif Get_String (Key_Alg) = "PS512"
      then
         return Alg_PS512;
      else
         return Alg_Invalid;
      end if;
   end Algorithm;

   -----------
   -- Curve --
   -----------

   function Curve return EC_Curve_Type
   is
   begin
      return Key_Curve;
   end Curve;

   ------------
   -- Keyset --
   ------------

   function Keyset return Boolean
   is
      use Key_Data;
   begin
      return Key_Index /= Null_Index;
   end Keyset;

   --------------
   -- Num_Keys --
   --------------

   function Num_Keys return Natural
   is
      use Key_Data;
   begin
      if Key_Index = Null_Index
      then
         return 1;
      else
         return Length (Key_Array);
      end if;
   end Num_Keys;

   ----------------
   -- Select_Key --
   ----------------

   procedure Select_Key (Index : Positive := 1)
   is
      use Key_Data;
      Kty  : Index_Type;
   begin
      Key_Valid := False;

      --  Key must be an object
      if Get_Kind /= Kind_Object
      then
         return;
      end if;

      --  Check whether this is a single key or a key set
      Key_Array := Query_Object ("keys");
      if Key_Array = End_Index
      then
         --  There is only on key - using anything but 1 here is invalid
         if Index /= 1
         then
            return;
         end if;
         Key_Index := Null_Index;
      else
         Key_Index := Pos (Index, Key_Array);
         if Key_Index = End_Index
         then
            --  Key not found at given Index
            return;
         end if;
      end if;

      --  Retrieve key id 'kid'
      Key_ID := Query_Object ("kid", Key_Index);
      if Key_ID = End_Index or else
         Get_Kind (Key_ID) /= Kind_String
      then
         return;
      end if;

      --  Retrieve key type 'kty'
      Kty := Query_Object ("kty", Key_Index);
      if Get_String (Kty) = "EC"
      then
         Key_Kind := Kind_EC;
      else
         return;
      end if;

      --  Retrieve key usage 'use'
      Key_Use := Query_Object ("use", Key_Index);

      --  Algortihm 'alg'
      Key_Alg := Query_Object ("alg");

      -- Revieve curve
      case Key_Kind is
         when Kind_EC =>
            if not Valid_EC
            then
               return;
            end if;
         when Kind_RSA =>
            if not Valid_RSA
            then
               return;
            end if;
         when Kind_Invalid =>
            return;
      end case;
      Key_Valid := True;

   end Select_Key;

end JWX.JWK;
