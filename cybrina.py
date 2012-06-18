# Script generate an error on OS X about timeout
# same lines work great on OS X python command console
import serial
#import time

ser = serial.Serial("/dev/cu.usbserial", rate=115200, timeout=1)
print ser.portstr
"""
f_string = "choregraphie.txt"
f_open = open(f_string,'r')
for line in f_open.readlines():
	ser.write(line+"\n\r")
	print line
	time.sleep(200)
	print "fini"
"""
ser.close()
# ser.write("#0 P1500 T500\n")
