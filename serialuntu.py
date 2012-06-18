import math
import serial
import time
from threading import Thread,Lock

#-------------------SERIAL-----------------
class Serial:
	def __init__(self, port='/dev/cu.usbserial', rate=115200):#9600
		self._serial = serial.Serial(port, rate)
		self._mutex = Lock()
		self._mutex.acquire()
		response = self._serial.readline().strip()
		if response != 'OK':
			raise Exception("Failed to communicate with the serial device!")
		self._mutex.release()

	def _shortCommand(self, command):
		self._serial.write(command)
		response = self._serial.readline()
		return response.strip()

	def _longCommand(self, command):
		response = self._shortCommand('RCV ' + str(len(command)) + "\n")
		if response != 'RDY':
			return None
		for i in range(int(math.ceil(len(command) / 128.0))):
			c = command[128*i:128*(i+1)]
			response = self._shortCommand(c)
		return self._serial.readline().strip()

	def command(self, command):
		self._mutex.acquire()
		if len(command) < 128:
			response = self._shortCommand(command + "\n")
		else:
			response = self._longCommand(command)
		self._mutex.release()
		return response



def main():
	serial = Serial(port='/dev/cu.usbserial', rate=115200)
	serial.command("#0 P1500 T500\n") 

if __name__ == '__main__':
	main()


