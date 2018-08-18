--
--  @summary BASE64 decoding (RFC4648)
--  @author  Alexander Senier
--  @date    2018-05-12
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package body JWX.Base64
    with SPARK_Mode
is

   function Alpha_To_Value_Default (Alpha : Character) return Natural is
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

   function Is_Valid_Default (Alpha : Character) return Boolean is
      (Alpha_To_Value_Default (Alpha) <= 63);

   function Alpha_To_Value_Url (Alpha : Character) return Natural is
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
         when '8' => 60, when '9' => 61, when '-' => 62, when '_' => 63,
         when others => Natural'Last);

   function Is_Valid_Url (Alpha : Character) return Boolean is
      (Alpha_To_Value_Url (Alpha) <= 63);

   type UInt6_Block is array (Natural range 1 .. 4) of UInt6
      with Pack, Size => 24;

   subtype Byte_Array_Block is JWX.Byte_Array (1 .. 3);

   ---------------
   -- Mask_Mult --
   ---------------

   function Mask_Mult (Data : UInt6;
                       Mask : Byte;
                       Mult : Byte) return Byte;
   --  Multiply and mask

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
      Pre => Div > 0;
   --  Multiply and divide

   function Mask_Div (Data : UInt6;
                      Mask : Byte;
                      Div  : Byte) return Byte
   is
   begin
      return (Byte (Data) and Mask) / Div;
   end Mask_Div;

   --------------------
   -- UInt6_To_Bytes --
   --------------------

   function UInt6_To_Bytes (Data : UInt6_Block) return Byte_Array_Block;
   --  Convert a block of 4 six byte numbers into a block of 3 eight byte
   --  numbers

   function UInt6_To_Bytes (Data : UInt6_Block) return Byte_Array_Block
   is
   begin
      return
         (0 => Mask_Mult (Data (1), 16#3f#,  4) or Mask_Div (Data (2), 16#30#, 16),
          1 => Mask_Mult (Data (2), 16#0f#, 16) or Mask_Div (Data (3), 16#3C#,  4),
          2 => Mask_Mult (Data (3), 16#03#, 64) or Mask_Div (Data (4), 16#ff#,  1));
   end UInt6_To_Bytes;

   ----------------
   -- Decode_Gen --
   ----------------

   generic
      with function Alpha_To_Value (Alpha : Character) return Natural;
      with function Is_Valid (Alpha : Character) return Boolean;
   procedure Decode_Gen
     (Encoded : String;
      Len     : out Natural;
      Result  : out JWX.Byte_Array)
   with
      Pre =>
           ((Encoded'Length > 0
         and Encoded'Length < Natural'Last / 9
         and Encoded'Last < Natural'Last - 4
         and Result'Length >= 3 * ((Encoded'Length + 3) / 4)))
         and then Result'First < Natural'Last - 9 * Encoded'Length / 12 - 3,
      Post => Len <= Result'Length;

   procedure Decode_Gen
     (Encoded : String;
      Len     : out Natural;
      Result  : out JWX.Byte_Array)
   is
      B0, B1, B2, B3 : UInt6;
      B0_Pos, B1_Pos, B2_Pos, B3_Pos : Natural;

      Last_Input_Block_Offset  : constant Integer := (Encoded'Length + 3) / 4 - 1;
      Last_Output_Block_Start  : constant Integer := Result'First + (3 * Last_Input_Block_Offset);
      Num_Last_Block_Bytes     : constant Integer := (Encoded'Length - 1) mod 4 + 1;
      Num_Last_Block_Out_Bytes : Integer;
      Last_Block               : Byte_Array_Block;
   begin
      Len := 0;
      Result := (others => 0);

      --  Loop over all but the last block
      for I in Integer range 0 .. Last_Input_Block_Offset - 1
      loop
         if not Is_Valid (Encoded (Encoded'First + 4 * I + 0)) or
            not Is_Valid (Encoded (Encoded'First + 4 * I + 1)) or
            not Is_Valid (Encoded (Encoded'First + 4 * I + 2)) or
            not Is_Valid (Encoded (Encoded'First + 4 * I + 3))
         then
            return;
         end if;

         B0 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4 * I + 0)));
         B1 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4 * I + 1)));
         B2 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4 * I + 2)));
         B3 := UInt6 (Alpha_To_Value (Encoded (Encoded'First + 4 * I + 3)));

         Result (Result'First + 3 * I .. Result'First + 3 * I + 2) :=
           UInt6_To_Bytes ((B0, B1, B2, B3));
      end loop;

      if Num_Last_Block_Bytes < 2
      then
         return;
      end if;

      pragma Assert (Num_Last_Block_Bytes < 5);
      pragma Assert (Encoded'Last < Natural'Last - 4);

      B0_Pos := Encoded'Last - Num_Last_Block_Bytes + 1;
      B1_Pos := Encoded'Last - Num_Last_Block_Bytes + 2;
      B2_Pos := Encoded'Last - Num_Last_Block_Bytes + 3;
      B3_Pos := Encoded'Last - Num_Last_Block_Bytes + 4;

      pragma Assert (B1_Pos in Encoded'Range);

      if not Is_Valid (Encoded (B0_Pos)) or
         not Is_Valid (Encoded (B1_Pos))
      then
         return;
      end if;

      Num_Last_Block_Out_Bytes := 1;
      B0 := UInt6 (Alpha_To_Value (Encoded (B0_Pos)));
      B1 := UInt6 (Alpha_To_Value (Encoded (B1_Pos)));
      B2 := 0;
      B3 := 0;

      if Num_Last_Block_Bytes > 2
      then
         if Is_Valid (Encoded (B2_Pos))
         then
            Num_Last_Block_Out_Bytes := 2;
            B2 := UInt6 (Alpha_To_Value ((Encoded (B2_Pos))));
         elsif Encoded (B2_Pos) /= '='
         then
            return;
         end if;
      end if;

      if Num_Last_Block_Bytes > 3
      then
         if Is_Valid (Encoded (B3_Pos))
         then
            Num_Last_Block_Out_Bytes := 3;
            B3 := UInt6 (Alpha_To_Value ((Encoded (B3_Pos))));
         elsif Encoded (B3_Pos) /= '='
         then
            return;
         end if;
      end if;

      Last_Block := UInt6_To_Bytes ((B0, B1, B2, B3));

      --  Padding bits shall be 0
      if Num_Last_Block_Out_Bytes < 3 and Last_Block (3) /= 0 then
         return;
      end if;

      --  Padding bits shall be 0
      if Num_Last_Block_Out_Bytes < 2 and Last_Block (2) /= 0 then
         return;
      end if;

      Result (Last_Output_Block_Start .. Last_Output_Block_Start + (Num_Last_Block_Out_Bytes - 1)) :=
         Last_Block (1 .. Num_Last_Block_Out_Bytes);
      Len := (3 * Last_Input_Block_Offset) + Num_Last_Block_Out_Bytes;
   end Decode_Gen;

   ------------
   -- Decode --
   ------------

   procedure Decode_Default_Inst is new Decode_Gen (Alpha_To_Value_Default, Is_Valid_Default);

   procedure Decode
     (Encoded : String;
      Len     : out Natural;
      Result  : out JWX.Byte_Array) renames Decode_Default_Inst;

   ----------------
   -- Decode_Url --
   ----------------

   procedure Decode_Url_Inst is new Decode_Gen (Alpha_To_Value_Url, Is_Valid_Url);

   procedure Decode_Url
     (Encoded :        String;
      Len     :    out Natural;
      Result  :    out JWX.Byte_Array) renames Decode_Url_Inst;

end JWX.Base64;
