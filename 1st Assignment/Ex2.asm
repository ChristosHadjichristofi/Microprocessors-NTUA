ORG 0800H	
			IN 10H
			MVI D,01H
			LDA 2000H
			CMA
			STA 3000H		; D=1, LOADS 1st "bit" of switches 
			LXI B,0244H     	; 0244H = 580
			CALL DELB     		; delay 0.58s
INCREASE:   		LDA 2000H			
			CPI 01H			
			JC CYCLE		; if A<1 then CY=1, GO TO CYCLE 
			CPI 02H
			JZ LIGHT_LED0		; if A=2 turn on led 0 only
			CMC			; get rid of carry
			MOV A,D			; else A=D
			RAL			; A=2*A
			CPI 00H			; if A==0 (leftmost bit of A has gone a full cycle) go to DECREASE
			JZ DECREASE		
			MOV D,A			; ELSE  (D=A=2*Aold)
			CMA				
			STA 3000H		; complement A to turn on corresponding led.
			LXI B,0244H     	; 0244H = 580
			CALL DELB     		; delay 0.58s
			JMP INCREASE		; repeat till full cycle or switches change

DECREASE:   		LDA 2000H
			CPI 01H
			JC CYCLE		; If A<1 then CY=1 , go to cycle
			CPI 02H
			JZ LIGHT_LED0		; if A=2 turn on led 0 only
			CMC
			MOV A,D
			RAR			; A=A/2,right shift
			CPI 00H
			JZ INCREASE		; Do this till all bits have been shifted right,
			MOV D,A			; so A=0 ,then go to increase
			CMA			
			STA 3000H		;complement A to turn on corresponding led.
			LXI B,0244H    		; 0244H = 580
			CALL DELB     		; delay 0.58s
			JMP DECREASE
	
CYCLE_INIT: 		MVI D,01H
			MOV A,D
			CMA
			STA 3000H
			LXI B,0244H     	; 0244H = 580
			CALL DELB     		; delay 0.58s

CYCLE:  		LDA 2000H
			CPI 01H
			JZ INCREASE  		; IF A==1 go to increase-decrease mode
			CPI 02H
			JZ LIGHT_LED0  		; If A=2 turn on led 0 only
			CMC
			MOV A,D			
			RAL			; else continue from LED that was last on and do cycle mode 
			CPI 00H
			JZ CYCLE_INIT  		; Difference from increase-decrease is we reinit starting 
			MOV D,A			; led when led-on reaches last led.
			CMA		
			STA 3000H		; print
			LXI B,0244H		; 0244H = 580
			CALL DELB    		; delay 0.58s
			JMP CYCLE		; delay
			
LIGHT_LED0: 		LDA 2000H
			CPI 01H
			JZ INCREASE  		; if A=1 go to increase-decrease mode
			JC CYCLE		; if  A=1 go to cycle
			RAR
			CMA			; do a right shift so that led 1 turns on
			STA 3000H
			JMP LIGHT_LED0		; repeat till A changes
END
