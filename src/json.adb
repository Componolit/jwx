package body JSON
   with SPARK_Mode
is
   ------------------
   -- Null_Element --
   ------------------

   Null_Element : Context_Element_Type :=
   -- Construct null element
      (Kind           => Kind_Null,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   Context : Context_Type := (others => Null_Element);

   ---------------------
   -- Boolean_Element --
   ---------------------

   function Boolean_Element (Value : Boolean) return Context_Element_Type is
   -- Construct boolean element
      (Kind           => Kind_Boolean,
       Boolean_Value  => Value,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   -------------------
   -- Float_Element --
   -------------------

   function Float_Element (Value : Float) return Context_Element_Type is
   -- Construct float element
      (Kind           => Kind_Float,
       Boolean_Value  => False,
       Float_Value    => Value,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   ---------------------
   -- Integer_Element --
   ---------------------

   function Integer_Element (Value : Long_Integer) return Context_Element_Type is
   -- Construct integer element
      (Kind           => Kind_Integer,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => Value,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   --------------------
   -- String_Element --
   --------------------

   function String_Element (String_Start, String_End : Integer) return Context_Element_Type is
   -- Construct string element
      (Kind           => Kind_String,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => String_Start,
       String_End     => String_End,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   --------------------
   -- Object_Element --
   --------------------

   function Object_Element return Context_Element_Type is
   -- Construct object element
      (Kind           => Kind_Object,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   -------------------
   -- Array_Element --
   -------------------

   function Array_Element return Context_Element_Type is
   -- Construct array element
      (Kind           => Kind_Array,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);


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
         return Null_Element;
      else
         return Context (Index);
      end if;
   end Get;

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
      Context_Index := Context_Index + 1;
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

   procedure Skip_Whitespace (Offset : in out Natural)
   is
   begin
      loop
         if Data'First < Data'Last - Offset and then
            (Data (Data'First + Offset) = ASCII.HT or
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

   function Parse_Null return Match_Type
   is
      Base : Natural := Data'First + Offset;
   begin

      if not (Context_Index in Context'Range)
      then
         return Match_Out_Of_Memory;
      end if;

      if Offset > Data'Length - 4
      then
         return Match_End_Of_Input;
      end if;

      if Data (Base .. Base + 3) = "null"
      then
         Context_Index := Context_Index + 1;
         Set (Null_Element);
         Offset := Offset + 4;
         return Match_OK;
      end if;

      return Match_None;
   end Parse_Null;

   ----------------
   -- Parse_Bool --
   ----------------

   function Parse_Bool return Match_Type
   is
      Base : Natural := Data'First + Offset;
   begin

      if not (Context_Index in Context'Range)
      then
         return Match_Out_Of_Memory;
      end if;

      if Offset > Data'Length - 4
      then
         return Match_End_Of_Input;
      end if;

      if Data (Base .. Base + 3) = "true"
      then
         Context_Index := Context_Index + 1;
         Set (Boolean_Element (True));
         Offset := Offset + 4;
         return Match_OK;
      end if;

      if Offset > Data'Length - 5
      then
         return Match_End_Of_Input;
      end if;

      if Data (Base .. Base + 4) = "false"
      then
         Context_Index := Context_Index + 1;
         Set (Boolean_Element (False));
         Offset := Offset + 5;
         return Match_OK;
      end if;

      return Match_None;
   end Parse_Bool;

   ---------------
   -- Match_Set --
   ---------------

   function Match_Set (Offset : Natural;
                       Set    : String) return Boolean
   with
      Pre => Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match_Set'Result then (for some E of Set => E = Data (Data'First + Offset)));

   function Match_Set (Offset : Natural;
                       Set    : String) return Boolean
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
      Post => To_Number'Result < 10;

   ---------------------------
   -- Parse_Fractional_Part --
   ---------------------------

   procedure Parse_Fractional_Part
     (Match   : out Match_Type;
      Result  : out Float)
   with
      Pre => Data'First < Integer'Last - Offset and Offset < Data'Length,
      Post => (if Match /= Match_OK then Offset = Offset'Old);

   procedure Parse_Fractional_Part
     (Match   :    out Match_Type;
      Result  :    out Float)
   is
      Divisor    : Long_Integer := 10;
      Tmp_Offset : Natural := Offset;
   begin
      Result := 0.0;
      Match  := Match_None;

      if not Match_Set (Tmp_Offset, ".") then
         return;
      end if;

      Tmp_Offset := Tmp_Offset + 1;
      Match      := Match_Invalid;

      loop

         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            Match := Match_End_Of_Input;
            return;
         end if;
         
         if Divisor = 0 or
            Divisor >= Long_Integer'Last/10
         then
            Match := Match_Overflow;
            return;
         end if;

         if not Match_Set (Tmp_Offset, "0123456789")
         then
            if Match = Match_OK then
               Offset := Tmp_Offset;
            end if;
            return;
         end if;

         Result := Result +
            Float (To_Number (Data (Data'First + Tmp_Offset))) / Float (Divisor);
         Divisor    := Divisor * 10;
         Tmp_Offset := Tmp_Offset + 1;
         Match      := Match_OK;
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
   is
      Leading_Zero : Boolean := False;
      Tmp_Offset   : Natural := Offset;
      Num_Matches  : Natural := 0;
   begin
      Match  := Match_Invalid;
      Result := 0;

      Negative := Match_Set (Tmp_Offset, "-");
      if Negative then
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      loop

         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            Match := Match_End_Of_Input;
            return;
         end if;

         if Num_Matches >= Natural'Last
         then
            Match := Match_Overflow;
            return;
         end if;

         -- Valid digit?
         exit when not Match_Set (Tmp_Offset, "0123456789");

         -- Check for leading '0'
         if Num_Matches = 0 and Data (Data'First + Tmp_Offset) = '0' then
            Leading_Zero := True;
         end if;

         pragma Loop_Invariant (Result >= 0);

         -- Check for overflow
         if Result >= Long_Integer'Last/10 then
            Match := Match_Overflow;
            return;
         end if;

         Result := Result * 10;
         Result := Result + To_Number (Data (Data'First + Tmp_Offset));
         Tmp_Offset := Tmp_Offset + 1;
         Num_Matches := Num_Matches + 1;
      end loop;

      -- No digits found
      if Num_Matches = 0 then
         Match := Match_None;
         return;
      end if;

      -- Leading zeros found
      if Check_Leading and
         ((Result > 0 and Leading_Zero) or
          (Result = 0 and Num_Matches > 1))
      then
         return;
      end if;

      Offset := Tmp_Offset;
      Match  := Match_OK;
   end Parse_Integer;

   -------------------------
   -- Parse_Exponent_Part --
   -------------------------

   procedure Parse_Exponent_Part
     (Match    :    out Match_Type;
      Result   :    out Long_Integer;
      Negative :    out Boolean)
   is
      Scale            : Long_Integer;
      Tmp_Offset       : Natural := Offset;
      Match_Exponent   : Match_Type;
      Integer_Negative : Boolean;
   begin
      Result := 0;
      Negative := False;
      Match  := Match_None;

      if not Match_Set (Tmp_Offset, "Ee") then
         return;
      end if;
      Tmp_Offset := Tmp_Offset + 1;
      Match      := Match_Invalid;

      if not (Data'First + Tmp_Offset in Data'Range)
      then
         Match := Match_End_Of_Input;
         return;
      end if;

      if Match_Set (Tmp_Offset, "+-")
      then
         if Data (Data'First + Tmp_Offset) = '-'
         then
            Negative := True;
         end if;
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      Parse_Integer (False, Match_Exponent, Scale, Integer_Negative);
      if Match_Exponent /= Match_OK or Integer_Negative
      then
         return;
      end if;

      Result := 1;
      for I in 1 .. Scale
      loop
         Result := Result * 10;
      end loop;

      Offset := Tmp_Offset;
      Match := Match_OK;

   end Parse_Exponent_Part;

   ------------------
   -- Parse_Number --
   ------------------

   function Parse_Number return Match_Type
   is
      Fractional_Component : Float := 0.0;
      Integer_Component    : Long_Integer;
      Scale                : Long_Integer;

      Tmp_Offset     : Natural := Offset;
      Match_Int      : Match_Type;
      Match_Frac     : Match_Type := Match_None;
      Match_Exponent : Match_Type;
      Negative       : Boolean;
      Scale_Negative : Boolean;
   begin
      Parse_Integer (True, Match_Int, Integer_Component, Negative);
      if Match_Int /= Match_OK
      then
         return Match_None;
      end if;

      if Data'First < Integer'Last - Tmp_Offset and Tmp_Offset < Data'Length
      then
         Parse_Fractional_Part (Match_Frac, Fractional_Component);
      end if;

      if Context_Index >= Context'Last
      then
         return Match_Out_Of_Memory;
      end if;

      if Match_Frac = Match_Invalid
      then
         return Match_Invalid;
      end if;

      Parse_Exponent_Part (Match_Exponent, Scale, Scale_Negative);
      if Match_Exponent = Match_Invalid
      then
         return Match_Invalid;
      end if;

      --  Convert to float if either we have fractional part or dividing by the
      --  scale would yield a non-integer number.
      if Match_Frac = Match_OK or
         (Match_Exponent = Match_OK and then
          (Scale_Negative and Integer_Component mod Scale > 0))
      then
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
            Context_Index := Context_Index + 1;
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
         Context_Index := Context_Index + 1;
         Set (Integer_Element (Integer_Component));
      end if;

      Offset := Tmp_Offset;
      return Match_OK;

   end Parse_Number;

   ------------------
   -- Parse_String --
   ------------------

   function Parse_String return Match_Type
   is
      Tmp_Offset   : Natural := Offset;
      String_Start : Natural;
      String_End   : Natural;
      Escaped      : Boolean := False;
   begin
      -- Check for starting "
      if not Match_Set (Tmp_Offset, """") then
         return Match_None;
      end if;

      Tmp_Offset   := Tmp_Offset + 1;
      String_Start := Data'First + Tmp_Offset;

      loop
         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            return Match_End_Of_Input;
         end if;

         exit when not Escaped and Match_Set (Tmp_Offset, """");
         Escaped := (if not Escaped and Match_Set (Tmp_Offset, "\") then True else False);
         Tmp_Offset := Tmp_Offset + 1;
      end loop;

      if Data'First >= Integer'Last - Tmp_Offset or
         Tmp_Offset >= Data'Length
      then
         return Match_End_Of_Input;
      end if;

      if Context_Index >= Context'Last
      then
         return Match_Out_Of_Memory;
      end if;

      if not Match_Set (Tmp_Offset, """")
      then
         return Match_Invalid;
      end if;

      String_End := Data'First + Tmp_Offset - 1;
      Context_Index := Context_Index + 1;
      Set (String_Element (String_Start, String_End));
      Offset := Tmp_Offset + 1;
      return Match_OK;

   end Parse_String;

   ------------------
   -- Parse_Object --
   ------------------

   function Parse_Object return Match_Type
   is
      Tmp_Offset      : Natural := Offset;
      Object_Index    : Index_Type;
      Previous_Member : Index_Type;
   begin
      -- Check for starting {
      if not Match_Set (Tmp_Offset, "{") then
         return Match_None;
      end if;

      Context_Index := Context_Index + 1;
      Object_Index := Context_Index;
      Set (Object_Element);
      Previous_Member := Object_Index;

      Tmp_Offset := Tmp_Offset + 1;

      loop
         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            return Match_End_Of_Input;
         end if;

         -- Check for ending '}'
         Skip_Whitespace (Tmp_Offset);
         if Match_Set (Tmp_Offset, "}")
         then
            Tmp_Offset := Tmp_Offset + 1;
            exit;
         end if;

         -- Link previous element to this element
         Context (Previous_Member).Next_Member := Context_Index + 1;
         Previous_Member := Context_Index + 1;

         -- Parse member name
         Skip_Whitespace (Tmp_Offset);
         if Parse_String /= Match_OK then
            return Match_Invalid;
         end if;

         -- Check for name separator (:)
         Skip_Whitespace (Tmp_Offset);
         if not Match_Set (Tmp_Offset, ":") then
            return Match_Invalid;
         end if;
         Tmp_Offset := Tmp_Offset + 1;

         -- Parse member
         if Parse_Internal /= Match_OK then
            return Match_Invalid;
         end if;

         Skip_Whitespace (Tmp_Offset);

         -- Check for value separator ','
         if Match_Set (Tmp_Offset, ",") then
            Tmp_Offset := Tmp_Offset + 1;
         end if;

      end loop;

      Context (Previous_Member).Next_Member := End_Index;
      Offset := Tmp_Offset;
      return Match_OK;

   end Parse_Object;

   ------------------
   -- Parse_Array --
   ------------------

   function Parse_Array return Match_Type
   is
      Tmp_Offset       : Natural := Offset;
      Array_Index      : Index_Type;
      Previous_Element : Index_Type;
   begin
      -- Check for starting [
      if not Match_Set (Tmp_Offset, "[") then
         return Match_None;
      end if;

      Context_Index := Context_Index + 1;
      Array_Index := Context_Index;
      Set (Array_Element);
      Previous_Element := Array_Index;

      Tmp_Offset := Tmp_Offset + 1;

      loop
         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            return Match_Invalid;
         end if;

         -- Check for ending ']'
         Skip_Whitespace (Tmp_Offset);
         if Match_Set (Tmp_Offset, "]")
         then
            Tmp_Offset := Tmp_Offset + 1;
            exit;
         end if;

         -- Link previous object to this element
         Context (Previous_Element).Next_Value := Context_Index + 1;
         Previous_Element := Context_Index + 1;

         -- Parse member
         if Parse_Internal /= Match_OK then
            return Match_Invalid;
         end if;

         Skip_Whitespace (Tmp_Offset);

         -- Check for value separator ','
         if Match_Set (Tmp_Offset, ",") then
            Tmp_Offset := Tmp_Offset + 1;
         end if;

      end loop;

      Context (Previous_Element).Next_Value := End_Index;
      Offset := Tmp_Offset;
      return Match_OK;

   end Parse_Array;

   --------------------
   -- Parse_Internal --
   --------------------

   function Parse_Internal return Match_Type
   is
   begin
      Skip_Whitespace (Offset);

      if Data'First <= Integer'Last - Offset - 3 and
         Offset < Data'Length
      then
         if Parse_Null = Match_None
         then
            if Data'First <= Integer'Last - Offset - 4
            then
               if Parse_Bool = Match_None
               then
                  if Parse_Number = Match_None
                  then
                     if Parse_String = Match_None
                     then
                        if Parse_Object = Match_None
                        then
                           if Parse_Array = Match_None
                           then
                              return Match_Invalid;
                           end if;
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end if;
      return Match_OK;
   end Parse_Internal;

   -----------
   -- Parse --
   -----------

   function Parse return Match_Type
   is
      Match : Match_Type;
   begin
      Match := Parse_Internal;
      Reset;
      return Match;
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

   ------------
   -- Length --
   ------------

   function Length (Index : Index_Type := Null_Index) return Natural
   is
      Element : Context_Element_Type := Get (Index);
      Count   : Natural := 0;
   begin
      loop
         exit when Element.Next_Value = End_Index;
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
         Last_Index := Element.Next_Value;
         Element    := Get (Element.Next_Value);
         Count      := Count + 1;
      end loop;
      return Last_Index;
   end Pos;
end JSON;
