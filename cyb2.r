
REBOL [ Title: "Cyb" 
	author: Sam Neurohack
	note: "Command cybrina with 2 Mindwave"
	Version: 0.3

]

;;
;; Initial setup 
;;
do %jresources/ieee.r
plotspline: copy []
curvea: copy []
curveb: copy []
xmax: 900
ymax: 700
xorigin: xmax / 2
yorigin: ymax / 2
xpre: xorigin
ypre: yorigin
xsig: xatt: xmed: xdelta: xtheta: xlalp: xhalp: xlbeta: xhbeta: xlgam: xhgam: 5
ysigp: yattp: ymedp: ydeltap: ythetap: ylalpp: ylalpp: yhalpp: ylbetap: yhbetap: ylgamp: yhgamp: 0
count: 1
average1: [0 0 0 0 0 0]
average2: [0 0 0 0 0 0]
average3: [0 0 0 0 0 0]
dmxcolor: [0 0 0 0 0 0]
oscpattern: array/initial [8] 0
dmxcolor/5: "000000"
dmxcolor/4: "000000"
dmxcolor/3: "000000"
dmxcolor/2: "000000"
dmxcolor/1: "000000"
vpcolor: [0 0 0 0 0 0]
host_name: system/network/host
serialip: host_name
serialport: 13859
data: make binary! 1000
namefile: %jresources/text.csv
host_name: system/network/host
jliveipOUT: 127.0.0.1
jliveportOUT: 13856 
oscipOUT: "127.0.0.1"
oscportOUT: 8080
ledlvl: 10
basechan: 1
lan: 1
osc: 0
forceset: 0
basemultiplier: 10
multiplier: basemultiplier
channb: 1
monomework: 0
plot: copy [pen white  line]			; For Anna
plotatt: copy [pen orange  line]		; For eeg
plotmed: copy [pen gray  line]
plotdelta: copy [pen snow  line]
plottheta: copy [pen crimson  line]
plotlalp: copy [pen snow  line]
plothalp: copy [pen green  line]
plotlbeta: copy [pen snow  line]
plothbeta: copy [pen blue  line]
plotlgam: copy [pen pink   line]
plothgam: copy [pen red  line]
maxgraph: 600
endgraph: 600
mindlevel: 0
mindcount: 0
pret: "start c:\Users\HACKSPACE\Desktop\Cybrina\jresources/pret.wav"
; 
; Cybrina lattitude
;
; tete #2			 bas < milieu < haut	: 1800 < 1500 < 1200
; tete #0		droite < milieu < gauche 	: 750 < 1500 < 2250
; bras droit devant #14	bas < milieu < haut : 2000 <     < 750
; bras droit #15   avant < milieu > arriere : 1500 < 1700 < 1900
; bras droit #13 			bas < horizontal : 1950 < 1300
; coude droit flexion #11 bas < flexion 90° : 1950 < 1400
; rotation epau droite #12 	interne < indifferente : 1450 < 800
maxtdroite: 750
maxtgauche: 2250
maxtbas: 1800
maxthaut: 1200
maxbddevantup: 750
maxbddevantdown: 2000
maxbdup: 1300
maxbdown: 1950
maxbdavant: 1500
maxbdarr: 1900
maxcoudedup: 1398 ; should be 1400 but 12 steps of 46 = 552  
maxcoudedown: 1950
robot: 0
motor: "#11"
tdg: 1500
tbh: 1500
bdbh: 2000
bdaa: 1700
couded: 1950
leftstart: 1950
leftend: 1600
leftstep: -21		; (leftend - leftstart) / 12
rightstart: 700
rightend: 1100
rightstep: 34		; (rightend - rightstart) / 12
motorstart: leftstart
motorend: leftend
motorstep: leftstep
currentpos: leftstart
;				
; Get OS
;				
Get_Os: does [
	switch system/version/4 [
		3 [os: "Windows" countos: "n"]
		2 [os: "MacOSX" countos: "c"]
		4 [os: "Linux" countos: "c"]
		5 [os: "BeOS" countos: "c"]
		7 [os: "NetBSD" countos: "c"]
		9 [os: "OpenBSD" countos: "c"]
		10 [os: "SunSolaris" countos: "c"]
	]
]
;;
;; EEG painter 
;;
doeeg: does [
			tsignal/text: form ysig
			tatt/text: form yatt
			append plotatt (as-pair (xatt - 1) 110 - yattp) (as-pair xatt 110 - yatt)
    		xatt: xatt + 1
			yattp: yatt
			tmed/text: form ymed
			append plotmed (as-pair xmed - 1 110 - ymedp) (as-pair xmed 110 - ymed)
    		xmed: xmed + 1
			ymedp: ymed

			tdelta/text: form ydelta
			append plotdelta (as-pair xdelta - 1 110 - (ydeltap / 5)) (as-pair xdelta 110 - (ydelta / 5))
    		xdelta: xdelta + 1
			ydeltap: ydelta
			ttheta/text: form ytheta
			append plottheta (as-pair xtheta - 1 110 - (ythetap / 5)) (as-pair xtheta 110 - (ytheta / 5))
    		xtheta: xtheta + 1
			ythetap: ytheta

			tlalp/text: form ylalp
			append plotlalp (as-pair xlalp - 1 110 - ylalpp) (as-pair xlalp 110 - ylalp)
    		xlalp: xlalp + 1
			ylalpp: ylalp
			thalp/text: form yhalp
			append plothalp (as-pair xhalp - 1 110 - yhalpp) (as-pair xhalp 110 - yhalp)
    		xhalp: xhalp + 1
			yhalpp: yhalp

			tlbeta/text: form ylbeta
			append plotlbeta (as-pair xlbeta - 1 110 - (ylbetap * 10)) (as-pair xlbeta 110 - (ylbeta * 10))
    		xlbeta: xlbeta + 1
			ylbetap: ylbeta
			thbeta/text: form yhbeta
			append plothbeta (as-pair xhbeta - 1 110 - (yhbetap * 20)) (as-pair xhbeta 110 - (yhbeta * 20))
    		xhbeta: xhbeta + 1
			yhbetap: yhbeta

			tlgam/text: form ylgam
			append plotlgam (as-pair xlgam - 1 110 - (ylgamp * 5)) (as-pair xlgam 110 - (ylgamp * 5))
    		xlgam: xlgam + 1
			ylgamp: ylgam
			thgam/text: form yhgam
			append plothgam (as-pair xhgam - 1 110 - (yhgamp / 2)) (as-pair xhgam 110 - (yhgamp / 2))
    		xhgam: xhgam + 1
			yhgamp: yhgam
			]
doclear: does [				    
					clear plotspline: head plotspline
					clear plot: head plot
					clear plotatt: head plotatt
					clear plotmed: head plotmed
					clear plotdelta: head plotdelta
					clear plottheta: head plottheta
					clear plotlalp: head plotlalp
					clear plothalp: head plothalp
					clear plotlbeta: head plotlbeta
					clear plothbeta: head plothbeta
					clear plotlgam: head plotlgam
					clear plothgam: head plothgam
					append plot compose [pen white  line]
					append plotatt compose [pen orange line]
					append plotmed compose [pen gray  line]
					append plotdelta compose [pen snow  line]
					append plottheta compose [pen crimson  line]
					append plotlalp compose [pen snow  line]
					append plothalp compose [pen green  line]
					append plotlbeta compose [pen snow  line]
					append plothbeta compose [pen blue  line]
					append plotlgam compose [pen pink   line]
					append plothgam compose  [pen red  line]
					darkness: 1
					allyhgam: 0
					tcount/text: form count
					xpre: xmax / 2
					ypre: ymax / 2
					xatt: xsig: xmed: xdelta: xtheta: xlalp: xhalp: xlbeta: xhbeta: xlgam: 5
					xhgam: 5
					show tcount
					if mainui = 1 [show eeg]
					if mainui > 6 [show peopleui]
					if all [mainui > 1 mainui < 7] [show ui]
]
;;
;; jROLLER Engine
;; 
doengine: does [
					data: 0
				    if osc = 1 [doosc]
					instruc/text: ""
					attlight: remove/part to-hex to-integer yatt 6
					h: to-integer multiplier * yhgam
					hval/text: h
					show hval
					;print ajoin [yhgam " " multiplier " " h]
					if lan = 1 [
						yhgamgoldfish: yhgam * 15
						newval: [count ysig yatt ymed yhgam yhgam yhgam yhgam yhgam yhgam yhgam yhgamgoldfish]
				    	newdata: reform newval
				    	;print newval
				    	;insert outport newdata													; if pure data
				    	]
					;print h
					huetorgb
					case  [
					           	ysig = 200
					     					[lvlbox1/color: 60.0.0
					     				 	lvlbox2/color: 60.0.0
					     				 	lvlbox3/color: 60.0.0
					     					lvlbox4/color: 60.0.0]
					     		all [ysig > 60 ysig < 200]
					     					[lvlbox1/color: red
					     				 	lvlbox2/color: 60.0.0
					     				 	lvlbox3/color: 60.0.0
					     					lvlbox4/color: 60.0.0]
					     		all [ysig > 30	ysig < 60] 
					     					[lvlbox1/color: red
					     				 	lvlbox2/color: red
					     				 	lvlbox3/color: 60.0.0
					     				 	lvlbox4/color: 60.0.0]
					     	   all [ysig > 0 ysig < 30] 
					     					[lvlbox1/color: red
					     				 	lvlbox2/color: red
					     				 	lvlbox3/color: red
					     				 	lvlbox4/color: 60.0.0]
					     	 ysig = 0
					     					[lvlbox1/color: red
					     					 lvlbox2/color: red
					     					 lvlbox3/color: red
					     				 	 lvlbox4/color: red]
					     	]
					 show lvlbox1
					 show lvlbox2
					 show lvlbox3
					 show lvlbox4
					case [
					     all [ymed = 0 forceset = 0][
					     		dmxcolor/5: ajoin ["00" attlight "00"]
					    		vpcolor/5: 0.0.0
						 		]
					  	 any [ymed > 0 forceset = 1][
					  	 		dmxcolor/5: ajoin [RGB.RHex "" RGB.GHex "" RGB.BHex]
					  	 		vpcolor/5: to-tuple (ajoin [RGB.R "." RGB.G "." RGB.B])
					  	 		doeeg
					  	 		]
						 ] 
			    	vled1/color: vpcolor/1
			    	vled2/color: vpcolor/2
			    	vled3/color: vpcolor/3
			    	vled4/color: vpcolor/4
			    	vled5/color: vpcolor/5
			    	show vled1
			    	show vled2
			    	show vled3
			    	show vled4
			    	show vled5
			    	average1/5: yhgam
			    	average1/6: ( average1/1 + average1/2 + average1/3 + average1/4 + average1/5 ) / 5
			    	either average1/6 > 7 [hgambciled/data: true] [hgambciled/data: false]
			    	average1/1: average1/2
					average1/2: average1/3
					average1/3: average1/4
					average1/4: average1/5
					dmxcolor/1: dmxcolor/2
					dmxcolor/2: dmxcolor/3
					dmxcolor/3: dmxcolor/4
					dmxcolor/4: dmxcolor/5
					vpcolor/1: vpcolor/2
					vpcolor/2: vpcolor/3
					vpcolor/3: vpcolor/4
					vpcolor/4: vpcolor/5
					count: count + 1
					tcount/text: form count
					if all [ysig = 0 robot = 1 (yatt - ymed < 8) (ymed - yatt < 8) ylgam < 2]	
										[if any [all [motorstep < 0 currentpos > motorend] all [motorstep > 0 currentpos < motorend]] 									 						[either mindcount < (mindlevel / 2) 		
																		[mindcount: mindcount + 1
																		print ajoin ["Mindcount: " mindcount]
																		countbox/color: green
																		show countbox
																		wait 0.5
																		countbox/color: 0.60.0
																		show countbox]
																		[currentpos: currentpos + motorstep
																		mindlevel: mindlevel + 1
																		mindcount: 0
																		print ajoin ["Mindlevel : " mindlevel]
																		countbox/color: green
																		show countbox
																		switch mindlevel [
																		 1 [mindlvlbox1/color: red
																		    show mindlvlbox1]
																		2 [mindlvlbox2/color: red
																		    show mindlvlbox2]
																		3 [mindlvlbox3/color: red
																		    show mindlvlbox3]
																		4 [mindlvlbox4/color: red
																			 show mindlvlbox4]
																		5 [mindlvlbox5/color: red
																			  show mindlvlbox5]
																		6 [mindlvlbox6/color: red
																			  show mindlvlbox6]
																		7 [mindlvlbox7/color: red
																			   show mindlvlbox7]
																		8 [mindlvlbox8/color: red
																			   show mindlvlbox8]
																		9 [mindlvlbox9/color: red
																			   show mindlvlbox9]
																		10 [mindlvlbox10/color: red
																			    show mindlvlbox10]
																		11 [mindlvlbox11/color: red
																				show mindlvlbox11]
																		12 [mindlvlbox12/color: red
																				    show mindlvlbox12]
																				]
																	cybcommand: ajoin [motor " P" currentpos " T500"]
																	print cybcommand
																	wait 0.5
																	countbox/color: 0.60.0
																	show countbox
																	;insert cybrina cybcommand
																			]
																		]
																	
																	]
					;if ysig = 0 [print ajoin ["tete DG : " tdg " tete bh : " tbh " bras D bh : " bdbh " bras D aa : " bdaa]]
					status/text: "Connected. Improve signal to calibrate"
					if any [ymed <> 0 forceset = 1]    
									[status/text: "Calibrated"
									]
					if yhgam = average1/3 [status/text: "Error TGC"]
					show tcount
					show hgambciled
					hgamval/text: yhgam
					show hgamval
]
;;
;; real 64 Monome Command 
;;
monomescale: does [
					elementx: min elementx 255 ; 8bits max
					case[
						elementx < 1 [monomex: 1]
						(elementx >= 1 elementx < 10) [monomex: 3]
						(elementx >= 10 elementx < 20) [monomex: 7]
						(elementx >= 20 elementx < 30) [monomex: 15]
						(elementx >= 30 elementx < 40) [monomex: 31]
						(elementx >= 40 elementx < 50) [monomex: 63]
						(elementx >= 50 elementx < 60) [monomex: 127]
						elementx >= 60 [monomex: 255]	
						]					
					]
doosc: does [
			either ysig > 0 
				[elementx: ysig
				monomescale
				oscommand: ajoin [oscipOUT " " oscportOUT " /40h/frame " monomex " " monomex " " monomex " " monomex " " monomex " " monomex " " monomex " " monomex]
				]
				[elementx: to-integer ydelta
				monomescale
				oscpattern/1: monomex
				elementx: to-integer ytheta
				monomescale
				oscpattern/2: monomex
				elementx: to-integer ylalp
				monomescale
				oscpattern/3: monomex
				elementx: to-integer yhalp
				monomescale
				oscpattern/4: monomex
				elementx: to-integer ylbeta
				monomescale
				oscpattern/5: monomex
				elementx: to-integer yhbeta
				monomescale
				oscpattern/6: monomex
				elementx: to-integer ylgam
				monomescale
				oscpattern/7: monomex
				elementx: to-integer yhgam
				monomescale
				oscpattern/8: monomex
				oscommand: ajoin [oscipOUT " " oscportOUT " /40h/frame " oscpattern/1 " " oscpattern/2 " " oscpattern/3 " " oscpattern/4 " " oscpattern/5 " " oscpattern/6 " " oscpattern/7 " " oscpattern/8]
				]	
			print oscommand
			if monomework: 1 [insert oscport oscommand]
			]

;;
;; yhgam is Hue. Conversion to RGB  
;;

huetorgb: does [
	
	s: 90
	v: 80
	
	s: s / 100
	v: v / 100
	either s = 0 [RGB.R: v * 255
		 		  RGB.G: v * 255
				  RGB.B: v * 255]

			[h: h / 60
			idec: to-integer h
			f: h - idec
			h1: v * (1 - s)
			h2: v * (1 - (s * f))
			h3: v * ((1 - s) * (1 - f))
		
			case [
				idec = 0 [ r: v 
					    g: h3 
					    b: h1]
					  
				idec = 1 [ r: h2
					    g: v 
					    b: h1]
			
				idec = 2 [ r: h1 
			 			g: v 
						b: h3]
			 
				idec = 3 [ r: h1
						g: h2 
						b: v]
						
				idec = 4 [ r: h3 
				  		g: h1 
				  		b: v]
				  		 
				idec > 4 [ r: v
				  		g: h1 
				  		b: h2]
				]
			RGB.R: to-integer (r * 255)
			RGB.G: to-integer (g * 255)
			RGB.B: to-integer (b * 255)
			RGB.Rhex: remove/part to-hex RGB.R 6
			RGB.Ghex: remove/part to-hex RGB.G 6
			RGB.Bhex: remove/part to-hex RGB.B 6
		    ]
	]
;;
;; Reset mindlevels
;;
resetmind: does [
		mindlevel: 0
		mindcount: 0
		mindlvlbox1/color: 60.0.0
		show mindlvlbox1
		mindlvlbox2/color: 60.0.0
		show mindlvlbox2
		mindlvlbox3/color: 60.0.0
		show mindlvlbox3
		mindlvlbox4/color: 60.0.0
		show mindlvlbox4
		mindlvlbox5/color: 60.0.0
		show mindlvlbox5
		mindlvlbox6/color: 60.0.0
		show mindlvlbox6
		mindlvlbox7/color: 60.0.0
		show mindlvlbox7
		mindlvlbox8/color: 60.0.0
		show mindlvlbox8
		mindlvlbox9/color: 60.0.0
		show mindlvlbox9
		mindlvlbox10/color: 60.0.0
		show mindlvlbox10
		mindlvlbox11/color: 60.0.0
		show mindlvlbox11
		mindlvlbox12/color: 60.0.0
		show mindlvlbox12
		cybcommand: ajoin [motor " P" motorstart " T500"]
		print cybcommand
		insert cybrina cybcommand
]

;;
;; Controllers UI
;;
controllers: layout [
	anti-alias on
	backdrop effect [gradient 1x1 0.0.0 50.50.50] 
	at 20x10 text "Cyb" white
	at 230x13 hgambciled: led green
	at 20x35 status: info bold "Cyb v0.3. Start to connect" 220x25 font-color white 
;; Live recording buttons
	at 20x70 text "Live Play" snow  
	at 180x10 hgamval: text "0000" gray 
	at 130x10 hval: text "0000" gray       
	at 197x70 tcount: text "00000" snow
	at 155x70 tsignal: text "000" snow 
	at 100x95 button 70 50.50.50 edge [size: 1x1] "Stop" [
		status/font/color: snow
		status/text: "Ready"
		show status
		tcount/text: "000"
		show tcount
		close tp
		resetmind
		]
	at 185x95 button 70 50.50.50 edge [size: 1x1] "Quit" [quit]		
	at 70x255 instruc: txt red "SIGNAL MONITOR" 
	at 20x230 lvlbox1: box 50x20 60.0.0 
	at 80x220 lvlbox2: box 50x30 60.0.0 
	at 140x180 lvlbox3: box 50x70 60.0.0 
	at 200x160 lvlbox4: box 50x90 60.0.0 

;; Prefs buttons
	
		at 20x400 text "Serial server IP" snow 
		at 130x400 lbl "Port" left snow 
		;at 200x400 lbl "type" snow 
		at 20x420 toserialip: field 100 to-string serialip snow 
		at 130x420 toserialport: field 55 to-string serialport
		;at 200x420 dmxcontroller: choice 55 50.50.50 edge [size: 1x1] "enttec" "arduino"
        at 20x450 button 70 50.50.50 edge [size: 1x1] snow "TOP" [insert choreport "COM TOP"
        															  print "TOPlight sent"]
        at 100x450 button 70 50.50.50 edge [size: 1x1] snow "RELOAD" [insert choreport "COM LOAD"]	
        at 180x450 button 70 50.50.50 edge [size: 1x1] snow "CYBRUN" [insert botport "cybrina.txt"
        															  print "cybrina.txt sent"]	
		
		at 185x300 button 70 50.50.50 edge [size: 1x1] "SavePrefs" [
													saveprefs
													status/text: "Preferences saved"
													show status
													]
		;at 20x410 vpbox1: box 230x30 black 
		at 40x500 vled1: box 30x30 60.0.0 
	    at 80x500 vled2: box 30x30 60.0.0
	    at 120x500 vled3: box 30x30 60.0.0
	    at 160x500 vled4: box 30x30 60.0.0
	    at 200x500 vled5: box 30x30 60.0.0
		at 20x335 button 70 50.50.50 edge [size: 1x1] "Load" [namefile: to-file request-file
															  tcount/text: "0"
															  show tcount]
		at 185x335 sidebtn: choice 70 50.50.50 edge [size: 1x1] "LEFT" "RIGHT"
													[cybside: form sidebtn/text
													case [
														cybside = "LEFT" [status/text: "LEFT -> Motor : #11"
																		  show status
																		  motor: "#11"
																		  motorstart: leftstart
																		  motorend: leftstart
																		  motorstep: leftstep
																		  currentpos: leftstart]
														cybside = "RIGHT"  [status/text: "RIGHT -> Motor : #12"
																		  show status
																		  motor: "#12"
																		  motorstart: rightstart
																		  motorend: rightend
																		  motorstep: rightstep
																		  currentpos: leftstart]
											
														]
													]
       									
		at 100x335 button 70 50.50.50 edge [size: 1x1] "Draw" [ print "Loading.."
																print namefile
																eeg-data: read/lines namefile
																records: ( length? eeg-data ) - 1
																print records
																tsignal/text: ""
																show tsignal
																status/text: "Rendering..."
																show status
																print "Rendering..."
																count: 1
																current: 2
																endgraph: records - 1
																resetmind
																print current
																print endgraph
																for element current endgraph 1 [ 
															 		data-line: pick eeg-data element 
																	dataline: parse/all data-line ","
																	tcount/text: form element
																	show tcount
																	if dataline/1 <> "count" [
																		ysig: to-decimal dataline/2
																		yatt: to-decimal dataline/3
																		ymed: to-decimal dataline/4
																		ydelta: to-decimal dataline/5
																		ytheta: to-decimal dataline/6
																		ylalp: to-decimal dataline/7
																		yhalp: to-decimal dataline/8
																		ylbeta: to-decimal dataline/9
																		yhbeta: to-decimal dataline/10
																		ylgam: to-decimal dataline/11
																		yhgam: to-decimal dataline/12
																		yhgam: yhgam * 5
																		;print "yhgam mutliplier h"
																		doengine
																		]
																		
																	show eeg
																	wait 1
																	]
																]
     at 185x370 jlivebtn: button 70 50.50.50 edge [size: 1x1] "OSC O/F" [
										either osc <> 1 [
													osc: 1
       												oscport: open/lines tcp://localhost:13857
       												status/text: "Send OSC ON"
       												show status]
       												[
       												osc: 0
       												close oscport
       												status/text: "Send OSC Off"
       												show status
       												]
       									]
	at 20x370 multibtn: choice 70 50.50.50 edge [size: 1x1] "x1" "x2" "x5" "x10" "x20" "x50"
													[multi: form multibtn/text
													case [
														multi = "x1" [status/text: "Base multiplier"
																		 show status
																		 multiplier: basemultiplier]
														multi = "x2"  [status/text: "multiplier x2"
																		  show status
																		  multiplier: multiplier * 2]
														multi = "x5"  [status/text: "multiplier x5"
																		  show status
																		  multiplier: multiplier * 5]
														multi = "x10" [status/text: "multiplier x10"
																		  show status
																		  multiplier: multiplier * 10]
														multi = "x20" [status/text: "multiplier x20"
																		  show status
																		  multiplier: multiplier * 20]
														multi = "x50" [status/text: "multiplier x50"
																	      show status
																		  multiplier: multiplier * 50]						
														]
														]
	at 100x370 button 70 50.50.50 edge [size: 1x1] "GO O/F" [
										either forceset <> 1 [
													forceset: 1
       												status/text: "GO LED ON"
       												show status]
       												[
       												forceset: 0
       												status/text: "GO LED Off"
       												show status
       												]
										]
	
	at 20x127 button 70 50.50.50 edge [size: 1x1] "RobON" 	[robot: 1
															cybside: form sidebtn/text
															case [
															cybside = "LEFT" [cybrina: do reduce ajoin ["open/lines/no-wait tcp://" serialip ":" 13863]
																			  ]
															cybside = "RIGHT" [cybrina: do reduce ajoin ["open/lines/no-wait tcp://" serialip ":" 13864] 
																			   ]
															]
															status/text: "Link OK"
															show status
															]										
	at 100x127 button 70 50.50.50 edge [size: 1x1] "OFFline" [robot: 0							
															close cybrina
															close voiceport
															]
	at 185x127 button 70 50.50.50 edge [size: 1x1] "Voiceon" [
															cybside: form sidebtn/text
															case [
															cybside = "LEFT" [voiceport: do reduce ajoin ["open/direct/lines/no-wait tcp://" serialip ":" 13861]]
															cybside = "RIGHT" [voiceport: do reduce ajoin ["open/direct/lines/no-wait tcp://" serialip ":" 13862]]															]
															] 
		
;;       						
;; RECORD from Headset data
;;
	at 20x95 button 70 50.50.50 edge [size: 1x1] "Start" [
		status/text: "connect.."
		show status
		tp: open/binary/no-wait tcp://localhost:13854
		resetmind
		ctime: now/time
		nom: ajoin ["records/MW" now/date ctime/hour "h" ctime/minute "m" ".csv"]
		filename: probe to-file nom
		write/lines filename "count,signal,attention,meditation,delta,theta,lalpha,halpha,lbeta,hbeta,lgamma,hgamma,tasks"
		forever [  
			wait tp 
			data: copy tp
			signal: copy/part skip data 3 1
			ysig: to-integer signal
			tsignal/text: form ysig
			show tsignal
			attention: copy/part skip data 39 1
			yatt: to-integer attention
			meditation: copy/part skip data 41 1
			ymed: to-integer meditation
			delta: copy/part skip data 6 4
			ydelta: (from-ieee delta) / 1000
			theta: copy/part skip data 10 4
			ytheta: (from-ieee theta) / 1000
			lalp: copy/part skip data 14 4
			ylalp: (from-ieee lalp) / 1000
			halp: copy/part skip data 18 4
			yhalp: (from-ieee halp) / 1000
			lbeta: copy/part skip data 22 4
			ylbeta: (from-ieee lbeta) / 1000
			hbeta: copy/part skip data 26 4
			yhbeta: (from-ieee hbeta) / 1000
			lgam: copy/part skip data 30 4
			ylgam: (from-ieee lgam) / 1002
			hgam: copy/part skip data 34 4
			yhgam: (from-ieee hgam) / 998
			either ysig < 200  
				[doengine
				show eeg
				write/append filename reduce [form count "," form ysig "," form yatt "," form ymed "," form ydelta "," form ytheta "," form ylalp "," form yhalp "," form ylbeta "," form yhbeta "," form ylgam "," form yhgam ",noparadigm" ] 
				write/append filename "^/"
				]
				[status/text: "WRONG SIGNALS"
				instruc/text: "Mettre le casque"]
		show instruc
		show status
		]
	]
]

Set_TimeOut: func [newto] [
	oldto: system/schemes/default/timeout
	system/schemes/default/timeout: newto
]

Restore_TimeOut: does [
	system/schemes/default/timeout: oldto 
]

; Read prefs
readprefs: does [

;jDMX prefs
					prefs-data: read/lines %jresources/jDMX.conf
					allplage: length? prefs-data
					data-line: pick prefs-data 1  
					data-line: pick prefs-data 2           
					prefline: parse/all data-line " "
	    			serialip: prefline/1
	    			toserialip/text: serialip
	    			data-line: pick prefs-data 3          
					prefline: parse/all data-line " "
	    			ledlvl: prefline/1
					]				
; save prefs
saveprefs: does [filename: probe to-file "jresources/jDMX.conf"
;jDMX prefs
				delete filename	
				serialip: toserialip/text
				serialport: toserialport/text
				write/lines filename "Preferences jDMX"
				write/append filename reduce [form serialip]   
				write/append filename "^/"
				write/append filename reduce [form toledlvl/text]   
				write/append filename "^/"
				]

;
; Running point
;
Get_OS
readprefs
;check TGC server ?
checktgc: does [testtgc:open/binary/no-wait tcp://localhost:13854
				if error? try [insert testlighted "read"] [status/text: "TGC connexion error"
														  show status]
				]
;;
;; MIND LEVEL UI
;;
mind: layout [
	backdrop effect [gradient 1x1 0.0.0 50.50.50]
	at 10x40 mindlvlbox1: box 50x80 60.0.0 
	at 70x40 mindlvlbox2: box 50x80 60.0.0 
	at 130x40 mindlvlbox3: box 50x80 60.0.0 
	at 190x40 mindlvlbox4: box 50x80 60.0.0
	at 250x40 mindlvlbox5: box 50x80 60.0.0 
	at 310x40 mindlvlbox6: box 50x80 60.0.0 
	at 370x40 mindlvlbox7: box 50x80 60.0.0 
	at 430x40 mindlvlbox8: box 50x80 60.0.0 
	at 490x40 mindlvlbox9: box 50x80 60.0.0 
	at 550x40 mindlvlbox10: box 50x80 60.0.0 
	at 610x40 mindlvlbox11: box 50x80 60.0.0 
	at 670x40 mindlvlbox12: box 50x80 60.0.0
	at 50x10 countbox: box 630x20 0.60.0	]
;;
;; EEG UI
;;
eeg: layout [
	anti-alias on
	backdrop effect [gradient 1x1 0.0.0 50.50.50]
	text "Jackson EEG" white
   	box 900x120 effect reduce [
        'grid 17x17 50.50.50
        'draw plotatt
        'draw plothgam	
        'draw plotmed]
   	box 900x120 effect reduce [
        'grid 17x17 50.50.50
        'draw plotdelta
        'draw plottheta]
	box 900x120 effect reduce [
        'grid 17x17 50.50.50
        'draw plotlalp
        'draw plothalp]
	box 900x120 effect reduce [
        'grid 17x17 45.45.45
        'draw plotlbeta
        'draw plothbeta]
	bgam: box 900x120 effect reduce [
        'grid 17x17 45.45.45
        'draw plotlgam
        'draw plothgam]
 	at 115x20 text "Att/Med" 70.70.70
 	at 170x20 tatt: text "000" orange
	at 200x20 tmed: text "000" gray
 	at 265x20 text "delta/theta" 70.70.70
 	at 335x20 tdelta: text "000" snow
	at 365x20 ttheta: text "000" crimson
 	at 415x20 text "l/h alpha" 70.70.70
 	at 475x20 tlalp: text "000" snow
	at 505x20 thalp: text "000" green
	at 585x20 text "l/hbeta" 70.70.70
	at 620x20 tlbeta: text "000" snow
	at 650x20 thbeta: text "000" blue
 	at 735x20 text "l/h gamma" 70.70.70
 	at 795x20 tlgam: text "000" pink
	at 825x20 thgam: text "000" red
	;;at 450x20 text "Mesures : " gray
	;;at 550x20 text "Signal : " gray
	]
;;	 
;; Start UIs
;;
controllers/offset: eeg/offset + (eeg/size * 1x0) - 20x0		  
view/new controllers
view/new eeg
view/new mind
do-events