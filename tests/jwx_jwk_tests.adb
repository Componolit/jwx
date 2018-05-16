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
       D_Ref      : Byte_Array;
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
      D_Val : Byte_Array (1 .. D_Ref'Length);
      D_Length : Natural;
   begin
      Load_Keys (Data);
      Select_Key;
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

      if Priv
      then
         D (D_Val, D_Length);
         Assert (D_Length = D_Ref'Length, "Wrong D size: " & D_Length'Img);
         Assert (D_Val (1 .. D_Length) = D_Ref, "Invalid D");
      end if;

      Assert (Usage = Usg, "Wrong usage type: " & Usage'Img);
      Assert (Algorithm = Alg, "Wrong algorithm: " & Algorithm'Img);
      Assert (Curve = Crv, "Wrong curve: " & Curve'Img);
   end Test_EC;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_RSA
      (Input_File : String;
       Key_ID     : String;
       Priv       : Boolean;
       Usg        : Key.Use_Type;
       Alg        : Key.Alg_Type;
       N_Ref      : Byte_Array;
       E_Ref      : Byte_Array;
       D_Ref      : Byte_Array)
   is
      use Key;
      Data : String := Read_File (Input_File);
      N_Val : Byte_Array (1 .. N_Ref'Length);
      N_Length : Natural;
      E_Val : Byte_Array (1 .. E_Ref'Length);
      E_Length : Natural;
      D_Val : Byte_Array (1 .. D_Ref'Length);
      D_Length : Natural;
   begin
      Load_Keys (Data);
      Assert (Loaded, "Invalid key file");

      Select_Key;
      Assert (Valid, "Key invalid");
      Assert (Kind = Kind_RSA, "Invalid kind: " & Kind'Img);
      Assert (ID = Key_ID, "Invalid key ID: " & ID);

      N (N_Val, N_Length);
      Assert (N_Length = N_Ref'Length, "Wrong N size: " & N_Length'Img);
      Assert (N_Val (1 .. N_Length) = N_Ref, "Invalid N");

      E (E_Val, E_Length);
      Assert (E_Length = E_Ref'Length, "Wrong E size: " & E_Length'Img);
      Assert (E_Val (1 .. E_Length) = E_Ref, "Invalid E");

      Assert (Private_Key = Priv, "Wrong key type: Private=" & Private_Key'Img);

      if Priv
      then
         D (D_Val, D_Length);
         Assert (D_Length = D_Ref'Length, "Wrong D size: " & D_Length'Img);
         Assert (D_Val (1 .. D_Length) = D_Ref, "Invalid D");
      end if;

      Assert (Usage = Usg, "Wrong usage type: " & Usage'Img);
      Assert (Algorithm = Alg, "Wrong algorithm: " & Algorithm'Img);
   end Test_RSA;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Oct
      (Input_File : String;
       Key_ID     : String;
       Usg        : Key.Use_Type;
       Alg        : Key.Alg_Type;
       K_Ref      : Byte_Array)
   is
      use Key;
      Data : String := Read_File (Input_File);
      K_Val : Byte_Array (1 .. K_Ref'Length);
      K_Length : Natural;
   begin
      Load_Keys (Data);
      Assert (Loaded, "Invalid key file");

      Select_Key;
      Assert (Valid, "Key invalid");
      Assert (Kind = Kind_Oct, "Invalid kind: " & Kind'Img);
      Assert (ID = Key_ID, "Invalid key ID: " & ID);

      Assert (Private_Key, "OCT must be private");

      K (K_Val, K_Length);
      Assert (K_Length = K_Ref'Length, "Wrong K size: " & K_Length'Img);
      Assert (K_Val (1 .. K_Length) = K_Ref, "Invalid K");

      Assert (Usage = Usg, "Wrong usage type: " & Usage'Img);
      Assert (Algorithm = Alg, "Wrong algorithm: " & Algorithm'Img);
   end Test_Oct;

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
               D_Ref      => (0, 0),
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
               D_Ref      => (0, 0),
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
               D_Ref      => (141, 152, 000, 137, 177, 073, 191, 054, 208, 199, 187, 085, 102, 213, 159, 047,
                              179, 012, 196, 192, 194, 133, 124, 223, 076, 037, 213, 115, 028, 201, 231, 221),
               Priv       => True,
               Usg        => Use_Sign,
               Alg        => Alg_ES256,
               Crv        => Curve_P256);

   end Test_Parse_Testkey013_Keypair;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_Testkey004_Keypair (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
   begin
      Test_RSA (Input_File => "tests/data/JWK_RSA_2048_Encryption_RS256_Testkey004_keypair.json",
                Key_ID     => "Testkey004",
                Priv       => True,
                N_Ref      => (159, 090, 054, 005, 086, 237, 153, 005, 086, 101, 092, 015, 178, 172, 111, 193,
                               217, 046, 026, 196, 174, 190, 047, 134, 114, 103, 165, 173, 095, 158, 255, 175,
                               086, 004, 017, 067, 227, 057, 066, 174, 244, 233, 212, 146, 088, 045, 048, 037,
                               237, 050, 046, 006, 185, 161, 170, 055, 020, 128, 011, 033, 228, 217, 218, 251,
                               140, 217, 122, 192, 022, 090, 154, 035, 144, 236, 223, 027, 148, 099, 127, 035,
                               234, 111, 247, 185, 029, 051, 024, 083, 252, 185, 083, 021, 213, 135, 067, 043,
                               141, 239, 131, 069, 216, 043, 045, 192, 027, 195, 150, 206, 075, 155, 168, 251,
                               118, 180, 253, 098, 173, 007, 158, 098, 041, 172, 176, 071, 051, 191, 224, 095,
                               117, 117, 120, 234, 182, 132, 165, 191, 093, 167, 226, 162, 054, 051, 205, 235,
                               251, 127, 124, 196, 231, 094, 128, 142, 062, 164, 252, 106, 206, 010, 113, 217,
                               141, 006, 133, 129, 061, 123, 108, 029, 016, 093, 012, 082, 126, 075, 254, 003,
                               022, 152, 031, 162, 126, 037, 114, 105, 228, 015, 013, 002, 098, 170, 231, 243,
                               104, 234, 202, 000, 161, 189, 231, 119, 054, 249, 140, 094, 192, 025, 206, 224,
                               030, 185, 181, 129, 107, 093, 232, 103, 083, 006, 054, 096, 057, 015, 114, 239,
                               220, 124, 159, 172, 221, 249, 004, 165, 140, 014, 085, 155, 196, 146, 232, 019,
                               147, 133, 032, 152, 155, 244, 050, 036, 239, 085, 239, 037, 060, 025, 113, 067),
                D_Ref      => (118, 158, 191, 145, 207, 248, 196, 044, 221, 248, 075, 196, 127, 187, 174, 225,
                               125, 026, 189, 224, 101, 055, 187, 198, 248, 072, 193, 098, 194, 200, 104, 010,
                               140, 028, 049, 001, 249, 022, 057, 214, 101, 007, 223, 046, 037, 039, 086, 045,
                               021, 089, 130, 059, 141, 089, 147, 140, 182, 220, 237, 236, 136, 031, 199, 203,
                               243, 056, 061, 016, 218, 083, 013, 100, 166, 080, 061, 112, 153, 080, 075, 103,
                               095, 239, 131, 087, 048, 046, 069, 208, 215, 082, 217, 079, 106, 136, 234, 238,
                               116, 020, 180, 002, 124, 252, 255, 108, 126, 254, 100, 183, 034, 063, 056, 086,
                               032, 050, 112, 096, 080, 239, 087, 238, 056, 153, 141, 011, 035, 177, 148, 130,
                               044, 212, 120, 015, 075, 057, 203, 128, 209, 014, 185, 166, 244, 017, 119, 171,
                               014, 079, 193, 108, 159, 160, 083, 151, 062, 169, 066, 015, 155, 102, 006, 035,
                               242, 078, 134, 247, 014, 155, 186, 028, 042, 137, 000, 221, 094, 098, 248, 125,
                               145, 026, 086, 036, 151, 157, 209, 219, 238, 038, 025, 115, 175, 017, 167, 196,
                               212, 060, 015, 115, 085, 214, 241, 194, 116, 181, 106, 217, 254, 246, 022, 060,
                               189, 249, 128, 109, 057, 086, 100, 077, 156, 042, 164, 218, 126, 118, 252, 155,
                               167, 063, 120, 074, 126, 219, 040, 153, 188, 249, 008, 025, 171, 156, 090, 103,
                               003, 095, 024, 150, 007, 231, 068, 217, 075, 158, 059, 159, 019, 233, 176, 001),
                E_Ref      => (001, 000, 001),
                Usg        => Use_Encrypt,
                Alg        => Alg_RS256);

   end Test_Parse_Testkey004_Keypair;

   --------------------------------------------------------------------------------------------------------------------

   procedure Test_Parse_Testkey033_Keyset (T : in out Test_Cases.Test_Case'Class)
   is
      use Key;
   begin
      Test_Oct (Input_File => "tests/data/JWK_OCT_128_Signing_HS512_Testkey033_keyset.json",
                Key_ID     => "Testkey033",
                K_Ref      => (062, 028, 173, 034, 215, 007, 204, 249, 087, 122, 135, 146, 147, 118, 003, 047),
                Usg        => Use_Sign,
                Alg        => Alg_HS512);

   end Test_Parse_Testkey033_Keyset;

   --------------------------------------------------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_RFC7517_Vector_1'Access, "RFC7517 Vector #1");
      Register_Routine (T, Test_Parse_Testkey013_Pubkey'Access, "Testkey013 pubkey");
      Register_Routine (T, Test_Parse_Testkey013_Keypair'Access, "Testkey013 keypair");
      Register_Routine (T, Test_Parse_Testkey004_Keypair'Access, "Testkey004 keypair");
      Register_Routine (T, Test_Parse_Testkey033_Keyset'Access, "Testkey033 keyset");
   end Register_Tests;

   --------------------------------------------------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JWX Tests");
   end Name;

end JWX_JWK_Tests;

