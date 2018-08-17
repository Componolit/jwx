with JWX;
with Areas;
with Ada.Text_IO; use Ada.Text_IO;
with JWX_Test_Utils; use JWX_Test_Utils;

procedure Area is
   Area  : JWX.Real_Type;
   Valid : Boolean;
   Data  : String := Read_File ("tests/data/countries.json");
begin   
   Areas.Areas (Data, Valid, Area);
   if Valid
   then
      Put_Line ("Area of all countries: " & Area'Img);
   else
      Put_Line ("Error");
   end if;
   
end Area;
