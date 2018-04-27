-- RFC4648 encoding and decoding

package Base64
    with SPARK_Mode
is

type Byte is mod 2**8
   with Size => 8;

type Byte_Array is array (Natural range <>) of Byte
   with Pack;

   procedure To_Byte_Array
      (Data   :        String;
       Result : in out Byte_Array)
   with
      Pre =>
         Data'Length > 0 and
         Result'Length >= Data'Length;
   -- Convert a String to a byte array

   procedure To_String
      (Data   :        Byte_Array;
       Result : in out String)
   with
      Pre =>
         Data'Length > 0 and
         Result'Length >= Data'Length;
   -- Convert a Byte_Array to a String

   procedure Encode
       (Raw    :        Byte_Array;
        Result : in out String);
   -- Encode raw byte array into Base64 string

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
