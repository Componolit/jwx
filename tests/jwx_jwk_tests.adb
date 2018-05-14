--
-- \brief  Tests for JWX.JWK
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.JWK;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;

package body JWX_JWK_Tests is

   package Key is new JWK;

   procedure Test_Parse_RFC7517_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
      Data : String := Read_File ("tests/data/RFC7517_example_1.json");
   begin
      Parse (Data);
		Assert (Valid, "Key invalid");
		Assert (Kind = Kind_EC, "Invalid kind");
		Assert (ID = "Public key used in JWS spec Appendix A.3 example", "Invalid key ID");
		Assert (False, "Not finished");
      --  FIXME: Check for X/Y coordinates
		--  Assert (X = );
	end Test_Parse_RFC7517_Vector_1;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_RFC7517_Vector_1'Access, "RFC7517 Vector #1");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWX Tests");
   end Name;

end JWX_JWK_Tests;

