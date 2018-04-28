package JSON
   with SPARK_Mode
is

   type Context_Element_Type is private;
   type Context_Type is array (Natural range <>) of Context_Element_Type;

   procedure Parse (Context : in out Context_Type;
                    Data    :        String;
                    Valid   :    out Boolean)
   with
      Pre => Context'Length > 1;
   -- Parse a JSON file

private

   type Kind_Type  is (Kind_Boolean);
   type Value_Type is (Value_True, Value_Null, Value_False);

   type Context_Element_type is
   record
      Kind  : Kind_Type;
      Value : Value_Type;
   end record;

end JSON;
