with Examples;
with Ada.Text_IO; use Ada.Text_IO;
with JWX_Test_Utils; use JWX_Test_Utils;

procedure Example
is
   Area  : Float;
   Valid : Boolean;
begin   
   Examples.Areas (Read_File ("tests/data/countries.json"), Valid, Area);
   if Valid
   then
      Put_Line ("Area of all countries: " & Area'Img);
   else
      Put_Line ("Error");
   end if;
   
end Example;
