--
-- \brief  JWT validation (RFC 7519)
-- \author Alexander Senier
-- \date   2018-06-08
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package JWX.JWT
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

end JWX.JWT;
