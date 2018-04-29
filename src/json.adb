package body JSON
   with SPARK_Mode
is
   ----------------
   -- Parse_Bool --
   ----------------

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Data    :        String)
   with
      Pre => Context'Length > 0 and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length;

   procedure Parse_Bool
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Data    :        String)
   is
      Base : Natural := Data'First + Offset;
   begin
      if Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "true"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_True);
         Offset := Offset + 4;
      elsif Offset <= Data'Length - 4 and then Data (Base .. Base + 3) = "null"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_Null);
         Offset := Offset + 4;
      elsif Offset <= Data'Length - 5 and then Data (Base .. Base + 4) = "false"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_False);
         Offset := Offset + 5;
      end if;
   end Parse_Bool;

   -----------
   -- Parse --
   -----------

   procedure Parse
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Data    :        String)
   is
   begin
      Parse_Bool (Context, Offset, Data);
   end Parse;

end JSON;
