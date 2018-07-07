--
-- \brief  Test stream authentication checking
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic
   Key_Data       : String;
   Audience       : String;
   Issuer         : String;
package JWX.Stream_Auth
is
   type Auth_Result_Type is (Auth_OK, Auth_Noent, Auth_Fail, Auth_Invalid);

   function Authenticated (Buf : String;
                           Now : Long_Integer) return Auth_Result_Type;

end JWX.Stream_Auth;
