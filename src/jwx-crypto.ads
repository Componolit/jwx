generic
   Payload : String;
   Auth    : String;
   Key     : in out String;
package JWX.Crypto
with
   Abstract_State => State,
   Initializes    => State
is

   --  Validate authenticator using algorithm @Alg@
   procedure Valid (Alg   : Alg_Type;
                    Valid : out Boolean);

end JWX.Crypto;
