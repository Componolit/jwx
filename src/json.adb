package body JSON
   with SPARK_Mode
is
   ----------
   -- Next --
   ----------

   function Next (Index : Index_Type) return Index_Type
   is
   begin
      return Index + 1;
   end Next;

   ------------------
   -- Meta_Element --
   ------------------

   function Meta_Element (Initial_Offset : Index_Type) return Context_Element_Type is
   -- Construct meta data element
      (Kind           => Kind_Meta,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Context_Offset => Initial_Offset,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   ------------------
   -- Null_Element --
   ------------------

   function Null_Element return Context_Element_Type is
   -- Construct null element
      (Kind           => Kind_Null,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Context_Offset => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

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
       Context_Offset => 0,
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
       Context_Offset => 0,
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
       Context_Offset => 0,
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
       Context_Offset => 0,
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
       Context_Offset => 0,
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
       Context_Offset => 0,
       Next_Value     => End_Index,
       Next_Member    => End_Index);

   -------------------
   -- Context_Valid --
   -------------------

   function Context_Valid (Context : Context_Type) return Boolean is
      (Context'Length > 1 and then
       Context (Context'First).Context_Offset in Context'Range);

   -----------------------
   -- Get_Current_Index --
   -----------------------

   function Get_Current_Index (Context : Context_Type) return Index_Type
   with
      Pre  => Context_Valid (Context),
      Post => Get_Current_Index'Result in Context'Range;

   function Get_Current_Index (Context : Context_Type) return Index_Type
   -- Get current context index
   is
   begin
      return Context (Context'First).Context_Offset;
   end Get_Current_Index;

   ---------
   -- Get --
   ---------

   function Get (Context : Context_Type;
                 Index   : Index_Type := Null_Index) return Context_Element_Type
   -- Return current element of a context
   with
      Pre => Context_Valid (Context)
   is
   begin
      if Index = Null_Index
      then
         return Context (Get_Current_Index (Context));
      elsif Index = End_Index
      then
         return Null_Element;
      else
         return Context (Index);
      end if;
   end Get;

   -----------------------------
   -- Increment_Current_Index --
   -----------------------------

   procedure Increment_Current_Index (Context : in out Context_Type)
   with
      Pre => Context_Valid (Context) and then
             Get_Current_Index (Context) < Context'Last,
      Post => Context_Valid (Context) and then
              Get_Current_Index (Context) in Context'Range;

   procedure Increment_Current_Index (Context : in out Context_Type)
   -- Increment the current context offset
   is
   begin
      Context (Context'First).Context_Offset :=
         Context (Context'First).Context_Offset + 1;
   end Increment_Current_Index;

   -----------
   -- Reset --
   -----------

   procedure Reset (Context : in out Context_Type)
   with
      Pre  => Context_Valid (Context),
      Post => Context_Valid (Context)
   is
   begin
      Context (Context'First).Context_Offset := Context'First + 1;
   end Reset;

   --------------
   -- Get_Kind --
   --------------

   function Get_Kind (Context : Context_Type;
                      Index   : Index_Type := Null_Index) return Kind_Type
   is
   begin
      return Get (Context, Index).Kind;
   end Get_Kind;

   -----------------
   -- Get_Boolean --
   -----------------

   function Get_Boolean (Context : Context_Type;
                         Index   : Index_Type := Null_Index) return Boolean
   is
   begin
      return Get (Context, Index).Boolean_Value;
   end Get_Boolean;

   ---------------
   -- Get_Float --
   ---------------

   function Get_Float (Context : Context_Type;
                       Index   : Index_Type := Null_Index) return Float
   is
   begin
      return Get (Context, Index).Float_Value;
   end Get_Float;

   -----------------
   -- Get_Integer --
   -----------------

   function Get_Integer (Context : Context_Type;
                         Index   : Index_Type := Null_Index) return Long_Integer
   is
   begin
      return Get (Context, Index).Integer_Value;
   end Get_Integer;

   ----------------
   -- Get_String --
   ----------------

   function Get_String (Context : Context_Type;
                        Data    : String;
                        Index   : Index_Type := Null_Index) return String
   is
      Element : Context_Element_Type := Get (Context, Index);
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
   -- Parse_Whitespace --
   ----------------------

   procedure Parse_Whitespace
     (Offset  : in out Natural;
      Data    :        String)
   with
      Pre => Data'First <= Integer'Last - Offset - 1 and
             Offset < Data'Length;

   procedure Parse_Whitespace
     (Offset  : in out Natural;
      Data    :        String)
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
   end Parse_Whitespace;

   ----------------
   -- Parse_Null --
   ----------------

   procedure Parse_Null
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First <= Integer'Last - Offset - 3 and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_Null
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Base : Natural := Data'First + Offset;
   begin
      Match := Match_None;
      if Get_Current_Index (Context) < Context'Last and
         (Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "null")
      then
         Increment_Current_Index (Context);
         Context (Get_Current_Index (Context)) := Null_Element;
         Offset := Offset + 4;
         Match := Match_OK;
      end if;
   end Parse_Null;

   ----------------
   -- Parse_Bool --
   ----------------

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First <= Integer'Last - Offset - 5 and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Base : Natural := Data'First + Offset;
   begin
      Match := Match_None;
      if Get_Current_Index (Context) < Context'Last and
         (Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "true")
      then
         Increment_Current_Index (Context);
         Context (Get_Current_Index (Context)) := Boolean_Element (True);
         Offset := Offset + 4;
         Match := Match_OK;
      elsif Get_Current_Index (Context) < Context'Last and
            (Offset <= Data'Length - 5 and then Data (Base .. Base + 4) = "false")
      then
         Increment_Current_Index (Context);
         Context (Get_Current_Index (Context)) := Boolean_Element (False);
         Offset := Offset + 5;
         Match := Match_OK;
      end if;
   end Parse_Bool;

   ---------------
   -- Match_Set --
   ---------------

   function Match_Set
     (Data   : String;
      Offset : Natural;
      Set    : String) return Boolean
   with
      Pre => Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match_Set'Result then (for some E of Set => E = Data (Data'First + Offset)));

   function Match_Set
     (Data   : String;
      Offset : Natural;
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
     (Offset  : in out Natural;
      Match   :    out Match_Type;
      Result  :    out Float;
      Data    :        String)
   with
      Pre => Data'First < Integer'Last - Offset and Offset < Data'Length,
      Post => (if Match /= Match_OK then Offset = Offset'Old);

   procedure Parse_Fractional_Part
     (Offset  : in out Natural;
      Match   :    out Match_Type;
      Result  :    out Float;
      Data    :        String)
   is
      Divisor    : Long_Integer := 10;
      Tmp_Offset : Natural := Offset;
   begin
      Result := 0.0;
      Match  := Match_None;

      if not Match_Set (Data, Tmp_Offset, ".") then
         return;
      end if;

      Tmp_Offset := Tmp_Offset + 1;
      Match      := Match_Invalid;

      while (Data'First < Integer'Last - Tmp_Offset and
             Tmp_Offset < Data'Length and
             Divisor > 0 and
             Divisor < Long_Integer'Last/10) and then
             Match_Set (Data, Tmp_Offset, "0123456789")
      loop
         Result := Result +
            Float (To_Number (Data (Data'First + Tmp_Offset))) / Float (Divisor);
         Divisor    := Divisor * 10;
         Tmp_Offset := Tmp_Offset + 1;
         Match      := Match_OK;
      end loop;

      if Match = Match_OK then
         Offset := Tmp_Offset;
      end if;
   end Parse_Fractional_Part;

   -------------------
   -- Parse_Integer --
   -------------------

   procedure Parse_Integer
     (Offset        : in out Natural;
      Check_Leading :        Boolean;
      Match         :    out Match_Type;
      Result        :    out Long_Integer;
      Negative      :    out Boolean;
      Data          :        String)
   with
      Pre => Data'First < Integer'Last - Offset and
             Offset < Data'Length;

   procedure Parse_Integer
     (Offset        : in out Natural;
      Check_Leading :        Boolean;
      Match         :    out Match_Type;
      Result        :    out Long_Integer;
      Negative      :    out Boolean;
      Data          :        String)
   is
      Leading_Zero : Boolean := False;
      Tmp_Offset   : Natural := Offset;
      Num_Matches  : Natural := 0;
   begin
      Match  := Match_Invalid;
      Result := 0;

      Negative := Match_Set (Data, Tmp_Offset, "-");
      if Negative then
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      while Data'First < Integer'Last - Tmp_Offset and
            Tmp_Offset < Data'Length and
            Num_Matches < Natural'Last
      loop
         -- Valid digit?
         exit when not Match_Set (Data, Tmp_Offset, "0123456789");

         -- Check for leading '0'
         if Num_Matches = 0 and Data (Data'First + Tmp_Offset) = '0' then
            Leading_Zero := True;
         end if;

         pragma Loop_Invariant (Result >= 0);

         -- Check for overflow
         if Result >= Long_Integer'Last/10 then
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
     (Offset   : in out Natural;
      Match    :    out Match_Type;
      Result   :    out Long_Integer;
      Negative :    out Boolean;
      Data     :        String)
   with
      Pre => Data'First < Integer'Last - Offset and Offset < Data'Length,
      Post => (if Match /= Match_OK then Offset = Offset'Old);

   procedure Parse_Exponent_Part
     (Offset   : in out Natural;
      Match    :    out Match_Type;
      Result   :    out Long_Integer;
      Negative :    out Boolean;
      Data     :        String)
   is
      Scale            : Long_Integer;
      Tmp_Offset       : Natural := Offset;
      Match_Exponent   : Match_Type := Match_None;
      Integer_Negative : Boolean;
   begin
      Result := 0;
      Negative := False;
      Match  := Match_None;

      if not Match_Set (Data, Tmp_Offset, "Ee") then
         return;
      end if;
      Tmp_Offset := Tmp_Offset + 1;
      Match      := Match_Invalid;

      if Match_Set (Data, Tmp_Offset, "+-")
      then
         if Data (Data'First + Tmp_Offset) = '-'
         then
            Negative := True;
         end if;
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      Parse_Integer (Tmp_Offset, False, Match_Exponent, Scale, Integer_Negative, Data);
      if Match_Exponent /= Match_OK
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

   procedure Parse_Number
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_Number
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Fractional_Component : Float := 0.0;
      Integer_Component    : Long_Integer := 0;
      Scale                : Long_Integer := 0;

      Tmp_Offset     : Natural := Offset;
      Match_Frac     : Match_Type := Match_None;
      Match_Exponent : Match_Type := Match_None;
      Negative       : Boolean;
      Scale_Negative : Boolean;
   begin
      Parse_Integer (Tmp_Offset, True, Match, Integer_Component, Negative, Data);
      if Match /= Match_OK
      then
         return;
      end if;

      if Data'First < Integer'Last - Tmp_Offset and Tmp_Offset < Data'Length
      then
         Parse_Fractional_Part (Tmp_Offset, Match_Frac, Fractional_Component, Data);
      end if;

      if Match_Frac = Match_Invalid or
         Get_Current_Index (Context) >= Context'Last then
         Match := Match_Invalid;
         return;
      end if;

      Parse_Exponent_Part (Tmp_Offset, Match_Exponent, Scale, Scale_Negative, Data);
      if Match_Exponent = Match_Invalid
      then
         Match := Match_Invalid;
         return;
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
            Increment_Current_Index (Context);
            Context (Get_Current_Index (Context)) := Float_Element (Tmp);
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
         Increment_Current_Index (Context);
         Context (Get_Current_Index (Context)) := Integer_Element (Integer_Component);
      end if;

      Offset := Tmp_Offset;
      Match  := Match_OK;

   end Parse_Number;

   ------------------
   -- Parse_String --
   ------------------

   procedure Parse_String
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_String
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Tmp_Offset   : Natural := Offset;
      String_Start : Natural;
      String_End   : Natural;
      Escaped      : Boolean := False;
   begin
      Match := Match_None;

      -- Check for starting "
      if not Match_Set (Data, Tmp_Offset, """") then
         return;
      end if;

      Tmp_Offset   := Tmp_Offset + 1;
      String_Start := Data'First + Tmp_Offset;
      Match        := Match_Invalid;

      while (Data'First < Integer'Last - Tmp_Offset and
             Tmp_Offset < Data'Length)
      loop
         exit when not Escaped and Match_Set (Data, Tmp_Offset, """");
         Escaped := (if not Escaped and Match_Set (Data, Tmp_Offset, "\") then True else False);
         Tmp_Offset := Tmp_Offset + 1;
      end loop;

      if Data'First >= Integer'Last - Tmp_Offset or
         Tmp_Offset >= Data'Length
      then
         return;
      end if;

      if not Match_Set (Data, Tmp_Offset, """") or
         Get_Current_Index (Context) >= Context'Last
      then
         return;
      end if;

      String_End := Data'First + Tmp_Offset - 1;
      Increment_Current_Index (Context);
      Context (Get_Current_Index (Context)) := String_Element (String_Start, String_End);
      Offset := Tmp_Offset + 1;
      Match := Match_OK;

   end Parse_String;

   ------------------
   -- Parse_Object --
   ------------------

   procedure Parse_Object
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_Object
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Tmp_Offset      : Natural := Offset;
      Match_Name      : Match_Type;
      Match_Member    : Match_Type;
      Object_Index    : Index_Type;
      Previous_Member : Index_Type;
   begin
      Match := Match_None;

      -- Check for starting {
      if not Match_Set (Data, Tmp_Offset, "{") then
         return;
      end if;

      Increment_Current_Index (Context);
      Object_Index := Get_Current_Index (Context);
      Context (Object_Index) := Object_Element;
      Previous_Member := Object_Index;

      Tmp_Offset := Tmp_Offset + 1;
      Match := Match_Invalid;

      loop
         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            return;
         end if;

         -- Check for ending '}'
         Parse_Whitespace (Tmp_Offset, Data);
         if Match_Set (Data, Tmp_Offset, "}")
         then
            Tmp_Offset := Tmp_Offset + 1;
            exit;
         end if;

         -- Link previous element to this element
         Context (Previous_Member).Next_Member := Get_Current_Index (Context) + 1;
         Previous_Member := Get_Current_Index (Context) + 1;

         -- Parse member name
         Parse_Whitespace (Tmp_Offset, Data);
         Parse_String (Context, Tmp_Offset, Match_Name, Data);
         if Match_Name /= Match_OK then
            return;
         end if;

         -- Check for name separator (:)
         Parse_Whitespace (Tmp_Offset, Data);
         if not Match_Set (Data, Tmp_Offset, ":") then
            return;
         end if;
         Tmp_Offset := Tmp_Offset + 1;

         -- Parse member
         Parse_Internal (Context, Tmp_Offset, Match_Member, Data);
         if Match_Member /= Match_OK then
            return;
         end if;

         Parse_Whitespace (Tmp_Offset, Data);

         -- Check for value separator ','
         if Match_Set (Data, Tmp_Offset, ",") then
            Tmp_Offset := Tmp_Offset + 1;
         end if;

      end loop;

      Context (Previous_Member).Next_Member := End_Index;
      Offset := Tmp_Offset;
      Match := Match_OK;

   end Parse_Object;

   ------------------
   -- Parse_Array --
   ------------------

   procedure Parse_Array
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if Match /= Match_OK then Context = Context'Old and
                                         Offset = Offset'Old);

   procedure Parse_Array
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
      Tmp_Offset       : Natural := Offset;
      Match_Element    : Match_Type;
      Array_Index      : Index_Type;
      Previous_Element : Index_Type;
   begin
      Match := Match_None;

      -- Check for starting [
      if not Match_Set (Data, Tmp_Offset, "[") then
         return;
      end if;

      Increment_Current_Index (Context);
      Array_Index := Get_Current_Index (Context);
      Context (Array_Index) := Array_Element;
      Previous_Element := Array_Index;

      Tmp_Offset := Tmp_Offset + 1;
      Match := Match_Invalid;

      loop
         if Data'First >= Integer'Last - Tmp_Offset or
            Tmp_Offset >= Data'Length
         then
            return;
         end if;

         Parse_Whitespace (Tmp_Offset, Data);
         if Match_Set (Data, Tmp_Offset, "]")
         then
            Tmp_Offset := Tmp_Offset + 1;
            exit;
         end if;

         -- Link previous object to this element
         Context (Previous_Element).Next_Value := Get_Current_Index (Context) + 1;
         Previous_Element := Get_Current_Index (Context) + 1;

         -- Parse member
         Parse_Internal (Context, Tmp_Offset, Match_Element, Data);
         if Match_Element /= Match_OK then
            return;
         end if;

         Parse_Whitespace (Tmp_Offset, Data);

         -- Check for value separator ','
         if Match_Set (Data, Tmp_Offset, ",") then
            Tmp_Offset := Tmp_Offset + 1;
         -- Check for ending '}'
         end if;

      end loop;

      Context (Previous_Element).Next_Value := End_Index;
      Offset := Tmp_Offset;
      Match := Match_OK;

   end Parse_Array;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Context : in out Context_Type)
   is
   begin
      Context := (others => Null_Element);
      Context (Context'First) := Meta_Element (Context'First);
   end Initialize;

   --------------------
   -- Parse_Internal --
   --------------------

   procedure Parse_Internal
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
   begin
      Match := Match_None;
      Parse_Whitespace (Offset, Data);

      if Data'First <= Integer'Last - Offset - 3 and
         Offset < Data'Length
      then
         Parse_Null (Context, Offset, Match, Data);
         if Match = Match_None
         then
            if Data'First <= Integer'Last - Offset - 4
            then
               Parse_Bool (Context, Offset, Match, Data);
               if Match = Match_None
               then
                  Parse_Number (Context, Offset, Match, Data);
                  if Match = Match_None
                  then
                     Parse_String (Context, Offset, Match, Data);
                     if Match = Match_None
                     then
                        Parse_Object (Context, Offset, Match, Data);
                        if Match = Match_None
                        then
                           Parse_Array (Context, Offset, Match, Data);
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end if;
   end Parse_Internal;

   -----------
   -- Parse --
   -----------

 procedure Parse
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String)
   is
   begin
      Parse_Internal (Context, Offset, Match, Data);
      Reset (Context);
   end Parse;

   ------------------
   -- Query_Object --
   ------------------

   function Query_Object (Context  : Context_Type;
                          Data     : String;
                          Name     : String;
                          Index    : Index_Type := Null_Index) return Index_Type
   is
      I : Index_Type := Index;
   begin
      loop
         I := Get (Context, I).Next_Member;
         exit when I = End_Index;

         if Get_Kind (Context, I) = Kind_String and then
            Get_String (Context, Data, I) = Name
         then
            -- Value object are stored next to member names
            return Next (I);
         end if;
      end loop;
      return End_Index;
   end Query_Object;

   ------------
   -- Length --
   ------------

   function Length (Context : Context_Type;
                    Index   : Index_Type := Null_Index) return Natural
   is
      Element : Context_Element_Type := Get (Context, Index);
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

   function Pos (Context  : Context_Type;
                 Position : Natural;
                 Index    : Index_Type := Null_Index) return Index_Type
   is
      Count      : Natural := 0;
      Last_Index : Index_Type := Index;
      Element    : Context_Element_Type := Get (Context, Last_Index);
   begin
      loop
         exit when Count = Position;
         if Element.Next_Value = End_Index
         then
            return End_Index;
         end if;
         Last_Index := Element.Next_Value;
         Element    := Get (Context, Element.Next_Value);
         Count      := Count + 1;
      end loop;
      return Last_Index;
   end Pos;
end JSON;
