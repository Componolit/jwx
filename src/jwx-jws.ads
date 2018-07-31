--
-- \brief  JWS validation (RFC 7515)
-- \author Alexander Senier
-- \date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

package JWX.JWS
is

   type Error_Type is (Error_Invalid,
                       Error_Invalid_Key,
                       Error_OK,
                       Error_Fail);

   type Result_Type (Error : Error_Type := Error_Invalid) is
   record
      case Error is
         when Error_OK =>
            First : Positive := Positive'Last;
            Last  : Positive := 1;
         when others =>
            null;
      end case;
   end record;

   Result_Invalid     : constant Result_Type := (Error => Error_Invalid);
   Result_Fail        : constant Result_Type := (Error => Error_Fail);
   Result_Invalid_Key : constant Result_Type := (Error => Error_Invalid_Key);

   function Valid_Result (Data   : String;
                          Result : Result_Type) return Boolean
   is
      ((if Result.Error = Error_OK then
           Result.First >= Data'First and
           Result.Last  <= Data'Last and
           Result.First <= Result.Last));

   -- Validate signature
   function Validate_Compact (Data     : String;
                              Key_Data : String) return Result_Type
   with
      Pre  => Data'Length >= 5 and
              Key_Data'First >= 0 and
              Key_Data'Last < Natural'Last and
              Key_Data'First <= Key_Data'Last,
      Post => Valid_Result (Data, Validate_Compact'Result);

end JWX.JWS;
