--
--  @author Alexander Senier
--  @date   2018-05-12
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

--  @summary JSON decoding (RFC 7159)
generic

   Data         : String;
   Context_Size : Natural := Data'Length / 3 + 2;
   Depth_Max    : Natural := 100;

package JWX.JSON
  with Abstract_State => State
is

   type Kind_Type is (Kind_Invalid,
                      Kind_Null,
                      Kind_Boolean,
                      Kind_Real,
                      Kind_Integer,
                      Kind_String,
                      Kind_Object,
                      Kind_Array);
   --  Kind of a JSON context object
   --
   --  @value Kind_Invalid  Invalid element
   --  @value Kind_Null     JSON "null" element
   --  @value Kind_Boolean  Boolean
   --  @value Kind_Real     Fractional number
   --  @value Kind_Integer  Integral number
   --  @value Kind_String   String
   --  @value Kind_Object   Structured object
   --  @value Kind_Array    Array

   type Match_Type is (Match_OK,
                       Match_None,
                       Match_Invalid,
                       Match_Out_Of_Memory,
                       Match_Depth_Limit);
   --  Result of a parsing operation
   --
   --  @value Match_OK             JSON document parsed successfully
   --  @value Match_None           No JSON data found
   --  @value Match_Invalid        Malformed JSON data found
   --  @value Match_Out_Of_Memory  Out of context buffer memory, increase
   --                              generic Context_Size parameter when
   --                              instanciating package
   --  @value Match_Depth_Limit    Recursion depth exceeded

   type Index_Type is new Natural range 1 .. Context_Size;
   Null_Index : constant Index_Type := Index_Type'First;
   End_Index  : constant Index_Type := Index_Type'Last;

   procedure Parse (Match : out Match_Type)
   with
      Pre => Data'First >= 0 and
             Data'Last < Natural'Last and
             Data'First <= Data'Last,
      Global => (Input  => (Data, Context_Size, End_Index),
                 In_Out => State);
   --  Parse a JSON file
   --
   --  @param Match  Result of parsing

   function Has_Kind (Index : Index_Type;
                      Kind  : Kind_Type) return Boolean
   with
      Ghost;
   --  Assert the element associated with Index is of Kind
   --
   --  @param Index  Index of element
   --  @param Kind   Expected kind

   function Get_Kind (Index : Index_Type := Null_Index) return Kind_Type
   with
      Post   => Has_Kind (Index, Get_Kind'Result);
   --  Return the kind of a context element
   --
   --  @param Index  Index of element, current element by default
   --  @return Element kind, Invalid_Element if element does not exist

   function Get_Boolean (Index : Index_Type := Null_Index) return Boolean
   with
      Pre => Get_Kind (Index) = Kind_Boolean;
   --  Return value of a boolean context element
   --
   --  @param Index  Index of element, current element by default

   function Get_Real (Index : Index_Type := Null_Index) return Real_Type
   with
      Pre => Get_Kind (Index) = Kind_Real or
             Get_Kind (Index) = Kind_Integer;
   --  Return value of real context element
   --
   --  @param Index  Index of element, current element by default

   function Get_Integer (Index : Index_Type := Null_Index) return Integer_Type
   with
      Pre => Get_Kind (Index) = Kind_Integer;
   --  Return value of integer context element
   --
   --  @param Index  Index of element, current element by default

   function Get_String (Index : Index_Type := Null_Index) return String
   with
      Pre => Get_Kind (Index) = Kind_String;
   --  Return value of a string context element
   --
   --  @param Index  Index of element, current element by default

   function Get_Range (Index : Index_Type := Null_Index) return Range_Type
   with
      Pre => Get_Kind (Index) = Kind_String,
      Post => (if Get_Range'Result /= Empty_Range then
                  Get_Range'Result.First >= Data'First and
                  Get_Range'Result.Last  <= Data'Last and
                  Get_Range'Result.First <= Get_Range'Result.Last and
                  Get_Range'Result.Last < Positive'Last);
   --  Get range of string object inside Data
   --
   --  This is an alternative to Get_String which does not return the actual
   --  string data, but a range object demarcating the beginning and the end
   --  index of the string withing the input document held in Data. This is
   --  useful where you cannot cope with unbounded data, e.g. when constructing
   --  a complex object from a JSON document (cf. JWX.JWK).
   --
   --  @param Index  Index of element, current element by default

   function Query_Object (Name  : String;
                          Index : Index_Type := Null_Index) return Index_Type
   with
       Pre => Get_Kind (Index) = Kind_Object,
       Global => (State, Data, End_Index);
   --  Query object element
   --
   --  @param Name   Name of object element to query
   --  @param Index  Index of element, current element by default
   --  @return An index pointing to object element with name "Name", End_Index
   --         if element was not found

   function Elements (Index : Index_Type := Null_Index) return Natural
   with
      Pre => Get_Kind (Index) = Kind_Object;
   --  Return number of elements of an object
   --
   --  @param Index  Index of element, current element by default

   function Length (Index : Index_Type := Null_Index) return Natural
   with
      Pre => Get_Kind (Index) = Kind_Array,
      Annotate => (GNATprove, Terminating);
   --  Return length of an array
   --
   --  @param Index  Index of element, current element by default

   function Pos (Position : Natural;
                 Index    : Index_Type := Null_Index) return Index_Type
   with
      Pre => Get_Kind (Index) = Kind_Array;
   --  Return object at given position of an array
   --
   --  @param Position  Position inside array
   --  @param Index  Index of array element, current element by default
   --  @return Index to object at Position, End_Index if out of bounds

end JWX.JSON;
