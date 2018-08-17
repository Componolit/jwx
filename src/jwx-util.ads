--
--  @author Alexander Senier
--  @date   2018-05-16
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX;

--  @summary JWX utility functions
package JWX.Util
with
   SPARK_Mode
is
   procedure To_Byte_Array
      (Data   :     String;
       Result : out JWX.Byte_Array)
   with
      Pre => Result'Length >= Data'Length;
   --  Convert a string into an equivalent byte array
   --  @param Data   Input string
   --  @param Result Converted byte array

   procedure To_String
      (Data   :     JWX.Byte_Array;
       Result : out String)
   with
      Pre => Result'Length >= Data'Length;
   --  Convert a byte array into an equivalent string
   --  @param Data   Input byte array
   --  @param Result Converted string

end JWX.Util;
