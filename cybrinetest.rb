#
# cybrina.rb to access serial port on MacOS
#
# needs serialport for ruby in **ruby1.8**
# To install on OS X follow http://ruby-serialport.rubyforge.org/
# on bash : sudo gem install ruby-serialport
# Launch with : ruby cybrinet.rb
# test : 
# telnet localhost 2000 
# #4 P1500 T500
require 'socket'
require 'rubygems'
server = TCPServer.new 13859
loop do 
	client = server.accept
	client.each_line do |line|
		puts line
	end
end