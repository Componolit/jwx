--
-- \brief  Tests for JWX.BASE64
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.BASE64;
with JWX.Util;
use JWX;
with JWX_Test_Utils; use JWX_Test_Utils;

package body JWX_BASE64_Tests is

   subtype Result_Type is Byte_Array (1..50);
   subtype String_Type is String (1..50);

   procedure Test_Vector (Input  : String;
                          Output : String)
   is
      L : Natural;
      R : Result_Type;
      S : String_Type;
   begin
      Decode (Encoded => Input, Length => L, Result => R);
      Util.To_String (R, S);
      Assert (L > 0, "Too short: " & L'Img);
      Assert (S(1..L) = Output, "Invalid result: " & S(1..L));
   end Test_Vector;

   procedure Test_RFC4648_Test_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zg==", "f");
   end Test_RFC4648_Test_Vector_1;

   procedure Test_RFC4648_Test_Vector_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zm8=", "fo");
   end Test_RFC4648_Test_Vector_2;

   procedure Test_RFC4648_Test_Vector_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zm9v", "foo");
   end Test_RFC4648_Test_Vector_3;

   procedure Test_RFC4648_Test_Vector_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zm9vYg==", "foob");
   end Test_RFC4648_Test_Vector_4;

   procedure Test_RFC4648_Test_Vector_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zm9vYmE=", "fooba");
   end Test_RFC4648_Test_Vector_5;

   procedure Test_RFC4648_Test_Vector_6 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("Zm9vYmFy", "foobar");
   end Test_RFC4648_Test_Vector_6;

   procedure Test_Wikipedia_Test_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("YW55IGNhcm5hbCBwbGVhc3VyZS4=", "any carnal pleasure.");
   end Test_Wikipedia_Test_Vector_1;

   procedure Test_Wikipedia_Test_Vector_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("YW55IGNhcm5hbCBwbGVhc3VyZQ==", "any carnal pleasure");
   end Test_Wikipedia_Test_Vector_2;

   procedure Test_Wikipedia_Test_Vector_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("YW55IGNhcm5hbCBwbGVhc3Vy", "any carnal pleasur");
   end Test_Wikipedia_Test_Vector_3;

   procedure Test_Wikipedia_Test_Vector_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("YW55IGNhcm5hbCBwbGVhc3U=", "any carnal pleasu");
   end Test_Wikipedia_Test_Vector_4;

   procedure Test_Wikipedia_Test_Vector_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector ("YW55IGNhcm5hbCBwbGVhcw==", "any carnal pleas");
   end Test_Wikipedia_Test_Vector_5;

   procedure Test_Vector_Implicit (Input  : String;
                          Output : String)
   is
      L : Natural;
      R : Result_Type;
      S : String_Type;
   begin
      Decode (Encoded => Input, Length => L, Result => R, Padding => Padding_Implicit);
      Util.To_String (R, S);
      Assert (L > 0, "Too short: " & L'Img);
      Assert (S(1..L) = Output, "Invalid result: " & S(1..L));
   end Test_Vector_Implicit;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zg", "f");
   end Test_RFC4648_Implicit_Padding_Test_Vector_1;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zm8", "fo");
   end Test_RFC4648_Implicit_Padding_Test_Vector_2;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zm9v", "foo");
   end Test_RFC4648_Implicit_Padding_Test_Vector_3;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zm9vYg", "foob");
   end Test_RFC4648_Implicit_Padding_Test_Vector_4;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zm9vYmE", "fooba");
   end Test_RFC4648_Implicit_Padding_Test_Vector_5;

   procedure Test_RFC4648_Implicit_Padding_Test_Vector_6 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("Zm9vYmFy", "foobar");
   end Test_RFC4648_Implicit_Padding_Test_Vector_6;

   procedure Test_Wikipedia_Implicit_Padding_Test_Vector_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("YW55IGNhcm5hbCBwbGVhc3VyZS4", "any carnal pleasure.");
   end Test_Wikipedia_Implicit_Padding_Test_Vector_1;

   procedure Test_Wikipedia_Implicit_Padding_Test_Vector_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("YW55IGNhcm5hbCBwbGVhc3VyZQ", "any carnal pleasure");
   end Test_Wikipedia_Implicit_Padding_Test_Vector_2;

   procedure Test_Wikipedia_Implicit_Padding_Test_Vector_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("YW55IGNhcm5hbCBwbGVhc3Vy", "any carnal pleasur");
   end Test_Wikipedia_Implicit_Padding_Test_Vector_3;

   procedure Test_Wikipedia_Implicit_Padding_Test_Vector_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("YW55IGNhcm5hbCBwbGVhc3U", "any carnal pleasu");
   end Test_Wikipedia_Implicit_Padding_Test_Vector_4;

   procedure Test_Wikipedia_Implicit_Padding_Test_Vector_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Implicit ("YW55IGNhcm5hbCBwbGVhcw", "any carnal pleas");
   end Test_Wikipedia_Implicit_Padding_Test_Vector_5;

   procedure Test_Vector_Url (Input  : String;
                          Output : String)
   is
      L : Natural;
      R : Result_Type;
      S : String_Type;
   begin
      Decode_Url (Encoded => Input, Length => L, Result => R);
      Util.To_String (R, S);
      Assert (L > 0, "Too short: " & L'Img);
      Assert (S(1..L) = Output, "Invalid result: " & S(1..L));
   end Test_Vector_Url;

   procedure Test_RFC4648_Test_Vector_URL_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zg==", "f");
   end Test_RFC4648_Test_Vector_URL_1;

   procedure Test_RFC4648_Test_Vector_URL_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zm8=", "fo");
   end Test_RFC4648_Test_Vector_URL_2;

   procedure Test_RFC4648_Test_Vector_URL_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zm9v", "foo");
   end Test_RFC4648_Test_Vector_URL_3;

   procedure Test_RFC4648_Test_Vector_URL_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zm9vYg==", "foob");
   end Test_RFC4648_Test_Vector_URL_4;

   procedure Test_RFC4648_Test_Vector_URL_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zm9vYmE=", "fooba");
   end Test_RFC4648_Test_Vector_URL_5;

   procedure Test_RFC4648_Test_Vector_URL_6 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("Zm9vYmFy", "foobar");
   end Test_RFC4648_Test_Vector_URL_6;

   procedure Test_Wikipedia_Test_Vector_URL_1 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("YW55IGNhcm5hbCBwbGVhc3VyZS4=", "any carnal pleasure.");
   end Test_Wikipedia_Test_Vector_URL_1;

   procedure Test_Wikipedia_Test_Vector_URL_2 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("YW55IGNhcm5hbCBwbGVhc3VyZQ==", "any carnal pleasure");
   end Test_Wikipedia_Test_Vector_URL_2;

   procedure Test_Wikipedia_Test_Vector_URL_3 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("YW55IGNhcm5hbCBwbGVhc3Vy", "any carnal pleasur");
   end Test_Wikipedia_Test_Vector_URL_3;

   procedure Test_Wikipedia_Test_Vector_URL_4 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("YW55IGNhcm5hbCBwbGVhc3U=", "any carnal pleasu");
   end Test_Wikipedia_Test_Vector_URL_4;

   procedure Test_Wikipedia_Test_Vector_URL_5 (T : in out Test_Cases.Test_Case'Class)
   is
   begin
      Test_Vector_Url ("YW55IGNhcm5hbCBwbGVhcw==", "any carnal pleas");
   end Test_Wikipedia_Test_Vector_URL_5;

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_RFC4648_Test_Vector_1'Access, "RCF4848 test vector #1");
      Register_Routine (T, Test_RFC4648_Test_Vector_2'Access, "RCF4848 test vector #2");
      Register_Routine (T, Test_RFC4648_Test_Vector_3'Access, "RCF4848 test vector #3");
      Register_Routine (T, Test_RFC4648_Test_Vector_4'Access, "RCF4848 test vector #4");
      Register_Routine (T, Test_RFC4648_Test_Vector_5'Access, "RCF4848 test vector #5");
      Register_Routine (T, Test_RFC4648_Test_Vector_6'Access, "RCF4848 test vector #6");
      Register_Routine (T, Test_Wikipedia_Test_Vector_1'Access, "Wikipedia test vector #1");
      Register_Routine (T, Test_Wikipedia_Test_Vector_2'Access, "Wikipedia test vector #2");
      Register_Routine (T, Test_Wikipedia_Test_Vector_3'Access, "Wikipedia test vector #3");
      Register_Routine (T, Test_Wikipedia_Test_Vector_4'Access, "Wikipedia test vector #4");
      Register_Routine (T, Test_Wikipedia_Test_Vector_5'Access, "Wikipedia test vector #5");

      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_1'Access, "RCF4848 implicit padding test vector #1");
      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_2'Access, "RCF4848 implicit padding test vector #2");
      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_3'Access, "RCF4848 implicit padding test vector #3");
      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_4'Access, "RCF4848 implicit padding test vector #4");
      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_5'Access, "RCF4848 implicit padding test vector #5");
      Register_Routine (T, Test_RFC4648_Implicit_Padding_Test_Vector_6'Access, "RCF4848 implicit padding test vector #6");
      Register_Routine (T, Test_Wikipedia_Implicit_Padding_Test_Vector_1'Access, "Wikipedia implicit padding test vector #1");
      Register_Routine (T, Test_Wikipedia_Implicit_Padding_Test_Vector_2'Access, "Wikipedia implicit padding test vector #2");
      Register_Routine (T, Test_Wikipedia_Implicit_Padding_Test_Vector_3'Access, "Wikipedia implicit padding test vector #3");
      Register_Routine (T, Test_Wikipedia_Implicit_Padding_Test_Vector_4'Access, "Wikipedia implicit padding test vector #4");
      Register_Routine (T, Test_Wikipedia_Implicit_Padding_Test_Vector_5'Access, "Wikipedia implicit padding test vector #5");

      Register_Routine (T, Test_RFC4648_Test_Vector_URL_1'Access, "RCF4848 test vector URL #1");
      Register_Routine (T, Test_RFC4648_Test_Vector_URL_2'Access, "RCF4848 test vector URL #2");
      Register_Routine (T, Test_RFC4648_Test_Vector_URL_3'Access, "RCF4848 test vector URL #3");
      Register_Routine (T, Test_RFC4648_Test_Vector_URL_4'Access, "RCF4848 test vector URL #4");
      Register_Routine (T, Test_RFC4648_Test_Vector_URL_5'Access, "RCF4848 test vector URL #5");
      Register_Routine (T, Test_RFC4648_Test_Vector_URL_6'Access, "RCF4848 test vector URL #6");
      Register_Routine (T, Test_Wikipedia_Test_Vector_URL_1'Access, "Wikipedia test vector URL #1");
      Register_Routine (T, Test_Wikipedia_Test_Vector_URL_2'Access, "Wikipedia test vector URL #2");
      Register_Routine (T, Test_Wikipedia_Test_Vector_URL_3'Access, "Wikipedia test vector URL #3");
      Register_Routine (T, Test_Wikipedia_Test_Vector_URL_4'Access, "Wikipedia test vector URL #4");
      Register_Routine (T, Test_Wikipedia_Test_Vector_URL_5'Access, "Wikipedia test vector URL #5");
   end Register_Tests;

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("BASE64 Tests");
   end Name;

end JWX_BASE64_Tests;
