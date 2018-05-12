package body JWX.Base64
    with SPARK_Mode
is

   type UInt6 is mod 2**6
      with Size => 6;

   function Alpha_To_Value (Alpha : Character) return Natural is
      (case Alpha is
         when 'A' =>  0, when 'B' =>  1, when 'C' =>  2, when 'D' =>  3,
         when 'E' =>  4, when 'F' =>  5, when 'G' =>  6, when 'H' =>  7,
         when 'I' =>  8, when 'J' =>  9, when 'K' => 10, when 'L' => 11,
         when 'M' => 12, when 'N' => 13, when 'O' => 14, when 'P' => 15,
         when 'Q' => 16, when 'R' => 17, when 'S' => 18, when 'T' => 19,
         when 'U' => 20, when 'V' => 21, when 'W' => 22, when 'X' => 23,
         when 'Y' => 24, when 'Z' => 25, when 'a' => 26, when 'b' => 27,
         when 'c' => 28, when 'd' => 29, when 'e' => 30, when 'f' => 31,
         when 'g' => 32, when 'h' => 33, when 'i' => 34, when 'j' => 35,
         when 'k' => 36, when 'l' => 37, when 'm' => 38, when 'n' => 39,
         when 'o' => 40, when 'p' => 41, when 'q' => 42, when 'r' => 43,
         when 's' => 44, when 't' => 45, when 'u' => 46, when 'v' => 47,
         when 'w' => 48, when 'x' => 49, when 'y' => 50, when 'z' => 51,
         when '0' => 52, when '1' => 53, when '2' => 54, when '3' => 55,
         when '4' => 56, when '5' => 57, when '6' => 58, when '7' => 59,
         when '8' => 60, when '9' => 61, when '+' => 62, when '/' => 63,
         when others => Natural'Last);

   function Is_Valid (Alpha : Character) return Boolean is
      (Alpha_To_Value (Alpha) <= 63);

   type Symbol_Type is array (UInt6) of Character;
   Value_To_Alpha : Symbol_Type :=
      ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
       'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
       'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
       'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
       'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
       'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
       'w', 'x', 'y', 'z', '0', '1', '2', '3',
       '4', '5', '6', '7', '8', '9', '+', '/');

   pragma Assert (for all I in UInt6 range  0.. 7 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range  8..15 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 16..23 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 24..31 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 32..39 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 40..47 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 48..55 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 range 56..63 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);
   pragma Assert (for all I in UInt6 => UInt6 (Alpha_To_Value (Value_To_Alpha (I))) = I);

   pragma Assert (for all I in Character range 'A'..'Z' => Value_To_Alpha (UInt6 (Alpha_To_Value (I))) = I);
   pragma Assert (for all I in Character range 'a'..'z' => Value_To_Alpha (UInt6 (Alpha_To_Value (I))) = I);
   pragma Assert (for all I in Character range '0'..'9' => Value_To_Alpha (UInt6 (Alpha_To_Value (I))) = I);
   pragma Assert (Value_To_Alpha (UInt6 (Alpha_To_Value ('+'))) = '+');
   pragma Assert (Value_To_Alpha (UInt6 (Alpha_To_Value ('/'))) = '/');

   type UInt6_Block is array (Natural range 1..4) of UInt6
      with Pack, Size => 24;

   subtype Byte_Array_Block is Byte_Array (1..3);

   ---------------
   -- Mask_Mult --
   ---------------

   function Mask_Mult (Data : UInt6;
                       Mask : Byte;
                       Mult : Byte) return Byte
   is
   begin
      return (Byte (Data) and Mask) * Mult;
   end Mask_Mult;

   --------------
   -- Mask_Div --
   --------------

   function Mask_Div (Data : UInt6;
                      Mask : Byte;
                      Div  : Byte) return Byte
   with
      Pre => Div > 0
   is
   begin
      return (Byte (Data) and Mask) / Div;
   end Mask_Div;

   --------------------
   -- UInt6_To_Bytes --
   --------------------

   function UInt6_To_Bytes (Data : UInt6_Block) return Byte_Array_Block
   is
   begin
      return
         (0 => Mask_Mult (Data (1), 16#3f#,  4) or Mask_Div (Data (2), 16#30#, 16),
          1 => Mask_Mult (Data (2), 16#0f#, 16) or Mask_Div (Data (3), 16#3C#,  4),
          2 => Mask_Mult (Data (3), 16#03#, 64) or Mask_Div (Data (4), 16#ff#,  1));
   end UInt6_To_Bytes;

   ------------
   -- Decode --
   ------------

   procedure Decode
     (Encoded :        String;
      Length  :    out Natural;
      Result  : in out Byte_Array)
   is
      B0, B1, B2, B3 : UInt6;
      Last_Input_Block_Offset  : constant Integer := Encoded'Length/4-1;
      Last_Output_Block_Start  : constant Integer := Result'First + (3 * Last_Input_Block_Offset);
      Num_Last_Block_Bytes     : Integer := 1;
      Last_Block               : Byte_Array_Block;
   begin
      Length := 0;

      -- Loop over all but the last block
      for I in Integer range 0 .. Last_Input_Block_Offset - 1
      loop
         if not Is_Valid (Encoded (Encoded'First + 4*I + 0)) or
            not Is_Valid (Encoded (Encoded'First + 4*I + 1)) or
            not Is_Valid (Encoded (Encoded'First + 4*I + 2)) or
            not Is_Valid (Encoded (Encoded'First + 4*I + 3))
         then
            return;
         end if;

         B0 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4*I + 0)));
         B1 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4*I + 1)));
         B2 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4*I + 2)));
         B3 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4*I + 3)));

         Result (Result'First+3*I .. Result'First+3*I+2) := UInt6_To_Bytes ((B0, B1, B2, B3));
      end loop;

      if not Is_Valid (Encoded (Encoded'Last - 3)) or
         not Is_Valid (Encoded (Encoded'Last - 2))
      then
         return;
      end if;

      B0 := UInt6 (Alpha_To_Value (Encoded (Encoded'Last - 3)));
      B1 := UInt6 (Alpha_To_Value (Encoded (Encoded'Last - 2)));

      if Encoded (Encoded'Last - 1) = '=' then
         B2 := 0;
      elsif Is_Valid (Encoded (Encoded'Last - 1)) then
         B2 := UInt6 (Alpha_To_Value ((Encoded (Encoded'Last - 1))));
         Num_Last_Block_Bytes := 2;
      else
         return;
      end if;

      if Encoded (Encoded'Last - 0) = '=' then
         B3 := 0;
      elsif Is_Valid (Encoded (Encoded'Last - 0)) then
         B3 := UInt6 (Alpha_To_Value ((Encoded (Encoded'Last - 0))));
         Num_Last_Block_Bytes := 3;
      else
         return;
      end if;

      pragma Assert (Num_Last_Block_Bytes < 4);
      pragma Assert (Result'Length >= 3);

      Last_Block := UInt6_To_Bytes ((B0, B1, B2, B3));

      -- Padding bits shall be 0
      if Num_Last_Block_Bytes < 3 and Last_Block (3) /= 0 then
         return;
      end if;

      -- Padding bits shall be 0
      if Num_Last_Block_Bytes < 2 and Last_Block (2) /= 0 then
         return;
      end if;

      Result (Last_Output_Block_Start .. Last_Output_Block_Start + (Num_Last_Block_Bytes - 1)) :=
         Last_Block (1 .. Num_Last_Block_Bytes);
      Length := (3 * Last_Input_Block_Offset) + Num_Last_Block_Bytes;
   end Decode;

end JWX.Base64;
