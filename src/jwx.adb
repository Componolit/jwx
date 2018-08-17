--
-- @summary Main package
-- @author  Alexander Senier
-- @date    2018-05-12
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package body JWX
is
   ---------------
   -- Algorithm --
   ---------------

   function Algorithm (Alg_String : String) return Alg_Type
   is
   begin
      if Alg_String = "none"
      then
         return Alg_None;
      elsif Alg_String = "HS256"
      then
         return Alg_HS256;
      elsif Alg_String = "HS384"
      then
         return Alg_HS384;
      elsif Alg_String = "HS512"
      then
         return Alg_HS512;
      elsif Alg_String = "RS256"
      then
         return Alg_RS256;
      elsif Alg_String = "RS384"
      then
         return Alg_RS384;
      elsif Alg_String = "RS512"
      then
         return Alg_RS512;
      elsif Alg_String = "ES256"
      then
         return Alg_ES256;
      elsif Alg_String = "ES384"
      then
         return Alg_ES384;
      elsif Alg_String = "ES512"
      then
         return Alg_ES512;
      elsif Alg_String = "PS256"
      then
         return Alg_PS256;
      elsif Alg_String = "PS384"
      then
         return Alg_PS384;
      elsif Alg_String = "PS512"
      then
         return Alg_PS512;
      else
         return Alg_Invalid;
      end if;
   end Algorithm;

end JWX;
