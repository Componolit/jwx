--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into JSON.Test_Data.

with AUnit.Assertions; use AUnit.Assertions;
with System.Assertions;

--  begin read only
--  id:2.2/00/
--
--  This section can be used to add with clauses if necessary.
--
--  end read only

with Ada.Direct_IO;
with Ada.Directories;
with Ada.Text_IO;

--  begin read only
--  end read only
package body JSON.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

function Read_File (File_Name : String) return String
is
   File_Size : Natural := Natural (Ada.Directories.Size (File_Name));
   subtype File_String is String (1 .. File_Size);
   package File_String_IO is new Ada.Direct_IO (File_String);

   File     : File_String_IO.File_Type;
   Contents : File_String;
begin
   File_String_IO.Open (File, File_String_IO.In_File, File_Name);
   File_String_IO.Read (File, Contents);
   File_String_IO.Close (File);
   return Contents;
end Read_File;

--  begin read only
--  end read only

--  begin read only
   procedure Test_Parse (Gnattest_T : in out Test);
   procedure Test_Parse_791d33 (Gnattest_T : in out Test) renames Test_Parse;
--  id:2.2/791d331ce5a87481/Parse/1/0/
   procedure Test_Parse (Gnattest_T : in out Test) is
   --  json.ads:24:4:Parse
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Match_Type;
      Context : Context_Type (Index_Type range 1..100000);
   begin

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 4 and
                                Get_Kind (Context) = Kind_Boolean and
                                Get_Boolean (Context)), "Parse true");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "false");
      AUnit.Assertions.Assert (Match = Match_OK and
                               Offset = 5 and
                               Get_Kind (Context) = Kind_Boolean and
                               not Get_Boolean (Context), "Parse false.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "null");
      AUnit.Assertions.Assert (Match = Match_OK and
                               Offset = 4 and
                               Get_Kind (Context) = Kind_Null, "Parse null.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "True");
      AUnit.Assertions.Assert (Match /= Match_OK and Offset = 0, "True case insensitive.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "FALSE");
      AUnit.Assertions.Assert (Match /= Match_OK and Offset = 0, "False case insensitive.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "nulL");
      AUnit.Assertions.Assert (Match /= Match_OK and Offset = 0, "Null case insensitive.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "    null");
      AUnit.Assertions.Assert (Match = Match_OK, "Parse boolean with space.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "  " & ASCII.CR & ASCII.LF & "true");
      AUnit.Assertions.Assert (Match = Match_OK, "Parse boolean with CRLF");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, ASCII.HT & "false");
      AUnit.Assertions.Assert (Match = Match_OK, "Parse boolean with tab.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "42");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 2 and
                                Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 42), "Parse small positive integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "40000");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 40000), "Parse positive integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "-42");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 3 and
                                Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = -42), "Parse small negative integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "2147483647");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 10 and
                                Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 2147483647), "Parse big positive integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "1234e2");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 123400), "Parse integer with positive exponent");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "1234E+2");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 123400), "Parse integer with positive exponent (2).");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "1234E+02");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 123400), "Parse integer with positive exponent with leading 0.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "12345e-2");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = 123.45), "Parse number with negative exponent, resulting in fractional.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "12300e-2");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 123), "Parse number with negative exponent, resulting in integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "   0 ");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 4 and
                                Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = 0), "Parse zero integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "-2147483647");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 11 and
                                Get_Kind (Context) = Kind_Integer and
                                Get_Integer (Context) = -2147483647), "Parse big negative integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "92233720368547758080");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Too big integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "-92233720368547758080");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Too small integer.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "3.14");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 4 and
                                Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = 3.14), "Parse small positive float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "-3.14");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 5 and
                                Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = -3.14), "Parse small negative float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "0.00000000001");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 13 and
                                Get_Kind (Context) = Kind_Float and
                                Get_Float (Context)= 0.00000000001), "Very small positive float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "-0.00000000001");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 14 and
                                Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = -0.00000000001), "Very small negative float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, " 0.0   ");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Offset = 4 and
                                Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = 0.0), "Parse zero float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "123.5e+02");
      AUnit.Assertions.Assert (Match = Match_OK and then
                               (Get_Kind (Context) = Kind_Float and
                                Get_Float (Context) = 12350.0), "Parse float with exponent with leading 0.");
      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "000068547758080");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Leading zero.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "000.06854");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Leading zero float.");

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "54775. ");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Missing fractional part.");

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := """Hello world!""";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  (Offset = 14 and
                                   Get_Kind (Context) = Kind_String and
                                   Get_String (Context, Data) = "Hello world!"), "Simple string");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := """Invalid String";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_Invalid, "Unclosed string");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := """Say \""Hello World\""!""";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  (Offset = 22 and
                                   Get_Kind (Context) = Kind_String and
                                   Get_String (Context, Data) = "Say \""Hello World\""!"), "Escaped string");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := """Escaped backslash\\""";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  (Offset = 21 and
                                   Get_Kind (Context) = Kind_String and
                                   Get_String (Context, Data) = "Escaped backslash\\"), "Escaped backslash");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := """Escaped \backslash""";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  (Offset = 20 and
                                   Get_Kind (Context) = Kind_String and
                                   Get_String (Context, Data) = "Escaped \backslash"), "Escaped regular character");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := " { ""precision"": ""zip"", ""Latitude"":  37.7668, ""Longitude"": -122.3959, ""Address"":   """", ""City"":      ""SAN FRANCISCO"", ""State"":     ""CA"", ""Zip"":       ""94107"", ""Country"":   ""US"" }";
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context, 2) = Kind_Object, "Parse simple object: " & Get_Kind (Context, 2)'Img);

         Result := Query_Object (Context, Data, "precision");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "zip", "Query string from simple object (1): " & Get_Kind (Context, Result)'Img);

         Result := Query_Object (Context, Data, "Latitude");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_Float and then
                                  Get_Float (Context, Result) = 37.7668, "Query float from simple object");

         Result := Query_Object (Context, Data, "Longitude");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_Float and then
                                  Get_Float (Context, Result) = -122.3959, "Query negative float from simple object");

         Result := Query_Object (Context, Data, "Address");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "", "Query empty string from simple object");

         Result := Query_Object (Context, Data, "City");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "SAN FRANCISCO", "Query string from simple object (2)");

         Result := Query_Object (Context, Data, "State");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "CA", "Query string from simple object (3)");

         Result := Query_Object (Context, Data, "Zip");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "94107", "Query digit-only string from simple object");

         Result := Query_Object (Context, Data, "Country");
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_String and then
                                  Get_String (Context, Data, Result) = "US", "Query string from simple object (4)");

         Result := Query_Object (Context, Data, "Does-not-exist");
         AUnit.Assertions.Assert (Result = End_Index, "Query non-existing member from simple object");
      end;

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "  {} ");
      AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Object, "Parse empty object");

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "  [116, 943, 234, 38793] ";
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Array, "Parse simple array");

         AUnit.Assertions.Assert (Length (Context) = 4, "Simple array length: " & Length (Context)'Img);

         Result := Pos (Context, 2);
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_Integer and then
                                  Get_Integer (Context, Result) = 943, "Get simple array element");

         Result := Pos (Context, 4);
         AUnit.Assertions.Assert (Get_Kind (Context, Result) = Kind_Integer and then
                                  Get_Integer (Context, Result) = 38793, "Get simple array element");

         Result := Pos (Context, 7);
         AUnit.Assertions.Assert (Result = End_Index, "Out of bounds array access");
      end;

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, " [""foo"", ""bar"" ");
      AUnit.Assertions.Assert (Match = Match_Invalid, "Unclosed array");

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "  [116, -4.5, ""baz"", true] ";
         Result : Context_Element_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Array, "Parse mixed array");

         AUnit.Assertions.Assert (Length (Context) = 4, "Mixed array length");

         AUnit.Assertions.Assert (Get_Integer (Context, Pos (Context, 1)) = 116, "Get mixed array integer element");
         AUnit.Assertions.Assert (Get_Float (Context, Pos (Context, 2)) = -4.5, "Get mixed array float element");
         AUnit.Assertions.Assert (Get_String (Context, Data, Pos (Context, 3)) = "baz", "Get mixed array string element");
         AUnit.Assertions.Assert (Get_Boolean (Context, Pos (Context, 4)) = true, "Get mixed array boolean element");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "    [] ";
         Result : Context_Element_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Array, "Parse empty array");
         AUnit.Assertions.Assert (Length (Context) = 0, "Empty array length");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "[{""A"": 42}, {""B"": {""D"": 234}}, {""C"": 9}]";
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Array, "Array of objects");
         AUnit.Assertions.Assert (Length (Context) = 3, "Array of objects length");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := Read_File ("tests/data/RFC7159_example1.json");
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Object, "RFC7159 example #1");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := Read_File ("tests/data/RFC7159_example2.json");
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Array, "RFC7159 example #2");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := Read_File ("tests/data/country.json");
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Object, "country example");

         Result := Query_Object (Context, Data, "area");
         AUnit.Assertions.Assert (Result /= Null_Index and  then
                                  (Get_Kind (Context, Result) = Kind_Float and then
                                   Get_Float (Context, Result) = 1246700.0), "country query area");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "[{""area"": 123.0}, {""area"": 200.5}]";
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Array, "recusive objects");

         Result := Pos (Context, 1);
         AUnit.Assertions.Assert (Result /= Null_Index and then
                                  Get_Kind (Context, Result) = Kind_Object, "recursive objects");

         Result := Query_Object (Context, Data, "area", Result);
         AUnit.Assertions.Assert (Result /= End_Index and  then
                                  (Get_Kind (Context, Result) = Kind_Float and then
                                   Get_Float (Context, Result) = 123.0), "recursive object query area");
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := Read_File ("tests/data/two_countries.json");
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Array, "two countries example");

         Result := Pos (Context, 1);
         AUnit.Assertions.Assert (Result /= Null_Index and then
                                  Get_Kind (Context, Result) = Kind_Object, "two countries array access");

         Result := Query_Object (Context, Data, "area", Result);
         AUnit.Assertions.Assert (Result /= Null_Index and  then
                                  (Get_Kind (Context, Result) = Kind_Float and then
                                   Get_Float (Context, Result) = 1246700.0), "two countries query area: " & Get_Float (Context, Result)'Img);
      end;

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := Read_File ("tests/data/countries.json");
         Result : Index_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then
                                  Get_Kind (Context) = Kind_Array, "Countries example");

         Result := Pos (Context, 4);
         AUnit.Assertions.Assert (Result /= Null_Index and then
                                  Get_Kind (Context, Result) = Kind_Object, "Countries example array");

         Result := Query_Object (Context, Data, "area", Result);
         AUnit.Assertions.Assert (Result /= Null_Index and  then
                                  (Get_Kind (Context, Result) = Kind_Integer and then
                                   Get_Integer (Context, Result) = 83600), "Query area: " & Result'Img);

         -- France
         declare
            France, AltSpellings, Translations, German, Japanese : Index_Type;
         begin
            France := Pos (Context, 97);
            AUnit.Assertions.Assert (France /= Null_Index and then
                                     Get_Kind (Context, France) = Kind_Object, "Get France from array");

            --  alternaive spellings
            AltSpellings := Query_Object (Context, Data, "altSpellings", France);
            AUnit.Assertions.Assert (Result /= Null_Index and  then
                                     Get_Kind (Context, AltSpellings) = Kind_Array, "Get altSpellings of France");

            Result := Pos (Context, 3, AltSpellings);
            AUnit.Assertions.Assert (Result /= Null_Index and  then
                                     (Get_Kind (Context, Result) = Kind_String and then
                                      Get_String (Context, Data, Result) = "République française"), "Get third alt spelling of France");

            --  What's France in other languages?
            Translations := Query_Object (Context, Data, "translations", France);
            AUnit.Assertions.Assert (Result /= Null_Index and  then
                                     Get_Kind (Context, Translations) = Kind_Object, "Get translations of France");

            --  What's France in German?
            German := Query_Object (Context, Data, "deu", Translations);
            AUnit.Assertions.Assert (German /= Null_Index and  then
                                     Get_Kind (Context, German) = Kind_Object, "Get German translations of France");

            Result := Query_Object (Context, Data, "common", German);
            AUnit.Assertions.Assert (Result /= Null_Index and  then
                                     (Get_Kind (Context, Result) = Kind_String and then
                                      Get_String (Context, Data, Result) = "Frankreich"), "Get common German translations of France");

            --  What's France in Japanese?
            Japanese := Query_Object (Context, Data, "jpn", Translations);
            AUnit.Assertions.Assert (Japanese /= Null_Index and  then
                                     Get_Kind (Context, Japanese) = Kind_Object, "Get Japanese translations of France");

            Result := Query_Object (Context, Data, "official", Japanese);
            AUnit.Assertions.Assert (Result /= Null_Index and  then
                                     (Get_Kind (Context, Result) = Kind_String and then
                                      Get_String (Context, Data, Result) = "フランス共和国"), "Get official Japanese translations of France");
         end;

      end;

--  begin read only
   end Test_Parse;
--  end read only


--  begin read only
   procedure Test_Get_Kind (Gnattest_T : in out Test);
   procedure Test_Get_Kind_d143b5 (Gnattest_T : in out Test) renames Test_Get_Kind;
--  id:2.2/d143b5554cbc3797/Get_Kind/1/0/
   procedure Test_Get_Kind (Gnattest_T : in out Test) is
   --  json.ads:27:4:Get_Kind
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Get_Kind;
--  end read only


--  begin read only
   procedure Test_Get_Boolean (Gnattest_T : in out Test);
   procedure Test_Get_Boolean_bda11c (Gnattest_T : in out Test) renames Test_Get_Boolean;
--  id:2.2/bda11c0438ff0918/Get_Boolean/1/0/
   procedure Test_Get_Boolean (Gnattest_T : in out Test) is
   --  json.ads:30:4:Get_Boolean
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Match_Type;
      Context : Context_Type (Index_Type range 1..10);
   begin

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match = Match_OK and Offset = 4 and
                               Get_Kind (Context) = Kind_Boolean and
                               Get_Boolean (Context) = true, "Parse true");

--  begin read only
   end Test_Get_Boolean;
--  end read only


--  begin read only
   procedure Test_Get_Float (Gnattest_T : in out Test);
   procedure Test_Get_Float_b24b62 (Gnattest_T : in out Test) renames Test_Get_Float;
--  id:2.2/b24b6252a4b822a4/Get_Float/1/0/
   procedure Test_Get_Float (Gnattest_T : in out Test) is
   --  json.ads:35:4:Get_Float
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Get_Float;
--  end read only


--  begin read only
   procedure Test_Get_Integer (Gnattest_T : in out Test);
   procedure Test_Get_Integer_5c8a32 (Gnattest_T : in out Test) renames Test_Get_Integer;
--  id:2.2/5c8a32da9aa98cbe/Get_Integer/1/0/
   procedure Test_Get_Integer (Gnattest_T : in out Test) is
   --  json.ads:40:4:Get_Integer
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Get_Integer;
--  end read only


--  begin read only
   procedure Test_Get_String (Gnattest_T : in out Test);
   procedure Test_Get_String_bde0a4 (Gnattest_T : in out Test) renames Test_Get_String;
--  id:2.2/bde0a48b391f2a08/Get_String/1/0/
   procedure Test_Get_String (Gnattest_T : in out Test) is
   --  json.ads:45:4:Get_String
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Get_String;
--  end read only


--  begin read only
   procedure Test_Query_Object (Gnattest_T : in out Test);
   procedure Test_Query_Object_5a39a2 (Gnattest_T : in out Test) renames Test_Query_Object;
--  id:2.2/5a39a2ea1053411b/Query_Object/1/0/
   procedure Test_Query_Object (Gnattest_T : in out Test) is
   --  json.ads:50:4:Query_Object
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      --  Tested in Parse test
      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Query_Object;
--  end read only


--  begin read only
   procedure Test_Length (Gnattest_T : in out Test);
   procedure Test_Length_8991c1 (Gnattest_T : in out Test) renames Test_Length;
--  id:2.2/8991c12d8324dfc9/Length/1/0/
   procedure Test_Length (Gnattest_T : in out Test) is
   --  json.ads:56:4:Length
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Length;
--  end read only


--  begin read only
   procedure Test_Pos (Gnattest_T : in out Test);
   procedure Test_Pos_3b2306 (Gnattest_T : in out Test) renames Test_Pos;
--  id:2.2/3b230678699c3e2a/Pos/1/0/
   procedure Test_Pos (Gnattest_T : in out Test) is
   --  json.ads:61:4:Pos
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- Tested in Parse test
      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Pos;
--  end read only


--  begin read only
   procedure Test_Parse_Internal (Gnattest_T : in out Test);
   procedure Test_Parse_Internal_e42729 (Gnattest_T : in out Test) renames Test_Parse_Internal;
--  id:2.2/e42729f1a2970082/Parse_Internal/1/0/
   procedure Test_Parse_Internal (Gnattest_T : in out Test) is
   --  json.ads:100:4:Parse_Internal
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      -- Tested in Parse test
      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Parse_Internal;
--  end read only


--  begin read only
   --  procedure Test_Context_Valid (Gnattest_T : in out Test);
   --  procedure Test_Context_Valid_5ba400 (Gnattest_T : in out Test) renames Test_Context_Valid;
--  id:2.2/5ba40009ae9b6130/Context_Valid/1/1/
   --  procedure Test_Context_Valid (Gnattest_T : in out Test) is
--  end read only
--  
--        pragma Unreferenced (Gnattest_T);
--  
--     begin
--  
--        AUnit.Assertions.Assert
--          (Gnattest_Generated.Default_Assert_Value,
--           "Test not implemented.");
--  
--  begin read only
   --  end Test_Context_Valid;
--  end read only


--  begin read only
   --  procedure Test_Next (Gnattest_T : in out Test);
   --  procedure Test_Next_ddc7a9 (Gnattest_T : in out Test) renames Test_Next;
--  id:2.2/ddc7a95fae1b9e96/Next/1/1/
   --  procedure Test_Next (Gnattest_T : in out Test) is
--  end read only
--  
--        pragma Unreferenced (Gnattest_T);
--  
--     begin
--  
--        AUnit.Assertions.Assert (Next (42) = 43, "Next.");
--        AUnit.Assertions.Assert (Next (100) /= Next (1000), "not Next.");
--  
--  begin read only
   --  end Test_Next;
--  end read only


--  begin read only
   --  procedure Test_Initialize (Gnattest_T : in out Test);
   --  procedure Test_Initialize_e84d09 (Gnattest_T : in out Test) renames Test_Initialize;
--  id:2.2/e84d09615b851310/Initialize/1/1/
   --  procedure Test_Initialize (Gnattest_T : in out Test) is
--  end read only
--  
--        pragma Unreferenced (Gnattest_T);
--  
--     begin
--  
--        null;
--  
--  begin read only
   --  end Test_Initialize;
--  end read only

--  begin read only
--  id:2.2/02/
--
--  This section can be used to add elaboration code for the global state.
--
begin
--  end read only
   null;
--  begin read only
--  end read only
end JSON.Test_Data.Tests;
