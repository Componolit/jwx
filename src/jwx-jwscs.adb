--
--  @summary JWS compact serialization (RFC 7515, 7.1)
--  @author  Alexander Senier
--  @date    2018-05-20
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package body JWX.JWSCS
is
   First       : Natural := 0;
   Second      : Natural := 0;

   -----------
   -- Split --
   -----------

   procedure Split (Token_Valid : out Boolean)
   is
      Found : Boolean := False;
   begin
      Token_Valid := False;
      First  := Data_Index'First;
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
         not (First in Data'First + 1 .. Data'Last - 1)
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
         not (Second in First + 1 .. Data'Last - 1)
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

      --  At least one byte of payload
      if not (First + 1 <= Second - 1)
      then
         return;
      end if;

      Token_Valid := True;
   end Split;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is
     (First < Data'Last and then
        (First + 1 <= Second - 1 and
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

   function JOSE_Data return String is (Data (Data'First .. First - 1));

   -------------
   -- Payload --
   -------------

   function Payload return String is (Data (First + 1 .. Second - 1));

   -------------------
   -- Payload_First --
   -------------------

   function Payload_First return Positive is (First + 1);

   ------------------
   -- Payload_Last --
   ------------------

   function Payload_Last return Positive is (Second - 1);

   ---------------------
   -- Signature_Input --
   ---------------------

   function Signature_Input return String is (Data (Data'First .. Second - 1));

   ---------------
   -- Signature --
   ---------------

   function Signature return String is (Data (Second + 1 .. Data'Last));

end JWX.JWSCS;
