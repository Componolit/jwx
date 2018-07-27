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
   Key_Data       : JWX.Data_Type;
   Audience       : JWX.Data_Type;
   Issuer         : JWX.Data_Type;
package JWX.Stream_Auth
is
   type Auth_Result_Type is (Auth_OK, Auth_Noent, Auth_Fail, Auth_Invalid);

   function Authenticated (Buf : JWX.Data_Type;
                           Now : Long_Integer) return Auth_Result_Type
   with
      Pre => Buf'First >= JWX.Data_Index'First and
             Buf'Last <= JWX.Data_Index'Last and
             Buf'Last < Natural'Last - 9 and
             Buf'Length > 9;

end JWX.Stream_Auth;
