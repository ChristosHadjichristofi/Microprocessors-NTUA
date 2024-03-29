			IN 10H
READ_BITS:		MVI B,01H		; B is pointer to bits
			LXI H,0A10H		; HL is where results are stored
			LDA 2000H		; Reading switches
			JMP FIRST_RUN		; Need this tag to avoid wrong store
TRAVERSE_BITS:	CPI 00H				; When A is zero, all bits traversed
			JZ  LAST_XOR		; So we need to do the XOR
			MOV A,C 		; Restore A's value which was stored in C
FIRST_RUN:		MOV C,A 		; Save A's value to C
			ANA B			; Keep Bi
			MOV D,A 		; D has Bi
			MOV A,B			; Getting B to A so as to move to next bit
			RAL 			; which is Ai. This is done by
			MOV B,A 		; multiplying B by 2
			CPI 08H			; If A is equal to 8 then AND gate
			JZ AND_GATE		; so we jump to AND_GATE
			CPI 80H			; If A is equal to 128 then AND gate
			JZ AND_GATE		; so we jump to AND_GATE
;------------------------or gate------------------------	
			MOV A,C 		; Restore A's value which was stored in C
			ANA B   		; Keep Ai
			RAR			; Moving Ai to the same position as Bi
			ORA D  			; OR Ai,Bi
			JMP SAVE		; Proceed to save
;------------------------endgate------------------------
;------------------------and gate------------------------
AND_GATE:		MOV A,C 		; Restore A's value which was stored in C
			ANA B   		; Keep Ai
			RAR			; Moving Ai to the same position as Bi
			ANA D 			; AND Ai,Bi
;------------------------end gate------------------------
SAVE:			MOV M,A			; Save result in memory
			INX H  			; Move the pointer to next pos
			MOV A,B			; Getting B to A so as to move to next bit
			RAL			; which B(i+1). This is done by
			MOV B,A			; multiplying B by 2
			JMP TRAVERSE_BITS	; Continue traverse of bits
			
LAST_XOR:		LDA 0A12H		; If we jumped here then last action
			MOV B,A			; must be operated. Which is XOR
			LDA 0A13H 		; So we load the last 2 results which 
			RAR			; are stored in 0A13 and 0A12. Two RARS
			RAR 			; must be done so as digits are in same 
			XRA B			; position.
			STA 0A13H 		; Store the result

;-------------------------------------------------------------
; B is an auxilary register so as to get the result ready.
; Loading to H the start of the "stack" that the results 
; are in.Moving whatever is inside Memory to A.Adding to
; the auxilary Register (B). Move to next elem of the "stack".
; Note that every RAR is done so as the bits are shown in the 
; correct position(led).
;-------------------------------------------------------------
PRINT:			MVI B,00H 		
			LXI H,0A10H 		
			MOV A,M 		
			ADD B			
			MOV B,A		
			INX H			

			MOV A,M 		
			RAR			
			ADD B			
			MOV B,A		
			INX H			

			MOV A,M		
			RAR			
			RAR 			
			ADD B		
			MOV B,A	
			INX H			

			MOV A,M 		
			RAR 			
			ADD B			
			CMA			; A = A' so as to print the right result
			STA 3000H		; Printing.
			JMP READ_BITS		; Moving to next input
END
			
			
