with AUnit.Assertions; use AUnit.Assertions;
with JSON;

package body JWX_JSON_Tests is

   procedure Test_Parse_True (T : in out Test_Cases.Test_Case'Class)
   is
      package J is new JSON (Context_Size => 10, Data => "true");
      use J;
   begin
		Assert (Parse = Match_OK, "Parse failed");
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Boolean = true, "Invalid value");
	end Test_Parse_True;

   procedure Test_Parse_False (T : in out Test_Cases.Test_Case'Class)
   is
      package J is new JSON (Context_Size => 10, Data => "false");
      use J;
   begin
		Assert (Parse = Match_OK, "Parse failed");
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Boolean = false, "Invalid value");
	end Test_Parse_False;

	-- Register test routines to call
   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      -- Repeat for each test routine:
      Register_Routine (T, Test_Parse_True'Access, "Parse true");
      Register_Routine (T, Test_Parse_False'Access, "Parse false");
   end Register_Tests;

   -- Identifier of test case
   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JSON Tests");
   end Name;

end JWX_JSON_Tests;
