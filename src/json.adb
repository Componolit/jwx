package body JSON
   with SPARK_Mode
is
   ----------------
   -- Parse_Bool --
   ----------------

   procedure Parse_Bool
     (Context : in out Context_Type;
      Data    :        String;
      Valid   :    out Boolean)
   with
      Pre => Context'Length > 0;

   procedure Parse_Bool
     (Context : in out Context_Type;
      Data    :        String;
      Valid   :    out Boolean)
   is
   begin
      Valid := True;

      if Data'Length > 3 and then Data (Data'First .. Data'First + 3) = "true"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_True);
      elsif Data'Length > 3 and then Data (Data'First .. Data'First + 3) = "null"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_Null);
      elsif Data'Length > 4 and then Data (Data'First .. Data'First + 4) = "false"
      then
         Context (Context'First) := (Kind => Kind_Boolean, Value => Value_False);
      else
         Valid := False;
      end if;
   end Parse_Bool;

   -----------
   -- Parse --
   -----------

   procedure Parse
     (Context : in out Context_Type;
      Data    :        String;
      Valid   :    out Boolean)
   is
   begin
      Parse_Bool (Context, Data, Valid);
   end Parse;

end JSON;
