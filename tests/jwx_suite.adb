--
-- \brief  JWX test suite
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

-- Import tests and sub-suites to run
with JWX_JSON_Tests;
with JWX_Base64_Tests;

package body JWX_Suite is

   use AUnit.Test_Suites;

   -- Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   JSON_Test   : aliased JWX_JSON_Tests.Test_Case;
   Base64_Test : aliased JWX_Base64_Tests.Test_Case;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, JSON_Test'Access);
      Add_Test (Result'Access, Base64_Test'Access);
      return Result'Access;
   end Suite;

end JWX_Suite;
