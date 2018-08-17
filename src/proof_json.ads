--
-- @author Alexander Senier
-- @date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX.JSON;

-- @private
-- @summary Helper package for proving generic JWX.JSON
package Proof_JSON
is
   procedure Do_Parse (Data  :     String;
                       Match : out Boolean)
   with
       Pre => Data'First >= 0 and
              Data'Last < Natural'Last and
              Data'First <= Data'Last;
   -- @private
   -- @param Data  Input data
   -- @param Match Result

end Proof_JSON;
