generic
   Payload : String;
   Auth    : String;
   Key     : String;
package JWX.Crypto
is

   --  Validate authenticator using algorithm @Alg@
   function Valid (Alg : Alg_Type) return Boolean;

end JWX.Crypto;
