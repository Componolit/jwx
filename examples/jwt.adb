with Ada.Text_IO; use Ada.Text_IO;
with JWX.JWT;
with JWX_Test_Utils;

procedure JWT is
   Tmp  : String := JWX_Test_Utils.Read_File ("tests/data/JWT_test_data.dat");
   Key  : String := JWX_Test_Utils.Read_File ("tests/data/HTTP_auth_key.json");
   Data : String := Tmp (Tmp'First .. Tmp'Last - 1);

   package J is new JWX.JWT (Data     => Data,
                             Key_Data => Key,
                             Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                             Issuer   => "https://cmpnlt-demo.eu.auth0.com/",
                             Now      => 1528404620);
   use J;
   Result : Result_Type;
begin
   Validate_Compact (Result => Result);
   if Result = Result_OK then
      Put_Line ("Token is valid");
   end if;
end JWT;
