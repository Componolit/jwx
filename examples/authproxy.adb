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

with Ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions;
with GNAT.Sockets;
with JWX.Stream_Auth;
with JWX_Test_Utils; use JWX_Test_Utils;

procedure Authproxy
is
   Server     : GNAT.Sockets.Socket_Type;
   Upstream   : GNAT.Sockets.Socket_Type;
   Downstream : GNAT.Sockets.Socket_Type;
   Address    : GNAT.Sockets.Sock_Addr_Type;

   Error_Message : String := "HTTP/1.1 401 Unauthorized" & ASCII.CR & ASCII.LF;
   Key_Data      : String := Read_File ("tests/data/HTTP_auth_key.json");

   procedure Send_Upstream (Data : String)
   is
   begin
      Put_Line ("Send_Upstream");
      String'Write (GNAT.Sockets.Stream (Upstream), Data);
   end Send_Upstream;

   procedure Send_Downstream (Data : String)
   is
   begin
      Put_Line ("Send_Downstream");
      String'Write (GNAT.Sockets.Stream (Downstream), Data);
   end Send_Downstream;

   package HA is new JWX.Stream_Auth (Error_Response  => Error_Message,
                                      Key_Data        => Key_Data,
                                      Upstream_Send   => Send_Upstream,
                                      Downstream_Send => Send_Downstream);

   task type Copy_Up is
      entry Run;
   end Copy_Up;

   task body Copy_Up
   is
      C : Character;
   begin
      loop
         accept Run;
         begin
            loop
               C := Character'Input (GNAT.Sockets.Stream (Downstream));
               Put_Line ("Copy_Up1: " & C);
               HA.Downstream_Receive ("" & C);
               -- FIXME: We need to detect when request is finished to
               -- signal that upstream got closed.
            end loop;
         exception
            when Ada.IO_Exceptions.End_Error =>
               Put_Line ("Copy_Up Done");
               GNAT.Sockets.Close_Socket (Downstream);
         end;
      end loop;
   end Copy_Up;

   task type Copy_Down is
      entry Run;
   end Copy_Down;

   task body Copy_Down
   is
   begin
      loop
         accept Run;
         begin
            loop
               Put_Line ("Copy_Down1");
               HA.Upstream_Receive ("" & Character'Input (GNAT.Sockets.Stream (Upstream)));
               Put_Line ("Copy_Down2");
            end loop;
         exception
            when Ada.IO_Exceptions.End_Error =>
               GNAT.Sockets.Close_Socket (Upstream);
         end;
      end loop;
   end Copy_Down;

   Up   : Copy_Up;
   Down : Copy_Down;

begin
   GNAT.Sockets.Initialize;
   GNAT.Sockets.Create_Socket (Socket => Upstream);
   GNAT.Sockets.Connect_Socket (Socket => Upstream,
                                Server => (Family => GNAT.Sockets.Family_Inet,
                                           Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                                           Port   => 5000));
   GNAT.Sockets.Create_Socket (Socket => Server);
   GNAT.Sockets.Set_Socket_Option
      (Socket => Server,
       Option => (Name => GNAT.Sockets.Reuse_Address, Enabled => True));

   GNAT.Sockets.Bind_Socket
      (Socket  => Server,
       Address => (Family => GNAT.Sockets.Family_Inet,
                   Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
                   Port   => 5001));
   GNAT.Sockets.Listen_Socket (Socket => Server);
   GNAT.Sockets.Accept_Socket
      (Server  => Server,
       Socket  => Downstream,
       Address => Address);
   Ada.Text_IO.Put_Line ("Connection from " & GNAT.Sockets.Image (Address));

   Down.Run;
   Up.Run;
end Authproxy;
