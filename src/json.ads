package JSON
   with SPARK_Mode
is

   type Kind_Type  is (Kind_Null, Kind_Boolean, Kind_Float, Kind_Integer, Kind_String, Kind_Object);
   type Match_Type is (Match_OK, Match_None, Match_Invalid);
   type Context_Element_Type is tagged private;

   function Null_Element return Context_Element_Type;
   -- Construct null element

   function Boolean_Element (Value : Boolean) return Context_Element_Type;
   -- Construct boolean element

   function Float_Element (Value : Float) return Context_Element_Type;
   -- Construct float element

   function Integer_Element (Value : Long_Integer) return Context_Element_Type;
   -- Construct integer element

   function String_Element (String_Start, String_End : Integer) return Context_Element_Type;
   -- Construct string element

   function Get_Kind (Element : Context_Element_Type) return Kind_Type;
   -- Return kind of a context element

   function Get_Boolean (Element : Context_Element_Type) return Boolean
   with
      Pre'Class => Element.Get_Kind = Kind_Boolean;
   -- Return value of boolean context element

   function Get_Float (Element : Context_Element_Type) return Float
   with
      Pre'Class => Element.Get_Kind = Kind_Float;
   -- Return value of float context element

   function Get_Integer (Element : Context_Element_Type) return Long_Integer
   with
      Pre'Class => Element.Get_Kind = Kind_Integer;
   -- Return value of integer context element

   function Get_String (Element : Context_Element_Type; Data : String) return String
   with
      Pre'Class => Element.Get_Kind = Kind_String;
   -- Return value of a string context element

   type Context_Type is array (Natural range <>) of Context_Element_Type;

   procedure Parse (Context : in out Context_Type;
                    Offset  : in out Natural;
                    Match   :    out Match_Type;
                    Data    :        String)
   with
      Pre => Context'Length > 1 and
             Data'First <= Integer'Last - Offset - 4 and
             Offset < Data'Length;
   -- Parse a JSON file

   function Query_Object (Context  : Context_Type;
                          Position : Natural;
                          Name     : String) return Context_Element_Type
   with
      Pre => Position in Context'Range and then
             Context (Position).Get_Kind = Kind_Object;
   -- Query an object by name

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

   function Null_Element return Context_Element_Type is
      (Kind          => Kind_Null,
       Boolean_Value => False,
       Float_Value   => 0.0,
       Integer_Value => 0,
       String_Start  => 0,
       String_End    => 0);

   function Boolean_Element (Value : Boolean) return Context_Element_Type is
      (Kind          => Kind_Boolean,
       Boolean_Value => Value,
       Float_Value   => 0.0,
       Integer_Value => 0,
       String_Start  => 0,
       String_End    => 0);

   function Float_Element (Value : Float) return Context_Element_Type is
      (Kind          => Kind_Float,
       Boolean_Value => False,
       Float_Value   => Value,
       Integer_Value => 0,
       String_Start  => 0,
       String_End    => 0);

   function Integer_Element (Value : Long_Integer) return Context_Element_Type is
      (Kind          => Kind_Integer,
       Boolean_Value => False,
       Float_Value   => 0.0,
       Integer_Value => Value,
       String_Start  => 0,
       String_End    => 0);

   function String_Element (String_Start, String_End : Integer) return Context_Element_Type is
      (Kind          => Kind_String,
       Boolean_Value => False,
       Float_Value   => 0.0,
       Integer_Value => 0,
       String_Start  => String_Start,
       String_End    => String_End);

end JSON;
