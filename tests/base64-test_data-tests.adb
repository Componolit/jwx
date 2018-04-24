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
   procedure Test_Encode (Gnattest_T : in out Test);
   procedure Test_Encode_060b6f (Gnattest_T : in out Test) renames Test_Encode;
--  id:2.2/060b6f9bfe4f8a12/Encode/1/0/
   procedure Test_Encode (Gnattest_T : in out Test) is
   --  base64.ads:9:4:Encode
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
   procedure Test_Decode_190339 (Gnattest_T : in out Test) renames Test_Decode;
--  id:2.2/190339337434c039/Decode/1/0/
   procedure Test_Decode (Gnattest_T : in out Test) is
   --  base64.ads:14:4:Decode
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

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
