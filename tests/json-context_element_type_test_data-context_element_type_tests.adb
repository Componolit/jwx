--  This package has been generated automatically by GNATtest.
--  You are allowed to add your code to the bodies of test routines.
--  Such changes will be kept during further regeneration of this file.
--  All code placed outside of test routine bodies will be lost. The
--  code intended to set up and tear down the test environment should be
--  placed into JSON.Context_Element_type_Test_Data.

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
package body JSON.Context_Element_type_Test_Data.Context_Element_type_Tests is

--  begin read only
--  id:2.2/01/
--
--  This section can be used to add global variables and other elements.
--
--  end read only

--  begin read only
--  end read only

--  begin read only
   procedure Test_Is_Null (Gnattest_T : in out Test_Context_Element_type);
   procedure Test_Is_Null_b0baff (Gnattest_T : in out Test_Context_Element_type) renames Test_Is_Null;
--  id:2.2/b0baff9e83457e01/Is_Null/1/0/
   procedure Test_Is_Null (Gnattest_T : in out Test_Context_Element_type) is
   --  json.ads:10:4:Is_Null
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (Null_Element.Is_Null, "Null element is null.");

--  begin read only
   end Test_Is_Null;
--  end read only


--  begin read only
   procedure Test_Get_Kind (Gnattest_T : in out Test_Context_Element_type);
   procedure Test_Get_Kind_54b377 (Gnattest_T : in out Test_Context_Element_type) renames Test_Get_Kind;
--  id:2.2/54b3772dd6597445/Get_Kind/1/0/
   procedure Test_Get_Kind (Gnattest_T : in out Test_Context_Element_type) is
   --  json.ads:13:4:Get_Kind
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (Null_Element.Get_Kind = Kind_Null, "Null element is kind null.");

--  begin read only
   end Test_Get_Kind;
--  end read only


--  begin read only
   procedure Test_Get_Boolean (Gnattest_T : in out Test_Context_Element_type);
   procedure Test_Get_Boolean_521306 (Gnattest_T : in out Test_Context_Element_type) renames Test_Get_Boolean;
--  id:2.2/5213066f5fbc2bf6/Get_Boolean/1/0/
   procedure Test_Get_Boolean (Gnattest_T : in out Test_Context_Element_type) is
   --  json.ads:16:4:Get_Boolean
--  end read only

      pragma Unreferenced (Gnattest_T);

      Offset  : Natural;
      Match   : Boolean;
      Context : Context_Type (Integer range 1..1);
   begin

      Offset := 0;
      Parse (Context, Offset, Match, "true");
      AUnit.Assertions.Assert (Match and Offset = 4 and
                               Context (1).Get_Kind = Kind_Boolean and
                               Context (1).Get_Boolean = true, "Parse true");

--  begin read only
   end Test_Get_Boolean;
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
end JSON.Context_Element_type_Test_Data.Context_Element_type_Tests;
