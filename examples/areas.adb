with JWX.JSON;
with Ada.Text_IO; use Ada.Text_IO;

pragma Elaborate_All (JWX.JSON);

package body Areas is
   procedure Areas (Data   : in out String;
                    Valid  : out Boolean;
                    Result : out JWX.Real_Type)
   is
      package C is new JWX.JSON (Data);
      use C;
      use type JWX.Real_Type;

      Match   : Match_Type;
      Element : Index_Type;
      Area    : Index_Type;
   begin
      Result := 0.0;
      Valid := False;

      Parse (Match);
      if Match /= Match_OK or else
         Get_Kind /= Kind_Array
      then
         return;
      end if;

      for I in 1 .. Length
      loop
         Element  := Pos (I);
         Area := Query_Object ("area", Element);
         Result := Result + Get_Real (Area);
      end loop;

      Valid := True;
   end Areas;

end Areas;
