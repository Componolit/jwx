with LSC.Types;
with LSC.SHA256;

package JWX.LSC
with
   SPARK_Mode => On
is
   package SC renames Standard.LSC;

   --  Convert JWX byte array to LSC word32 array
   procedure JWX_Byte_Array_To_LSC_Word32_Array
      (Input  :     JWX.Byte_Array;
       Output : out SC.Types.Word32_Array_Type;
       Offset :     Natural := 0);

   --  Convert JWX byte array to LSC SHA256 message
   procedure JWX_Byte_Array_To_LSC_SHA256_Message
      (Input  :     JWX.Byte_Array;
       Output : out SC.SHA256.Message_Type);

end JWX.LSC;
