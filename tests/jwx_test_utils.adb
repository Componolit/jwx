with Ada.Direct_IO;
with Ada.Directories;

package body JWX_Test_Utils
is
   ---------------
   -- Read_File --
   ---------------

   function Read_File (File_Name : String) return String
   is
      File_Size : Natural := Natural (Ada.Directories.Size (File_Name));
      subtype File_String is String (1 .. File_Size);
      package File_String_IO is new Ada.Direct_IO (File_String);

      File     : File_String_IO.File_Type;
      Contents : File_String;
   begin
      File_String_IO.Open (File, File_String_IO.In_File, File_Name);
      File_String_IO.Read (File, Contents);
      File_String_IO.Close (File);
      return Contents;
   end Read_File;

   -------------------
   -- To_Byte_Array --
   -------------------

   procedure To_Byte_Array
      (Data   :        String;
       Result : in out JWX.Byte_Array)
   is
   begin
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Pos (Data (Data'First + I));
      end loop;
   end To_Byte_Array;

   ---------------
   -- To_String --
   ---------------

   procedure To_String
      (Data   :        JWX.Byte_Array;
       Result : in out String)
   is
   begin
      for I in 0 .. Data'Length - 1
      loop
         Result (Result'First + I) := Character'Val (Data (Data'First + I));
      end loop;
   end To_String;

end JWX_Test_Utils;
