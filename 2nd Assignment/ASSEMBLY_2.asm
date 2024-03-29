		IN 10H
		MVI D,00H		; Initiate D to zero.
		LXI B,0064H		; 100ms.Initiate E to 75dec.
START:		MVI E,4BH		; Because 75*(100ms+100ms) = 15s
		LDA 2000H		; Reading from dip switch.
		CMP D			; Compare A to previous value.
		MOV H,A 		; Save A to H.
		JC MUST_FLICKER   	; If C = 1 then switch went from ON --> OFF
       		MOV D,A         	; Keeping previous read of LSB Dip switch
       		JMP START         	; Start over, if switch didnt go from ON-->OFF

INIT_E:	MVI E,4BH			; Initiate E to 75dec.

MUST_FLICKER:	MVI A,00H 		; Making sure A is Zero, so flicker is right.
		STA 3000H		; print complement of A(11111111)
		CALL DELB		; delay to see result
		CMA			; complement zero so in outport 00000000 is 
		STA 3000H 		; shown.
		CALL DELB 		; delay to see result
		MOV A,H			; Restore A's current value.It was saved to H
		MOV D,A			; Keeping previous read of LSB Dip switch.
		LDA 2000H		; Reading from port.
		MOV H,A 		; Save A to H. 
		CMP D			; Compare A to previous value.
		JC INIT_E		; If C = 1 then switch went from ON --> OFF.
					; So restarting the timer.
		DCR E			; Decreasing the timer by one.
		MOV A,E			; Moving E to A, to compare if E reached
		CPI 00H			; zero. If yes then go back to start and 
		JZ START		; wait for an other input
		JMP MUST_FLICKER	; else continue the flickering ;)
END



