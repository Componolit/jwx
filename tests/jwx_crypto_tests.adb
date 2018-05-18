--
-- \brief  Tests for JWX.Crypto
-- \author Alexander Senier
-- \date   2018-05-18
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.Crypto;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;

package body JWX_Crypto_Tests is

   procedure Test_Message_Type_Conversion (T : in out Test_Cases.Test_Case'Class)
   is
   begin
		Assert (False, "Not implemented");
	end Test_Message_Type_Conversion;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Message_Type_Conversion'Access, "Message type conversion");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("Crypto Tests");
   end Name;

end JWX_Crypto_Tests;
