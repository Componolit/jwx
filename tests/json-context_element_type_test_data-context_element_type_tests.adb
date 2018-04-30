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
   procedure Test_Null_Element (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Null_Element_014ed4 (Gnattest_T : in out Test_Context_Element_Type) renames Test_Null_Element;
--  id:2.2/014ed40dcdbb8de1/Null_Element/1/0/
   procedure Test_Null_Element (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:8:4:Null_Element
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Null_Element = (Kind          => Kind_Null,
                         Boolean_Value => False,
                         Float_Value   => 0.0,
                         Integer_Value => 0),
         "Null element constuction.");

--  begin read only
   end Test_Null_Element;
--  end read only


--  begin read only
   procedure Test_Boolean_Element (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Boolean_Element_55bbfe (Gnattest_T : in out Test_Context_Element_Type) renames Test_Boolean_Element;
--  id:2.2/55bbfee41a3acb92/Boolean_Element/1/0/
   procedure Test_Boolean_Element (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:11:4:Boolean_Element
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      for b in Boolean
      loop
         AUnit.Assertions.Assert
           (Boolean_Element (b) = (Kind          => Kind_Boolean,
                                   Boolean_Value => b,
                                   Float_Value   => 0.0,
                                   Integer_Value => 0),
            "Boolean element constuction for " & b'Img & ".");
      end loop;


--  begin read only
   end Test_Boolean_Element;
--  end read only


--  begin read only
   procedure Test_Float_Element (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Float_Element_cefcca (Gnattest_T : in out Test_Context_Element_Type) renames Test_Float_Element;
--  id:2.2/cefccab2ed86d567/Float_Element/1/0/
   procedure Test_Float_Element (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:14:4:Float_Element
--  end read only

      pragma Unreferenced (Gnattest_T);

      Test_Value : constant Float := 1.6336;
   begin

      AUnit.Assertions.Assert
        (Float_Element (Test_Value) = (Kind          => Kind_Float,
                                       Boolean_Value => false,
                                       Float_Value   => Test_Value,
                                       Integer_Value => 0),
         "Float element constuction.");

--  begin read only
   end Test_Float_Element;
--  end read only


--  begin read only
   procedure Test_Get_Kind (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Kind_54b377 (Gnattest_T : in out Test_Context_Element_Type) renames Test_Get_Kind;
--  id:2.2/54b3772dd6597445/Get_Kind/1/0/
   procedure Test_Get_Kind (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:17:4:Get_Kind
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert (Null_Element.Get_Kind = Kind_Null, "Null element is kind null.");

--  begin read only
   end Test_Get_Kind;
--  end read only


--  begin read only
   procedure Test_Get_Boolean (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Boolean_521306 (Gnattest_T : in out Test_Context_Element_Type) renames Test_Get_Boolean;
--  id:2.2/5213066f5fbc2bf6/Get_Boolean/1/0/
   procedure Test_Get_Boolean (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:20:4:Get_Boolean
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
   procedure Test_Get_Float (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Float_11a14f (Gnattest_T : in out Test_Context_Element_Type) renames Test_Get_Float;
--  id:2.2/11a14f2e5e32c6e3/Get_Float/1/0/
   procedure Test_Get_Float (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:25:4:Get_Float
--  end read only

      pragma Unreferenced (Gnattest_T);

      Test_Value : constant Float := 1.6336;
   begin

      AUnit.Assertions.Assert
        (Float_Element (Test_Value).Get_Float = Test_Value,
         "Float element constuction.");

--  begin read only
   end Test_Get_Float;
--  end read only


--  begin read only
   procedure Test_Get_Integer (Gnattest_T : in out Test_Context_Element_Type);
   procedure Test_Get_Integer_02bdc1 (Gnattest_T : in out Test_Context_Element_Type) renames Test_Get_Integer;
--  id:2.2/02bdc12333f30151/Get_Integer/1/0/
   procedure Test_Get_Integer (Gnattest_T : in out Test_Context_Element_Type) is
   --  json.ads:30:4:Get_Integer
--  end read only

      pragma Unreferenced (Gnattest_T);

   begin

      AUnit.Assertions.Assert
        (Gnattest_Generated.Default_Assert_Value,
         "Test not implemented.");

--  begin read only
   end Test_Get_Integer;
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
