--
-- \brief  JWX test helper functions
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

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
