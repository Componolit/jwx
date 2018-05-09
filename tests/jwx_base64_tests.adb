with AUnit.Assertions; use AUnit.Assertions;

package body JWX_BASE64_Tests is

   procedure Test_Parse_True (T : in out Test_Cases.Test_Case'Class)
   is
   begin
		Assert (False, "Invalid");
	end Test_Parse_True;

	-- Register test routines to call
   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Parse_True'Access, "Parse true");
   end Register_Tests;

   -- Identifier of test case
   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("BASE64 Tests");
   end Name;

end JWX_BASE64_Tests;
