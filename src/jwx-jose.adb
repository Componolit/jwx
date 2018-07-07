--
-- \brief  JOSE header decoding (RFC 7515, section 4)
-- \author Alexander Senier
-- \date   2018-06-06
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with JWX.JSON;
with JWX.Base64;
with JWX.Util;

package body JWX.JOSE
is
   JOSE_Data   : JWX.Byte_Array (1 .. Data'Length/4*3);
   JOSE_Valid  : Boolean := False;
   Alg         : JWX.Alg_Type := JWX.Alg_Invalid;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is (JOSE_Valid);

   ------------
   -- Decode --
   ------------

   procedure Decode
   is
      use JWX.Base64;
      JOSE_Length : Natural;
      JOSE_Text   : String (1 .. JOSE_Data'Length);
   begin
      -- Decode JOSE header
      Decode_Url (Encoded => Data,
                  Length  => JOSE_Length,
                  Result  => JOSE_Data);
      if JOSE_Length = 0
      then
         return;
      end if;

      -- Parse JOSE header
      Util.To_String (Data   => JOSE_Data (JOSE_Data'First .. JOSE_Data'First + JOSE_Length - 1),
                      Result => JOSE_Text);

      declare
         JT : constant String := JOSE_Text;
         package J is new JWX.JSON (JT);
         Match_JOSE : J.Match_Type;
         JOSE_Alg   : J.Index_Type;
         use type J.Match_Type;
         use type J.Index_Type;
      begin
         J.Parse (Match_JOSE);
         if Match_JOSE /= J.Match_OK
         then
            return;
         end if;

         JOSE_Alg := J.Query_Object ("alg");
         if JOSE_Alg = J.End_Index
         then
            return;
         end if;

         Alg := Algorithm (J.Get_String (JOSE_Alg));
         JOSE_Valid := True;
      end;

   end Decode;

   ---------------
   -- Algorithm --
   ---------------

   function Algorithm return JWX.Alg_Type is (Alg);

begin
   Decode;
end JWX.JOSE;
