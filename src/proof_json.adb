--
--  @summary Helper package for proving generic JWX.JSON
--  @summary Alexander Senier
--  @date    2018-05-12
--
--  Copyright (C) 2018 Componolit GmbH
--
--  This file is part of JWX, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

package body Proof_JSON
is
   procedure Do_Parse (Data  :     String;
                       Match : out Boolean)
   is
      package P is new JWX.JSON (Data);
      M : P.Match_Type;
      use P;
   begin
      Match := False;
      pragma Warnings (Off, "unused assignment to ""Offset""");
      Parse (M);
      pragma Warnings (On, "unused assignment to ""Offset""");
      if M /= Match_OK
      then
         return;
      end if;

      if Get_Kind = Kind_Object
      then
         Match := True;
      end if;
   end Do_Parse;
end Proof_JSON;
