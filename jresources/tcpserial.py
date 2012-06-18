#!/usr/bin/env python

# Translate TCP message to a serial port
#
import socket, serial, time, random 

# TCP listener
   
TCP_IP = '127.0.0.1'
TCP_PORT = 13859
BUFFER_SIZE = 1024  # Normally 1024, but we want fast response
ser = serial.Serial("/dev/cu.usbserial")
print ser.portstr
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((TCP_IP, TCP_PORT))
s.listen(1)
conn, addr = s.accept()
print 'Connection address:', addr
while 1:
       data = conn.recv(BUFFER_SIZE)
       if not data: break
       print "received data:", data
       ser.write(data+"\r\n")       
conn.close()
ser.close()