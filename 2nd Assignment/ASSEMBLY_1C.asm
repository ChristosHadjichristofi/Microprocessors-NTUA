ARXH:		IN 10H
		MVI A,FFH		; FFH=255 decimal
		LXI B,0900H 		; BC pair has memory location 0900H
		LXI D,0000H 		; INIT DE PAIR  
		MVI L,00H 		; L IS A COUNTER
			
LOOPA:  	STAX B 			; store accumulator to register pair HL
		DCR A			; A--;
		INX B 			; Move one memory space down
		CPI 00H 
		JNZ LOOPA
		;FINISHED INIT MATRIX STARTING IN 0900H
			
		LXI D,0900H 		; DE pair has memory location 0900H
DATA:		LDAX D 			;load contents of DE mem loc to A
		CPI 20H 		; Comparing A with 20H
		JC NEXT 		; If Carry = 1 then A < 20H
		CPI 70H 		; Comparin A with 70H
		JC IT_IS 		; If Carry = 1 then A < 70H.
MIGHTBE:	JZ IT_IS 		; If not might be equal to 70H.
		JMP NEXT 		; If Z = 1 then A = 70H. Else jump to next
IT_IS:		INR C 			; If all checks passed, then counter ++.
NEXT:		INX D 			; Move one memory space down
		INR L 			; L++ 
		MOV A,L 
		CPI 00H 		; compare L to 0 (256)
		JNZ DATA 	
		MOV A,C 		; Load content of C to A.
		CMA 			; Getting A ready for printing.
		STA 3000H 		; Printing content of A which is C.
END


