--
-- \brief  JWS validation (RFC 7515)
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package JWX.JWS
with
   SPARK_Mode
is

   type Result_Type is (Result_Invalid,
                        Result_Invalid_Key,
                        Result_OK,
                        Result_Fail);

   procedure Validate_Compact (Data     :        String;
                               Key_Data : in out String;
                               Result   :    out Result_Type)
   with
      Pre => Key_Data'First <= Key_Data'Last;

end JWX.JWS;
