with JWX.JSON;

pragma Elaborate_All (JWX.JSON);

package body Examples
   with SPARK_Mode
is
   procedure Areas (Data   : String;
                    Valid  : out Boolean;
                    Result : out Float)
   is
      package C is new JWX.JSON ("foo");
      use C; 
   begin
      null;
   end Areas;

end Examples;
