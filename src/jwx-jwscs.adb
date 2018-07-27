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

package body JWX.JWSCS
is
   Token_Valid : Boolean;
   First       : Natural;
   Second      : Natural;

   --------------------
   -- Get_Separators --
   --------------------

   procedure Get_Separators
   is
      Found : Boolean := False;
   begin
      Token_Valid := False;
      First := Data_Index'First;
      Second := Data_Index'First;

      --  Find first separator
      for I in Data'Range
      loop
         if Data (I) = '.'
         then
            First := I;
            Found := True;
            exit;
         end if;
      end loop;

      if not Found or
         not (First in Data'First .. Data'Last - 1)
      then
         return;
      end if;

      --  Find second
      Found := False;
      for I in First + 1 .. Data'Last
      loop
         if Data (I) = '.'
         then
            Second := I;
            Found := True;
            exit;
         end if;
      end loop;

      if not Found or
         not (Second in Data'First .. Data'Last - 1)
      then
         return;
      end if;

      --  Check for another separator (-> invalid)
      for I in Second + 1 .. Data'Last
      loop
         if Data (I) = '.'
         then
            return;
         end if;
      end loop;

      Token_Valid := True;
   end Get_Separators;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is
     ((Token_Valid and
       First < Second and
       Data'Length > 0 and
       Data'First < Natural'Last) and then
      (First in Data'First + 1 .. Data'Last - 1 and
       Second in Data'First + 1 .. Data'Last - 1));

   -----------------
   -- JOSE_Length --
   -----------------

   function JOSE_Length return Natural is (First - Data'First);

   ---------------
   -- JOSE_Data --
   ---------------

   function JOSE_Data return Data_Type is (Data (Data'First .. First - 1));

   -------------
   -- Payload --
   -------------

   function Payload return Data_Type is (Data (First + 1 .. Second - 1));

   ---------------------
   -- Signature_Input --
   ---------------------

   function Signature_Input return Data_Type is (Data (Data'First .. Second - 1));

   ---------------
   -- Signature --
   ---------------

   function Signature return Data_Type is (Data (Second + 1 .. Data'Last));

begin
   Get_Separators;
end JWX.JWSCS;
