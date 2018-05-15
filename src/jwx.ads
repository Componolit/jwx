--
-- \brief  Main package
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package JWX
is
   type UInt6 is mod 2**6
      with Size => 6;

   type Byte is mod 2**8
      with Size => 8;

   type Byte_Array is array (Natural range <>) of Byte
      with Pack;
end JWX;
