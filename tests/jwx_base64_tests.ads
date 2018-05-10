with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;
with BASE64; use BASE64;

package JWX_BASE64_Tests is

   type Test_Case is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T: in out Test_Case);
   -- Register routines to be run

   function Name (T : Test_Case) return Message_String;
   -- Provide name identifying the test case

end JWX_BASE64_Tests;
