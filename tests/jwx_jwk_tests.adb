--
-- \brief  Tests for JWX.JWK
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.JWK;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;

package body JWX_JWK_Tests is

   package Key is new JWK;

   procedure Test_Parse_RFC7517_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
      Data : String := Read_File ("tests/data/RFC7517_example_1.json");
      X_Ref : Byte_Array := (127, 205, 206, 039, 112, 246, 196, 093,
                             065, 131, 203, 238, 111, 219, 075, 123,
                             088, 007, 051, 053, 123, 233, 239, 019,
                             186, 207, 110, 060, 123, 209, 084, 069);
      X_Val : Byte_Array (1 .. X_Ref'Length);
      X_Length : Natural;

      Y_Ref : Byte_Array := (199, 241, 068, 205, 027, 189, 155, 126,
                             135, 044, 223, 237, 185, 238, 185, 244,
                             179, 105, 093, 110, 169, 011, 036, 173,
                             138, 070, 035, 040, 133, 136, 229, 173);
      Y_Val : Byte_Array (1 .. Y_Ref'Length);
      Y_Length : Natural;

   begin
      Parse (Data);
      Assert (Valid, "Key invalid");
      Assert (Kind = Kind_EC, "Invalid kind");
      Assert (ID = "Public key used in JWS spec Appendix A.3 example", "Invalid key ID");

      X (X_Val, X_Length);
      Assert (X_Length = X_Ref'Length, "Wrong X size");
      Assert (X_Val (1 .. X_Length) = X_Ref, "Invalid X");

      Y (Y_Val, Y_Length);
      Assert (Y_Length = Y_Ref'Length, "Wrong Y size");
      Assert (Y_Val (1 .. Y_Length) = Y_Ref, "Invalid Y");

   end Test_Parse_RFC7517_Vector_1;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_RFC7517_Vector_1'Access, "RFC7517 Vector #1");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWX Tests");
   end Name;

end JWX_JWK_Tests;

