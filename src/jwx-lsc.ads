with LSC.Types;
with LSC.SHA256;

use type LSC.SHA256.Message_Index;

package JWX.LSC
with
   SPARK_Mode => On
is
   package SC renames Standard.LSC;

   --  Convert JWX byte array to LSC word32 array
   procedure JWX_Byte_Array_To_LSC_Word32_Array
      (Input  :     JWX.Byte_Array;
       Output : out SC.Types.Word32_Array_Type;
       Offset :     Natural := 0)
   with
      Pre => Input'First < Integer'Last - Offset - 4 * Output'Length;

   --  Convert JWX byte array to LSC SHA256 message
   procedure JWX_Byte_Array_To_LSC_SHA256_Message
      (Input  :     JWX.Byte_Array;
       Output : out SC.SHA256.Message_Type)
   with
      Pre => ((Input'Length > 0 and
              Output'Last > Output'First and
              Output'Length <= SC.SHA256.Message_Index (Integer'Last) / 64) and then
              Input'First < Integer'Last - 64 * Integer (Output'Last - Output'First) - 4 * Output'Length);

end JWX.LSC;
