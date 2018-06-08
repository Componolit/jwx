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
   Buffer_Length  : Natural := 4096;
   Error_Response : String;
   Key_Data       : in out String;
   with procedure Upstream_Send (Data : String);
   with procedure Downstream_Send (Data : String);
package JWX.Stream_Auth
   with
      Abstract_State => (State, Auth),
      Initializes    => (State, Auth)
is
   -- Receive data from upstream
   procedure Upstream_Receive (Data : String)
   with
      Global => (Input => Auth);

   -- Receive data from downstream
   procedure Downstream_Receive (Data : String)
   with
      Global => (In_Out => State,
                 Output => Auth);

   -- Signal that downstream got closed
   procedure Downstream_Close
   with
      Global => (In_Out => State,
                 Output => Auth);

end JWX.Stream_Auth;
