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

with JWX.JWT;
with Ada.Text_IO; use Ada.Text_IO;

package body JWX.Stream_Auth
is
   -------------------
   -- Authenticated --
   -------------------

   function Authenticated (Buf : String;
                           Now : Long_Integer) return Auth_Result_Type
   is
      First : Natural := Buf'Last;
      Last  : Natural := Buf'First;
      Auth  : Auth_Result_Type := Auth_Noent;
   begin
      -- At least space for 'id_token=' must be available
      if Buf'Length < 10
      then
         return Auth_Noent;
      end if;

      -- Search ID token
      for I in Buf'First .. Buf'Last - 8
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
            Last := I - 1;
            Auth := Auth_Fail;
         end if;
      end loop;

      if Auth = Auth_Noent
      then
         return Auth_Noent;
      end if;

      declare
         B : constant String := Buf (First .. Last);
         package P is new JWX.JWT (Data     => B,
                                   Key_Data => Key_Data,
                                   Audience => Audience,
                                   Issuer   => Issuer,
                                   Now      => Now);
         use P;
         Auth_Result : Result_Type;
      begin
         Validate_Compact (Result => Auth_Result);

         case Auth_Result
         is
            when Result_Fail        => return Auth_Fail;
            when Result_OK          => return Auth_OK;
            when others             => return Auth_Invalid;
         end case;
      end;

   end Authenticated;

end JWX.Stream_Auth;
