#
# cybrina.rb to access serial port on MacOS
#
# needs serialport for ruby in **ruby1.8**
# To install on OS X follow http://ruby-serialport.rubyforge.org/
# on bash : sudo gem install ruby-serialport
# Launch with : ruby cybrina.rb
require 'rubygems'
require 'serialport'
sp = SerialPort.new "/dev/tty.usbserial", 115200
File.open "choregraphie.txt" do |file|
 file.each_line do |line|
 	sp.write(line + "\r\n")  
 	sleep 0.2
 end
end