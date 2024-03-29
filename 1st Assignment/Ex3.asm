; a program that converts any 8bit binary number to its BCD where 
; the first 4 MSB digits represent the tens and the 4 LSB  represent the units

ORG 0800H
LOOP1:			LDA 2000H 		; reads the input from the dip switches
			MVI B,00H 		; counter for tens
STILL_GREATER:		CPI 64H 		; input == 100(decimal) ?
			JNC GREATER_OR_EQUAL_100
			CMC 			; we need to reset CY flag due to previous comparison
TENS:			CPI 0AH			; compare input with 10
			JC UNITS 		; if A is less than 10 then we have no tens
			SUI 0AH 		; Subtract 10 from accumulator(input)
			INR B 			; tens++
			JMP TENS 		; loop until no more TENS exist
			
UNITS:			CMC 			; we need to reset CY flag due to previous comparison
			MOV C,A 		; temporary hold of the units
			MOV A,B 		; pass the tens to the accumulator
			RAL 			; with the next 4 RAL , we move the last four
			RAL 			; digits of accumulator to the 4 MSB digits
			RAL 			; because A now holds the tens
			RAL 			; then we sum A and C to have the
			ADD C 			;complete form TTTTUUUU(T = TENS , U = UNITS)
			CMA 			; now do the printing
			STA 3000H
			JMP LOOP1

GREATER_OR_EQUAL_100:	SUI 64H 		; subtract 100 from the accumulator
			JMP STILL_GREATER
END
