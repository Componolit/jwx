--
--  @author Alexander Senier
--  @date   2018-06-08
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

--  @summary JWT validation (RFC 7519)
package JWX.JWT
with
   SPARK_Mode
is

   type Result_Type is (Result_Invalid,
                        Result_Invalid_Key,
                        Result_OK,
                        Result_Fail,
                        Result_Invalid_Base64,
                        Result_Invalid_Object,
                        Result_Invalid_Audience,
                        Result_Invalid_Issuer,
                        Result_Expired);
   --  Result of JWT validation
   --  @value Result_Invalid           Input data is no valid JWT
   --  @value Result_Invalid_Key       The key data is no valid JWK
   --  @value Result_OK                Validation succeeded
   --  @value Result_Fail              Validation failed
   --  @value Result_Invalid_Base64    Base64 decoding failed for JWT
   --  @value Result_Invalid_Object    Structure of the JWT was invalid
   --  @value Result_Invalid_Audience  Audience encoded in JWT did not match
   --  @value Result_Invalid_Issuer    Issuer encoded in JWT did not match
   --  @value Result_Expired           The JWT expired

   function Validate_Compact (Data     : String;
                              Key_Data : String;
                              Audience : String;
                              Issuer   : String;
                              Now      : Long_Integer) return Result_Type
   with
      Pre => Data'Length >= 5 and
             Key_Data'First >= 0 and
             Key_Data'Last < Natural'Last and
             Key_Data'First <= Key_Data'Last;
   --  Validate a JWT in compact serialization
   --
   --  @param Data      The JWT to validate
   --  @param Key_Data  The JWK to use for validation
   --  @param Audience  Audience to match with JWT
   --  @param Issuer    Issuer to match with JWT
   --  @param Now       Time against which to match JWT expiration time

end JWX.JWT;
