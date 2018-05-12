--
-- \brief  JWX test runner
-- \author Alexander Senier
-- \date   2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX_Suite;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Test is
   procedure Run is new AUnit.Run.Test_Runner (JWX_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run (Reporter);
end Test;
