with JWX.BASE64; use JWX.BASE64;

package JWX_Test_Utils
is
   function Read_File (File_Name : String) return String;

   procedure To_Byte_Array
      (Data   :        String;
       Result : in out Byte_Array);

   procedure To_String
      (Data   :        Byte_Array;
       Result : in out String);

end JWX_Test_Utils;
