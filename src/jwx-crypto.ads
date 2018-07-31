--
-- \brief  Validate JWT
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic
   Payload : String;
   Auth    : String;
   Key     : String;
package JWX.Crypto
is

   --  Validate authenticator using algorithm @Alg@
   procedure Valid (Alg   : Alg_Type;
                    Valid : out Boolean)
   with
      Pre => Key'First >= 0 and
             Key'Last < Natural'Last and
             Key'First <= Key'Last;

end JWX.Crypto;
