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
   Data     : String;
   Key_Data : String;
   Audience : String;
   Issuer   : String;
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

   procedure Validate_Compact (Result : out Result_Type)
   with
      Pre => Key_Data'First <= Key_Data'Last;

end JWX.JWT;
