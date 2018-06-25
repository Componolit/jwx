--
-- \brief  Tests for JWX.Stream_Auth
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
-- -- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX_Test_Utils; use JWX_Test_Utils;

package body JWX_Stream_Auth_Tests is

   ---------------------------------------------------------------------------

   procedure Test_Invalid_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "Invalid",
                                         Issuer   => "Invalid");
      use HA;
      Auth : Auth_Result_Type;
   begin
      Auth := Authenticated ("INVAILD REQUEST", 0);
      Assert (Auth /= Auth_Invalid, "Invalid request not detected: " & Auth'Img);
   end Test_Invalid_Request;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Unauthenticated_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");
      Input    : String := Read_File ("tests/data/HTTP_valid_unauth.dat");

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "Invalid",
                                         Issuer   => "Invalid");
      use HA;
      Auth : Auth_Result_Type;
   begin
      Auth := Authenticated (Input, 0);
      Assert (Auth /= Auth_Invalid,
              "Unauthenticated request not detected: " & Auth'Img);
   end Test_Valid_Unauthenticated_Request;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Authenticated_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Request  : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                         Issuer   => "https://cmpnlt-demo.eu.auth0.com/");
      use HA;
      Auth : Auth_Result_Type;
   begin
      Auth := Authenticated (Request, 1528404000);
      Assert (Auth = Auth_OK,
              "Authenticated request not detected: " & Auth'Img);
   end Test_Valid_Authenticated_Request;

   ---------------------------------------------------------------------------

   procedure Test_Garbage_Token (T : in out Test_Cases.Test_Case'Class)
   is
      Request  : String := Read_File ("tests/data/HTTP_garbage_auth.dat");
      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                         Issuer   => "https://cmpnlt-demo.eu.auth0.com/");
      use HA;
      Auth : Auth_Result_Type;
   begin
      Auth := Authenticated (Request, 1528404000);
      Assert (Auth = Auth_Fail, "Garbage token not detected: " & Auth'Img);
   end Test_Garbage_Token;

   ---------------------------------------------------------------------------

   procedure Test_Invalid_Key (T : in out Test_Cases.Test_Case'Class)
   is
      Request  : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Key_Data : String := Read_File ("tests/data/JWS_RFC7515_example_1_key.json");

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                         Issuer   => "https://cmpnlt-demo.eu.auth0.com/");
      use HA;
      Auth : Auth_Result_Type;
   begin
      Auth := Authenticated (Request, 1528404000);
      Assert (Auth = Auth_Fail, "Invalid key not detected: " & Auth'Img);
   end Test_Invalid_Key;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Invalid_Request'Access, "Invalid HTTP Request");
      Register_Routine (T, Test_Valid_Unauthenticated_Request'Access, "Valid unauthenticated HTTP Request");
      Register_Routine (T, Test_Valid_Authenticated_Request'Access, "Valid authenticated HTTP Request");
      Register_Routine (T, Test_Garbage_Token'Access, "Garbage token");
      Register_Routine (T, Test_Invalid_Key'Access, "Invalid key");
   end Register_Tests;

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("Stream_Auth Tests");
   end Name;

end JWX_Stream_Auth_Tests;
