with JWX;

generic
   Data : String;
package JWX.JOSE
is
   -- Valid JOSE header
   function Valid return Boolean;

   -- Algorithm defined in JOSE header
   function Algorithm return JWX.Alg_Type
   with
      Pre => Valid; 

end JWX.JOSE;
