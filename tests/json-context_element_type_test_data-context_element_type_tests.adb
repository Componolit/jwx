--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into JSON.Context_Element_Type_Test_Data.

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
package body JSON.Context_Element_Type_Test_Data.Context_Element_Type_Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_1_Get_Kind (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Kind_54b377 (Gnattest_T : in out Test_Context_Element_Type) renames Test_1_Get_Kind;
--  id:2.2/54b3772dd6597445/Get_Kind/0/0/
   procedure Test_1_Get_Kind (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:18:4:Get_Kind
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (true, "Null element");

--  begin read only
   end Test_1_Get_Kind;
--  end read only


--  begin read only
   procedure Test_1_Get_Boolean (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Boolean_521306 (Gnattest_T : in out Test_Context_Element_Type) renames Test_1_Get_Boolean;
--  id:2.2/5213066f5fbc2bf6/Get_Boolean/0/0/
   procedure Test_1_Get_Boolean (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:21:4:Get_Boolean
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Match_Type;
      Context : Context_Type (Integer range 1..1);
   begin

      Offset := 0;
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match = Match_OK and Offset = 4 and
                               Context (1).Get_Kind = Kind_Boolean and
                               Context (1).Get_Boolean = true, "Parse true");

--  begin read only
   end Test_1_Get_Boolean;
--  end read only


--  begin read only
   procedure Test_1_Get_Float (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Float_11a14f (Gnattest_T : in out Test_Context_Element_Type) renames Test_1_Get_Float;
--  id:2.2/11a14f2e5e32c6e3/Get_Float/0/0/
   procedure Test_1_Get_Float (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:26:4:Get_Float
--  end read only

      pragma Unreferenced (Gnattest_T);

      Test_Value : constant Float := 1.6336;
   begin

      AUnit.Assertions.Assert (True, "Float element accessor.");

--  begin read only
   end Test_1_Get_Float;
--  end read only


--  begin read only
   procedure Test_1_Get_Integer (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Integer_47cd2c (Gnattest_T : in out Test_Context_Element_Type) renames Test_1_Get_Integer;
--  id:2.2/47cd2c25a0b5f0b6/Get_Integer/0/0/
   procedure Test_1_Get_Integer (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:31:4:Get_Integer
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (True, "Integer element accessor.");

--  begin read only
   end Test_1_Get_Integer;
--  end read only


--  begin read only
   procedure Test_1_Get_String (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_String_8657fa (Gnattest_T : in out Test_Context_Element_Type) renames Test_1_Get_String;
--  id:2.2/8657fa34962ec79a/Get_String/0/0/
   procedure Test_1_Get_String (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:36:4:Get_String
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (True, "String element accessor.");

--  begin read only
   end Test_1_Get_String;
--  end read only


--  begin read only
   procedure Test_Query_Object (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Query_Object_cceaf1 (Gnattest_T : in out Test_Context_Element_Type) renames Test_Query_Object;
--  id:2.2/cceaf14acd4eb9f0/Query_Object/0/0/
   procedure Test_Query_Object (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:95:4:Query_Object
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (True, "Test not implemented.");

--  begin read only
   end Test_Query_Object;
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
end JSON.Context_Element_Type_Test_Data.Context_Element_Type_Tests;
