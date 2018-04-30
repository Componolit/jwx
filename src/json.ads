package JSON
   with SPARK_Mode
is

   type Kind_Type  is (Kind_Null, Kind_Boolean);
   type Context_Element_Type is tagged private;

   Null_Element : constant Context_Element_Type;

   function Is_Null (Element : Context_Element_Type) return Boolean;
   -- Element has 'null' value

   function Get_Kind (Element : Context_Element_Type) return Kind_Type;
   -- Return kind of a context element

   function Get_Boolean (Element : Context_Element_Type) return Boolean
   with
      Pre'Class => Element.Get_Kind = Kind_Boolean and not Element.Is_Null;
   -- Return value of boolean context element

   type Context_Type is array (Natural range <>) of Context_Element_Type;

   procedure Parse (Context : in out Context_Type;
                    Offset  : in out Natural;
                    Match   :    out Boolean;
                    Data    :        String)
   with
      Pre => Context'Length > 1 and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length;
   -- Parse a JSON file

private

   type Value_Type is (Value_True, Value_Null, Value_False);

   type Context_Element_type is
   tagged record
      Kind  : Kind_Type;
      Value : Value_Type;
   end record;

   Null_Element : constant Context_Element_Type := (Kind => Kind_Null, Value => Value_Null);

end JSON;
