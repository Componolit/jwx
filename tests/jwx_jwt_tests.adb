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

with AUnit.Assertions; use AUnit.Assertions;
with JWX.JWT;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;
use type JWX.JWT.Result_Type;

package body JWX_JWT_Tests is

   procedure Test_Validate_JWT (T : in out Test_Cases.Test_Case'Class)
   is
      Tmp  : String := Read_File ("tests/data/JWT_test_data.dat");
      Key  : String := Read_File ("tests/data/HTTP_auth_key.json");

      -- Do not pass in last character in Data as this is a new line which
      -- is not expected (JWX.JWSCS expects the token to end at the last
      -- character)
      Data   : String := Tmp (Tmp'First .. Tmp'Last - 1);
      Result : JWT.Result_Type;
   begin
      Result := JWT.Validate_Compact (Data     => Data,
                                      Key_Data => Key,
                                      Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                      Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                                      Now      => 1528404620);
      Assert (Result = JWT.Result_OK, "Validation failed: " & Result'Img);
   end Test_Validate_JWT;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_JWT_Invalid_Audience (T : in out Test_Cases.Test_Case'Class)
   is
      Tmp  : String := Read_File ("tests/data/JWT_test_data.dat");
      Key  : String := Read_File ("tests/data/HTTP_auth_key.json");

      -- Do not pass in last character in Data as this is a new line which
      -- is not expected (JWX.JWSCS expects the token to end at the last
      -- character)
      Data : String := Tmp (Tmp'First .. Tmp'Last - 1);

      Result : JWT.Result_Type;
   begin
      Result := JWT.Validate_Compact (Data     => Data,
                                      Key_Data => Key,
                                      Audience => "deadbeefkvjtHejID0lKzVioMfTmuXaM",
                                      Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                                      Now      => 1528404620);
      Assert (Result = JWT.Result_Invalid_Audience, "Invalid audience expected: " & Result'Img);
   end Test_JWT_Invalid_Audience;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_JWT_Invalid_Issuer (T : in out Test_Cases.Test_Case'Class)
   is
      Tmp  : String := Read_File ("tests/data/JWT_test_data.dat");
      Key  : String := Read_File ("tests/data/HTTP_auth_key.json");

      -- Do not pass in last character in Data as this is a new line which
      -- is not expected (JWX.JWSCS expects the token to end at the last
      -- character)
      Data : String := Tmp (Tmp'First .. Tmp'Last - 1);

      Result : JWT.Result_Type;
   begin
      Result := JWT.Validate_Compact (Data     => Data,
                                      Key_Data => Key,
                                      Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                      Issuer   => "https://invalid.eu.auth0.com/",
                                      Now      => 1528404620);
      Assert (Result = JWT.Result_Invalid_Issuer, "Invalid issuer expected: " & Result'Img);
   end Test_JWT_Invalid_Issuer;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_JWT_Expired (T : in out Test_Cases.Test_Case'Class)
   is
      Tmp  : String := Read_File ("tests/data/JWT_test_data.dat");
      Key  : String := Read_File ("tests/data/HTTP_auth_key.json");

      -- Do not pass in last character in Data as this is a new line which
      -- is not expected (JWX.JWSCS expects the token to end at the last
      -- character)
      Data : String := Tmp (Tmp'First .. Tmp'Last - 1);

      Result : JWT.Result_Type;
   begin
      Result := JWT.Validate_Compact (Data     => Data,
                                      Key_Data => Key,
                                      Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                      Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                                      Now      => 1528408620);
      Assert (Result = JWT.Result_Expired, "Expiry not detected: " & Result'Img);
   end Test_JWT_Expired;

   --------------------------------------------------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Validate_JWT'Access, "Validate JWT");
      Register_Routine (T, Test_JWT_Invalid_Audience'Access, "JWT invalid audiance");
      Register_Routine (T, Test_JWT_Invalid_Issuer'Access, "JWT invalid issuer");
      Register_Routine (T, Test_JWT_Expired'Access, "JWT expired");
   end Register_Tests;

   --------------------------------------------------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWT Tests");
   end Name;

end JWX_JWT_Tests;
