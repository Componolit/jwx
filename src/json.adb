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
      Match   :    out Boolean;
      Data    :        String)
   with
      Pre => Context'Length > 0 and
             Data'First <= Integer'Last - Offset - 3 and
             Offset < Data'Length,
      Post => (if not Match then Context = Context'Old and
                                 Offset = Offset'Old);

   procedure Parse_Null
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   is
      Base : Natural := Data'First + Offset;
   begin
      Match := False;
      if Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "null"
      then
         Context (Context'First) := Null_Element;
         Offset := Offset + 4;
         Match := True;
      end if;
   end Parse_Null;

   ----------------
   -- Parse_Bool --
   ----------------

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   with
      Pre => Context'Length > 0 and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length,
      Post => (if not Match then Context = Context'Old and
                                 Offset = Offset'Old);

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   is
      Base : Natural := Data'First + Offset;
   begin
      Match := False;
      if Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "true"
      then
         Context (Context'First) := Boolean_Element (True);
         Offset := Offset + 4;
         Match := True;
      elsif Offset <= Data'Length - 5 and then Data (Base .. Base + 4) = "false"
      then
         Context (Context'First) := Boolean_Element (False);
         Offset := Offset + 5;
         Match := True;
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
             Offset < Data'Length;

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

   ------------------
   -- Parse_Number --
   ------------------

   procedure Parse_Number
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   with
      Pre => Context'Length > 0 and
             Data'First < Integer'Last - Offset and
             Offset < Data'Length,
      Post => (if not Match then Context = Context'Old and
                                 Offset = Offset'Old);

   procedure Parse_Number
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   is
      Fractional_Component : Float := 0.0;
      Integer_Component    : Long_Integer := 0;

      Negative    : Boolean;
      Divisor     : Long_Integer := 10;
      Tmp_Offset  : Natural := Offset;
      Num_Matches : Natural := 0;
      Tmp_Match   : Boolean := False;
      Frac_Match  : Boolean := False;
      Fraction    : Boolean := False;

      function To_Number (Value : Character) return Long_Integer
         is (Character'Pos (Value) - Character'Pos ('0'));
   begin
      Negative := Match_Set (Data, Tmp_Offset, "-");
      if Negative then
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      while Tmp_Offset < Data'Length and then Match_Set (Data, Tmp_Offset, "0123456789")
      loop
         -- Check for leading 0
         if Num_Matches > 1 and Data (Data'First + Tmp_Offset) = '0' then
            Match := False;
            return;
         end if;

         -- Check for overflow
         if Integer_Component >= Long_Integer'Last/10 then
            Match := False;
            return;
         end if;

         Integer_Component := Integer_Component * 10;
         Integer_Component := Integer_Component + To_Number (Data (Data'First + Tmp_Offset));
         Tmp_Offset := Tmp_Offset + 1;
         Num_Matches := Num_Matches + 1;
         Tmp_Match := True;

      end loop;

      if not Tmp_Match then
         Match := False;
         return;
      end if;

      -- Fractional part
      Fraction := Match_Set (Data, Tmp_Offset, ".");
      if Fraction then
         Tmp_Offset := Tmp_Offset + 1;
      end if;

      while (Fraction and
             Tmp_Offset < Data'Length and
             Divisor < Long_Integer'Last/10) and then
             Match_Set (Data, Tmp_Offset, "0123456789")
      loop
         Fractional_Component :=
            Fractional_Component +
            Float (To_Number (Data (Data'First + Tmp_Offset))) / Float (Divisor);
         Divisor    := Divisor * 10;
         Frac_Match := True;
         Tmp_Offset := Tmp_Offset + 1;
      end loop;

      -- Error: Dot found but not digits following it
      if Fraction and not Frac_Match then
         Match := False;
         return;
      end if;

      -- FIXME: Support exponent as per RFC 7159, section 6

      if Fraction then
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
      Match  := True;

   end Parse_Number;

   -----------
   -- Parse --
   -----------

   procedure Parse
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   is
   begin
      Match := False;
      Parse_Whitespace (Offset, Data);

      if Data'First <= Integer'Last - Offset - 3 and
         Offset < Data'Length
      then
         Parse_Null (Context, Offset, Match, Data);
         if not Match
         then
            if Data'First <= Integer'Last - Offset - 4
            then
               Parse_Bool (Context, Offset, Match, Data);
               if not Match
               then
                  Parse_Number (Context, Offset, Match, Data);
               end if;
            end if;
         end if;
      end if;
   end Parse;

end JSON;
