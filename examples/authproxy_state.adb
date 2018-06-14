package body Authproxy_State
is
   procedure Next (State : in out ES_Type;
                   C     :        Character)
   is
   begin
      case State.ES is
         when ES_Invalid =>
            State.ES := (if C = ASCII.CR then ES_First_CR else ES_Invalid);
         when ES_First_CR =>
            State.ES := (if C = ASCII.LF then ES_First_LF else ES_Invalid);
         when ES_First_LF =>
            State.ES := (if C = ASCII.CR then ES_Second_CR else ES_Invalid);
         when ES_Second_CR =>
            State.ES := (if C = ASCII.LF then ES_Done else ES_Invalid);
         when ES_Done =>
            null;
      end case;
   end Next;

   function Done (State : in ES_Type) return Boolean is (State.ES = ES_Done);

end Authproxy_State;
