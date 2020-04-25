--
-- \brief  Tests for JWX.JSON
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with AUnit.Assertions; use AUnit.Assertions;
with JWX.JSON;
with JWX_Test_Utils; use JWX_Test_Utils;
use JWX;

package body JWX_JSON_Tests is

   procedure Test_Parse_True (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "true";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Boolean = true, "Invalid value");
	end Test_Parse_True;

   ---------------------------------------------------------------------------

   procedure Test_Parse_False (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "false";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Boolean = false, "Invalid value");
	end Test_Parse_False;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Null (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "null";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Null, "Invalid kind: " & Get_Kind'Img);
	end Test_Parse_Null;

   ---------------------------------------------------------------------------

   procedure Test_Parse_True_Wrong_Case (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "True";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match /= Match_OK, "Must fail: " & Match'Img);
	end Test_Parse_True_Wrong_Case;

   ---------------------------------------------------------------------------

   procedure Test_Parse_False_Wrong_Case (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "FALSE";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match /= Match_OK, "Must fail: " & Match'Img);
	end Test_Parse_False_Wrong_Case;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Null_Wrong_Case (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "nulL";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match /= Match_OK, "Must fail: " & Match'Img);
	end Test_Parse_Null_Wrong_Case;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Null_With_Space (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "    null";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Null, "Invalid kind: " & Get_Kind'Img);
	end Test_Parse_Null_With_Space;

   ---------------------------------------------------------------------------

   procedure Test_Parse_True_With_Newline (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "  " & ASCII.CR & ASCII.LF & "true";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
	end Test_Parse_True_With_Newline;

   ---------------------------------------------------------------------------

   procedure Test_Parse_False_With_Tab (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := ASCII.HT & "false";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Boolean, "Invalid kind: " & Get_Kind'Img);
	end Test_Parse_False_With_Tab;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Small_Positive_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "42";
      package J is new JWX.JSON (Data);
      use J;
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 42, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Small_Positive_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Positive_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "40000";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 40000, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Positive_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Small_Negative_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-42";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = -42, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Small_Negative_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Big_Positive_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "2147483647";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 2147483647, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Big_Positive_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Integer_With_Positive_Exponent (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "1234e2";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 123400, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Integer_With_Positive_Exponent;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Integer_With_Positive_Exponent_2 (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "1234E+2";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 123400, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Integer_With_Positive_Exponent_2;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Integer_With_Positive_Exponent_3 (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "1234E+02";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 123400, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Integer_With_Positive_Exponent_3;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Num_With_Neg_Exp_Frac (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "12345e-2";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = 123.45, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Num_With_Neg_Exp_Frac;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Num_With_Neg_Exp_Int (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "12300e-2";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 123, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Num_With_Neg_Exp_Int;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Zero_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "   0 ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = 0, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Zero_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Big_Negative_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-2147483647";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer = -2147483647, "Invalid value: " & Get_Integer'Img);
	end Test_Parse_Big_Negative_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Too_Big_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "92233720368547758080";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Parse_Too_Big_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Too_Small_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-92233720368547758080";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Parse_Too_Small_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Small_Positive_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "3.14";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = 3.14, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Small_Positive_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Small_Negative_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-3.14";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = -3.14, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Small_Negative_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Very_Small_Positive_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "0.00000000001";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = 0.00000000001, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Very_Small_Positive_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Too_Small_Positive_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "0.0000000000000000000000000000000001";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Parse_Too_Small_Positive_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Very_Small_Negative_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-0.00000000001";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = -0.00000000001, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Very_Small_Negative_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Too_Small_Negative_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "-0.0000000000000000000000000000000001";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Parse_Too_Small_Negative_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Zero_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := " 0.0 ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = 0.0, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Zero_Real;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Real_With_Exp_With_Leading_Zero (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "123.5e+02";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real = 12350.0, "Invalid value: " & Get_Real'Img);
	end Test_Parse_Real_With_Exp_With_Leading_Zero;

   ---------------------------------------------------------------------------

   procedure Test_Leading_Zero_Integer (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "000068547758080";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Leading_Zero_Integer;

   ---------------------------------------------------------------------------

   procedure Test_Leading_Zero_Real (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "000.06854";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Leading_Zero_Real;

   ---------------------------------------------------------------------------

   procedure Test_Missing_Fractional_Part (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "54775. ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Missing_Fractional_Part;

   ---------------------------------------------------------------------------

   procedure Test_Simple_String (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := """Hello world!""";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_String, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_String = "Hello world!", "Invalid value: " & Get_String);
	end Test_Simple_String;

   ---------------------------------------------------------------------------

   procedure Test_Unclosed_String (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := """Invalid String";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Must fail: " & Match'Img);
	end Test_Unclosed_String;

   ---------------------------------------------------------------------------

   procedure Test_Escaped_String (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := """Say \""Hello World\""!""";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_String, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_String = "Say \""Hello World\""!", "Invalid value: " & Get_String);
	end Test_Escaped_String;

   ---------------------------------------------------------------------------

   procedure Test_Escaped_Backslash (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := """Escaped backslash\\""";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_String, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_String = "Escaped backslash\\", "Invalid value: " & Get_String);
	end Test_Escaped_Backslash;

   ---------------------------------------------------------------------------

   procedure Test_Escaped_Regular_Character (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := """Escaped \character""";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_String, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_String = "Escaped \character", "Invalid value: " & Get_String);
	end Test_Escaped_Regular_Character;

   ---------------------------------------------------------------------------

   procedure Test_Simple_Object (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := " { ""precision"": ""zip"", ""Latitude"":  37.7668, ""Longitude"": -122.3959, ""Address"":   """", ""City"":      ""SAN FRANCISCO"", ""State"":     ""CA"", ""Zip"":       ""94107"", ""Country"":   ""US"" }";
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Object, "Invalid kind: " & Get_Kind'Img);

		Assert (Elements = 8, "Invalid number of elements: " & Elements'Img);

      Result := Query_Object ("precision");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "zip", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("Latitude");
		Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Real (Result) = 37.7668, "Invalid real: " & Get_Real (Result)'Img);

      Result := Query_Object ("Longitude");
		Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Real (Result) = -122.3959, "Invalid real: " & Get_Real (Result)'Img);

      Result := Query_Object ("Address");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("City");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "SAN FRANCISCO", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("State");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "CA", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("Zip");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "94107", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("Country");
		Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "US", "Invalid string: " & Get_String (Result));

      Result := Query_Object ("Does-not-exist");
		Assert (Result = End_Index, "Non-existent element found");

	end Test_Simple_Object;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Empty_Object (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "  {}  ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Object, "Invalid kind: " & Get_Kind'Img);
		Assert (Elements = 0, "Invalid number of elements: " & Elements'Img);
	end Test_Parse_Empty_Object;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Simple_Array (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "  [116, 943, 234, 38793] ";
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      AUnit.Assertions.Assert (Length = 4, "Invalid array length: " & Length'Img);

      Result := Pos (1);
      Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Integer (Result) = 116, "Invalid value: " & Get_Integer (Result)'Img);

      Result := Pos (2);
      Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Integer (Result) = 943, "Invalid value: " & Get_Integer (Result)'Img);

      Result := Pos (3);
      Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Integer (Result) = 234, "Invalid value: " & Get_Integer (Result)'Img);

      Result := Pos (4);
      Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Integer (Result) = 38793, "Invalid value: " & Get_Integer (Result)'Img);

      Result := Pos (7);
      Assert (Result = End_Index, "Out of bounds access not detected");

	end Test_Parse_Simple_Array;

   ---------------------------------------------------------------------------

   procedure Test_Unclosed_Array (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := " [""foo"", ""bar"" ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_Invalid, "Unclosed array not detected");
   end Test_Unclosed_Array;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Mixed_Array (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "  [116, -4.5, ""baz"", true] ";
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      AUnit.Assertions.Assert (Length = 4, "Invalid array length: " & Length'Img);

      Result := Pos (1);
      Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Integer (Result) = 116, "Invalid value: " & Get_Integer (Result)'Img);

      Result := Pos (2);
      Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Real (Result) = -4.5, "Invalid value: " & Get_Real (Result)'Img);

      Result := Pos (3);
      Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_String (Result) = "baz", "Invalid value: " & Get_String (Result));

      Result := Pos (4);
      Assert (Get_Kind (Result) = Kind_Boolean, "Invalid kind: " & Get_Kind (Result)'Img);
		Assert (Get_Boolean (Result) = true, "Invalid value: " & Get_Boolean (Result)'Img);

	end Test_Parse_Mixed_Array;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Empty_Array (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "   [] ";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      AUnit.Assertions.Assert (Length = 0, "Invalid array length: " & Length'Img);
	end Test_Parse_Empty_Array;

   ---------------------------------------------------------------------------

   procedure Test_Parse_Array_Of_Objects (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "[{""A"": 42}, {""B"": {""D"": 234}}, {""C"": 9}]";
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      AUnit.Assertions.Assert (Length = 3, "Invalid array length: " & Length'Img);
	end Test_Parse_Array_Of_Objects;

   ---------------------------------------------------------------------------

   procedure Test_RFC7159_Example_1 (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := Read_File ("tests/data/RFC7159_example1.json");
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Object, "Invalid kind: " & Get_Kind'Img);
	end Test_RFC7159_Example_1;

   ---------------------------------------------------------------------------

   procedure Test_RFC7159_Example_2 (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := Read_File ("tests/data/RFC7159_example2.json");
      package J is new JWX.JSON (Data);
      use J;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);
	end Test_RFC7159_Example_2;

   ---------------------------------------------------------------------------

   procedure Test_Complex_Country (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := Read_File ("tests/data/country.json");
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Object, "Invalid kind: " & Get_Kind'Img);
		Assert (Elements = 20, "Invalid number of elements: " & Elements'Img);

      Result := Query_Object ("area");
		Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real (Result) /= 1246700.0, "Invalid value: " & Get_Real (Result)'Img);
	end Test_Complex_Country;

   ---------------------------------------------------------------------------

   procedure Test_Mixed_Objects (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := "[{""area"": 123.0}, {""area"": 200.5}]";
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      Result := Pos (1);
		Assert (Get_Kind (Result) = Kind_Object, "Invalid kind: " & Get_Kind'Img);
		Assert (Elements (Result) = 1, "Invalid number of elements: " & Elements (Result)'Img);

      Result := Query_Object ("area", Result);
		Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real (Result) = 123.0, "Invalid value: " & Get_Real (Result)'Img);
	end Test_Mixed_Objects;

   ---------------------------------------------------------------------------

   procedure Test_Complex_Two_Countries (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := Read_File ("tests/data/two_countries.json");
      package J is new JWX.JSON (Data);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      Result := Pos (1);
		Assert (Result /= Null_Index, "Element not found");
		Assert (Get_Kind (Result) = Kind_Object, "Invalid kind: " & Get_Kind'Img);
		Assert (Elements (Result) = 20, "Invalid number of elements: " & Elements (Result)'Img);

      Result := Query_Object ("area", Result);
		Assert (Result /= Null_Index, "Element not found");
		Assert (Get_Kind (Result) = Kind_Real, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Real (Result) /= 1246700.0, "Invalid value: " & Get_Real (Result)'Img);
	end Test_Complex_Two_Countries;

   ---------------------------------------------------------------------------

   procedure Test_Complex_Countries (T : in out Test_Cases.Test_Case'Class)
   is
      Data : String := Read_File ("tests/data/countries.json");
      package J is new JWX.JSON (Data, 100000);
      use J;
      Result : Index_Type;
      Match : Match_Type;
   begin
      Parse (Match);
		Assert (Match = Match_OK, "No match: " & Match'Img);
		Assert (Get_Kind = Kind_Array, "Invalid kind: " & Get_Kind'Img);

      Result := Pos (4);
		Assert (Result /= Null_Index, "Element not found");
		Assert (Get_Kind (Result) = Kind_Object, "Invalid kind: " & Get_Kind'Img);
		Assert (Elements (Result) = 20, "Invalid number of elements: " & Elements (Result)'Img);

      Result := Query_Object ("area", Result);
		Assert (Result /= Null_Index, "Element not found");
		Assert (Get_Kind (Result) = Kind_Integer, "Invalid kind: " & Get_Kind'Img);
		Assert (Get_Integer (Result) = 83600, "Invalid value: " & Get_Integer (Result)'Img);

      -- France
      declare
         France, AltSpellings, Translations, German, Japanese : Index_Type;
      begin
         France := Pos (97);
		   Assert (France /= Null_Index, "Element not found");
		   Assert (Get_Kind (France) = Kind_Object, "Invalid kind: " & Get_Kind'Img);

         --  alternaive spellings
         AltSpellings := Query_Object ("altSpellings", France);
         Assert (Result /= Null_Index, "Not found");
         Assert (Get_Kind (AltSpellings) = Kind_Array, "Invalid kind: " & Get_Kind (AltSpellings)'Img);

         Result := Pos (3, AltSpellings);
         Assert (Result /= Null_Index, "Not found");
         Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
         Assert (Get_String (Result) = "République française", "Invalid string: " & Get_String (Result));

         --  What's France in other languages?
         Translations := Query_Object ("translations", France);
         Assert (Result /= Null_Index, "Not found");
         Assert (Get_Kind (Translations) = Kind_Object, "Invalid kind: " & Get_Kind (Result)'Img);

         --  What's France in German?
         German := Query_Object ("deu", Translations);
         Assert (German /= Null_Index, "Not found");
         Assert (Get_Kind (German) = Kind_Object, "Invalid kind: " & Get_Kind (Result)'Img);

         Result := Query_Object ("common", German);
         Assert (Result /= Null_Index, "Not found");
         Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
         Assert (Get_String (Result) = "Frankreich", "Invalid string: " & Get_String (Result));

         --  What's France in Japanese?
         Japanese := Query_Object ("jpn", Translations);
         Assert (Japanese /= Null_Index, "Not found");
         Assert (Get_Kind (Japanese) = Kind_Object, "Invalid kind: " & Get_Kind (Result)'Img);

         Result := Query_Object ("official", Japanese);
         Assert (Result /= Null_Index, "Not found");
         Assert (Get_Kind (Result) = Kind_String, "Invalid kind: " & Get_Kind (Result)'Img);
         Assert (Get_String (Result) = "フランス共和国", "Invalid string: " & Get_String (Result));
      end;

	end Test_Complex_Countries;

   ---------------------------------------------------------------------------

   procedure Register_Tests (T: in out Test_Case) is
      use AUnit.Test_Cases.Registration;
   begin
      Register_Routine (T, Test_Parse_True'Access, "Parse true");
      Register_Routine (T, Test_Parse_False'Access, "Parse false");
      Register_Routine (T, Test_Parse_Null'Access, "Parse null");
      Register_Routine (T, Test_Parse_True_Wrong_Case'Access, "Parse true with wrong case");
      Register_Routine (T, Test_Parse_False_Wrong_Case'Access, "Parse false with wrong case");
      Register_Routine (T, Test_Parse_Null_Wrong_Case'Access, "Parse null with wrong case");
      Register_Routine (T, Test_Parse_True_With_Newline'Access, "Parse boolean with newline");
      Register_Routine (T, Test_Parse_False_With_Tab'Access, "Parse boolean with tab");
      Register_Routine (T, Test_Parse_Small_Positive_Integer'Access, "Parse small positive integer");
      Register_Routine (T, Test_Parse_Positive_Integer'Access, "Parse positive integer");
      Register_Routine (T, Test_Parse_Small_Negative_Integer'Access, "Parse small negative integer");
      Register_Routine (T, Test_Parse_Big_Positive_Integer'Access, "Parse big positive integer");
      Register_Routine (T, Test_Parse_Integer_With_Positive_Exponent'Access, "Parse integer with positive exponent (1)");
      Register_Routine (T, Test_Parse_Integer_With_Positive_Exponent_2'Access, "Parse integer with positive exponent (2)");
      Register_Routine (T, Test_Parse_Integer_With_Positive_Exponent_3'Access, "Parse integer with positive exponent (3)");
      Register_Routine (T, Test_Parse_Num_With_Neg_Exp_Frac'Access, "Parse number with negative exponent (1)");
      Register_Routine (T, Test_Parse_Num_With_Neg_Exp_Int'Access, "Parse number with negative exponent (2)");
      Register_Routine (T, Test_Parse_Zero_Integer'Access, "Parse integer 0");
      Register_Routine (T, Test_Parse_Big_Negative_Integer'Access, "Parse big negative integer");
      Register_Routine (T, Test_Parse_Too_Big_Integer'Access, "Too big integer");
      Register_Routine (T, Test_Parse_Too_Small_Integer 'Access, "Too small integer");
      Register_Routine (T, Test_Parse_Small_Positive_Real'Access, "Parse small positive real");
      Register_Routine (T, Test_Parse_Small_Negative_Real 'Access, "Parse small negative real");
      Register_Routine (T, Test_Parse_Very_Small_Positive_Real'Access, "Parse very small positive real");
      Register_Routine (T, Test_Parse_Too_Small_Positive_Real'Access, "Too small positive real");
      Register_Routine (T, Test_Parse_Very_Small_Negative_Real'Access, "Parse very small negative real");
      Register_Routine (T, Test_Parse_Too_Small_Negative_Real'Access, "Too small negative real");
      Register_Routine (T, Test_Parse_Zero_Real'Access, "Parse zero real");
      Register_Routine (T, Test_Parse_Real_With_Exp_With_Leading_Zero'Access, "Parse real with exponent with leading zero");
      Register_Routine (T, Test_Leading_Zero_Integer'Access, "Integer with leading zero");
      Register_Routine (T, Test_Leading_Zero_Real 'Access, "Real with leading zero");
      Register_Routine (T, Test_Missing_Fractional_Part 'Access, "Missing fractional part");
      Register_Routine (T, Test_Simple_String'Access, "Parse simple string");
      Register_Routine (T, Test_Unclosed_String'Access, "Unclosed string");
      Register_Routine (T, Test_Escaped_String'Access, "Parse escaped string");
      Register_Routine (T, Test_Escaped_Backslash'Access, "Parse escaped backslash");
      Register_Routine (T, Test_Escaped_Regular_Character'Access, "Parse escaped regular character");
      Register_Routine (T, Test_Simple_Object'Access, "Parse simple object");
      Register_Routine (T, Test_Parse_Empty_Object'Access, "Parse empty object");
      Register_Routine (T, Test_Parse_Simple_Array'Access, "Parse simple array");
      Register_Routine (T, Test_Unclosed_Array'Access, "Unclosed array");
      Register_Routine (T, Test_Parse_Mixed_Array'Access, "Parse mixed array");
      Register_Routine (T, Test_Parse_Empty_Array'Access, "Parse empty array");
      Register_Routine (T, Test_Parse_Array_Of_Objects'Access, "Parse array of objects");
      Register_Routine (T, Test_RFC7159_Example_1'Access, "Parse RFC7159 example 1");
      Register_Routine (T, Test_RFC7159_Example_2'Access, "Parse RFC7159 example 2");
      Register_Routine (T, Test_Complex_Country'Access, "Parse country");
      Register_Routine (T, Test_Mixed_Objects'Access, "Parse mixed object");
      Register_Routine (T, Test_Complex_Two_Countries'Access, "Parse two countries");
      Register_Routine (T, Test_Complex_Countries'Access, "Parse many countries");
   end Register_Tests;

   ---------------------------------------------------------------------------

   function Name (T : Test_Case) return Test_String is
   begin
      return Format ("JSON Tests");
   end Name;

end JWX_JSON_Tests;
