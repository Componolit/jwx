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
   procedure Test_Initialize (Gnattest_T : in out Test);
   procedure Test_Initialize_e84d09 (Gnattest_T : in out Test) renames Test_Initialize;
--  id:2.2/e84d09615b851310/Initialize/1/0/
   procedure Test_Initialize (Gnattest_T : in out Test) is
   --  json.ads:50:4:Initialize
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_Initialize;
--  end read only


--  begin read only
   procedure Test_Parse (Gnattest_T : in out Test);
   procedure Test_Parse_f44d29 (Gnattest_T : in out Test) renames Test_Parse;
--  id:2.2/f44d29aaedc5307b/Parse/1/0/
   procedure Test_Parse (Gnattest_T : in out Test) is
   --  json.ads:56:4:Parse
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Match_Type;
      Context : Context_Type (Integer range 1..100);
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
         Result : Context_Element_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Object, "Parse simple object");

         Result := Query_Object (Context, Data, "precision");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "zip", "Query string from simple object");

         Result := Query_Object (Context, Data, "Latitude");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Float and then
                                  Result.Get_Float = 37.7668, "Query float from simple object");

         Result := Query_Object (Context, Data, "Longitude");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Float and then
                                  Result.Get_Float = -122.3959, "Query negative float from simple object");

         Result := Query_Object (Context, Data, "Address");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "", "Query empty string from simple object");

         Result := Query_Object (Context, Data, "City");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "SAN FRANCISCO", "Query string from simple object");

         Result := Query_Object (Context, Data, "State");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "CA", "Query string from simple object");

         Result := Query_Object (Context, Data, "Zip");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "94107", "Query digit-only string from simple object");

         Result := Query_Object (Context, Data, "Country");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_String and then
                                  Result.Get_String (Data) = "US", "Query string from simple object");

         Result := Query_Object (Context, Data, "Does-not-exist");
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Null, "Query non-existing member from simple object");
      end;

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "  {} ");
      AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Object, "Parse empty object");

      Offset := 0;
      Initialize (Context);
      declare
         Data : String := "  [116, 943, 234, 38793] ";
         Result : Context_Element_Type;
      begin
         Parse (Context, Offset, Match, Data);
         AUnit.Assertions.Assert (Match = Match_OK and then Get_Kind (Context) = Kind_Array, "Parse simple array");

         AUnit.Assertions.Assert (Length (Context) = 4, "Simple array length");

         Result := Pos (Context, 2);
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Integer and then Result.Get_Integer = 943, "Get simple array element");

         Result := Pos (Context, 4);
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Integer and then Result.Get_Integer = 38793, "Get simple array element");

         Result := Pos (Context, 7);
         AUnit.Assertions.Assert (Result.Get_Kind = Kind_Null, "Out of bounds array access");
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

         AUnit.Assertions.Assert (Pos (Context, 1).Get_Integer = 116, "Get mixed array integer element");
         AUnit.Assertions.Assert (Pos (Context, 2).Get_Float = -4.5, "Get mixed array float element");
         AUnit.Assertions.Assert (Pos (Context, 3).Get_String (Data) = "baz", "Get mixed array string element");
         AUnit.Assertions.Assert (Pos (Context, 4).Get_Boolean = true, "Get mixed array boolean element");
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

--  begin read only
   end Test_Parse;
--  end read only


--  begin read only
   procedure Test_1_Get_Kind (Gnattest_T : in out Test);
   procedure Test_Get_Kind_4c1c6f (Gnattest_T : in out Test) renames Test_1_Get_Kind;
--  id:2.2/4c1c6fe2e8fca998/Get_Kind/1/0/
   procedure Test_1_Get_Kind (Gnattest_T : in out Test) is
   --  json.ads:66:4:Get_Kind
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_1_Get_Kind;
--  end read only


--  begin read only
   procedure Test_1_Get_Boolean (Gnattest_T : in out Test);
   procedure Test_Get_Boolean_4d5fb0 (Gnattest_T : in out Test) renames Test_1_Get_Boolean;
--  id:2.2/4d5fb04694b2c853/Get_Boolean/1/0/
   procedure Test_1_Get_Boolean (Gnattest_T : in out Test) is
   --  json.ads:71:4:Get_Boolean
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Match_Type;
      Context : Context_Type (Integer range 1..10);
   begin

      Offset := 0;
      Initialize (Context);
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match = Match_OK and Offset = 4 and
                               Get_Kind (Context) = Kind_Boolean and
                               Get_Boolean (Context) = true, "Parse true");

--  begin read only
   end Test_1_Get_Boolean;
--  end read only


--  begin read only
   procedure Test_1_Get_Float (Gnattest_T : in out Test);
   procedure Test_Get_Float_492cca (Gnattest_T : in out Test) renames Test_1_Get_Float;
--  id:2.2/492cca72be95f3c3/Get_Float/1/0/
   procedure Test_1_Get_Float (Gnattest_T : in out Test) is
   --  json.ads:77:4:Get_Float
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_1_Get_Float;
--  end read only


--  begin read only
   procedure Test_1_Get_Integer (Gnattest_T : in out Test);
   procedure Test_Get_Integer_127000 (Gnattest_T : in out Test) renames Test_1_Get_Integer;
--  id:2.2/127000ceacbb4664/Get_Integer/1/0/
   procedure Test_1_Get_Integer (Gnattest_T : in out Test) is
   --  json.ads:83:4:Get_Integer
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_1_Get_Integer;
--  end read only


--  begin read only
   procedure Test_1_Get_String (Gnattest_T : in out Test);
   procedure Test_Get_String_db6fb3 (Gnattest_T : in out Test) renames Test_1_Get_String;
--  id:2.2/db6fb3c6ae402a77/Get_String/1/0/
   procedure Test_1_Get_String (Gnattest_T : in out Test) is
   --  json.ads:89:4:Get_String
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      null;

--  begin read only
   end Test_1_Get_String;
--  end read only


--  begin read only
   procedure Test_Length (Gnattest_T : in out Test);
   procedure Test_Length_ba239d (Gnattest_T : in out Test) renames Test_Length;
--  id:2.2/ba239ddf8f6431d6/Length/1/0/
   procedure Test_Length (Gnattest_T : in out Test) is
   --  json.ads:104:4:Length
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Length;
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
