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

generic
   Data     : JWX.Data_Type;
   Key_Data : JWX.Data_Type;
   Audience : JWX.Data_Type;
   Issuer   : JWX.Data_Type;
   Now      : Long_Integer;
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

   -- Return result
   function Result return Result_Type;

end JWX.JWT;
