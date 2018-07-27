--
-- \brief  JWS compact serialization (RFC 7515, 7.1)
-- \author Alexander Senier
-- \date   2018-05-20
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

generic
   Data : JWX.Data_Type;
package JWX.JWSCS
is
   -- Is the token valid
   function Valid return Boolean;

   -- Length of JOSE header
   function JOSE_Length return Natural
   with
      Pre => Valid;

   -- Raw data of JOSE header
   function JOSE_Data return JWX.Data_Type
   with
      Pre => Valid;

   -- Encoded payload
   function Payload return JWX.Data_Type
   with
      Pre => Valid;

   -- Encoded signature input (JOSE header + '.' + payload)
   function Signature_Input return JWX.Data_Type
   with
      Pre => Valid;

   -- Encoded signature
   function Signature return JWX.Data_Type
   with
      Pre => Valid;

end JWX.JWSCS;
