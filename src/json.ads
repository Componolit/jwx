package JSON
   with SPARK_Mode
is

   type Kind_Type  is (Kind_Null, Kind_Boolean, Kind_Float, Kind_Integer, Kind_String, Kind_Object);
   type Match_Type is (Match_OK, Match_None, Match_Invalid);
   type Context_Element_Type is tagged private;
   type Context_Type is array (Natural range <>) of Context_Element_Type;

   -- Parse a JSON file
   procedure Parse (Context : in out Context_Type;
                    Offset  : in out Natural;
                    Match   :    out Match_Type;
                    Data    :        String)
   with
      Pre => Context'Length > 1 and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length;

   -- Return kind of current element of a context
   function Get_Kind (Context : Context_Type) return Kind_Type;

   -- Return value of a boolean context element
   function Get_Boolean (Context : Context_Type) return Boolean
   with
      Pre => Get_Kind (Context) = Kind_Boolean;

   -- Return value of float context element
   function Get_Float (Context : Context_Type) return Float
   with
      Pre => Get_Kind (Context) = Kind_Float;

   -- Return value of integer context element
   function Get_Integer (Context : Context_Type) return Long_Integer
   with
      Pre => Get_Kind (Context) = Kind_Integer;

   -- Return value of a string context element
   function Get_String (Context : Context_Type;
                        Data    : String) return String
   with
      Pre => Get_Kind (Context) = Kind_String;

   -- Query an object by name
   procedure Query_Object (Context  : in out Context_Type;
                           Name     :        String)
   with
      Pre => Get_Kind (Context) = Kind_Object;

private

   type Context_Element_Type is
   tagged record
      Kind          : Kind_Type    := Kind_Null;
      Boolean_Value : Boolean      := False;
      Float_Value   : Float        := 0.0;
      Integer_Value : Long_Integer := 0;
      String_Start  : Integer      := 0;
      String_End    : Integer      := 0;
   end record;

end JSON;
