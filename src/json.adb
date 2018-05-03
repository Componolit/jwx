with Ada.Text_IO;
use Ada.Text_IO;

package body JSON
   with SPARK_Mode
is
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
      return Data (Element.String_Start..Element.String_End);
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
      Pre => Context'Length > 0 and
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
      if Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "null"
      then
         Context (Context'First) := Null_Element;
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
      Pre => Context'Length > 0 and
             Data'First <= Integer'Last - Offset - 4 and
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
      if Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "true"
      then
         Context (Context'First) := Boolean_Element (True);
         Offset := Offset + 4;
         Match := Match_OK;
      elsif Offset <= Data'Length - 5 and then Data (Base .. Base + 4) = "false"
      then
         Context (Context'First) := Boolean_Element (False);
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
      Pre => Context'Length > 0 and
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

      while (Data'First < Integer'Last - Tmp_Offset and Tmp_Offset < Data'Length) and then
             (Num_Matches < Natural'Last and Match_Set (Data, Tmp_Offset, "0123456789"))
      loop
         -- Check for leading 0
         if Num_Matches > 1 and Data (Data'First + Tmp_Offset) = '0' then
            return;
         end if;

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

      if Frac_Result = Match_Invalid then
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
            Context (Context'First) := Float_Element (Tmp);
         end;
      else
         if Negative then
            Integer_Component := -Integer_Component;
         end if;
         Context (Context'First) := Integer_Element (Integer_Component);
      end if;

      Offset := Tmp_Offset;
      Match  := Match_OK;

   end Parse_Number;

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
         if Match /= Match_OK
         then
            if Data'First <= Integer'Last - Offset - 4
            then
               Parse_Bool (Context, Offset, Match, Data);
               if Match /= Match_OK
               then
                  Parse_Number (Context, Offset, Match, Data);
               end if;
            end if;
         end if;
      end if;
   end Parse;

end JSON;
