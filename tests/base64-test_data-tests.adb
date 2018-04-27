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

--  begin read only
--  end read only

--  begin read only
   procedure Test_To_Byte_Array (Gnattest_T : in out Test);
   procedure Test_To_Byte_Array_16b0dc (Gnattest_T : in out Test) renames Test_To_Byte_Array;
--  id:2.2/16b0dc56c3d0b60c/To_Byte_Array/1/0/
   procedure Test_To_Byte_Array (Gnattest_T : in out Test) is
   --  base64.ads:10:4:To_Byte_Array
--  end read only

      pragma Unreferenced (Gnattest_T);

      subtype BA is Byte_Array (1..3);
      b : BA;

   begin

      Base64.To_Byte_Array ("Foo", b);
      AUnit.Assertions.Assert
        (b = (Character'Pos('F'), Character'Pos('o'), Character'Pos('o')),
         "Conversion failed.");

--  begin read only
   end Test_To_Byte_Array;
--  end read only


--  begin read only
   procedure Test_To_String (Gnattest_T : in out Test);
   procedure Test_To_String_8ef20e (Gnattest_T : in out Test) renames Test_To_String;
--  id:2.2/8ef20ee1bec5ccff/To_String/1/0/
   procedure Test_To_String (Gnattest_T : in out Test) is
   --  base64.ads:19:4:To_String
--  end read only

      pragma Unreferenced (Gnattest_T);
      S : String := "xxx";

   begin
      Base64.To_String ((Character'Pos('F'), Character'Pos('o'), Character'Pos('o')), S);
      AUnit.Assertions.Assert (S = "Foo", S);

--  begin read only
   end Test_To_String;
--  end read only


--  begin read only
   procedure Test_Encode (Gnattest_T : in out Test);
   procedure Test_Encode_139c8c (Gnattest_T : in out Test) renames Test_Encode;
--  id:2.2/139c8c615858bc41/Encode/1/0/
   procedure Test_Encode (Gnattest_T : in out Test) is
   --  base64.ads:28:4:Encode
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Encode;
--  end read only


--  begin read only
   procedure Test_Decode (Gnattest_T : in out Test);
   procedure Test_Decode_b2b1e9 (Gnattest_T : in out Test) renames Test_Decode;
--  id:2.2/b2b1e99c33b736d4/Decode/1/0/
   procedure Test_Decode (Gnattest_T : in out Test) is
   --  base64.ads:33:4:Decode
--  end read only

      pragma Unreferenced (Gnattest_T);
      subtype Result_Type is Byte_Array (1..3);
      subtype String_Type is String (1..3);

      V : Boolean;
      R : Result_Type;
      S : String_Type;
   begin

      Decode (Encoded => "Zg==", Valid => V, Result => R);
      To_String (R, S);
      AUnit.Assertions.Assert (V and S = "f", "Test vector #1 (valid=" & V'Img & " value=" & S & ")");

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
