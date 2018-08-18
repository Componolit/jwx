--
--  @summary JOSE header decoding (RFC 7515, section 4)
--  @author  Alexander Senier
--  @date    2018-06-06
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX.JSON;
with JWX.Base64;
with JWX.Util;

package body JWX.JOSE
is
   JOSE_Valid  : Boolean      := False;
   Alg         : JWX.Alg_Type := JWX.Alg_Invalid;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is (JOSE_Valid);

   ------------
   -- Decode --
   ------------

   procedure Decode;
   --  Decode JOSE header

   procedure Decode
   is
      use JWX.Base64;
   begin

      if Data'Length = 0 or
        Data'Length >= Natural'Last / 9 or
        Data'Last >= Natural'Last - 4
      then
         return;
      end if;

      declare
         JOSE_Data : JWX.Byte_Array (1 .. 3 * ((Data'Length + 3) / 4));
         JOSE_Text   : String (1 .. JOSE_Data'Length + 2);
         JOSE_Length : Natural;
      begin
         --  Decode JOSE header
         Decode_Url (Encoded => Data,
                     Len     => JOSE_Length,
                     Result  => JOSE_Data);
         if JOSE_Length = 0
         then
            return;
         end if;

         --  Parse JOSE header
         Util.To_String (Data   => JOSE_Data (JOSE_Data'First .. JOSE_Data'First + JOSE_Length - 1),
                         Result => JOSE_Text);

         declare
            JT : constant String := JOSE_Text;
            package J is new JWX.JSON (JT);
            use J;
            Match_JOSE : Match_Type;
            JOSE_Alg   : Index_Type;
         begin
            pragma Warnings (Off, "unused assignment to ""Offset""");
            Parse (Match_JOSE);
            pragma Warnings (On, "unused assignment to ""Offset""");
            if Match_JOSE /= Match_OK or else
              Get_Kind /= Kind_Object
            then
               return;
            end if;

            JOSE_Alg := Query_Object ("alg");
            if JOSE_Alg = End_Index or else
              Get_Kind (JOSE_Alg) /= Kind_String
            then
               return;
            end if;

            Alg := Algorithm (Get_String (JOSE_Alg));
            JOSE_Valid := True;
         end;
      end;

   end Decode;

   ---------------
   -- Algorithm --
   ---------------

   function Algorithm return JWX.Alg_Type is (Alg);

begin
   Decode;
end JWX.JOSE;
