
REBOL [ Title: "Cyb" 
	author: Sam Neurohack
	note: "Command cybrina with a text file"
	Version: 0.3
]

; 
; Cybrina lattitude
;
; tete #2			 bas < milieu < haut	: 1800 < 1500 < 1200
; tete #0		droite < milieu < gauche 	: 750 < 1500 < 2250
; oeil D #3 	   droit < milieu < interne : 1150 < 1450 < 1800
; oeil G #4       droite < milieu < gauche  : 1150 < 1500 < 1800
; bras droit devant #14	bas < milieu < haut : 2000 <     < 750
; bras droit #15   avant < milieu > arriere : 1500 < 1700 < 1900
; bras droit #13 			bas < horizontal : 1950 < 1300
; coude droit flexion #11 bas < flexion 90° : 2100 < 1400
; rotation epau droite #12 	interne < indifferente : 1450 < 700
; #11 1950 - 1600 #12 700 - 1100 

serialip: 192.168.1.7
serialport: 13859
waittime: 0.5
connection: 0
do %jresources/ieee.r
namefile: %choregraphie.txt

;
; runrun
;

runrun: does [
chore-data: read/lines namefile
records: ( length? chore-data ) - 1
print records
print "Moving…"
current: 1
endgraph: records + 1
if connection = 0 [status/text: "Pas de connection"
					show status]
for element current endgraph 1 
		[ 
		
		data-line: pick chore-data element 
		print data-line
		if connection = 1 [insert cybrina data-line]
		wait waittime
		]
]
controllers: layout [
	backdrop effect [gradient 1x1 0.0.0 50.50.50] 
	at 20x10 text "Cybrina" white
	at 20x35 status: info bold "cybrina v0.1" 220x25 font-color white 
;; Live recording buttons
	at 20x70 text "Live Play" snow  
	at 100x95 button 70 50.50.50 edge [size: 1x1] "close" [
		status/font/color: snow
		status/text: "Connection closed"
		show status
		close cybrina
		]
	at 180x95 button 70 50.50.50 edge [size: 1x1] "Quit" [quit]
	at 20x125 button 70 50.50.50 edge [size: 1x1] "Load" [
   			namefile: to-file request-file
   			status/text: "Ok"
   			show status
    		]
  	at 100x125 button 70 50.50.50 edge [size: 1x1] "Runrun" [
   			runrun
    		]
  
		
	at 20x95 button 70 50.50.50 edge [size: 1x1] "Connect" [
		cybrina: do reduce ajoin ["open/lines/no-wait tcp://" serialip ":" serialport] 																					status/text: "Link OK"
		show status
		connection: 1
		]
]


print "Connecting...."
view/new controllers
do-events
