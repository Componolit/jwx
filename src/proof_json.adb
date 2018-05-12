--
-- \brief  Helper package for proving generic JWX.JSON
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package body Proof_JSON
is
   procedure Do_Parse (Match : out P.Match_Type)
   is
   begin
      P.Parse (Match);
   end Do_Parse;
end Proof_JSON;
