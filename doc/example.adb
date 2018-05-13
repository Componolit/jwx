with Examples;
with Ada.Text_IO; use Ada.Text_IO;

procedure Example
is
   Area  : Float;
   Valid : Boolean;
begin   
   Examples.Areas ("tests/data/countries.json", Valid, Area);
   if Valid
   then
      Put_Line ("Area of all countries: " & Area'Img);
   else
      Put_Line ("Error");
   end if;
   
end Example;
