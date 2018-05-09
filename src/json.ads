generic

   Context_Size : Natural;
   Data         : String;

package JSON
   with SPARK_Mode
is

   type Kind_Type is (Kind_Null,
                      Kind_Boolean,
                      Kind_Float,
                      Kind_Integer,
                      Kind_String,
                      Kind_Object,
                      Kind_Array);

   type Match_Type is (Match_OK,
                       Match_None,
                       Match_Invalid,
                       Match_Out_Of_Memory,
                       Match_End_Of_Input,
                       Match_Overflow);

   type Index_Type is new Natural range 0 .. Context_Size;
   Null_Index : constant Index_Type;

   -- Parse a JSON file
   function Parse return Match_Type;

   -- Return kind of current element of a context
   function Get_Kind (Index : Index_Type := Null_Index) return Kind_Type;

   -- Return value of a boolean context element
   function Get_Boolean (Index : Index_Type := Null_Index) return Boolean
   with
      Pre => Get_Kind (Index) = Kind_Boolean;

   -- Return value of float context element
   function Get_Float (Index : Index_Type := Null_Index) return Float
   with
      Pre => Get_Kind (Index) = Kind_Float;

   -- Return value of integer context element
   function Get_Integer (Index : Index_Type := Null_Index) return Long_Integer
   with
      Pre => Get_Kind (Index) = Kind_Integer;

   -- Return value of a string context element
   function Get_String (Index : Index_Type := Null_Index) return String
   with
      Pre => Get_Kind (Index) = Kind_String;

   -- Query object
   function Query_Object (Name  : String;
                          Index : Index_Type := Null_Index) return Index_Type
   with
      Pre => Get_Kind (Index) = Kind_Object;

   -- Return length of an array
   function Length (Index : Index_Type := Null_Index) return Natural
   with
      Pre => Get_Kind (Index) = Kind_Array;

   -- Return object at given position of an array
   function Pos (Position : Natural;
                 Index    : Index_Type := Null_Index) return Index_Type
   with
      Pre => Get_Kind (Index) = Kind_Array;

private

   Null_Index : constant Index_Type := Index_Type'First;
   End_Index  : constant Index_Type := Index_Type'Last;

   type Context_Element_Type is
   tagged record
      Kind           : Kind_Type    := Kind_Null;
      Boolean_Value  : Boolean      := False;
      Float_Value    : Float        := 0.0;
      Integer_Value  : Long_Integer := 0;
      String_Start   : Integer      := 0;
      String_End     : Integer      := 0;
      Next_Value     : Index_Type   := 0;
      Next_Member    : Index_Type   := 0;
   end record;

   type Context_Type is array (Index_Type) of Context_Element_Type;

   Context_Index : Index_Type;
   Offset        : Natural := Data'First;

   function Parse_Internal return Match_Type;

end JSON;
