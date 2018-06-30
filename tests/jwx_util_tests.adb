--
-- \brief  Tests for JWX.Util
-- \author Alexander Senier
-- \date   2018-06-30
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.Util;

package body JWX_Util_Tests
is

   procedure Test_Integer_Size (T : in out Test_Cases.Test_Case'Class)
   is
      use JWX.Util;
   begin
		Assert (Size (43549) = 5, "Invalid size #1");
		Assert (Size (-1344454) = 8, "Invalid size #2");
		Assert (Size (0) = 1, "Invalid size #3");
		Assert (Size (1234567890) = 10, "Invalid size #4");
   end Test_Integer_Size;

   ---------------------------------------------------------------------------

   procedure Test_Float_Size (T : in out Test_Cases.Test_Case'Class)
   is
      use JWX.Util;
   begin
		Assert (Size (0.13445) = 7, "Invalid size #1");
		Assert (Size (-0.135) = 6, "Invalid size #2");
		Assert (Size (-0.135e10) = 7, "Invalid size #3");
		Assert (Size (1.5) = 3, "Invalid size #4");
		Assert (Size (0.000000000009) = 14, "Invalid size #5");
   end Test_Float_Size;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Integer_Size'Access, "Integer Size");
      Register_Routine (T, Test_Float_Size'Access, "Float Size");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("Util Tests");
   end Name;

end JWX_Util_Tests;
