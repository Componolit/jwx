--
-- \brief  Tests for JWX.JWS
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.JWS;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;

package body JWX_JWS_Tests is

   procedure Test_Parse_RFC7515_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use JWS;
      Result : Result_Type;
   begin
      Validate_Compact (Data     => Read_File ("tests/data/JWS_RFC7515_example_1.dat"),
                        Key_Data => Read_File ("tests/data/JWS_RFC7515_example_1_key.json"),
                        Result   => Result);

      Assert (Result = Result_OK, "Validation failed: " & Result'Img);
   end Test_Parse_RFC7515_Vector_1;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_RFC7515_Vector_1_Invalid (T : in out Test_Cases.Test_Case'Class)
   is
      use JWS;
      Result : Result_Type;
   begin
      Validate_Compact (Data     => Read_File ("tests/data/JWS_RFC7515_example_2.dat"),
                        Key_Data => Read_File ("tests/data/JWS_RFC7515_example_1_key.json"),
                        Result   => Result);

      Assert (Result /= Result_OK, "Validation must fail");
   end Test_Parse_RFC7515_Vector_1_Invalid;

   --------------------------------------------------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_RFC7515_Vector_1'Access, "RFC7515 Vector #1");
      Register_Routine (T, Test_Parse_RFC7515_Vector_1_Invalid'Access, "RFC7515 Vector #1 invalid");
   end Register_Tests;

   --------------------------------------------------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWS Tests");
   end Name;

end JWX_JWS_Tests;
