with Ada.Text_IO;
use Ada.Text_IO;

package body JSON
   with SPARK_Mode
is

   ------------------
   -- Meta_Element --
   ------------------

   function Meta_Element (Initial_Offset : Natural) return Context_Element_Type is
   -- Construct null element
      (Kind           => Kind_Meta,
       Boolean_Value  => False,
       Float_Value    => 0.0,
       Integer_Value  => 0,
       String_Start   => 0,
       String_End     => 0,
       Context_Offset => Initial_Offset,
       Next_Element   => 0);

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
       Next_Element   => 0);

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
       Next_Element   => 0);

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
       Next_Element   => 0);

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
       Next_Element   => 0);

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
       Next_Element   => 0);

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
       Next_Element   => 0);

   -------------------
   -- Context_Valid --
   -------------------

   function Context_Valid (Context : Context_Type) return Boolean is
      (Context'Length > 1 and then
       Context (Context'First).Context_Offset in Context'Range);

   -----------------------
   -- Get_Current_Index --
   -----------------------

   function Get_Current_Index (Context : Context_Type) return Natural
   with
      Pre  => Context_Valid (Context),
      Post => Get_Current_Index'Result in Context'Range;

   function Get_Current_Index (Context : Context_Type) return Natural
   -- Get current context index
   is
   begin
      return Context (Context'First).Context_Offset;
   end Get_Current_Index;

   -----------------
   -- Get_Current --
   -----------------

   function Get_Current (Context : Context_Type) return Context_Element_Type
   -- Return current element of a context
   with
      Pre => Context_Valid (Context)
   is
   begin
      return Context (Get_Current_Index (Context));
   end Get_Current;

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

   --------------
   -- Get_Kind --
   --------------

   function Get_Kind (Element : Context_Element_Type) return Kind_Type
   is
   begin
      return Element.Kind;
   end Get_Kind;

   -----------------
   -- Get_Boolean --
   -----------------

   function Get_Boolean (Element : Context_Element_Type) return Boolean
   is
   begin
      return Element.Boolean_Value;
   end Get_Boolean;

   ---------------
   -- Get_Float --
   ---------------

   function Get_Float (Element : Context_Element_Type) return Float
   is
   begin
      return Element.Float_Value;
   end Get_Float;

   -----------------
   -- Get_Integer --
   -----------------

   function Get_Integer (Element : Context_Element_Type) return Long_Integer
   is
   begin
      return Element.Integer_Value;
   end Get_Integer;

   ----------------
   -- Get_String --
   ----------------

   function Get_String (Element : Context_Element_Type;
                        Data    : String) return String
   is
   begin
      if Element.String_Start in Data'Range and
         Element.String_End in Data'Range
      then
         return Data (Element.String_Start .. Element.String_End);
      else
         return "";
      end if;
   end Get_String;

   --------------
   -- Get_Kind --
   --------------

   function Get_Kind (Context : Context_Type) return Kind_Type
   is
   begin
      return Get_Current (Context).Get_Kind;
   end Get_Kind;

   -----------------
   -- Get_Boolean --
   -----------------

   function Get_Boolean (Context : Context_Type) return Boolean
   is
   begin
      return Get_Current (Context).Get_Boolean;
   end Get_Boolean;

   ---------------
   -- Get_Float --
   ---------------

   function Get_Float (Context : Context_Type) return Float
   is
   begin
      return Get_Current (Context).Get_Float;
   end Get_Float;

   -----------------
   -- Get_Integer --
   -----------------

   function Get_Integer (Context : Context_Type) return Long_Integer
   is
   begin
      return Get_Current (Context).Get_Integer;
   end Get_Integer;

   ----------------
   -- Get_String --
   ----------------

   function Get_String (Context : Context_Type;
                        Data    : String) return String
   is
   begin
      return Get_Current (Context).Get_String (Data);
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

   -----------
   -- Match --
   -----------

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
   end;

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

      Negative    : Boolean;
      Tmp_Offset  : Natural := Offset;
      Num_Matches : Natural := 0;
      Frac_Result : Match_Type := Match_None;

   begin
      Match := Match_Invalid;

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

         -- Check for leading 0
         if Num_Matches > 1 and Data (Data'First + Tmp_Offset) = '0' then
            return;
         end if;

         pragma Loop_Invariant (Integer_Component >= 0);

         -- Check for overflow
         if Integer_Component >= Long_Integer'Last/10 then
            return;
         end if;

         Integer_Component := Integer_Component * 10;
         Integer_Component := Integer_Component + To_Number (Data (Data'First + Tmp_Offset));
         Tmp_Offset := Tmp_Offset + 1;
         Num_Matches := Num_Matches + 1;
      end loop;

      -- No digits found
      if Num_Matches = 0 then
         Match := Match_None;
         return;
      end if;

      if Data'First < Integer'Last - Tmp_Offset and Tmp_Offset < Data'Length
      then
         Parse_Fractional_Part (Tmp_Offset, Frac_Result, Fractional_Component, Data);
      end if;

      if Frac_Result = Match_Invalid or
         Get_Current_Index (Context) >= Context'Last then
         Match := Match_Invalid;
         return;
      end if;

      -- FIXME: Support exponent as per RFC 7159, section 6
      if Frac_Result = Match_OK then
         declare
            Tmp : Float := Float (Integer_Component) + Fractional_Component;
         begin
            if Negative then
               Tmp := -Tmp;
            end if;
            Increment_Current_Index (Context);
            Context (Get_Current_Index (Context)) := Float_Element (Tmp);
         end;
      else
         if Negative then
            Integer_Component := -Integer_Component;
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
      Tmp_Offset   : Natural := Offset;
      Match_Name   : Match_Type;
      Match_Member : Match_Type;
      Object_Index : Natural;
      Previous_Member : Natural;
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

         -- Parse member name
         Parse_Whitespace (Tmp_Offset, Data);
         Parse_String (Context, Tmp_Offset, Match_Name, Data);
         if Match_Name /= Match_OK then
            return;
         end if;

         -- Link previous element to this element
         Context (Previous_Member).Next_Element := Get_Current_Index (Context);
         Previous_Member := Get_Current_Index (Context);

         -- Check for name separator (:)
         Parse_Whitespace (Tmp_Offset, Data);
         if not Match_Set (Data, Tmp_Offset, ":") then
            return;
         end if;
         Tmp_Offset := Tmp_Offset + 1;

         -- Parse member
         Parse (Context, Tmp_Offset, Match_Member, Data);
         if Match_Member /= Match_OK then
            return;
         end if;

         Parse_Whitespace (Tmp_Offset, Data);

         -- Check for value separator ','
         if Match_Set (Data, Tmp_Offset, ",") then
            Tmp_Offset := Tmp_Offset + 1;
         -- Check for ending '}'
         elsif Match_Set (Data, Tmp_Offset, "}")
         then
            Tmp_Offset := Tmp_Offset + 1;
            exit;
         end if;

      end loop;

      Context (Previous_Member).Next_Element := 0;
      Context (Context'First).Context_Offset := Object_Index;
      Offset := Tmp_Offset;
      Match := Match_OK;

   end Parse_Object;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Context : in out Context_Type)
   is
   begin
      Context (Context'First) := Meta_Element (Context'First);
   end Initialize;

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
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end if;
   end Parse;

   ------------------
   -- Query_Object --
   ------------------

   function Query_Object (Context  : Context_Type;
                          Data     : String;
                          Name     : String) return Context_Element_Type
   is
      Element       : Context_Element_Type := Get_Current (Context);
      Element_Index : Natural;
   begin
      while Element.Next_Element /= 0
      loop
         Element_Index := Element.Next_Element;
         Element       := Context (Element_Index);

         if Element.Get_Kind = Kind_String and then
            Element.Get_String (Data) = Name
         then
            -- Value object are stored next to member names
            return Context (Element_Index + 1);
         end if;
      end loop;
      return Null_Element;
   end Query_Object;

   ------------
   -- Length --
   ------------

   function Length (Context : Context_Type) return Natural
   is
   begin
      return 0;
   end Length;

   ---------
   -- Pos --
   ---------

   function Pos (Context  : Context_Type;
                 Position : Natural) return Context_Element_Type
   is
   begin
      return Null_Element;
   end Pos;
end JSON;
