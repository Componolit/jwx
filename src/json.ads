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

   type Index_Type is new Natural;
   Null_Index : constant Index_Type;

   -- Return next index
   function Next (Index : Index_Type) return Index_Type;

   type Context_Type is array (Index_Type range <>) of Context_Element_Type;

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
   function Get_Kind (Context : Context_Type;
                      Index   : Index_Type := Null_Index) return Kind_Type
   with
      Pre => Context_Valid (Context);

   -- Return value of a boolean context element
   function Get_Boolean (Context : Context_Type;
                         Index   : Index_Type := Null_Index) return Boolean
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Boolean;

   -- Return value of float context element
   function Get_Float (Context : Context_Type;
                       Index   : Index_Type := Null_Index) return Float
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Float;

   -- Return value of integer context element
   function Get_Integer (Context : Context_Type;
                         Index   : Index_Type := Null_Index) return Long_Integer
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Integer;

   -- Return value of a string context element
   function Get_String (Context : Context_Type;
                        Data    : String;
                        Index   : Index_Type := Null_Index) return String
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_String;

   -- Query object
   function Query_Object (Context : Context_Type;
                          Data    : String;
                          Name    : String;
                          Index   : Index_Type := Null_Index) return Index_Type
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Object;

   -- Return length of an array
   function Length (Context : Context_Type;
                    Index   : Index_Type := Null_Index) return Natural
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Array;

   -- Return object at given position of an array
   function Pos (Context  : Context_Type;
                 Position : Natural;
                 Index    : Index_Type := Null_Index) return Index_Type
   with
      Pre => Context_Valid (Context) and then
             Get_Kind (Context, Index) = Kind_Array;

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
      Context_Offset : Index_Type   := 0;
      Next_Value     : Index_Type   := 0;
      Next_Member    : Index_Type   := 0;
   end record;

   procedure Parse_Internal
     (Context : in out Context_Type;
      Offset  : in out Natural;
      Match   :    out Match_Type;
      Data    :        String);

end JSON;
