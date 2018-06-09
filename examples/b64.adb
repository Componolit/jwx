with Ada.Text_IO; use Ada.Text_IO;
with JWX.Util;
with JWX.Base64;

procedure B64 is
   use JWX;
   Len    : Natural;
   Bytes  : Byte_Array (1..50);
   Result : String (1..50);
begin
   Base64.Decode (Encoded => "Zm9vYmFy", Length => Len, Result => Bytes);
   if Len > 0 then
      Util.To_String (Bytes, Result);
      Put_Line (Result (1 .. Len)); -- "foobar"
   end if;
end B64;
