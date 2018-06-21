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
      Refined_State => (State => (Key_Data.State,
                                  Key_Loaded,
                                  Key_Index,
                                  Key_Array,
                                  Key_Kind,
                                  Key_ID,
                                  Key_Curve,
                                  Key_X,
                                  Key_Y,
                                  Key_D,
                                  Key_N,
                                  Key_E,
                                  Key_K,
                                  Key_Use,
                                  Key_Alg))
is

   package Key_Data is new JSON (Data);
   use Key_Data;

   Key_Loaded   : Boolean;
   Key_Kind     : Kind_Type := Kind_Invalid;
   Key_Curve    : EC_Curve_Type := Curve_Invalid;
   Key_Index    : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Array    : Key_Data.Index_Type := Key_Data.End_Index;
   Key_ID       : Key_Data.Index_Type := Key_Data.End_Index;
   Key_X        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Y        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_D        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_N        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_E        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_K        : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Use      : Key_Data.Index_Type := Key_Data.End_Index;
   Key_Alg      : Key_Data.Index_Type := Key_Data.End_Index;

   -----------------
   -- Validate_EC --
   -----------------

   procedure Valid_EC (Valid : out Boolean)
   with
      Pre  => Key_Kind = Kind_EC,
      Post => Get_Kind (Key_X) = Kind_String and
              Get_Kind (Key_Y) = Kind_String;

   procedure Valid_EC (Valid : out Boolean)
   is
      Crv : Index_Type;
   begin

      Valid := False;

      --  Retrieve curve type 'crv'
      if Get_Kind (Key_Index) /= Kind_Object
      then
         return;
      end if;

      Crv := Query_Object ("crv", Key_Index);

      if Get_Kind (Crv) /= Kind_String
      then
         return;
      end if;

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
         return;
      end if;

      --  Check for 'x'
      Key_X := Query_Object ("x", Key_Index);
      if Key_X = End_Index or else
         Get_Kind (Key_X) /= Kind_String
      then
         return;
      end if;

      --  Check for 'y'
      Key_Y := Query_Object ("y", Key_Index);
      if Key_Y = End_Index or else
         Get_Kind (Key_Y) /= Kind_String
      then
         return;
      end if;

      --  Check for 'd' (optional)
      Key_D := Query_Object ("d", Key_Index);

      case Key_Curve is
         when Curve_P256 =>
            if Get_String (Key_X)'Length /= 43 or
               Get_String (Key_Y)'Length /= 43
            then
               return;
            end if;
         when Curve_P384 =>
            if Get_String (Key_X)'Length /= 64 or
               Get_String (Key_Y)'Length /= 64
            then
               return;
            end if;
         when Curve_P521 =>
            if Get_String (Key_X)'Length /= 88 or
               Get_String (Key_Y)'Length /= 88
            then
               return;
            end if;
         when Curve_Invalid =>
            return;
      end case;

      Valid := True;
   end Valid_EC;

   ------------------
   -- Validate_RSA --
   ------------------

   procedure Valid_RSA (Valid : out Boolean)
   with
      Pre  => Key_Kind = Kind_RSA,
      Post => Get_Kind (Key_N) = Kind_String and
              Get_Kind (Key_E) = Kind_String;

   procedure Valid_RSA (Valid : out Boolean)
   is
   begin
      Valid := False;

      if Get_Kind (Key_Index) /= Kind_Object
      then
         return;
      end if;

      --  Check for 'n'
      Key_N := Query_Object ("n", Key_Index);
      if Key_N = End_Index then
         return;
      end if;

      --  Check for 'e'
      Key_E := Query_Object ("e", Key_Index);
      if Key_E = End_Index then
         return;
      end if;

      --  Check for 'd' (optional)
      Key_D := Query_Object ("d", Key_Index);

      Valid := True;
   end Valid_RSA;

   ---------------
   -- Valid_Oct --
   ---------------

   procedure Valid_Oct (Valid : out Boolean)
   with
      Pre  => Key_Kind = Kind_OCT,
      Post => Get_Kind (Key_K) = Kind_String;

   procedure Valid_Oct (Valid : out Boolean)
   is
   begin
      Valid := False;

      if Get_Kind (Key_Index) /= Kind_Object
      then
         return;
      end if;

     --  Check for 'k'
      Key_K := Query_Object ("k", Key_Index);
      if Key_K = End_Index then
         return;
      end if;

      Valid := True;
   end Valid_Oct;

   ---------------
   -- Key_Valid --
   ---------------

   function Key_Valid return Boolean is
      (case Key_Kind is
          when Kind_EC      => Get_Kind (Key_X) = Kind_String and Get_Kind (Key_Y) = Kind_String,
          when Kind_RSA     => Get_Kind (Key_N) = Kind_String and Get_Kind (Key_E) = Kind_String,
          when Kind_Oct     => Get_Kind (Key_K) = Kind_String,
          when Kind_Invalid => False);

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
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_X),
                         Length  => Length,
                         Result  => Value);
   end X;

   -------
   -- Y --
   -------

   procedure Y (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_Y),
                         Length  => Length,
                         Result  => Value);
   end Y;

   -------
   -- N --
   -------

   procedure N (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_N),
                         Length  => Length,
                         Result  => Value);
   end N;

   -------
   -- E --
   -------

   procedure E (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_E),
                         Length  => Length,
                         Result  => Value);
   end E;

   -------
   -- D --
   -------

   procedure D (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_D),
                         Length  => Length,
                         Result  => Value);
   end D;

   -------
   -- K --
   -------

   procedure K (Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      Base64.Decode_Url (Encoded => Get_String (Key_K),
                         Length  => Length,
                         Result  => Value);
   end K;

   -----------------
   -- Private_Key --
   -----------------

   function Private_Key return Boolean
   is
   begin
      case Key_Kind is
         when Kind_EC | Kind_RSA => return Key_D /= Key_Data.End_Index;
         when Kind_OCT           => return True;
         when Kind_Invalid       => return False;
      end case;
   end Private_Key;

   -----------
   -- Usage --
   -----------

   function Usage return Use_Type
   is
   begin
      if Key_Use = End_Index or
         Get_Kind (Key_Use) /= Kind_String
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
   begin
      if Key_Alg = End_Index or
         Get_Kind (Key_Alg) /= Kind_String
      then
         return Alg_Invalid;
      end if;

      return Algorithm (Get_String (Key_Alg));
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
   begin
      return Key_Index /= Null_Index;
   end Keyset;

   --------------
   -- Num_Keys --
   --------------

   function Num_Keys return Natural
   is
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

   procedure Select_Key (Valid : out Boolean;
                         Index :     Positive := 1)
   is
      Kty   : Index_Type;
   begin
      Valid := False;

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

      if Get_Kind (Key_Index) /= Kind_Object
      then
         return;
      end if;

      --  Retrieve key id 'kid'
      Key_ID := Query_Object ("kid", Key_Index);

      --  Retrieve key type 'kty'
      Kty := Query_Object ("kty", Key_Index);
      if Get_Kind (Kty) /= Kind_String
      then
         return;
      end if;

      if Get_String (Kty) = "EC"
      then
         Key_Kind := Kind_EC;
      elsif Get_String (Kty) = "RSA"
      then
         Key_Kind := Kind_RSA;
      elsif Get_String (Kty) = "oct"
      then
         Key_Kind := Kind_OCT;
      else
         return;
      end if;

      --  Retrieve key usage 'use'
      Key_Use := Query_Object ("use", Key_Index);

      --  Algortihm 'alg'
      Key_Alg := Query_Object ("alg", Key_Index);

      -- Revieve curve
      case Key_Kind is
         when Kind_EC =>
            Valid_EC (Valid);
         when Kind_RSA =>
            Valid_RSA (Valid);
         when Kind_OCT =>
            Valid_Oct (Valid);
         when Kind_Invalid =>
            return;
      end case;

   end Select_Key;

begin
   declare
      Match : Key_Data.Match_Type;
   begin
      Key_Data.Parse (Match);
      Key_Loaded := Match = Key_Data.Match_OK;
   end;
end JWX.JWK;
