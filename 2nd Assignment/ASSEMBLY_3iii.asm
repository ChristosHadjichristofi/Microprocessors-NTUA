INIT:					IN 10H
					MVI A,10H		;fill memory spaces 0A10-0A13 HEX
					STA 0A10H		;with 10 (blank print in DCD)
					STA 0A11H
					STA 0A12H
					STA 0A13H
START:
;--------------------------------------------------------------------------
;For each line, declare its port, read key read port and decide based on
;last three digits(use ANI funct) the corresponding code to the button 
;pressed.Then, for each button pressed, DISPLAY subroutine is called.
;--------------------------------------------------------------------------
ZERO_LINE:				MVI A,FEH		; A=1111 1110
					STA 2800H		; declare scan port
					LDA 1800H 		; read from key read port
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_ONE
					CPI 06H   
					JZ INSTR_STEP
					CPI 05H 
					JZ FETCH_PC
FETCH_PC:				MVI A,85H
					JMP DISPLAY
INSTR_STEP:				MVI A,86H
					JMP DISPLAY
;--------------------------------------------------------------------------
LINE_ONE:				MVI A,FDH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_TWO
					CPI 06H   
					JZ RUN_BUTTON
					CPI 05H 
					JZ FETCH_REG
FETCH_ADDRESS:			MVI A,82H
					JMP DISPLAY
FETCH_REG:				MVI A,80H			
					JMP DISPLAY
RUN_BUTTON:				MVI A,84H
					JMP DISPLAY			
;--------------------------------------------------------------------------			
LINE_TWO:				MVI A,FBH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_THREE
					CPI 06H   
					JZ NUM_ZERO
					CPI 05H 
					JZ STORE_INCR
DCR:					MVI A,81H
					JMP DISPLAY
STORE_INCR:				MVI A,83H			
					JMP DISPLAY
NUM_ZERO:				MVI A,00H
					JMP DISPLAY					
;--------------------------------------------------------------------------
LINE_THREE:				MVI A,F7H 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_FOUR
					CPI 06H   
					JZ NUM_ONE
					CPI 05H 
					JZ NUM_TWO
NUM_THREE:				MVI A,03H
					JMP DISPLAY
NUM_TWO:				MVI A,02H			
					JMP DISPLAY
NUM_ONE:				MVI A,01H
					JMP DISPLAY
				
;--------------------------------------------------------------------------				
LINE_FOUR:				MVI A,EFH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_FIVE
					CPI 06H   
					JZ NUM_FOUR
					CPI 05H 
					JZ NUM_FIVE
NUM_SIX:				MVI A,06H
					JMP DISPLAY
NUM_FIVE:				MVI A,05H			
					JMP DISPLAY
NUM_FOUR:				MVI A,04H
					JMP DISPLAY
					
;--------------------------------------------------------------------------					
					
LINE_FIVE:				MVI A,DFH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_SIX
					CPI 06H   
					JZ NUM_SEVEN
					CPI 05H 
					JZ NUM_EIGHT
NUM_NINE:				MVI A,09H
					JMP DISPLAY
NUM_EIGHT:				MVI A,08H			
					JMP DISPLAY
NUM_SEVEN:				MVI A,07H
					JMP DISPLAY
;--------------------------------------------------------------------------
LINE_SIX:				MVI A,BFH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ LINE_SEVEN   
					CPI 06H   
					JZ ALPHA
					CPI 05H 
					JZ BETA
LETTER_C:				MVI A,0CH
					JMP DISPLAY
BETA:					MVI A,0BH		
					JMP DISPLAY
ALPHA:					MVI A,0AH
					JMP DISPLAY
;--------------------------------------------------------------------------
LINE_SEVEN:				MVI A,7FH 
					STA 2800H 
					LDA 1800H 
					ANI 07H   		; CHECK LAST 3 BITS
					CPI 07H
					JZ START  		; LOOP AGAIN
					CPI 06H   
					JZ DELTA
					CPI 05H 
					JZ EPSILON
LETTER_F:				MVI A,0FH
					JMP DISPLAY
EPSILON:				MVI A,0EH			
					JMP DISPLAY
DELTA:					MVI A,0DH
					JMP DISPLAY	
;---------------------------------------------------					
					
DISPLAY:				MOV L,A   		;Temporary save of A to L
					ANI F0H   		;ISOLATE 4 MSBs
					RRC
					RRC	    		;Move 4 MSBs to LSB
					RRC	    		;positions.
					RRC	    
					STA 0A15H 		;Store MSBs to leftmost display pos
					MOV A,L   		;Restore A to acquire LSBs
					ANI 0FH  		;ISOLATE 4 LSB
					STA 0A14H 		;Store MSBs to 2nd leftmost disp pos
					LXI D,0A10H 		;Give Code startin address.
					CALL STDM 
					CALL DCD
					JMP START
END

					
						