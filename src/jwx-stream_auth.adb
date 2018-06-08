--
-- \brief  Text stream authentication checking
-- \author Alexander Senier
-- \date   2018-06-07
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX.JWS;

package body JWX.Stream_Auth
   with
      Refined_State => (State => (Buf, Off),
                        Auth => (Authenticated))
is
   type Auth_Result_Type is (Auth_OK, Auth_Noent, Auth_Fail, Auth_Invalid);

   Authenticated : Auth_Result_Type := Auth_Invalid;
   Buf           : String (1 .. Buffer_Length) := (others => ' ');
   Off           : Natural := 0;

   -------------------------
   -- Check_Authentication --
   -------------------------

   procedure Check_Authentication
   is
      use JWX;
      First : Natural := Buf'Last;
      Last  : Natural := Buf'First;
      Auth_Result : JWS.Result_Type;
   begin
      Authenticated := Auth_Noent;

      -- At least space for 'id_token=' must be available
      if Off < 10
      then
         return;
      end if;

      -- Search ID token
      for I in Buf'First .. Buf'First + Off
      loop
         if Buf (I .. I + 8) = "id_token="
         then
            First := I + 9;
         end if;
      end loop;

      -- Search end of ID token (next ampersand)
      for I in First .. Buf'Last
      loop
         if Buf (I) = '&'
         then
            Last          := I - 1;
            Authenticated := Auth_Fail;
         end if;
      end loop;

      if Authenticated = Auth_Noent
      then
         return;
      end if;

      JWS.Validate_Compact
         (Data     => Buf (First .. Last),
          Key_Data => Key_Data,
          Result   => Auth_Result);

      case Auth_Result
      is
         when JWS.Result_Invalid
            | JWS.Result_Invalid_Key => Authenticated := Auth_Invalid;
         when JWS.Result_Fail        => Authenticated := Auth_Fail;
         when JWS.Result_OK          => Authenticated := Auth_OK;
      end case;

   end Check_Authentication;

   ----------------------
   -- Upstream_Receive --
   ----------------------

   procedure Upstream_Receive (Data : String)
   is
   begin
      if Authenticated /= Auth_OK
      then
         return;
      end if;

      Downstream_Send (Data);
   end Upstream_Receive;

   -----------
   -- Reset --
   -----------

   procedure Reset
   is
   begin
      Buf := (others => ' ');
      Off := 0;
   end Reset;

   ------------------------
   -- Downstream_Receive --
   ------------------------

   procedure Downstream_Receive (Data : String)
   is
   begin
      -- Reset state if we receive data and are already Authenticated
      if Authenticated = Auth_OK
      then
         Authenticated := Auth_Invalid;
         Reset;
      end if;

      if Buf'First > Buf'Last - Off - Data'Length
      then
         return;
      end if;

      Buf (Buf'First + Off .. Buf'First + Off + Data'Length - 1) := Data;
      Off := Off + Data'Length;

      Check_Authentication;
      case Authenticated
      is
         when Auth_OK =>
            Upstream_Send (Buf (Buf'First .. Buf'First + Off - 1));
            Reset;
         when Auth_Invalid
            | Auth_Fail =>
            Reset;
            Downstream_Send (Error_Response);
         when Auth_Noent =>
            -- Wait for more data
            null;
      end case;
   end Downstream_Receive;

   ----------------------
   -- Downstream_Close --
   ----------------------

   procedure Downstream_Close
   is
   begin
      if Authenticated = Auth_Noent
      then
         Downstream_Send (Error_Response);
      end if;
      Reset;
      Authenticated := Auth_Invalid;
   end Downstream_Close;

end JWX.Stream_Auth;
