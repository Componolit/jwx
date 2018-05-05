package JSON
   with SPARK_Mode
is

   type Kind_Type is (Kind_Null,
                      Kind_Boolean,
                      Kind_Float,
                      Kind_Integer,
                      Kind_String,
                      Kind_Object,
                      Kind_Array,
                      Kind_Meta);

   type Match_Type is (Match_OK, Match_None, Match_Invalid);

   type Context_Element_Type is tagged private;

   -- Return kind of an element
   function Get_Kind (Element : Context_Element_Type) return Kind_Type;

   -- Return boolean from element
   function Get_Boolean (Element : Context_Element_Type) return Boolean
   with
      Pre'Class => Element.Get_Kind = Kind_Boolean;

   -- Return float from element
   function Get_Float (Element : Context_Element_Type) return Float
   with
      Pre'Class => Element.Get_Kind = Kind_Float;

   -- Return integer from element
   function Get_Integer (Element : Context_Element_Type) return Long_Integer
   with
      Pre'Class => Element.Get_Kind = Kind_Integer;

   -- Return string from element
   function Get_String (Element : Context_Element_Type;
                        Data    : String) return String
   with
      Pre'Class => Element.Get_Kind = Kind_String;

   type Context_Type is array (Natural range <>) of Context_Element_Type;

   -- Predicate stating that context is initialized
   function Context_Valid (Context : Context_Type) return Boolean
   with
      Ghost;

   -- Initialize Context
   procedure Initialize (Context : in out Context_Type)
   with
      Pre  => Context'Length > 1,
      Post => Context_Valid (Context);

   -- Parse a JSON file
   procedure Parse (Context : in out Context_Type;
                    Offset  : in out Natural;
                    Match   :    out Match_Type;
                    Data    :        String)
   with
      Pre => Context_Valid (Context) and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length;

   -- Return kind of current element of a context
   function Get_Kind (Context : Context_Type) return Kind_Type
   with
      Pre => Context_Valid (Context);

   -- Return value of a boolean context element
   function Get_Boolean (Context : Context_Type) return Boolean
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context) = Kind_Boolean;

   -- Return value of float context element
   function Get_Float (Context : Context_Type) return Float
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context) = Kind_Float;

   -- Return value of integer context element
   function Get_Integer (Context : Context_Type) return Long_Integer
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context) = Kind_Integer;

   -- Return value of a string context element
   function Get_String (Context : Context_Type;
                        Data    : String) return String
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context) = Kind_String;

   -- Query an object by name
   function Query_Object (Context : Context_Type;
                          Data    : String;
                          Name   : String) return Context_Element_Type
   with
      Pre'Class => Context_Valid (Context) and then
                   Get_Kind (Context) = Kind_Object;

   -- Return length of an array
   function Length (Context : Context_Type) return Natural
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context) = Kind_Array;

   -- Return object at given position of an array
   function Pos (Context  : Context_Type;
                 Position : Natural) return Context_Element_Type
   with
      Pre'Class => Context_Valid (Context) and then
                   Get_Kind (Context) = Kind_Array;

private

   type Context_Element_Type is
   tagged record
      Kind           : Kind_Type    := Kind_Null;
      Boolean_Value  : Boolean      := False;
      Float_Value    : Float        := 0.0;
      Integer_Value  : Long_Integer := 0;
      String_Start   : Integer      := 0;
      String_End     : Integer      := 0;
      Context_Offset : Natural      := 0;
      Next_Element   : Natural      := 0;
   end record;

end JSON;
