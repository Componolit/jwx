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
        Result  :    out JWX.Byte_Array);
   -- Decode Base64 encoded string into byte array

   procedure Decode_Url
       (Encoded :        String;
        Length  :    out Natural;
        Result  :    out JWX.Byte_Array);
   -- Decode Base64URL encoded string into byte array

end JWX.Base64;
