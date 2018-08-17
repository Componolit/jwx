--
--  @summary JWK decoding (RFC 7517)
--  @author  Alexander Senier
--  @date    2018-05-13
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX.JSON;
with JWX.Base64;

package body JWX.JWK
is

   ----------------
   -- Parse_Keys --
   ----------------

   function Parse_Keys return Key_Array_Type
   is
      package Key_Data is new JSON (Data);
      use Key_Data;

      ---------------
      -- Parse_Key --
      ---------------

      function Parse_Key (Key_Index : Index_Type) return Key_Type
      is

         -----------------
         -- Populate_EC --
         -----------------

         procedure Populate_EC (Key_Index : Index_Type;
                                Key_Curve : out EC_Curve_Type;
                                Key_X     : out Range_Type;
                                Key_Y     : out Range_Type;
                                Key_D     : out Range_Type;
                                Valid     : out Boolean)
         is
            Index : Index_Type;
         begin
            Key_Curve := Curve_Invalid;
            Key_X     := Empty_Range;
            Key_Y     := Empty_Range;
            Key_D     := Empty_Range;
            Valid     := False;

            --  Retrieve curve type 'crv'
            if Get_Kind (Key_Index) /= Kind_Object
            then
               return;
            end if;

            Index := Query_Object ("crv", Key_Index);

            if Get_Kind (Index) /= Kind_String
            then
               return;
            end if;

            if Get_String (Index) = "P-256"
            then
               Key_Curve := Curve_P256;
            elsif Get_String (Index) = "P-384"
            then
               Key_Curve := Curve_P384;
            elsif Get_String (Index) = "P-521"
            then
               Key_Curve := Curve_P521;
            else
               return;
            end if;

            --  Check for 'x'
            Index := Query_Object ("x", Key_Index);
            if Index = End_Index or else
              Get_Kind (Index) /= Kind_String
            then
               return;
            end if;

            Key_X := Get_Range (Index);
            if Key_X = Empty_Range
            then
               return;
            end if;

            --  Check for 'y'
            Index := Query_Object ("y", Key_Index);
            if Index = End_Index or else
              Get_Kind (Index) /= Kind_String
            then
               return;
            end if;

            Key_Y := Get_Range (Index);
            if Key_Y = Empty_Range
            then
               return;
            end if;

            --  Check for 'd' (optional)
            Index := Query_Object ("d", Key_Index);
            if Index /= End_Index
            then
               if  Get_Kind (Index) /= Kind_String
               then
                  return;
               end if;
               Key_D := Get_Range (Index);
            else
               Key_D := Empty_Range;
            end if;

            case Key_Curve is
            when Curve_P256 =>
               if Length (Key_X) /= 43 or
                  Length (Key_Y) /= 43
               then
                  return;
               end if;
            when Curve_P384 =>
               if Length (Key_X) /= 64 or
                  Length (Key_Y) /= 64
               then
                  return;
               end if;
            when Curve_P521 =>
               if Length (Key_X) /= 88 or
                  Length (Key_Y) /= 88
               then
                  return;
               end if;
            when Curve_Invalid =>
               return;
            end case;

            Valid := True;
         end Populate_EC;

         ------------------
         -- Populate_RSA --
         ------------------

         procedure Populate_RSA (Key_Index : Index_Type;
                                 Key_N : out Range_Type;
                                 Key_E : out Range_Type;
                                 Key_D : out Range_Type;
                                 Valid : out Boolean)
         is
            Index : Index_Type;
         begin
            Key_N := Empty_Range;
            Key_E := Empty_Range;
            Key_D := Empty_Range;
            Valid := False;

            if Get_Kind (Key_Index) /= Kind_Object
            then
               return;
            end if;

            --  Check for 'n'
            Index := Query_Object ("n", Key_Index);
            if Index = End_Index or else
              Get_Kind (Index) /= Kind_String
            then
               return;
            end if;
            Key_N := Get_Range (Index);

            --  Check for 'e'
            Index := Query_Object ("e", Key_Index);
            if Index = End_Index or else
              Get_Kind (Index) /= Kind_String
            then
               return;
            end if;
            Key_E := Get_Range (Index);

            --  Check for 'd' (optional)
            Index := Query_Object ("d", Key_Index);
            if Index /= End_Index
            then
               if Get_Kind (Index) /= Kind_String
               then
                  return;
               end if;
               Key_D := Get_Range (Index);
            else
               Key_D := Empty_Range;
            end if;

            Valid := True;
         end Populate_RSA;

         ------------------
         -- Populate_Oct --
         ------------------

         procedure Populate_Oct (Key_Index : Index_Type;
                                 Key_K : out Range_Type;
                                 Valid : out Boolean)
         is
            Index : Index_Type;
         begin
            Key_K := Empty_Range;
            Valid := False;

            if Get_Kind (Key_Index) /= Kind_Object
            then
               return;
            end if;

            --  Check for 'k'
            Index := Query_Object ("k", Key_Index);
            if Index = End_Index or else
              Get_Kind (Index) /= Kind_String
            then
               return;
            end if;
            Key_K := Get_Range (Index);

            Valid := True;
         end Populate_Oct;

         Index        : Index_Type;
         Valid        : Boolean;
         Result_Kind  : Kind_Type;
         Result_ID    : Range_Type := Empty_Range;
         Result_Usage : Range_Type := Empty_Range;
         Result_Alg   : Range_Type := Empty_Range;

      begin
         if Get_Kind (Key_Index) /= Kind_Object
         then
            return Invalid_Key;
         end if;

         --  Retrieve key id 'kid'
         Index := Query_Object ("kid", Key_Index);
         if Index /= End_Index
         then
            if Get_Kind (Index) /= Kind_String
            then
               return Invalid_Key;
            end if;
            Result_ID := Get_Range (Index);
         end if;

         --  Retrieve key type 'kty'
         Index := Query_Object ("kty", Key_Index);
         if Index = End_Index or else
           Get_Kind (Index) /= Kind_String
         then
            return Invalid_Key;
         end if;

         if Get_String (Index) = "EC"
         then
            Result_Kind := Kind_EC;
         elsif Get_String (Index) = "RSA"
         then
            Result_Kind := Kind_RSA;
         elsif Get_String (Index) = "oct"
         then
            Result_Kind := Kind_OCT;
         else
            return Invalid_Key;
         end if;

         --  Retrieve key usage 'use'
         Index := Query_Object ("use", Key_Index);
         if Index /= End_Index
         then
            if Get_Kind (Index) /= Kind_String
            then
               return Invalid_Key;
            end if;
            Result_Usage := Get_Range (Index);
         end if;

         --  Algortihm 'alg'
         Index := Query_Object ("alg", Key_Index);
         if Index /= End_Index
         then
            if Get_Kind (Index) /= Kind_String
            then
               return Invalid_Key;
            end if;
            Result_Alg := Get_Range (Index);
         end if;

         --  Retrieve curve
         case Result_Kind is
            when Kind_EC =>
               declare
                  Result_X     : Range_Type;
                  Result_Y     : Range_Type;
                  Result_D     : Range_Type;
                  Result_Curve : EC_Curve_Type;
               begin
                  Populate_EC (Key_Index => Key_Index,
                               Key_Curve => Result_Curve,
                               Key_X     => Result_X,
                               Key_Y     => Result_Y,
                               Key_D     => Result_D,
                               Valid     => Valid);
                  if not Valid
                  then
                     return Invalid_Key;
                  end if;
                  return Key_Type'(Kind  => Kind_EC,
                                   ID       => Result_ID,
                                   Usage    => Result_Usage,
                                   Alg      => Result_Alg,
                                   X        => Result_X,
                                   Y        => Result_Y,
                                   DE       => Result_D,
                                   Curve    => Result_Curve);
               end;

            when Kind_RSA =>
               declare
                  Result_N : Range_Type;
                  Result_E : Range_Type;
                  Result_D : Range_Type;
               begin
                  Populate_RSA (Key_Index => Key_Index,
                                Key_N => Result_N,
                                Key_E => Result_E,
                                Key_D => Result_D,
                                Valid => Valid);
                  if not Valid
                  then
                     return Invalid_Key;
                  end if;
                  return Key_Type'(Kind  => Kind_RSA,
                                   ID       => Result_ID,
                                   Usage    => Result_Usage,
                                   Alg      => Result_Alg,
                                   DR       => Result_D,
                                   N        => Result_N,
                                   E        => Result_E);
               end;
            when Kind_OCT =>
               declare
                  Result_K : Range_Type;
               begin
                  Populate_Oct (Key_Index => Key_Index,
                                Key_K => Result_K,
                                Valid => Valid);
                  if not Valid
                  then
                     return Invalid_Key;
                  end if;
                  return Key_Type'(Kind  => Kind_OCT,
                                   ID       => Result_ID,
                                   Usage    => Result_Usage,
                                   Alg      => Result_Alg,
                                   K        => Result_K);
               end;
            when Kind_Invalid =>
               return Invalid_Key;
         end case;

      end Parse_Key;

      Match     : Key_Data.Match_Type;
      Key_Array : Index_Type;

   begin

      pragma Warnings (Off, "unused assignment to ""Offset""");
      Key_Data.Parse (Match);
      pragma Warnings (On, "unused assignment to ""Offset""");
      if Match /= Key_Data.Match_OK
      then
         return Empty_Key_Array;
      end if;

      --  Key must be an object
      if Get_Kind /= Kind_Object
      then
         return Empty_Key_Array;
      end if;

      --  Check whether this is a single key or a key set
      Key_Array := Query_Object ("keys");
      if Key_Array = End_Index
      then
         return Key_Array_Type'(1 => Parse_Key (Key_Index => Null_Index));
      else
         if Get_Kind (Key_Array) /= Kind_Array
         then
            return Empty_Key_Array;
         end if;
         declare
            L : constant Natural := Key_Data.Length (Key_Array);
            Result : Key_Array_Type (1 .. L) := (others => Invalid_Key);
         begin
            for I in 1 .. Length (Key_Array)
            loop
               Result (I) := Parse_Key (Pos (I, Key_Array));
            end loop;
            return Result;
         end;
      end if;
   end Parse_Keys;

   ----------
   -- Kind --
   ----------

   function Kind (Key : Key_Type) return Kind_Type is (Key.Kind);

   --------
   -- ID --
   --------

   function ID (Key : Key_Type) return String
   is
   begin
      if not In_Range (Key.ID, Data)
      then
         return "";
      end if;

      return Data (Key.ID.First .. Key.ID.Last);
   end ID;

   ------------------
   -- Decode_Field --
   ------------------

   procedure Decode_Field (Encoded :     String;
                           Length  : out Natural;
                           Result  : out JWX.Byte_Array)
   with
      Post => Length <= Result'Length;

   procedure Decode_Field (Encoded :     String;
                           Length  : out Natural;
                           Result  : out JWX.Byte_Array)
   is
   begin
      if (Encoded'Length <= 0 or
          Encoded'Length >= Natural'Last / 9 or
          Encoded'Last >= Natural'Last - 4 or
          Result'Length < 3 * ((Encoded'Length + 3) / 4)) or else
          Result'First >= Natural'Last - 9 * Encoded'Length / 12 - 3
      then
         Length := 0;
         Result := (Result'Range => 0);
         return;
      end if;

      Base64.Decode_Url (Encoded => Encoded,
                         Length  => Length,
                         Result  => Result);
   end Decode_Field;

   -------
   -- X --
   -------

   procedure X (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      if not In_Range (Key.X, Data)
      then
         Value := (others => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (Key.X.First .. Key.X.Last),
                    Length  => Length,
                    Result  => Value);
   end X;

   -------
   -- Y --
   -------

   procedure Y (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      if not In_Range (Key.Y, Data)
      then
         Value := (others => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (Key.Y.First .. Key.Y.Last),
                    Length  => Length,
                    Result  => Value);
   end Y;

   -------
   -- N --
   -------

   procedure N (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      if not In_Range (Key.N, Data)
      then
         Value := (others => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (Key.N.First .. Key.N.Last),
                    Length  => Length,
                    Result  => Value);
   end N;

   -------
   -- E --
   -------

   procedure E (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      if not In_Range (Key.E, Data)
      then
         Value := (others => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (Key.E.First .. Key.E.Last),
                    Length  => Length,
                    Result  => Value);
   end E;

   -------
   -- D --
   -------

   procedure D (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
      D : Range_Type;
   begin
      case Key.Kind is
         when Kind_RSA => D := Key.DR;
         when Kind_EC  => D := Key.DE;
         when others   => D := Empty_Range;
      end case;

      if D = Empty_Range or else
         not In_Range (D, Data)
      then
         Value  := (Value'Range => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (D.First .. D.Last),
                    Length  => Length,
                    Result  => Value);
   end D;

   -------
   -- K --
   -------

   procedure K (Key    : Key_Type;
                Value  : out Byte_Array;
                Length : out Natural)
   is
      use JWX;
   begin
      if not In_Range (Key.K, Data)
      then
         Value := (others => 0);
         Length := 0;
         return;
      end if;

      Decode_Field (Encoded => Data (Key.K.First .. Key.K.Last),
                    Length  => Length,
                    Result  => Value);
   end K;

   -----------------
   -- Private_Key --
   -----------------

   function Private_Key (Key : Key_Type) return Boolean
   is
   begin
      case Key.Kind is
         when Kind_EC      => return Key.DE /= Empty_Range;
         when Kind_RSA     => return Key.DR /= Empty_Range;
         when Kind_OCT     => return True;
         when Kind_Invalid => return False;
      end case;
   end Private_Key;

   -----------
   -- Usage --
   -----------

   function Usage (Key : Key_Type) return Use_Type
   is
   begin
      if Key.Usage = Empty_Range or
         not In_Range (Key.Usage, Data)
      then
         return Use_Unknown;
      end if;

      if Data (Key.Usage.First .. Key.Usage.Last) = "enc"
      then
         return Use_Encrypt;
      elsif Data (Key.Usage.First .. Key.Usage.Last) = "sig"
      then
         return Use_Sign;
      end if;

      return Use_Unknown;
   end Usage;

   ---------------
   -- Algorithm --
   ---------------

   function Algorithm (Key : Key_Type) return Alg_Type
   is
   begin
      if Key.Alg = Empty_Range or else
         not In_Range (Key.Alg, Data)
      then
         return Alg_Invalid;
      end if;

      return Algorithm (Data (Key.Alg.First .. Key.Alg.Last));
   end Algorithm;

   -----------
   -- Curve --
   -----------

   function Curve (Key : Key_Type) return EC_Curve_Type
   is
   begin
      return Key.Curve;
   end Curve;

end JWX.JWK;
