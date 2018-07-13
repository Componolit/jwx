--
-- \brief  JSON decoding (RFC 7159)
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic

   Input_Data   : String;
   Context_Size : Natural := Input_Data'Length/3 + 2;

package JWX.JSON
   with
      Abstract_State => State,
      Initializes    => (State, Data)
is


   -- This is a workaround for a bug in GNAT prior to Community 2018, where a
   -- generic formal parameter is not considered a legal component of refined
   -- state.
   Data : constant String := Input_Data;

   type Kind_Type is (Kind_Invalid,
                      Kind_Null,
                      Kind_Boolean,
                      Kind_Float,
                      Kind_Integer,
                      Kind_String,
                      Kind_Object,
                      Kind_Array);

   type Match_Type is (Match_OK,
                       Match_None,
                       Match_Invalid,
                       Match_Out_Of_Memory);

   type Index_Type is new Natural range 1 .. Context_Size;
   Null_Index : constant Index_Type := Index_Type'First;
   End_Index  : constant Index_Type := Index_Type'Last;

   -- Parse a JSON file
   procedure Parse (Match : out Match_Type)
   with
       Pre     => Data'First <= Data'Last;

   -- Assert that a @Index@ has a certain kind
   function Has_Kind (Index : Index_Type;
                      Kind  : Kind_Type) return Boolean
   with
      Ghost;

   -- Return kind of current element of a context
   function Get_Kind (Index : Index_Type := Null_Index) return Kind_Type
   with
      Global => (Input => State),
      Post   => Has_Kind (Index, Get_Kind'Result);

   -- Return value of a boolean context element
   function Get_Boolean (Index : Index_Type := Null_Index) return Boolean
   with
      Pre => Get_Kind (Index) = Kind_Boolean;

   -- Return value of float context element
   function Get_Float (Index : Index_Type := Null_Index) return Long_Float
   with
      Pre => Get_Kind (Index) = Kind_Float or
             Get_Kind (Index) = Kind_Integer;

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

   -- Return number of elements of an object
   function Elements (Index : Index_Type := Null_Index) return Natural
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

end JWX.JSON;
