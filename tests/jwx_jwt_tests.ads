--
-- \brief  Tests for JWX.JWT
-- \author Alexander Senier
-- \date   2018-06-08
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package JWX_JWT_Tests is

   type Test_Case is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T: in out Test_Case);
   -- Register routines to be run

   function Name (T : Test_Case) return Message_String;
   -- Provide name identifying the test case

end JWX_JWT_Tests;
