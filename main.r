	
REBOL [ Title: "Voice and serial server" 
	author: Sam Neurohack
	note: "work with cyb2.r"
	Version: 0.8]

Get_Os: does [
	switch system/version/4 [
		3 [os: "Windows" countos: "n"]
		2 [os: "MacOSX" countos: "c"
						saycommand: "say"]
		4 [os: "Linux" countos: "c"
						saycommand: "festival"]
		5 [os: "BeOS" countos: "c"]
		7 [os: "NetBSD" countos: "c"]
		9 [os: "OpenBSD" countos: "c"]
		10 [os: "SunSolaris" countos: "c"]
	]
]
print "Waiting for clients..."
print "connect Left RobON"
serialeft: open/direct/lines/no-wait tcp://:13863
wait serialeft
portserialeft: first serialeft
print "Left robON connected"

print "connect left voice"
listentextleft: open/direct/lines/no-wait tcp://:13861
wait listentextleft
portextleft: first listentextleft
print "Left talk connected"

print "connect right RobON"
serialright: open/direct/lines/no-wait tcp://:13864
wait serialright
portserialright: first serialright
print "Right robON connected"

print "connect right voice"
listentextright: open/direct/lines/no-wait tcp://:13862
wait listentextright
portextright: first listentextright
print "Right text connected"

Get_OS
;;
;; Controllers UI
;;
controllers: layout [
	backdrop effect [gradient 1x1 0.0.0 50.50.50]
at 70x40 button 70 50.50.50 edge [size: 1x1] "Quit" [quit]
at 20x127 button 70 50.50.50 edge [size: 1x1] "RobINIT" 	[robot: 1						
															cybrina: open/lines/no-wait tcp://localhost:13859
															print "Initialisation"
															insert cybrina "#0 P1500 T500"
															wait 0.5
															insert cybrina "#1 P1650 T500"
															wait 0.5
															insert cybrina "#2 P1500 T500"
															wait 0.5
															insert cybrina "#3 P1500 T500"
															wait 0.5
															insert cybrina "#4 P1500 T500"
															wait 0.5
															insert cybrina "#11 P1950 T500"
															wait 0.5
															insert cybrina "#12 P800 T500"
															wait 0.5
															insert cybrina "#13 P1950 T500"
															wait 0.5
															insert cybrina "#14 P2000 T500"
															wait 0.5
															insert cybrina "#15 P1700 T500"
															wait 0.5
															print "End init"
															]														
	at 100x127 button 70 50.50.50 edge [size: 1x1] "RobOFF" [robot: 0							
															close cybrina
															]
	

;
; Main loop
;

at 20x40 button 70 50.50.50 edge [size: 1x1] "Start" [
	forever [
	;print "start"															; main loop
        	ready: wait [portextleft portextright portserialeft portserialright]
        	if	ready		[											; Handling port commands
        						msg: copy ready
        						print msg
        						msgline: parse/all (to-string msg) " "
        						either (length? msgline) = 3 				; 3 words = new serial command
        								[insert cybrina msgline							
        								]
        								[commande: ajoin [saycommand " " msgline]
										call reduce [commande]]	
       							]
        			]

				]
]

view/new controllers
do-events