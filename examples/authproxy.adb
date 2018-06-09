--
-- \brief  WIP: Filter for transparently checking authentication token in TCP
--         connections. THIS IS UNFINISHED AND DOES NOT WORK, YET.
-- \author Alexander Senier
-- \date   2018-06-09
--
-- Copyright (C) 2018 Componolit GmbH
--
-- This file is part of JWX, which is distributed under the terms of the
-- GNU Affero General Public License version 3.
--

with Ada.Text_IO;
with Ada.IO_Exceptions;
with GNAT.Sockets;

procedure Authproxy
is
   Receiver   : GNAT.Sockets.Socket_Type;
   Downstream : GNAT.Sockets.Socket_Type;
   Upstream   : GNAT.Sockets.Socket_Type;
   Client     : GNAT.Sockets.Sock_Addr_Type;
   DS_Channel : GNAT.Sockets.Stream_Access;
   US_Channel : GNAT.Sockets.Stream_Access;

   task type Copy_Socket is
      entry Setup (L, R : GNAT.Sockets.Stream_Access);
      entry Run;
   end Copy_Socket;

   task body Copy_Socket
   is
      C     : Character;
      Left  : GNAT.Sockets.Stream_Access;
      Right : GNAT.Sockets.Stream_Access;
   begin
      loop
         accept Setup (L, R: GNAT.Sockets.Stream_Access)
         do
            Left  := L;
            Right := R;
         end;

         accept Run;
         begin
            Ada.Text_IO.Put_Line ("Running");
            loop
               C := Character'Input (Left);
               Ada.Text_IO.Put_Line ("Copy: " & C);
               Character'Output (Right, C);
            end loop;
         exception
            when Ada.IO_Exceptions.End_Error => null;
         end;
      end loop;
   end Copy_Socket;

   Up, Down : Copy_Socket;
   Request : GNAT.Sockets.Request_Type := (Name => GNAT.Sockets.Non_Blocking_IO, Enabled => True);

begin
   Ada.Text_IO.Put_Line ("Start");
   GNAT.Sockets.Initialize;
   GNAT.Sockets.Create_Socket (Socket => Upstream);
   GNAT.Sockets.Control_Socket (Socket => Upstream, Request => Request);
   GNAT.Sockets.Connect_Socket (Socket => Upstream,
                                Server => (Family => GNAT.Sockets.Family_Inet,
                                           Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                                           Port   => 5000));
   Ada.Text_IO.Put_Line ("Connected");
   US_Channel := GNAT.Sockets.Stream (Upstream);

   GNAT.Sockets.Create_Socket (Socket => Receiver);
   GNAT.Sockets.Set_Socket_Option
      (Socket => Receiver,
       Option => (Name => GNAT.Sockets.Reuse_Address, Enabled => True));

   GNAT.Sockets.Bind_Socket
      (Socket  => Receiver,
       Address => (Family => GNAT.Sockets.Family_Inet,
                   Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                   Port   => 5001));
   GNAT.Sockets.Listen_Socket (Socket => Receiver);
   GNAT.Sockets.Accept_Socket
      (Server  => Receiver,
       Socket  => Downstream,
       Address => Client);
   Ada.Text_IO.Put_Line ("Connection from " & GNAT.Sockets.Image (Client));
   DS_Channel := GNAT.Sockets.Stream (Downstream);
   Down.Setup (DS_Channel, US_Channel);
   Down.Run;
   Up.Setup (US_Channel, DS_Channel);
   Up.Run;
   GNAT.Sockets.Close_Socket (Downstream);
end Authproxy;
