generic
   Payload : String;
   Auth    : String;
   Key     : String;
package JWX.Crypto
is

   --  Validate authenticator using algorithm @Alg@
   procedure Valid (Alg   : Alg_Type;
                    Valid : out Boolean);

end JWX.Crypto;
