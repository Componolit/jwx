--
-- @author Alexander Senier
-- @date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX;

-- @summary JOSE header decoding (RFC 7515, section 4)
generic
   Data : String;
package JWX.JOSE
is
   -- Valid JOSE header
   function Valid return Boolean;

   -- Algorithm defined in JOSE header
   function Algorithm return JWX.Alg_Type
   with
      Pre => Valid;

end JWX.JOSE;
