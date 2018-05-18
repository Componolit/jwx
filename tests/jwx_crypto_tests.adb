--
-- \brief  Tests for JWX.Crypto
-- \author Alexander Senier
-- \date   2018-05-18
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.Crypto;
with JWX.LSC;
with JWX.Util;
with JWX_Test_Utils; use JWX_Test_Utils;

use JWX;
with LSC.Types;
with LSC.SHA256;
with LSC.Byteorder32;

package body JWX_Crypto_Tests
is

   function M (Item : LSC.Types.Word32) return LSC.Types.Word32
   is
   begin
      return LSC.Byteorder32.BE_To_Native (Item);
   end M;

   ---------------------------------------------------------------------------

   procedure Test_Block_Type_Conversion_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use LSC.SHA256;
      use LSC.Types;
      use JWX.LSC;
      use JWX.Util;
      Block : Block_Type;
      Input : String := "Hi There";
      BA    : JWX.Byte_Array (1 .. Input'Length);
   begin
      To_Byte_Array (Input, BA);
      JWX_Byte_Array_To_LSC_Word32_Array (BA, Block);
		Assert (Block = Block_Type'(M (16#48692054#), M (16#68657265#), others => 0), "Conversion invalid");
	end Test_Block_Type_Conversion_1;

   ---------------------------------------------------------------------------

   procedure Test_Block_Type_Conversion_2 (T : in out Test_Cases.Test_Case'Class)
   is
      use LSC.SHA256;
      use LSC.Types;
      use JWX.LSC;
      use JWX.Util;
      Block : Block_Type;
      Input : String := "what do ya want for nothing?";
      BA    : JWX.Byte_Array (1 .. Input'Length);

      Result : SC.SHA256.Block_Type :=
        (M (16#77686174#), M (16#20646f20#), M (16#79612077#), M (16#616e7420#),
         M (16#666f7220#), M (16#6e6f7468#), M (16#696e673f#), others => 0);
   begin
      To_Byte_Array (Input, BA);
      JWX_Byte_Array_To_LSC_Word32_Array (BA, Block);
		Assert (Block = Result, "Conversion invalid");
	end Test_Block_Type_Conversion_2;

   ---------------------------------------------------------------------------

   procedure Test_Message_Type_Conversion_1 (T : in out Test_Cases.Test_Case'Class)
   is
      use LSC.SHA256;
      use LSC.Types;
      use JWX.LSC;
      use JWX.Util;

      subtype MT is LSC.SHA256.Message_Type (1 .. 4);

      Expected : MT := (
      LSC.SHA256.Block_Type'(
         M (16#1d68a3cd#), M (16#6b07a7e3#), M (16#3ce93a05#), M (16#f89defe5#),
         M (16#0142fe91#), M (16#8508e319#), M (16#b283d17c#), M (16#1423afc0#),
         M (16#86508665#), M (16#b34c6d13#), M (16#777da272#), M (16#d202d291#),
         M (16#91c89d4b#), M (16#f2852209#), M (16#a4241e91#), M (16#2e4c9b6e#)),
      LSC.SHA256.Block_Type'(
         M (16#8342da56#), M (16#5fa7bbb0#), M (16#0e5541f7#), M (16#11ac4f01#),
         M (16#69bd4113#), M (16#a51388fc#), M (16#f57aac73#), M (16#95d774eb#),
         M (16#07eb51e1#), M (16#526efaa3#), M (16#c589f223#), M (16#89adaf4d#),
         M (16#48d01d42#), M (16#99a16171#), M (16#7a84a41c#), M (16#5cabe95b#)),
      LSC.SHA256.Block_Type'(
         M (16#d056a140#), M (16#25e4da39#), M (16#54251a17#), M (16#288bbf71#),
         M (16#7040f900#), M (16#e6b3eeb9#), M (16#b4c7337e#), M (16#59c946c0#),
         M (16#d72b53b2#), M (16#04e16a4a#), M (16#bb00aa33#), M (16#fc674d6a#),
         M (16#cdb821d9#), M (16#b1d2a1ca#), M (16#0d286937#), M (16#81ef2acf#)),
      LSC.SHA256.Block_Type'(
         M (16#e908e006#), M (16#815853a2#), M (16#d6100b5d#), M (16#a81ce416#),
         M (16#d98ba37d#), M (16#36e3c68b#), M (16#52cf0c1c#), M (16#aa9805b9#),
         M (16#3b7e68b7#), M (16#2c56511d#), M (16#711336b8#), M (16#eb1fe87f#),
         M (16#88b5870c#), M (16#697807fd#), M (16#dd1d1028#), M (16#87d5777f#)));

      Input  : String := Read_File ("tests/data/hmac_sha256-message-1.dat");
      BA     : JWX.Byte_Array (1 .. Input'Length);
      Result : MT;

   begin
      To_Byte_Array (Input, BA);
      JWX_Byte_Array_To_LSC_SHA256_Message (BA, Result);
		Assert (Result = Expected, "Conversion invalid");
	end Test_Message_Type_Conversion_1;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Block_Type_Conversion_1'Access, "Block conversion 1");
      Register_Routine (T, Test_Block_Type_Conversion_2'Access, "Block conversion 2");
      Register_Routine (T, Test_Message_Type_Conversion_1'Access, "Message conversion 1");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("Crypto Tests");
   end Name;

end JWX_Crypto_Tests;
