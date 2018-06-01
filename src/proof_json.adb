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
   procedure Do_Parse (Data  : String;
                       Match : out Boolean)
   is
      package P is new JWX.JSON (Data);
      M : P.Match_Type;
      use type P.Match_Type;
   begin
      P.Parse (M);
      Match := M = P.Match_OK;
   end Do_Parse;
end Proof_JSON;
