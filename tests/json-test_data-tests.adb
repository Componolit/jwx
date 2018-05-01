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

--  begin read only
--  end read only
package body JSON.Test_Data.Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Parse (Gnattest_T : in out Test);
   procedure Test_Parse_7ff026 (Gnattest_T : in out Test) renames Test_Parse;
--  id:2.2/7ff026f73f098df3/Parse/1/0/
   procedure Test_Parse (Gnattest_T : in out Test) is
   --  json.ads:40:4:Parse
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Boolean;
      Context : Context_Type (Integer range 1..100);
   begin

      Offset := 0;
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match and Offset = 4 and
                               Context (1).Get_Kind = Kind_Boolean and
                               Context (1).Get_Boolean = true, "Parse true");

      Offset := 0;
      Parse (Context, Offset, Match, "false");
      AUnit.Assertions.Assert (Match and
                               Offset = 5 and
                               Context (1).Get_Kind = Kind_Boolean and
                               Context (1).Get_Boolean = false, "Parse false.");

      Offset := 0;
      Parse (Context, Offset, Match, "null");
      AUnit.Assertions.Assert (Match and
                               Offset = 4 and
                               Context (1).Get_Kind = Kind_Null, "Parse null.");

      Offset := 0;
      Parse (Context, Offset, Match, "True");
      AUnit.Assertions.Assert (not Match and Offset = 0, "True case insensitive.");

      Offset := 0;
      Parse (Context, Offset, Match, "FALSE");
      AUnit.Assertions.Assert (not Match and Offset = 0, "True case insensitive.");

      Offset := 0;
      Parse (Context, Offset, Match, "nulL");
      AUnit.Assertions.Assert (not Match and Offset = 0, "True case insensitive.");

      Offset := 0;
      Parse (Context, Offset, Match, "    null");
      AUnit.Assertions.Assert (Match, "Parse boolean with space.");

      Offset := 0;
      Parse (Context, Offset, Match, "  " & ASCII.CR & ASCII.LF & "true");
      AUnit.Assertions.Assert (Match, "Parse boolean with CRLF");

      Offset := 0;
      Parse (Context, Offset, Match, ASCII.HT & "false");
      AUnit.Assertions.Assert (Match, "Parse boolean with tab.");

      Offset := 0;
      Parse (Context, Offset, Match, "42");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 2 and
                                Context (1).Get_Kind = Kind_Integer and
                                Context (1).Get_Integer = 42), "Parse small positive integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "-42");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 3 and
                                Context (1).Get_Kind = Kind_Integer and
                                Context (1).Get_Integer = -42), "Parse small negative integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "2147483647");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 10 and
                                Context (1).Get_Kind = Kind_Integer and
                                Context (1).Get_Integer = 2147483647), "Parse big positive integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "   0 ");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 4 and
                                Context (1).Get_Kind = Kind_Integer and
                                Context (1).Get_Integer = 0), "Parse zero integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "-2147483647");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 11 and
                                Context (1).Get_Kind = Kind_Integer and
                                Context (1).Get_Integer = -2147483647), "Parse big negative integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "92233720368547758080");
      AUnit.Assertions.Assert (not Match, "Too big integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "-92233720368547758080");
      AUnit.Assertions.Assert (not Match, "Too small integer.");

      Offset := 0;
      Parse (Context, Offset, Match, "3.14");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 4 and
                                Context (1).Get_Kind = Kind_Float and
                                Context (1).Get_Float = 3.14), "Parse small positive float.");

      Offset := 0;
      Parse (Context, Offset, Match, "-3.14");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 5 and
                                Context (1).Get_Kind = Kind_Float and
                                Context (1).Get_Float = -3.14), "Parse small negative float.");

      Offset := 0;
      Parse (Context, Offset, Match, "0.00000000001");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 13 and
                                Context (1).Get_Kind = Kind_Float and
                                Context (1).Get_Float = 0.00000000001), "Very small positive float.");

      Offset := 0;
      Parse (Context, Offset, Match, "-0.00000000001");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 14 and
                                Context (1).Get_Kind = Kind_Float and
                                Context (1).Get_Float = -0.00000000001), "Very small negative float.");

      Offset := 0;
      Parse (Context, Offset, Match, " 0.0   ");
      AUnit.Assertions.Assert (Match and then
                               (Offset = 4 and
                                Context (1).Get_Kind = Kind_Float and
                                Context (1).Get_Float = 0.0), "Parse zero float.");

      Offset := 0;
      Parse (Context, Offset, Match, "000068547758080");
      AUnit.Assertions.Assert (not Match, "Leading zero.");

      Offset := 0;
      Parse (Context, Offset, Match, "54775. ");
      AUnit.Assertions.Assert (not Match, "Missing fractional part.");

--  begin read only
   end Test_Parse;
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
