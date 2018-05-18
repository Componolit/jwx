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

with AUnit; use AUnit;
with AUnit.Test_Cases; use AUnit.Test_Cases;

package JWX_Crypto_Tests is

   type Test_Case is new Test_Cases.Test_Case with null record;

   procedure Register_Tests (T: in out Test_Case);

   function Name (T : Test_Case) return Message_String;

end JWX_Crypto_Tests;
