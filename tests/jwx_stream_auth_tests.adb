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

      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_Failed);
   begin
      HA.Downstream_Receive ("INVAILD REQUEST");
      HA.Downstream_Close;
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

      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_Failed);
   begin
      HA.Downstream_Receive (Read_File ("tests/data/HTTP_valid_unauth.dat"));
      HA.Downstream_Close;
      Assert (False, "Valid unauthenticated request not detected");
   exception
      when Test_OK => null;
   end Test_Valid_Unauthenticated_Request;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Authenticated_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Request       : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Key_Data      : String := Read_File ("tests/data/HTTP_auth_key.json");
      Error_Message : String := "Error Message";

      procedure Check_OK (Data : String)
      is
         Data_Does_Not_Match : exception;
      begin
         if Data /= Request
         then
            raise Data_Does_Not_Match;
         end if;
         raise Test_OK;
      end Check_OK;

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Check_OK,
                                      Downstream_Send => Raise_Logic_Error);
   begin
      HA.Downstream_Receive (Request);
      HA.Downstream_Close;
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
         Error_Not_Set_Downstream : exception;
      begin
         if Data /= Error_Message 
         then
            raise Error_Not_Set_Downstream;
         end if;
         raise Test_OK;
      end Check_OK;

      Key_Data : String := Read_File ("tests/data/HTTP_auth_key.json");

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_OK);
   begin
      HA.Downstream_Receive (Request);
      HA.Downstream_Close;
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
         if Data /= Error_Message
         then
            raise Logic_Error;
         end if;
         raise Test_OK;
      end Check_OK;

      Key_Data : String := Read_File ("tests/data/JWS_RFC7515_example_1_key.json");

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Raise_Logic_Error,
                                      Downstream_Send => Check_OK);
   begin
      HA.Downstream_Receive (Request);
      HA.Downstream_Close;
   exception
      when Test_OK => null;
   end Test_Invalid_Key;

   ---------------------------------------------------------------------------

   procedure Test_Valid_Multipart_Request (T : in out Test_Cases.Test_Case'Class)
   is
      Request       : String := Read_File ("tests/data/HTTP_valid_auth.dat");
      Key_Data      : String := Read_File ("tests/data/HTTP_auth_key.json");
      Error_Message : String := "Error Message";

      procedure Check_OK (Data : String)
      is
         Data_Does_Not_Match : exception;
      begin
         if Data /= Request
         then
            raise Data_Does_Not_Match;
         end if;
         raise Test_OK;
      end Check_OK;

      package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Check_OK,
                                      Downstream_Send => Raise_Logic_Error);
   begin
      -- Make sure we "cut through" the token
      HA.Downstream_Receive (Request (Request'First .. Request'First + 700));
      HA.Downstream_Receive (Request (Request'First + 701 .. Request'Last));
      HA.Downstream_Close;
      Assert (False, "Valid multipart request not detected");
   exception
      when Test_OK => null;
   end Test_Valid_Multipart_Request;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Invalid_Request'Access, "Invalid HTTP Request");
      Register_Routine (T, Test_Valid_Unauthenticated_Request'Access, "Valid unauthenticated HTTP Request");
      Register_Routine (T, Test_Valid_Authenticated_Request'Access, "Valid authenticated HTTP Request");
      Register_Routine (T, Test_Garbage_Token'Access, "Garbage token");
      Register_Routine (T, Test_Invalid_Key'Access, "Invalid key");
      Register_Routine (T, Test_Valid_Multipart_Request'Access, "Authenticated Request in multiple messages");
   end Register_Tests;

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("Stream_Auth Tests");
   end Name;

end JWX_Stream_Auth_Tests;
