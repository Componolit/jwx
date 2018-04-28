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
   procedure Test_Parse_8d61b6 (Gnattest_T : in out Test) renames Test_Parse;
--  id:2.2/8d61b60544a8bbfd/Parse/1/0/
   procedure Test_Parse (Gnattest_T : in out Test) is
   --  json.ads:8:4:Parse
--  end read only

      pragma Unreferenced (Gnattest_T);

      Valid   : Boolean;
      Context : Context_Type (Integer range 1..100);
   begin

      Parse (Context, "true", Valid);
      AUnit.Assertions.Assert (Valid, "Parse true.");

      Parse (Context, "false", Valid);
      AUnit.Assertions.Assert (Valid, "Parse false.");

      Parse (Context, "null", Valid);
      AUnit.Assertions.Assert (Valid, "Parse null.");

      Parse (Context, "True", Valid);
      AUnit.Assertions.Assert (not Valid, "True case insensitive.");

      Parse (Context, "FALSE", Valid);
      AUnit.Assertions.Assert (not Valid, "True case insensitive.");

      Parse (Context, "nulL", Valid);
      AUnit.Assertions.Assert (not Valid, "True case insensitive.");

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
