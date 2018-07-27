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

generic
   Data     : JWX.Data_Type;
   Key_Data : JWX.Data_Type;
package JWX.JWS
is

   type Result_Type is (Result_Invalid,
                        Result_Invalid_Key,
                        Result_OK,
                        Result_Fail);

   -- Valid
   function Valid return Boolean;

   -- Validate signature
   procedure Validate_Compact (Result : out Result_Type)
   with
      Pre => Key_Data'First <= Key_Data'Last,
      Post => (if Result = Result_OK then Valid);

   -- Return payload
   function Payload return String
   with
      Pre => Valid;

end JWX.JWS;
