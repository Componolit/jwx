--  This package is intended to set up and tear down  the test environment.
--  Once created by GNATtest, this package will never be overwritten
--  automatically. Contents of this package can be modified in any way
--  except for sections surrounded by a 'read only' marker.

package body JSON.Context_Element_type_Test_Data is

   Local_Context_Element_type : aliased GNATtest_Generated.GNATtest_Standard.JSON.Context_Element_type;
   procedure Set_Up (Gnattest_T : in out Test_Context_Element_type) is
   begin
      Gnattest_T.Fixture := Local_Context_Element_type'Access;
   end Set_Up;

   procedure Tear_Down (Gnattest_T : in out Test_Context_Element_type) is
   begin
      null;
   end Tear_Down;

end JSON.Context_Element_type_Test_Data;
