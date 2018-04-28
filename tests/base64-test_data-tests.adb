--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into Base64.Test_Data.

with AUnit.Assertions; use AUnit.Assertions;
with System.Assertions;

--  begin read only
--  id:2.2/00/
--
--  This section can be used to add with clauses if necessary.
--
--  end read only

--  begin read only
--  end read only
package body Base64.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

   procedure To_Byte_Array
      (Data   :        String;
       Result : in out Byte_Array)
   with
      Pre =>
         Data'Length > 0 and
         Result'Length >= Data'Length;
   -- Convert a String to a byte array

   procedure To_String
      (Data   :        Byte_Array;
       Result : in out String)
   with
      Pre =>
         Data'Length > 0 and
         Result'Length >= Data'Length;
   -- Convert a Byte_Array to a String

   -------------------
   -- To_Byte_Array --
   -------------------

   procedure To_Byte_Array
      (Data   :        String;
       Result : in out Byte_Array)
   is
   begin
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Pos (Data (Data'First + I));
      end loop;
   end To_Byte_Array;

   ---------------
   -- To_String --
   ---------------

   procedure To_String
      (Data   :        Byte_Array;
       Result : in out String)
   is
   begin
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Val (Data (Data'First + I));
      end loop;
   end To_String;

--  begin read only
--  end read only

--  begin read only
   procedure Test_Decode (Gnattest_T : in out Test);
   procedure Test_Decode_9d8f81 (Gnattest_T : in out Test) renames Test_Decode;
--  id:2.2/9d8f8119fdf6d82a/Decode/1/0/
   procedure Test_Decode (Gnattest_T : in out Test) is
   --  base64.ads:13:4:Decode
--  end read only

      pragma Unreferenced (Gnattest_T);
      subtype Result_Type is Byte_Array (1..50);
      subtype String_Type is String (1..50);

      L : Natural;
      R : Result_Type;
      S : String_Type;
   begin

      Decode (Encoded => "Zg==", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "f", "RFC4648 - Test vector #1");

      Decode (Encoded => "Zm8=", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "fo", "RFC4648 - Test vector #2");

      Decode (Encoded => "Zm9v", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "foo", "RFC4648 - Test vector #3");

      Decode (Encoded => "Zm9vYg==", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "foob", "RFC4648 - Test vector #4");

      Decode (Encoded => "Zm9vYmE=", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "fooba", "RFC4648 - Test vector #5");

      Decode (Encoded => "Zm9vYmFy", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "foobar", "RFC4648 - Test vector #6");

      Decode (Encoded => "YW55IGNhcm5hbCBwbGVhc3VyZS4=", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "any carnal pleasure.", "Wikipedia - Test vector #1");

      Decode (Encoded => "YW55IGNhcm5hbCBwbGVhc3VyZQ==", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "any carnal pleasure", "Wikipedia - Test vector #2");

      Decode (Encoded => "YW55IGNhcm5hbCBwbGVhc3Vy", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "any carnal pleasur", "Wikipedia - Test vector #3");

      Decode (Encoded => "YW55IGNhcm5hbCBwbGVhc3U=", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "any carnal pleasu", "Wikipedia - Test vector #4");

      Decode (Encoded => "YW55IGNhcm5hbCBwbGVhcw==", Length => L, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (L > 0 and S(1..L) = "any carnal pleas", "Wikipedia - Test vector #5");

--  begin read only
   end Test_Decode;
--  end read only

--  begin read only
--  id:2.2/02/
--
--  This section can be used to add elaboration code for the global state.
--
begin
--  end read only
   null;
--  begin read only
--  end read only
end Base64.Test_Data.Tests;
