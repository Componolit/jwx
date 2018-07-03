--
-- \brief  JWX utility functions
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package body JWX.Util
   with
      SPARK_Mode
is
   -------------------
   -- To_Byte_Array --
   -------------------

   procedure To_Byte_Array
      (Data   :     String;
       Result : out JWX.Byte_Array)
   is
   begin
      Result := (others => 0);
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Pos (Data (Data'First + I));
      end loop;
   end To_Byte_Array;

   ---------------
   -- To_String --
   ---------------

   procedure To_String
      (Data   :     JWX.Byte_Array;
       Result : out String)
   is
   begin
      Result := (others => Character'Val (0));
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Val (Data (Data'First + I));
      end loop;
   end To_String;

   ----------
   -- Size --
   ----------

   function Size (Value : Float) return Natural
   is
   begin
      return 0;
   end Size;

   function Size (Value : Long_Integer) return Natural
   is
      Tmp    : Long_Integer := Value;
      Result : Natural      := 0;
   begin
      if Tmp <= 0
      then
         Result := 1;
      end if;

      while Tmp /= 0
      loop
         Tmp    := Tmp / 10;
         Result := Result + 1;
      end loop;
      return Result;
   end Size;

end JWX.Util;
