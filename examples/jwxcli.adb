with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line;
with Ada.Text_IO.Text_Streams;
with Ada.Directories;
with JWX.JSON;

procedure JWXCLI is
   type String_Ptr is access all String;

   function Read_File (Name : String) return String_Ptr
   is
      Block_Size : constant := 1024;
      use Ada.Text_IO.Text_Streams;
      File_Size : Natural := Natural (Ada.Directories.Size (Name));
      Result : String_Ptr := new String (1 .. File_Size);
      File : File_Type;
      Len  : Natural;
      Off  : Natural := 1;
   begin
      Open (File, In_File, Name);
      loop
         Len := (if File_Size - Off > Block_Size then Block_Size else File_Size - Off + 1);
         String'Read (Stream (File), Result.all (Off .. Off + Len - 1));
         Off := Off + Len;
         exit when Off >= File_Size;
      end loop;
      Close (File);
      return Result;
   end Read_File;

   Input : access String := Read_File (Ada.Command_Line.Argument (1));
   package J is new JWX.JSON (Input.all);
   use J;
   Match : Match_Type;
begin
   Parse (Match);
   if Match = Match_OK
   then
      Ada.Command_Line.Set_Exit_Status (0);
   else
      Ada.Command_Line.Set_Exit_Status (1);
   end if;
end JWXCLI;
