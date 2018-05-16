--
-- \brief  JWX utility functions
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX;

package JWX.Util
   with
      SPARK_Mode
is
   procedure To_Byte_Array
      (Data   :        String;
       Result : in out JWX.Byte_Array);

   procedure To_String
      (Data   :        JWX.Byte_Array;
       Result : in out String);

end JWX.Util;
