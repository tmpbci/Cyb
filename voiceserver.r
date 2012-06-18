
    REBOL [ Title: "Cybrina voice Server" ]
  
  saycommand: "say -v Victoria "
        listen: open/direct/lines/no-wait tcp://:13860
        wait listen
        port: first listen



  view/new win: layout [
        text "Say the upcoming text from tcp 13860"
        display: info "" 300x200
        button "quit" [
            close port
            close listen
            unview quit
        	]
    	]
    win/offset: 40x40
    show win

    forever [
        wait port
        foreach msg any [copy port []] [
            append display/text join msg newline
            print msg
     		commande: ajoin [saycommand " " msg]
			call reduce [commande]
        	]
        show display
    	]