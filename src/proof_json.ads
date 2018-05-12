package body Proof_JSON
is
   procedure Do_Parse (Match : out P.Match_Type)
   is
   begin
      P.Parse (Match);
   end Do_Parse;
end Proof_JSON;
with JWX.JSON;

package Proof_JSON
is
   Data : constant String (1..100) := (others => 'x');
   package P is new JWX.JSON (Data);

   procedure Do_Parse (Match : out P.Match_Type);

end Proof_JSON;
