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

   type Padding_Kind is (Padding_Implicit, Padding_Explicit);

   procedure Decode
       (Encoded :        String;
        Length  :    out Natural;
        Result  : in out JWX.Byte_Array;
        Padding :        Padding_Kind := Padding_Explicit);
   -- Decode Base64 encoded string into byte array

   procedure Decode_Url
       (Encoded :        String;
        Length  :    out Natural;
        Result  : in out JWX.Byte_Array;
        Padding :        Padding_Kind := Padding_Explicit);
   -- Decode Base64URL encoded string into byte array

end JWX.Base64;
