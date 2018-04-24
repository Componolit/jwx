package body Base64
    with SPARK_Mode
is

   ------------
   -- Encode --
   ------------

   function Encode (Raw : Byte_Array) return String is
   begin
        return "";
   end Encode;

   ------------
   -- Decode --
   ------------

   function Decode (Encoded : String) return Byte_Array is
   begin
        return (1,2,3);
   end Decode;

end Base64;
