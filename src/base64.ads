-- RFC4648 encoding and decoding
package Base64
with SPARK_Mode
is

type Byte is mod 2**8;
type Byte_Array is array (Natural range <>) of Byte;

   function Encode (Raw : Byte_Array) return String
    with
        Pre => False;
   -- Encode raw byte array into Base64 string

   function Decode (Encoded : String) return Byte_Array;
   -- Decode Base64 encoded string into byte array

end Base64;
