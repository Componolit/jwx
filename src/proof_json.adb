package body Proof_JSON
is
   procedure Do_Parse (Match : out P.Match_Type)
   is
   begin
      P.Parse (Match);
   end Do_Parse;
end Proof_JSON;
