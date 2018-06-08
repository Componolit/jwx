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
      procedure Dump (Data : String)
      is
      begin
         OK := (if Data = "foo" then True else False);
      end Dump;

      Invalid_Key : String := "Invalid key";

      package HA is new JWX.Stream_Auth
                           (Error_Response  => "Error",
                            Key_Data        => Invalid_Key,
                            Upstream_Send   => Dump,
                            Downstream_Send => Dump);
   begin
      OK := False;
      HA.Upstream_Receive ("Message");
   end Test;

end Proof_Stream_Auth;
