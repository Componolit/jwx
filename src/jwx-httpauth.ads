--
-- \brief  HTTP authentication checking
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic
   Buffer_Length  : Natural := 4096;
   Error_Response : String;
   Key_Data       : String;
   with procedure Upstream_Send (Data : String);
   with procedure Downstream_Send (Data : String);
package JWX.HTTPAuth
is
   -- Receive data from downstream
   procedure Upstream_Receive (Data : String);

   -- Receive data from upstream
   procedure Downstream_Receive (Data : String);

end JWX.HTTPAuth;
