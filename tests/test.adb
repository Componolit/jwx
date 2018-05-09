with JWX_Suite;
with AUnit.Run;
with AUnit.Reporter.Text;

procedure Test is
   procedure Run is new AUnit.Run.Test_Runner (JWX_Suite.Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Run (Reporter);
end Test;
