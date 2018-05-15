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

   procedure Test_EC
      (Input_File : String;
       Key_ID     : String;
       X_Ref      : Byte_Array;
       Y_Ref      : Byte_Array;
       Priv       : Boolean;
       Usg        : Key.Use_Type;
       Alg        : Key.Alg_Type;
       Crv        : Key.EC_Curve_Type)
   is
      use Key;
      Data : String := Read_File (Input_File);
      X_Val : Byte_Array (1 .. X_Ref'Length);
      X_Length : Natural;
      Y_Val : Byte_Array (1 .. Y_Ref'Length);
      Y_Length : Natural;
   begin
      Parse (Data);
      Assert (Valid, "Key invalid");
      Assert (Kind = Kind_EC, "Invalid kind: " & Kind'Img);
      Assert (ID = Key_ID, "Invalid key ID: " & ID);

      X (X_Val, X_Length);
      Assert (X_Length = X_Ref'Length, "Wrong X size: " & X_Length'Img);
      Assert (X_Val (1 .. X_Length) = X_Ref, "Invalid X");

      Y (Y_Val, Y_Length);
      Assert (Y_Length = Y_Ref'Length, "Wrong Y size: " & Y_Length'Img);
      Assert (Y_Val (1 .. Y_Length) = Y_Ref, "Invalid Y");

      Assert (Private_Key = Priv, "Wrong key type: Private=" & Private_Key'Img);
      Assert (Usage = Usg, "Wrong usage type: " & Usage'Img);
      Assert (Algorithm = Alg, "Wrong algorithm: " & Algorithm'Img);
      Assert (Curve = Crv, "Wrong curve: " & Curve'Img);
   end Test_EC;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_RFC7517_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
   begin
      Test_EC (Input_File => "tests/data/RFC7517_example_1.json",
               Key_ID     => "Public key used in JWS spec Appendix A.3 example",
               X_Ref      => (127, 205, 206, 039, 112, 246, 196, 093, 065, 131, 203, 238, 111, 219, 075, 123,
                              088, 007, 051, 053, 123, 233, 239, 019, 186, 207, 110, 060, 123, 209, 084, 069),
               Y_Ref      => (199, 241, 068, 205, 027, 189, 155, 126, 135, 044, 223, 237, 185, 238, 185, 244,
                              179, 105, 093, 110, 169, 011, 036, 173, 138, 070, 035, 040, 133, 136, 229, 173),
               Priv       => False,
               Usg        => Use_Unknown,
               Alg        => Alg_Invalid,
               Crv        => Curve_P256);

   end Test_Parse_RFC7517_Vector_1;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_Testkey013_Pubkey (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
   begin
      Test_EC (Input_File => "tests/data/JWK_EC_P256_Signing_ES256_Testkey013_pubkey.json",
               Key_ID     => "Testkey013",
               X_Ref      => (041, 003, 039, 146, 127, 179, 113, 238, 150, 215, 060, 230, 088, 217, 037, 108,
                              017, 232, 141, 137, 072, 087, 225, 236, 103, 104, 136, 081, 188, 104, 243, 058),
               Y_Ref      => (236, 037, 218, 121, 048, 179, 245, 031, 231, 165, 092, 192, 052, 105, 053, 139,
                              225, 208, 150, 068, 135, 184, 202, 182, 098, 137, 208, 082, 109, 168, 110, 130),
               Priv       => False,
               Usg        => Use_Sign,
               Alg        => Alg_ES256,
               Crv        => Curve_P256);

   end Test_Parse_Testkey013_Pubkey;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_Testkey013_Keypair (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
   begin
      Test_EC (Input_File => "tests/data/JWK_EC_P256_Signing_ES256_Testkey013_keypair.json",
               Key_ID     => "Testkey013",
               X_Ref      => (041, 003, 039, 146, 127, 179, 113, 238, 150, 215, 060, 230, 088, 217, 037, 108,
                              017, 232, 141, 137, 072, 087, 225, 236, 103, 104, 136, 081, 188, 104, 243, 058),
               Y_Ref      => (236, 037, 218, 121, 048, 179, 245, 031, 231, 165, 092, 192, 052, 105, 053, 139,
                              225, 208, 150, 068, 135, 184, 202, 182, 098, 137, 208, 082, 109, 168, 110, 130),
               Priv       => True,
               Usg        => Use_Sign,
               Alg        => Alg_ES256,
               Crv        => Curve_P256);

   end Test_Parse_Testkey013_Keypair;

   --------------------------------------------------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_RFC7517_Vector_1'Access, "RFC7517 Vector #1");
      Register_Routine (T, Test_Parse_Testkey013_Pubkey'Access, "Testkey013 pubkey");
      Register_Routine (T, Test_Parse_Testkey013_Keypair'Access, "Testkey013 keypair");
   end Register_Tests;

   --------------------------------------------------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWX Tests");
   end Name;

end JWX_JWK_Tests;

