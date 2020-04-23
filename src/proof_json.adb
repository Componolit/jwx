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

with JWX.JSON;

package body Proof_JSON
is
   procedure Do_Parse (Data  :     String;
                       Match : out Boolean)
   is
      package P is new JWX.JSON (Data);
      use type P.Kind_Type;
      use type P.Match_Type;
      M : P.Match_Type;
   begin
      Match := False;
      pragma Warnings (Off, "unused assignment to ""Offset""");
      P.Parse (M);
      pragma Warnings (On, "unused assignment to ""Offset""");
      if M /= P.Match_OK
      then
         return;
      end if;

      if P.Get_Kind = P.Kind_Object
      then
         Match := True;
      end if;
   end Do_Parse;
end Proof_JSON;
