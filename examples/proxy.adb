--
-- \brief  Simple TCP forwarder
-- \author Alexander Senier
-- \date   2018-06-24
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with GNAT.Sockets; use GNAT.Sockets;
with Ada.Text_IO; use Ada.Text_IO;

procedure Proxy
is
   Server_Socket  : Socket_Type;

   Client_Socket  : Socket_Type;
   Client_Address : Sock_Addr_Type;

   Server_IP   : String   := "127.0.0.1";
   Server_Port : constant := 5001;

   Server_Address : constant Sock_Addr_Type :=
      (Family => Family_Inet,
       Addr   => Inet_Addr (Server_IP),
       Port   => Server_Port);

   Upstream_IP   : String   := "127.0.0.1";
   Upstream_Port : constant := 80;

   Upstream_Address : constant Sock_Addr_Type :=
      (Family => Family_Inet,
       Addr   => Inet_Addr (Upstream_IP),
       Port   => Upstream_Port);

   task type Proxy 
   is
      entry Setup (S : Socket_Type);
   end Proxy;

   task body Proxy
   is
      Server_Socket   : Socket_Type;
      Upstream_Socket : Socket_Type;

      C         : Character;
      Read_Set  : Socket_Set_Type;
      Write_Set : Socket_Set_Type;
      Selector  : Selector_Type;
      Status    : Selector_Status;
      Request   : Request_Type (N_Bytes_To_Read);
   begin
      accept Setup (S : Socket_Type)
      do
         Server_Socket := S;
      end;

      Create_Socket (Socket => Upstream_Socket);
      Connect_Socket (Socket => Upstream_Socket,
                      Server => Upstream_Address);

      -- Initialized socket set
      Empty (Read_Set);
      Empty (Write_Set);

      Create_Selector (Selector);

      loop
         Set (Read_Set, Server_Socket);
         Set (Read_Set, Upstream_Socket);
         Check_Selector (Selector, Read_Set, Write_Set, Status);

         case Status is
            when Completed =>
               if Is_Set (Read_Set, Server_Socket)
               then
                  Control_Socket (Server_Socket, Request);
                  if Request.Size = 0
                  then
                     -- Server socket was closed, close upstream socket
                     Close_Socket (Upstream_Socket);
                     Close_Socket (Server_Socket);
                     exit;
                  end if;
                  declare
                     Buffer : String (1 .. Request.Size);
                  begin
                     String'Read (Stream (Server_Socket), Buffer);
                     String'Write (Stream (Upstream_Socket), Buffer);
                  end;
               elsif Is_Set (Read_Set, Upstream_Socket)
               then
                  Control_Socket (Upstream_Socket, Request);
                  if Request.Size = 0
                  then
                     -- Upstream socket was closed, close server socket
                     Close_Socket (Upstream_Socket);
                     Close_Socket (Server_Socket);
                     exit;
                  end if;
                  declare
                     Buffer : String (1 .. Request.Size);
                  begin
                     String'Read (Stream (Upstream_Socket), Buffer);
                     String'Write (Stream (Server_Socket), Buffer);
                  end;
               end if;

            when Expired => Put_Line ("Expired");
            when Aborted => Put_Line ("Aborted");
         end case;
      end loop;

      Close_Selector (Selector);
      Put (ASCII.BS);

   end Proxy;

   P : access Proxy;

begin
   Put_Line ("Forwarding " & Image (Server_Address) & " <=> " & Image (Upstream_Address));
   Initialize;
   Create_Socket (Socket => Server_Socket);
   Set_Socket_Option
      (Socket => Server_Socket,
       Option => (Name => Reuse_Address, Enabled => True));
   Bind_Socket
      (Socket  => Server_Socket,
       Address => Server_Address);
   Listen_Socket (Socket => Server_Socket);

   loop
      Accept_Socket
         (Server  => Server_Socket,
          Socket  => Client_Socket,
          Address => Client_Address);
      Put (".");
      P := new Proxy; 
      P.Setup (Client_Socket);
   end loop;
end Proxy;
