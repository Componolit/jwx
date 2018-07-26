--
-- \brief  Helper package for proving generic JWX.Stream_Auth
-- \author Alexander Senier
-- \date   2018-06-07
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package body Proof_Stream_Auth
with
   SPARK_Mode
is
   procedure Test (OK : out Boolean)
   is
      package HA is new JWX.Stream_Auth
                           (Key_Data  => "Invalid key",
                            Audience  => "Invalid",
                            Issuer    => "Invalid");
      use HA;
   begin
      OK := Authenticated ("Invalid Message", 12345678) = Auth_OK;
   end Test;

end Proof_Stream_Auth;
