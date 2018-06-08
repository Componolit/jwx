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
with JWX_JWK_Tests;
with JWX_JWS_Tests;
with JWX_Crypto_Tests;
with JWX_Stream_Auth_Tests;
with JWX_JWT_Tests;

package body JWX_Suite is

   use AUnit.Test_Suites;

   -- Statically allocate test suite:
   Result : aliased Test_Suite;

   --  Statically allocate test cases:
   JSON_Test        : aliased JWX_JSON_Tests.Test_Case;
   Base64_Test      : aliased JWX_Base64_Tests.Test_Case;
   JWK_Test         : aliased JWX_JWK_Tests.Test_Case;
   JWS_Test         : aliased JWX_JWS_Tests.Test_Case;
   Crypto_Test      : aliased JWX_Crypto_Tests.Test_Case;
   Stream_Auth_Test : aliased JWX_Stream_Auth_Tests.Test_Case;
   JWT_Test         : aliased JWX_JWT_Tests.Test_Case;

   function Suite return Access_Test_Suite is
   begin
      Add_Test (Result'Access, JSON_Test'Access);
      Add_Test (Result'Access, Base64_Test'Access);
      Add_Test (Result'Access, JWK_Test'Access);
      Add_Test (Result'Access, JWS_Test'Access);
      Add_Test (Result'Access, Crypto_Test'Access);
      Add_Test (Result'Access, Stream_Auth_Test'Access);
      Add_Test (Result'Access, JWT_Test'Access);
      return Result'Access;
   end Suite;

end JWX_Suite;
