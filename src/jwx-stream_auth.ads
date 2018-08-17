--
-- @author Alexander Senier
-- @date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

-- @summary Stream authentication checking
--
-- @description
-- Given a key in the form of a JSON web key (JWK), an audience string and an
-- issuer string, the Authenticated procedure in this package searches an input
-- string for a JSON web token (JWT), decodes it and tries to validate it. The
-- JWT must be present as the URL parameter "id_token=".
generic
   Key_Data       : String;
   Audience       : String;
   Issuer         : String;
package JWX.Stream_Auth
is
   type Auth_Result_Type is (Auth_OK, Auth_Noent, Auth_Fail, Auth_Invalid);
   -- Authentication result
   --
   -- @value Auth_OK       Authentication succeeded
   -- @value Auth_Noent    No JSON web token found in input data
   -- @value Auth_Fail     JSON web token found, but authentication failed
   -- @value Auth_Invalid  Unspecified error during authentication

   function Authenticated (Buf : String;
                           Now : Long_Integer) return Auth_Result_Type
   with
      Pre => Buf'First >= JWX.Data_Index'First and
             Buf'Last <= JWX.Data_Index'Last and
             Buf'Last < Natural'Last - 9 and
             Buf'Length > 9;
   -- Check whether string contains valid authentication token
   --
   -- @param Buf  String buffer to validate
   -- @param Now  Current time as a UNIX Epoch (seconds since 1.1.1970)

end JWX.Stream_Auth;
