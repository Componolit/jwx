with JSON;

package Proof_JSON
is
   Data : String (1..100) := (others => 'x');
   package P is new JSON (Data);
end Proof_JSON;
