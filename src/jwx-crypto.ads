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
   Key     : in out String;
package JWX.Crypto
with
   Abstract_State => State,
   Initializes    => State
is

   --  Validate authenticator using algorithm @Alg@
   procedure Valid (Alg   : Alg_Type;
                    Valid : out Boolean);

end JWX.Crypto;
