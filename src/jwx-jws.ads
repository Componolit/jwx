--
-- @author Alexander Senier
-- @date   2018-05-16
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

-- @summary JWS validation (RFC 7515)
package JWX.JWS
with
   SPARK_Mode
is

   type Error_Type is (Error_Invalid,
                       Error_Invalid_Key,
                       Error_OK,
                       Error_Fail);
   -- Error type for signature operation
   --
   -- @value Error_Invalid      Data was malformed
   -- @value Error_Invalid_Key  Key was invalid
   -- @value Error_OK           Success
   -- @value Error_Fail         Unknown error

   type Result_Type (Error : Error_Type := Error_Invalid) is
   record
      case Error is
         when Error_OK =>
            Payload : Range_Type := Empty_Range;
         when others =>
            null;
      end case;
   end record;
   --  Result of a signature validation
   --
   --  @value Error    Error code
   --  @value Payload  Range of payload data on success

   Result_Invalid     : constant Result_Type := (Error => Error_Invalid);
   Result_Fail        : constant Result_Type := (Error => Error_Fail);
   Result_Invalid_Key : constant Result_Type := (Error => Error_Invalid_Key);

   function Valid_Result (Data   : String;
                          Result : Result_Type) return Boolean
   is
      (if Result.Error = Error_OK then
           In_Range (Result.Payload, Data));
   --  Assert that bounds of validation result are valid
   --
   --  @param Data   Input data
   --  @param Result Validation result defining payload range

   function Validate_Compact (Data     : String;
                              Key_Data : String) return Result_Type
   with
      Pre  => Data'Length >= 5 and
              Key_Data'First >= 0 and
              Key_Data'Last < Natural'Last and
              Key_Data'First <= Key_Data'Last,
      Post => Valid_Result (Data, Validate_Compact'Result);
   -- Validate a JSON web signature in compact serialization format
   --
   -- @param Data      Input data to validate
   -- @param Key_Data  JSON web key to use for validation

end JWX.JWS;
