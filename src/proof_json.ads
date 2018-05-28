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

with JWX.JSON;

package Proof_JSON
is
   package P is new JWX.JSON (100);
   procedure Do_Parse (Data  : String;
                       Match : out P.Match_Type)
   with
      Pre => Data'First <= Data'Last;

end Proof_JSON;
