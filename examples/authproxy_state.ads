package Authproxy_State
is
   type End_State is (ES_Invalid, ES_First_CR, ES_First_LF, ES_Second_CR, ES_Done);

   type ES_Type is
   tagged record
      ES : End_State := ES_Invalid;
   end record;

   procedure Next (State : in out ES_Type;
                   C     :        Character);

   function Done (State : in ES_Type) return Boolean;

end Authproxy_State;
