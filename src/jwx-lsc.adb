with JWX;

package body JWX.LSC
with
   SPARK_Mode => On
is
   ----------------------------------------
   -- JWX_Byte_Array_To_LSC_Word32_Array --
   ----------------------------------------

   procedure JWX_Byte_Array_To_LSC_Word32_Array
      (Input  :     JWX.Byte_Array;
       Output : out SC.Types.Word32_Array_Type;
       Offset :     Natural := 0)
   is
      use SC;
      use SC.Types;
      Value : Byte_Array32_Type;
   begin
      Output := (others => 0);
      for O in Output'Range
      loop
         Value := (others => 0);
         for J in Value'Range
         loop
            declare
               Pos : constant Integer :=
                  Input'First + Offset +
                  Integer ((O - Output'First)) * Value'Length +
                  Integer ((J - Value'First));
            begin
               Value (J) := Types.Byte ((if Pos in Input'Range then Input (Pos) else 0));
            end;
            Output (O) := Byte_Array32_To_Word32 (Value);
         end loop;
      end loop;
   end JWX_Byte_Array_To_LSC_Word32_Array;

   ------------------------------------------
   -- JWX_Byte_Array_To_LSC_SHA256_Message --
   ------------------------------------------

   procedure JWX_Byte_Array_To_LSC_SHA256_Message
      (Input  :     JWX.Byte_Array;
       Output : out SC.SHA256.Message_Type)
   is
      use SC;
      use SC.Types;
      use SC.SHA256;
   begin
      Output := (others => (others => 0));
      for O in Output'Range
      loop
         JWX_Byte_Array_To_LSC_Word32_Array
            (Input  => Input,
             Output => Output (O),
             Offset => 64 * Integer (O - Output'First));
      end loop;
   end JWX_Byte_Array_To_LSC_SHA256_Message;

end JWX.LSC;
