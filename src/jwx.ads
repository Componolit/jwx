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

   type Alg_Type is (Alg_Invalid,
                     Alg_None,
                     Alg_HS256,
                     Alg_HS384,
                     Alg_HS512,
                     Alg_RS256,
                     Alg_RS384,
                     Alg_RS512,
                     Alg_ES256,
                     Alg_ES384,
                     Alg_ES512,
                     Alg_PS256,
                     Alg_PS384,
                     Alg_PS512);

   -- Convert a algorithm string to Alg_Type
   function Algorithm (Alg_String : String) return Alg_Type;

end JWX;
