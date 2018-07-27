--
-- \brief  BASE64 decoding (RFC4648)
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX;

package JWX.Base64
    with SPARK_Mode
is

   procedure Decode
     (Encoded :        String;
      Length  :    out Natural;
      Result  :    out JWX.Byte_Array)
   with
     Pre =>
          ((Encoded'Length > 0
        and Encoded'Length < Natural'Last / 9
        and Encoded'Last < Natural'Last - 4
        and Result'Length >= 3 * ((Encoded'Length + 3) / 4)))
        and then Result'First < Natural'Last - 9 * Encoded'Length / 12 - 3,
     Post => Length <= Result'Length;
   -- Decode Base64 encoded string into byte array

   procedure Decode_Url
     (Encoded :        String;
      Length  :    out Natural;
      Result  :    out JWX.Byte_Array)
   with
      Pre =>
         ((Encoded'Length > 0
         and Encoded'Length < Natural'Last / 9
         and Encoded'Last < Natural'Last - 4
         and Result'Length >= 3 * ((Encoded'Length + 3) / 4)))
         and then Result'First < Natural'Last - 9 * Encoded'Length / 12 - 3,
      Post => Length <= Result'Length;
   -- Decode Base64URL encoded string into byte array

end JWX.Base64;
