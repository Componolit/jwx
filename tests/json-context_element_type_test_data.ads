--  This package is intended to set up and tear down  the test environment.
--  Once created by GNATtest, this package will never be overwritten
--  automatically. Contents of this package can be modified in any way
--  except for sections surrounded by a 'read only' marker.


with AUnit.Test_Fixtures;

with GNATtest_Generated;

package JSON.Context_Element_type_Test_Data is

   type Context_Element_type_Access is access all GNATtest_Generated.GNATtest_Standard.JSON.Context_Element_type'Class;

--  begin read only
   type Test_Context_Element_type is new AUnit.Test_Fixtures.Test_Fixture
--  end read only
   with record
      Fixture : Context_Element_type_Access;
   end record;

   procedure Set_Up (Gnattest_T : in out Test_Context_Element_type);
   procedure Tear_Down (Gnattest_T : in out Test_Context_Element_type);

end JSON.Context_Element_type_Test_Data;
