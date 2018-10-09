--
--  @author Alexander Senier
--  @date   2018-06-06
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

--  @summary Cryptographic validation of JWT payload.
generic
   Payload : String;
   Auth    : String;
   Key     : String;
package JWX.Crypto
is

   procedure Valid (Alg           : Alg_Type;
                    Valid_Payload : out Boolean)
   with
      Pre => Key'First >= 0 and
             Key'Last < Natural'Last and
             Key'First <= Key'Last,
      Global => (Payload, Auth, Key);
   --  Validate authenticator
   --
   --  @param Alg            Algorithm to use
   --  @param Valid_Payload  Validation result

end JWX.Crypto;
