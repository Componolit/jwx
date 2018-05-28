with JWX.JSON;
with JWX.Base64;
with JWX.Util;

package body JWX.JOSE
is
   Jose_Data   : JWX.Byte_Array (1 .. Data'Length/4*3);
   Jose_Text   : String (1 .. Jose_Data'Length);
   Jose_Valid  : Boolean := False;
   Alg         : JWX.Alg_Type := JWX.Alg_Invalid;

   -----------
   -- Valid --
   -----------

   function Valid return Boolean is (Jose_Valid);

   ------------
   -- Decode --
   ------------

   procedure Decode
   is
      package J is new JWX.JSON (Jose_Data'Length);
      use JWX.Base64;
      use type J.Match_Type;
      use type J.Index_Type;
      JOSE_Length : Natural;
      JOSE_Alg    : J.Index_Type;
      Match_JOSE  : J.Match_Type;
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
      J.Parse (JOSE_Text, Match_JOSE);
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
      Jose_Valid := True;

   end Decode;

   ---------------
   -- Algorithm --
   ---------------

   function Algorithm return JWX.Alg_Type is (Alg);

begin
   Decode;
end JWX.JOSE;
