-- RFC4648 encoding and decoding

package Base64
    with SPARK_Mode
is

type Byte is mod 2**8
   with Size => 8;

type Byte_Array is array (Natural range <>) of Byte
   with Pack;

   procedure Decode
       (Encoded :        String;
        Length  :    out Natural;
        Result  : in out Byte_Array)
   with
      Pre => Encoded'Length >= 4 and
             Encoded'Length mod 4 = 0 and
             Result'Length >= 3*(Encoded'Length/4);
   -- Decode Base64 encoded string into byte array

end Base64;
