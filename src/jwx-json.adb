--
-- \brief  JSON decoding (RFC 7159)
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package body JWX.JSON
   with
      Refined_State => (State => (Context, Context_Index, Offset))
is
   type Context_Element_Type (Kind : Kind_Type := Kind_Invalid) is
   record
      Next_Member : Index_Type := Null_Index;
      Next_Value  : Index_Type := Null_Index;
      case Kind is
         when Kind_Null
            | Kind_Invalid
            | Kind_Object
            | Kind_Array => null;
         when Kind_Boolean =>
            Boolean_Value  : Boolean      := False;
         when Kind_Float =>
            Float_Value    : Float        := 0.0;
         when Kind_Integer =>
            Integer_Value  : Long_Integer := 0;
         when Kind_String =>
            String_Start   : Integer      := 0;
            String_End     : Integer      := 0;
      end case;
   end record;

   type Context_Type is array (Index_Type) of Context_Element_Type;

   Context_Index : Index_Type;
   Offset        : Natural;

   procedure Parse_Internal (Match : out Match_Type);

   ---------------------
   -- Invalid_Element --
   ---------------------

   Invalid_Element : constant Context_Element_Type :=
   -- Construct invalid element
      (Kind        => Kind_Invalid,
       Next_Member => Null_Index,
       Next_Value  => Null_Index);

   Context : Context_Type := (others => Invalid_Element);

   ------------------
   -- Null_Element --
   ------------------

   Null_Element : constant Context_Element_Type :=
   -- Construct null element
      (Kind        => Kind_Null,
       Next_Member => Null_Index,
       Next_Value  => Null_Index);

   ---------------------
   -- Boolean_Element --
   ---------------------

   function Boolean_Element (Value : Boolean) return Context_Element_Type is
   -- Construct boolean element
      (Kind          => Kind_Boolean,
       Boolean_Value => Value,
       Next_Member   => Null_Index,
       Next_Value    => Null_Index);

   -------------------
   -- Float_Element --
   -------------------

   function Float_Element (Value : Float) return Context_Element_Type is
   -- Construct float element
      (Kind        => Kind_Float,
       Float_Value => Value,
       Next_Member => Null_Index,
       Next_Value  => Null_Index);

   ---------------------
   -- Integer_Element --
   ---------------------

   function Integer_Element (Value : Long_Integer) return Context_Element_Type is
   -- Construct integer element
      (Kind          => Kind_Integer,
       Integer_Value => Value,
       Next_Member   => Null_Index,
       Next_Value    => Null_Index);

   --------------------
   -- String_Element --
   --------------------

   function String_Element (String_Start, String_End : Integer) return Context_Element_Type is
   -- Construct string element
      (Kind         => Kind_String,
       String_Start => String_Start,
       String_End   => String_End,
       Next_Member  => Null_Index,
       Next_Value   => Null_Index);

   --------------------
   -- Object_Element --
   --------------------

   Object_Element : constant Context_Element_Type :=
   -- Construct object element
      (Kind        => Kind_Object,
       Next_Member => Null_Index,
       Next_Value  => Null_Index);

   -------------------
   -- Array_Element --
   -------------------

   Array_Element : constant Context_Element_Type :=
   -- Construct array element
      (Kind        => Kind_Array,
       Next_Member => Null_Index,
       Next_Value  => Null_Index);

   ---------
   -- Get --
   ---------

   function Get (Index : Index_Type := Null_Index) return Context_Element_Type
   -- Return current element of a context
   is
   begin
      if Index = Null_Index
      then
         return Context (Context_Index);
      elsif Index = End_Index
      then
         return Invalid_Element;
      else
         return Context (Index);
      end if;
   end Get;

   --------------
   -- Has_Kind --
   --------------

   function Has_Kind (Index : Index_Type;
                      Kind  : Kind_Type) return Boolean
   is
        (Get (Index).Kind = Kind);

   ---------
   -- Set --
   ---------

   procedure Set (Value : Context_Element_Type;
                  Index : Index_Type := Null_Index)
   -- Return current element of a context
   is
   begin
      if Index = Null_Index
      then
         Context (Context_Index) := Value;
      else
         Context (Index) := Value;
      end if;
   end Set;

   -----------
   -- Reset --
   -----------

   procedure Reset
   is
   begin
      Context_Index := Context'First;
      Offset := 0;
   end Reset;

   --------------
   -- Get_Kind --
   --------------

   function Get_Kind (Index : Index_Type := Null_Index) return Kind_Type
   is
   begin
      return Get (Index).Kind;
   end Get_Kind;

   -----------------
   -- Get_Boolean --
   -----------------

   function Get_Boolean (Index : Index_Type := Null_Index) return Boolean
   is
   begin
      return Get (Index).Boolean_Value;
   end Get_Boolean;

   ---------------
   -- Get_Float --
   ---------------

   function Get_Float (Index : Index_Type := Null_Index) return Float
   is
   begin
      if Get_Kind (Index) = Kind_Integer
      then
         return Float (Get (Index).Integer_Value);
      end if;
      return Get (Index).Float_Value;
   end Get_Float;

   -----------------
   -- Get_Integer --
   -----------------

   function Get_Integer (Index : Index_Type := Null_Index) return Long_Integer
   is
   begin
      return Get (Index).Integer_Value;
   end Get_Integer;

   ----------------
   -- Get_String --
   ----------------

   function Get_String (Index : Index_Type := Null_Index) return String
   is
      Element : Context_Element_Type := Get (Index);
   begin
      if Element.String_Start in Data'Range and
         Element.String_End in Data'Range
      then
         return Data (Element.String_Start .. Element.String_End);
      else
         return "";
      end if;
   end Get_String;

   ----------------------
   -- Skip_Whitespace --
   ----------------------

   procedure Skip_Whitespace
   is
   begin
      loop
         if Offset >= Data'Length
         then
            return;
         end if;

         if (Data (Data'First + Offset) = ASCII.HT or
             Data (Data'First + Offset) = ASCII.LF or
             Data (Data'First + Offset) = ASCII.CR or
             Data (Data'First + Offset) = ASCII.FF or
             Data (Data'First + Offset) = ' ')
         then
            Offset := Offset + 1;
         else
            return;
         end if;
      end loop;
   end Skip_Whitespace;

   ----------------
   -- Parse_Null --
   ----------------

   procedure Parse_Null (Match : out Match_Type)
   is
      Base : Natural;
   begin
      Match := Match_None;

      if Context_Index >= Context'Last
      then
         Match := Match_Out_Of_Memory;
         return;
      end if;

      if Offset > Data'Length - 4
      then
         Match := Match_None;
         return;
      end if;

      Base := Data'First + Offset;
      if Data (Base .. Base + 3) = "null"
      then
         Set (Null_Element);
         Context_Index := Context_Index + 1;
         Offset := Offset + 4;
         Match := Match_OK;
      end if;

   end Parse_Null;

   ----------------
   -- Parse_Bool --
   ----------------

   procedure Parse_Bool (Match : out Match_Type)
   is
      Base : Natural;
   begin
      Match := Match_None;

      if Context_Index >= Context'Last
      then
         Match := Match_Out_Of_Memory;
         return;
      end if;

      if Offset > Data'Length - 4
      then
         Match := Match_None;
         return;
      end if;

      Base := Data'First + Offset;
      if Data (Base .. Base + 3) = "true"
      then
         Set (Boolean_Element (True));
         Context_Index := Context_Index + 1;
         Offset := Offset + 4;
         Match := Match_OK;
         return;
      end if;

      if Offset > Data'Length - 5
      then
         Match := Match_None;
         return;
      end if;

      if Data (Base .. Base + 4) = "false"
      then
         Set (Boolean_Element (False));
         Context_Index := Context_Index + 1;
         Offset := Offset + 5;
         Match := Match_OK;
      end if;

   end Parse_Bool;

   ---------------
   -- Match_Set --
   ---------------

   function Match_Set (Set : String) return Boolean
   with
      Post => (if Match_Set'Result then (for some E of Set => E = Data (Data'First + Offset)));

   function Match_Set (Set : String) return Boolean
   is
   begin
      for Value of Set
      loop
         if Offset < Data'Length and then
            Data (Data'First + Offset) = Value
         then
            return True;
         end if;
      end loop;
      return False;
   end Match_Set;

   ---------------
   -- To_Number --
   ---------------

   function To_Number (Value : Character) return Long_Integer
      is (Character'Pos (Value) - Character'Pos ('0'))
   with
      Pre  => Value >= '0' and Value <= '9',
      Post => To_Number'Result >=  0 and
              To_Number'Result <  10;

   ---------------------------
   -- Parse_Fractional_Part --
   ---------------------------

   procedure Parse_Fractional_Part
     (Match   : out Match_Type;
      Result  : out Float)
   with
      Pre => Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post =>
         (if Match /= Match_OK then Offset = Offset'Old) and
         Result >= 0.0 and
         Result <  1.0;

   procedure Parse_Fractional_Part
     (Match   :    out Match_Type;
      Result  :    out Float)
   is
      Divisor     : Long_Integer := 10;
      Old_Offset  : constant Natural := Offset;
   begin
      Result := 0.0;
      Match  := Match_None;

      if not Match_Set (".") then
         return;
      end if;

      Match  := Match_Invalid;
      if Offset >= Natural'Last
      then
         return;
      end if;

      Offset := Offset + 1;

      loop

         if Data'First > Integer'Last - Offset or
            Offset > Data'Length - 1
         then
            if Match /= Match_OK then
               Offset := Old_Offset;
            end if;
            return;
         end if;

         if Divisor <= 0 or
            Divisor >= Long_Integer'Last/10
         then
            Match := Match_Invalid;
            Offset := Old_Offset;
            return;
         end if;

         if not Match_Set ("0123456789")
         then
            if Match /= Match_OK then
               Offset := Old_Offset;
            end if;
            return;
         end if;

         pragma Assert (Divisor > 0);
         Result := Result +
            Float (To_Number (Data (Data'First + Offset))) / Float (Divisor);
         Divisor := Divisor * 10;
         Offset  := Offset + 1;
         Match   := Match_OK;
      end loop;

   end Parse_Fractional_Part;

   -------------------
   -- Parse_Integer --
   -------------------

   procedure Parse_Integer
     (Check_Leading :        Boolean;
      Match         :    out Match_Type;
      Result        :    out Long_Integer;
      Negative      :    out Boolean)
   with
      Post => Result >= 0;

   procedure Parse_Integer
     (Check_Leading :        Boolean;
      Match         :    out Match_Type;
      Result        :    out Long_Integer;
      Negative      :    out Boolean)
   is
      Leading_Zero : Boolean := False;
      Num_Matches  : Natural := 0;
      Old_Offset   : constant Natural := Offset;
   begin
      Match    := Match_Invalid;
      Negative := False;
      Result   := 0;

      if Offset > Data'Length - 1
      then
         Match := Match_Invalid;
         return;
      end if;

      Negative := Match_Set ("-");
      if Negative
      then
         Offset := Offset + 1;
      end if;

      loop

         if Num_Matches >= Natural'Last
         then
            Match := Match_Invalid;
            Offset := Old_Offset;
            return;
         end if;

         -- Valid digit?
         exit when
            not Match_Set ("0123456789") or
            Data'First >= Integer'Last - Offset or
            Data'First > Data'Last - Offset or
            Offset > Data'Length - 1 or
            Num_Matches >= Natural'Last;

         -- Check for leading '0'
         if Num_Matches = 0 and
            Data (Data'First + Offset) = '0'
         then
            Leading_Zero := True;
         end if;

         pragma Loop_Invariant (Result >= 0);
         pragma Loop_Invariant (Data'First + Offset in Data'Range);

         -- Check for overflow
         if Num_Matches >= Natural'Last or
            Result >= Long_Integer'Last/10
         then
            Match := Match_Invalid;
            Offset := Old_Offset;
            return;
         end if;

         Result := Result * 10;
         Result := Result + To_Number (Data (Data'First + Offset));
         Offset      := Offset + 1;
         Num_Matches := Num_Matches + 1;
      end loop;

      -- No digits found
      if Num_Matches = 0
      then
         Match  := Match_None;
         Offset := Old_Offset;
         return;
      end if;

      -- Leading zeros found
      if Check_Leading and
         ((Result > 0 and Leading_Zero) or
          (Result = 0 and Num_Matches > 1))
      then
         Offset := Old_Offset;
         return;
      end if;

      Match := Match_OK;
   end Parse_Integer;

   -------------------------
   -- Parse_Exponent_Part --
   -------------------------

   procedure Parse_Exponent_Part
     (Match    :    out Match_Type;
      Result   :    out Long_Integer;
      Negative :    out Boolean)
   with
      Post => (if Match = Match_OK then Result > 0);

   procedure Parse_Exponent_Part
     (Match    :    out Match_Type;
      Result   :    out Long_Integer;
      Negative :    out Boolean)
   is
      Scale            : Long_Integer;
      Match_Exponent   : Match_Type;
      Integer_Negative : Boolean;
      Old_Offset       : constant Natural := Offset;
   begin
      Result   := 0;
      Negative := False;
      Match    := Match_None;

      if not Match_Set ("Ee")
      then
         return;
      end if;

      Match  := Match_Invalid;
      if Offset >= Natural'Last
      then
         return;
      end if;

      Offset := Offset + 1;

      if Offset > Data'Length or else
         Data'First > Data'Last - Offset
      then
         Match := Match_None;
         Offset := Old_Offset;
         return;
      end if;

      if Match_Set ("+-")
      then
         if Data (Data'First + Offset) = '-'
         then
            Negative := True;
         end if;
         Offset := Offset + 1;
      end if;

      Parse_Integer (False, Match_Exponent, Scale, Integer_Negative);
      if Match_Exponent /= Match_OK or Integer_Negative
      then
         Offset := Old_Offset;
         return;
      end if;

      Result := 1;
      for I in 1 .. Scale
      loop
         if Result > Long_Integer'Last / 10
         then
            Offset := Old_Offset;
            return;
         end if;
         pragma Loop_Invariant (Result > 0);
         Result := Result * 10;
      end loop;

      Match := Match_OK;

   end Parse_Exponent_Part;

   ------------------
   -- Parse_Number --
   ------------------

   procedure Parse_Number (Match : out Match_Type)
   is
      Fractional_Component : Float := 0.0;
      Integer_Component    : Long_Integer;
      Scale                : Long_Integer;

      Match_Int      : Match_Type;
      Match_Frac     : Match_Type := Match_None;
      Match_Exponent : Match_Type;
      Negative       : Boolean;
      Scale_Negative : Boolean;
   begin
      Parse_Integer (True, Match_Int, Integer_Component, Negative);
      if Match_Int /= Match_OK
      then
         Match := Match_Int;
         return;
      end if;

      if Data'First < Integer'Last - Offset and
         Offset < Data'Length
      then
         Parse_Fractional_Part (Match_Frac, Fractional_Component);
      end if;

      if Context_Index >= Context'Last
      then
         Match := Match_Out_Of_Memory;
         return;
      end if;

      if Match_Frac = Match_Invalid
      then
         Match := Match_Invalid;
         return;
      end if;

      Parse_Exponent_Part (Match_Exponent, Scale, Scale_Negative);
      if Match_Exponent = Match_Invalid
      then
         Match := Match_Invalid;
         return;
      end if;

      pragma Assert ((if Match_Exponent = Match_OK then Scale > 0));

      --  Convert to float if either we have fractional part or dividing by the
      --  scale would yield a non-integer number.
      if Match_Frac = Match_OK or
         (Match_Exponent = Match_OK and then
          (Scale_Negative and Integer_Component mod Scale > 0))
      then
         if Float (Integer_Component) >= Float'Last
         then
            Match := Match_Invalid;
            return;
         end if;

         pragma Assert (Float (Integer_Component) < Float'Last);
         pragma Assert (Fractional_Component >= 0.0);
         pragma Assert (Fractional_Component <  1.0);
         declare
            Tmp : Float := Float (Integer_Component) + Fractional_Component;
         begin
            if Negative then
               Tmp := -Tmp;
            end if;
            if Match_Exponent = Match_OK
            then
               if Scale_Negative
               then
                  Tmp := Tmp / Float (Scale);
               else
                  Tmp := Tmp * Float (Scale);
               end if;
            end if;
            Set (Float_Element (Tmp));
         end;
      else
         if Negative then
            Integer_Component := -Integer_Component;
         end if;
         if Match_Exponent = Match_OK
         then
            if Scale_Negative
            then
               Integer_Component := Integer_Component / Scale;
            else
               Integer_Component := Integer_Component * Scale;
            end if;
         end if;
         Set (Integer_Element (Integer_Component));
      end if;

      Context_Index := Context_Index + 1;
      Match := Match_OK;

   end Parse_Number;

   ------------------
   -- Parse_String --
   ------------------

   procedure Parse_String (Match : out Match_Type)
   with
      Global => (In_Out => (Context,
                            Context_Index,
                            Offset),
                 Input =>  (Data,
                            Context_Size));

   procedure Parse_String (Match : out Match_Type)
   is
      String_Start : Natural;
      String_End   : Natural;
      Escaped      : Boolean := False;
      Old_Offset   : constant Natural := Offset;
   begin
      -- Check for starting "
      if not Match_Set ("""") then
         Match := Match_None;
         return;
      end if;

      Match := Match_Invalid;
      if Offset >= Natural'Last
      then
         return;
      end if;

      Offset := Offset + 1;
      String_Start := Data'First + Offset;

      loop
         if Data'First > Integer'Last - Offset or
            Offset > Data'Length - 1
         then
            Offset := Old_Offset;
            Match  := Match_Invalid;
            return;
         end if;

         exit when not Escaped and Match_Set ("""");
         Escaped := (if not Escaped and Match_Set ("\") then True else False);
         Offset := Offset + 1;
      end loop;

      if Data'First > Integer'Last - Offset or
         Offset > Data'Length - 1
      then
         Offset := Old_Offset;
         Match  := Match_Invalid;
         return;
      end if;

      if Context_Index >= Context'Last
      then
         Offset := Old_Offset;
         Match  := Match_Out_Of_Memory;
         return;
      end if;

      if not Match_Set ("""")
      then
         Offset := Old_Offset;
         Match  := Match_Invalid;
         return;
      end if;
      Offset := Offset + 1;

      String_End := Data'First + Offset - 2;

      Set (String_Element (String_Start, String_End));
      Context_Index := Context_Index + 1;
      Match := Match_OK;

   end Parse_String;

   ------------------
   -- Parse_Object --
   ------------------

   procedure Parse_Object (Match : out Match_Type)
   is
      Object_Index    : Index_Type;
      Previous_Member : Index_Type;
      Result          : Match_Type;
      Match_Member    : Match_Type;
      Old_Offset      : constant Natural := Offset;
   begin

      if Context_Index >= Context'Last
      then
         Match := Match_Out_Of_Memory;
         return;
      end if;

      -- Check for starting {
      if not Match_Set ("{") then
         Match := Match_None;
         return;
      end if;

      Object_Index := Context_Index;
      Set (Object_Element);
      Context_Index := Context_Index + 1;
      Previous_Member := Object_Index;

      Match := Match_Invalid;
      if Offset >= Natural'Last
      then
         return;
      end if;

      Offset := Offset + 1;

      loop
         if Offset >= Natural'Last or
            Data'First > Integer'Last - Offset or
            Offset > Data'Length - 1
         then
            Offset := Old_Offset;
            return;
         end if;

         -- Check for ending '}'
         Skip_Whitespace;
         if Match_Set ("}")
         then
            Offset := Offset + 1;
            exit;
         end if;

         -- Link previous element to this element
         Context (Previous_Member).Next_Member := Context_Index;
         Previous_Member := Context_Index;

         -- Parse member name
         Skip_Whitespace;
         Parse_String (Result);
         if Result /= Match_OK
         then
            Offset := Old_Offset;
            return;
         end if;

         -- Check for name separator (:)
         Skip_Whitespace;
         if Offset >= Natural'Last or
            not Match_Set (":")
         then
            Offset := Old_Offset;
            return;
         end if;
         Offset := Offset + 1;

         -- Parse member
         Parse_Internal (Match_Member);
         if Match_Member /= Match_OK then
            Offset := Old_Offset;
            return;
         end if;

         Skip_Whitespace;

         if Offset >= Natural'Last
         then
            Offset := Old_Offset;
            return;
         end if;

         -- Check for value separator ','
         if Match_Set (",") then
            Offset := Offset + 1;
         end if;

      end loop;

      Context (Previous_Member).Next_Member := End_Index;
      Match := Match_OK;

   end Parse_Object;

   ------------------
   -- Parse_Array --
   ------------------

   procedure Parse_Array (Match : out Match_Type)
   is
      Array_Index      : Index_Type;
      Previous_Element : Index_Type;
      Match_Element    : Match_Type;
      Old_Offset       : constant Natural := Offset;
   begin

      if Context_Index >= Context'Last
      then
         Match := Match_Out_Of_Memory;
         return;
      end if;

      -- Check for starting [
      if not Match_Set ("[") then
         Match := Match_None;
         return;
      end if;

      Array_Index := Context_Index;
      Set (Array_Element);
      Context_Index := Context_Index + 1;
      Previous_Element := Array_Index;

      Match := Match_Invalid;
      if Offset >= Natural'Last
      then
         return;
      end if;

      Offset := Offset + 1;

      loop
         if Offset >= Natural'Last or
            Data'First >= Integer'Last - Offset or
            Offset > Data'Length - 1
         then
            Offset := Old_Offset;
            return;
         end if;

         -- Check for ending ']'
         Skip_Whitespace;
         if Match_Set ("]")
         then
            Offset := Offset + 1;
            exit;
         end if;

         -- Link previous object to this element
         Context (Previous_Element).Next_Value := Context_Index;
         Previous_Element := Context_Index;

         -- Parse element
         Parse_Internal (Match_Element);
         if Match_Element /= Match_OK then
            Offset := Old_Offset;
            return;
         end if;

         Skip_Whitespace;

         if Offset >= Natural'Last
         then
            Offset := Old_Offset;
            return;
         end if;

         -- Check for value separator ','
         if Match_Set (",") then
            Offset := Offset + 1;
         end if;

      end loop;

      Context (Previous_Element).Next_Value := End_Index;
      Match := Match_OK;

   end Parse_Array;

   --------------------
   -- Parse_Internal --
   --------------------

   procedure Parse_Internal (Match : out Match_Type)
   is
   begin
      Skip_Whitespace;

      Parse_Null (Match);
      if Match = Match_None
      then
         Parse_Bool (Match);
         if Match = Match_None
         then
            Parse_Number (Match);
            if Match = Match_None
            then
               Parse_String (Match);
               if Match = Match_None
               then
                  Parse_Object (Match);
                  if Match = Match_None
                  then
                     Parse_Array (Match);
                  end if;
               end if;
            end if;
         end if;
      end if;
   end Parse_Internal;

   -----------
   -- Parse --
   -----------

   procedure Parse (Match : out Match_Type)
   is
   begin
      Parse_Internal (Match);
      if Context_Index > Context'First
      then
         Reset;
      end if;
   end Parse;

   ------------------
   -- Query_Object --
   ------------------

   function Query_Object (Name  : String;
                          Index : Index_Type := Null_Index) return Index_Type
   is
      I : Index_Type := Index;
   begin
      loop
         I := Get (I).Next_Member;
         exit when I = End_Index;

         if Get_Kind (I) = Kind_String and then
            Get_String (I) = Name
         then
            -- Value object are stored next to member names
            return I + 1;
         end if;
      end loop;
      return End_Index;
   end Query_Object;

   --------------
   -- Elements --
   --------------

   function Elements (Index : Index_Type := Null_Index) return Natural
   is
      I     : Index_Type := Index;
      Count : Natural := 0;
   begin
      loop
         I := Get (I).Next_Member;
         exit when
            Count >= Natural'Last or
            I = End_Index;
         Count := Count + 1;
      end loop;
      return Count;
   end Elements;

   ------------
   -- Length --
   ------------

   function Length (Index : Index_Type := Null_Index) return Natural
   is
      Element : Context_Element_Type := Get (Index);
      Count   : Natural := 0;
   begin
      loop
         exit when
            Count >= Natural'Last or
            Element.Next_Value = End_Index;

         Element := Context (Element.Next_Value);
         Count := Count + 1;
      end loop;
      return Count;
   end Length;

   ---------
   -- Pos --
   ---------

   function Pos (Position : Natural;
                 Index    : Index_Type := Null_Index) return Index_Type
   is
      Count      : Natural := 0;
      Last_Index : Index_Type := Index;
      Element    : Context_Element_Type := Get (Last_Index);
   begin
      loop
         exit when Count = Position;

         if Element.Next_Value = End_Index
         then
            return End_Index;
         end if;

         if Count >= Natural'Last
         then
            return End_Index;
         end if;

         Last_Index := Element.Next_Value;
         Element    := Get (Element.Next_Value);
         Count      := Count + 1;
      end loop;
      return Last_Index;
   end Pos;

begin
   Reset;
end JWX.JSON;
