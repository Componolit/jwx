--
-- \brief  Proof-of-concept gilter for transparently checking
--         JWT authentication token in HTTP connections
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
with Authproxy_State;

procedure Authproxy
is
   Server    : GNAT.Sockets.Socket_Type;
   Client    : GNAT.Sockets.Sock_Addr_Type;
   Listen    : GNAT.Sockets.Sock_Addr_Type;
   Webserver : GNAT.Sockets.Sock_Addr_Type :=
      (Family => GNAT.Sockets.Family_Inet,
       Addr   => GNAT.Sockets.Inet_Addr ("127.0.0.1"),
       Port   => 80);

   Listen_Address : String := "127.0.3.1";
   Listen_Port    : constant := 5001;

   Error_HTML : constant String :=
      "<HTML><BODY><H1>Unauthorized request. Please login.</H1></BODY></HTML>";

   --  FIXME: Warning: This is dangerous
   type Time_t is new Long_Integer;
   procedure Time (Time : in out Time_t);
   pragma import (C, Time);

   function Error_Message (Input : String) return String
   is
   begin
      return
         "HTTP/1.1 401 Unauthorized"
         & ASCII.CR & ASCII.LF &
         "Connection: Keep-Alive"
         & ASCII.CR & ASCII.LF &
         "Content-Length:" & Input'Length'Img
         & ASCII.CR & ASCII.LF
         & ASCII.CR & ASCII.LF
         & Input;
   end Error_Message;

   Key_Data      : String := Read_File ("tests/data/HTTP_auth_key.json");

   task type Copy_Down is
      entry Setup (H : GNAT.Sockets.Socket_Type;
                   L : GNAT.Sockets.Socket_Type);
   end Copy_Down;

   task body Copy_Down
   is
      C     : Character;
      High  : GNAT.Sockets.Socket_Type;
      Low   : GNAT.Sockets.Socket_Type;
   begin
      accept Setup (H : GNAT.Sockets.Socket_Type;
                    L : GNAT.Sockets.Socket_Type)
      do
         High := H;
         Low  := L;
      end;

      loop
         begin
            Character'Read (GNAT.Sockets.Stream (High), C);
            Character'Write (GNAT.Sockets.Stream (Low), C);
         exception
            when Ada.IO_Exceptions.End_Error =>
               exit;
         end;
      end loop;

      GNAT.Sockets.Close_Socket (High);
   end Copy_Down;

   task type Copy_Up is
      entry Setup (Server : GNAT.Sockets.Socket_Type);
   end Copy_Up;

   task body Copy_Up
   is
      C    : Character;
      Low  : GNAT.Sockets.Socket_Type;
      High : GNAT.Sockets.Socket_Type;
      Down : Copy_Down;

      Buf  : String (1 .. 4096);
      Off  : Natural := Buf'First;

      use Authproxy_State;
      State : ES_Type;

      package HA is new JWX.Stream_Auth (Key_Data => Key_Data,
                                         Audience => "4cCy0QeXkvjtHejID0lKzVioMfTmuXaM",
                                         Issuer   => "https://cmpnlt-demo.eu.auth0.com/");
      use HA;

      Auth : Auth_Result_Type := Auth_Invalid;
      Now : Time_t := 0;
   begin

      accept Setup (Server : GNAT.Sockets.Socket_Type)
      do
         GNAT.Sockets.Accept_Socket
            (Server  => Server,
             Socket  => Low,
             Address => Client);
         Put_Line ("Connection from " & GNAT.Sockets.Image (Client));
      end;

      loop
         begin
            Character'Read (GNAT.Sockets.Stream (Low), C);
         exception
            when Ada.IO_Exceptions.End_Error =>
               exit;
         end;

         Buf (Off) := C;
         if Auth /= Auth_OK
         then
            State.Next (C);

            if State.Done
            then
               Time (Now);
               Auth := Authenticated (Buf (Buf'First .. Off), Long_Integer (Now));
               if Auth /= Auth_OK
               then
                  Put_Line ("Not authenticated, sending error message");
                  -- Send error message
                  String'Write (GNAT.Sockets.Stream (Low), Error_Message (Error_HTML));
                  -- GNAT.Sockets.Close_Socket (Low);
                  exit;
               else
                  Put_Line ("Authenticated, forwarding");
                  GNAT.Sockets.Create_Socket (Socket => High);
                  GNAT.Sockets.Connect_Socket (Socket => High,
                                               Server => Webserver);
                  Put_Line ("Connected to " & GNAT.Sockets.Image (Webserver));
                  Down.Setup (High, Low);
                  String'Write (GNAT.Sockets.Stream (High), Buf (1 .. Off));
                  Off := Buf'First;
               end if;
            end if;
         else
            String'Write (GNAT.Sockets.Stream (High), Buf (1 .. Off));
         end if;
         Off := Off + 1;

      end loop;
   end Copy_Up;

begin
   GNAT.Sockets.Initialize;
   GNAT.Sockets.Create_Socket (Socket => Server);
   GNAT.Sockets.Set_Socket_Option
      (Socket => Server,
       Option => (Name => GNAT.Sockets.Reuse_Address, Enabled => True));
   Listen := (Family => GNAT.Sockets.Family_Inet,
              Addr   => GNAT.Sockets.Inet_Addr (Listen_Address),
              Port   => Listen_Port);
   GNAT.Sockets.Bind_Socket
      (Socket  => Server,
       Address => Listen);
   GNAT.Sockets.Listen_Socket (Socket => Server);
   Put_Line ("Validator listening on " & GNAT.Sockets.Image (Listen));

   loop
      declare
         Up : Copy_Up;
      begin
         Up.Setup (Server);
      end;
   end loop;
end Authproxy;
