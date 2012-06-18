REBOL [ Title: "cybrina.r" 
	author: Sam Neurohack
	note: 
	Version: 0.1
]
system/ports/serial: [cu.usbserial]
Command1: "#0 P1500 T500"
Command2: "#0 P1400 T500"

controllers: layout [
	anti-alias on
	backdrop effect [gradient 1x1 0.0.0 50.50.50] 
	at 20x10 text "Cybrina" white
	at 20x35 status: info bold "cybrina v0.1" 220x25 font-color white 
;; Live recording buttons
	at 20x70 text "Live Play" snow  
	at 180x10 hgamval: text "0000" gray 
	at 130x10 hval: text "0000" gray       
	at 197x70 tcount: text "00000" snow
	at 155x70 tsignal: text "000" snow 
	at 100x95 button 70 50.50.50 edge [size: 1x1] "close" [
		status/font/color: snow
		status/text: "Ready"
		show status
		tcount/text: "000"
		show tcount
		close cybrina
		]
	at 180x95 button 70 50.50.50 edge [size: 1x1] "Quit" [quit]
	at 20x125 button 70 50.50.50 edge [size: 1x1] "Comm 1" [
   			insert cybrina Command1
    		]
  	at 100x125 button 70 50.50.50 edge [size: 1x1] "Comm 2" [
   			insert cybrina Command2
    		]
  
		
	at 20x95 button 70 50.50.50 edge [size: 1x1] "open" [
		cybrina: open/lines/no-wait tcp://localhost:13859
		Print "Activating Device ..."
		;wait [cybrina 0:00:5]
		]
]


print "Connecting...."
view/new controllers
do-events