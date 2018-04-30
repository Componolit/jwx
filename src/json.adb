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

   function Get_Integer (Element : Context_Element_Type) return Integer
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
             Offset < Data'Length;

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
             Offset < Data'Length;

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
   -- Parse --
   -----------

   procedure Parse
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Boolean;
      Data    :        String)
   is
   begin
      Parse_Whitespace (Offset, Data);

      Parse_Null (Context, Offset, Match, Data);
      if not Match then
         Parse_Bool (Context, Offset, Match, Data);
      end if;
   end Parse;

end JSON;
