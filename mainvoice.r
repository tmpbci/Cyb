	
REBOL [ Title: "Voice server" 
	author: Sam Neurohack
	note: "work with cyb2.r"
	Version: 0.8]

; commandline actually used is hardcoded for windows host : start
; can be replaced by autodetect removing start by a 'call reduce sometext composed'
;

Get_Os: does [
	switch system/version/4 [
		3 [os: "Windows" countos: "Start"]
		2 [os: "MacOSX" countos: "c"
						saycommand: "afplay"]
		4 [os: "Linux" countos: "c"
						saycommand: "festival"]
		5 [os: "BeOS" countos: "c"]
		7 [os: "NetBSD" countos: "c"]
		9 [os: "OpenBSD" countos: "c"]
		10 [os: "SunSolaris" countos: "c"]
	]
]


Get_OS
;;
;; Controllers UI
;;
controllers: layout [
	backdrop effect [gradient 1x1 0.0.0 50.50.50]
at 180x70 button 70 50.50.50 edge [size: 1x1] "Quit" [quit]
at 100x70 button 70 50.50.50 edge [size: 1x1] "close" [quit]
														
;
; Main loop
;
at 20x35 status: info bold "Cyb v0.3. Start to connect" 220x25 font-color white 
at 20x70 button 70 50.50.50 edge [size: 1x1] "Start" [
	status/text: "connect left voice"
	show status
	listentextleft: open/direct/lines/no-wait tcp://:13861
	wait listentextleft
	portextleft: first listentextleft
	status/text: "Left talk connected"
	show status
	wait 1
	;status/text: "connect right voice"
	;show status
	;listentextright: open/direct/lines/no-wait tcp://:13862
	;wait listentextright
	;portextright: first listentextright
	;status/text"Right text connected"
	;show status
	
	forever [
	;print "start"															; main loop

        	ready: wait portextleft
        	if	ready			[											; Handling port commands
        						msg: copy ready
        						print msg
        						status/text: msg
        						show status
        						if msg = "CONTINUEZ" [call "start c:\users\hackspace\desktop\cybrina\jresources\continuez.wav"]
        						if msg = "ENCORE" [call "start c:\users\hackspace\desktop\cybrina\jresources\encore.wav"]
        						if msg = "GAGNE" [call "start c:\users\hackspace\desktop\cybrina\jresources\gagne.wav"]
								]
			]
	]
]
view/new controllers
do-events