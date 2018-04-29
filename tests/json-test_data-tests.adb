--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into JSON.Test_Data.

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
package body JSON.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Parse (Gnattest_T : in out Test);
   procedure Test_Parse_44459a (Gnattest_T : in out Test) renames Test_Parse;
--  id:2.2/44459a1ec5d8e27c/Parse/1/0/
   procedure Test_Parse (Gnattest_T : in out Test) is
   --  json.ads:8:4:Parse
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Context : Context_Type (Integer range 1..100);
   begin

      Offset := 0;
      Parse (Context, Offset, "true");
      AUnit.Assertions.Assert (Offset = 4, "Parse true");

      Offset := 0;
      Parse (Context, Offset, "false");
      AUnit.Assertions.Assert (Offset = 5, "Parse false.");

      Offset := 0;
      Parse (Context, Offset, "null");
      AUnit.Assertions.Assert (Offset = 4, "Parse null.");

      Offset := 0;
      Parse (Context, Offset, "True");
      AUnit.Assertions.Assert (Offset = 0, "True case insensitive.");

      Offset := 0;
      Parse (Context, Offset, "FALSE");
      AUnit.Assertions.Assert (Offset = 0, "True case insensitive.");

      Offset := 0;
      Parse (Context, Offset, "nulL");
      AUnit.Assertions.Assert (Offset = 0, "True case insensitive.");

--  begin read only
   end Test_Parse;
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
end JSON.Test_Data.Tests;
