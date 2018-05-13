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

package JWX.Base64
    with SPARK_Mode
is

   type Byte is mod 2**8
      with Size => 8;

   type Byte_Array is array (Natural range <>) of Byte
      with Pack;

   procedure Decode
       (Encoded :        String;
        Length  :    out Natural;
        Result  : in out Byte_Array)
   with
      Pre => Encoded'Length >= 4 and
             Encoded'Length mod 4 = 0 and
             Result'Length >= 3*(Encoded'Length/4);
   -- Decode Base64 encoded string into byte array

end JWX.Base64;