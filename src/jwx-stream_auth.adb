--
--  @summary Text stream authentication checking
--  @author  Alexander Senier
--  @date    2018-06-07
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

with JWX.JWT;

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
      Found : Boolean := False;

      Result : JWX.JWT.Result_Type;
      use type JWT.Result_Type;
   begin
      --  At least space for 'id_token=' must be available
      if Buf'Length < 10
      then
         return Auth_Noent;
      end if;

      --  Search ID token
      for I in Buf'First .. Buf'Last - 8
      loop
         if Buf (I .. I + 8) = "id_token="
         then
            First := I + 9;
            Found := True;
            pragma Assert (First >= Buf'First);
            exit;
         end if;
      end loop;

      if not Found or
         not (First in Buf'Range)
      then
         return Auth_Noent;
      end if;

      --  Search end of ID token (next ampersand)
      Found := False;
      for I in First .. Buf'Last
      loop
         pragma Loop_Invariant (First >= Buf'First);
         pragma Loop_Invariant (I <= Buf'Last);
         if Buf (I) = '&' or
            Buf (I) = ' '
         then
            Last  := I - 1;
            Found := True;
            exit;
         end if;
      end loop;

      if (not Found or
          not (Last in Buf'Range) or
          not (First <= Last)) or else
         Last - First < 4
      then
         return Auth_Noent;
      end if;

      pragma Assert (First <= Last);
      pragma Assert (First >= Buf'First);
      pragma Assert (Last <= Buf'Last);
      pragma Assert (Buf (First .. Last)'Length >= 5);

      Result := JWT.Validate_Compact (Data     => Buf (First .. Last),
                                      Key_Data => Key_Data,
                                      Audience => Audience,
                                      Issuer   => Issuer,
                                      Now      => Now);
      case Result
      is
         when JWT.Result_Fail => return Auth_Fail;
         when JWT.Result_OK   => return Auth_OK;
         when others          => return Auth_Invalid;
      end case;

   end Authenticated;

end JWX.Stream_Auth;
