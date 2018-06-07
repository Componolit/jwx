--
-- \brief  Tests for JWX.HTTPAuth
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
-- -- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX_Test_Utils; use JWX_Test_Utils;

package body JWX_HTTPAuth_Tests is

   Logic_Error : exception;
   Test_OK     : exception;

   procedure Raise_Logic_Error (Data : String)
   is
   begin
      raise Logic_Error;
   end Raise_Logic_Error;

   ---------------------------------------------------------------------------

   procedure Test_Invalid_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Error_Message : String := "Error Message";
      procedure Check_Failed (Data : String)
      is
      begin
         if Data /= Error_Message
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_Failed;

      package HA is new JWX.HTTPAuth (Error_Response  => Error_Message,
                                      Key_Data        => Read_File ("tests/data/HTTP_auth_key.json"),
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_Failed);
   begin
      HA.Downstream_Receive ("INVAILD REQUEST");
      Assert (False, "Invalid request not detected");
   exception
      when Test_OK => null;
   end Test_Invalid_Request;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Unauthenticated_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Error_Message : String := "Error Message";
      procedure Check_Failed (Data : String)
      is
      begin
         if Data /= Error_Message
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_Failed;

      package HA is new JWX.HTTPAuth (Error_Response  => Error_Message,
                                      Key_Data        => Read_File ("tests/data/HTTP_auth_key.json"),
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_Failed);
   begin
      HA.Downstream_Receive (Read_File ("tests/data/HTTP_valid_unauth.dat"));
      Assert (False, "Valid unauthenticated request not detected");
   exception
      when Test_OK => null;
   end Test_Valid_Unauthenticated_Request;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Authenticated_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Request : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Error_Message : String := "Error Message";

      procedure Check_OK (Data : String)
      is
      begin
         if Data /= Request
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_OK;

      package HA is new JWX.HTTPAuth (Error_Response  => Error_Message,
                                      Key_Data        => Read_File ("tests/data/HTTP_auth_key.json"),
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_OK);
   begin
      HA.Downstream_Receive (Request);
      Assert (False, "Valid authenticated request not detected");
   exception
      when Test_OK => null;
   end Test_Valid_Authenticated_Request;

   ---------------------------------------------------------------------------

   procedure Test_Garbage_Token (T : in out Test_Cases.Test_Case'Class)
   is
      Request : String := Read_File ("tests/data/HTTP_garbage_auth.dat");
      Error_Message : String := "Error Message";

      procedure Check_OK (Data : String)
      is
      begin
         if Data /= Error_Message 
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_OK;

      package HA is new JWX.HTTPAuth (Error_Response  => Error_Message,
                                      Key_Data        => Read_File ("tests/data/HTTP_auth_key.json"),
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_OK);
   begin
      HA.Downstream_Receive (Request);
      Assert (False, "Garbage token not detected");
   exception
      when Test_OK => null;
   end Test_Garbage_Token;

   ---------------------------------------------------------------------------

   procedure Test_Invalid_Key (T : in out Test_Cases.Test_Case'Class)
   is
      Request : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Error_Message : String := "Error Message";

      procedure Check_OK (Data : String)
      is
      begin
         if Data /= Request
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_OK;

      package HA is new JWX.HTTPAuth (Error_Response  => Error_Message,
                                      Key_Data        => Read_File ("tests/data/JWS_RFC7515_example_1_key.json"),
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_OK);
   begin
      HA.Downstream_Receive (Request);
      Assert (False, "Invalid key not detected");
   exception
      when Test_OK => null;
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
      return Format ("HTTPAuth Tests");
   end Name;

end JWX_HTTPAuth_Tests;
