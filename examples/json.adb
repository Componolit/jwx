with Ada.Text_IO; use Ada.Text_IO;
with JWX.JSON;

procedure JSON is
   Data : String := " { ""precision"": ""zip"", ""Latitude"":  37.7668, ""Longitude"": -122.3959, ""Address"": """", ""City"": ""SAN FRANCISCO"", ""State"": ""CA"", ""Zip"": ""94107"", ""Country"": ""US"" }";
   package J is new JWX.JSON (Data);
   use J;
   Result : Index_Type;
   Match : Match_Type;
begin
   Parse (Match);
   if Match = Match_OK and then Get_Kind = Kind_Object
   then
      Result := Query_Object ("City");
      Put_Line ("City: " & Get_String (Result)); -- "SAN FRANCISCO"

      Result := Query_Object ("Latitude");
      Put_Line ("Lat.: " & Get_Float (Result)'Img); -- 37.7668
   end if;
end JSON;
