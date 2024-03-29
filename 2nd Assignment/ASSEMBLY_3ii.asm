IN 10H
INIT:       MVI L,00H 	            ; L is a counter for flicker times 
            LXI B,1388H             ; 5000 ms delay
            CALL KIND  	            ; read input from keyboard
            CPI 00H	            ; IF A==0 then error-read again
            JZ INIT
            CPI 08H  	            ; IF A>8 then error-read again
            JZ CONTINUE	            ; else continue
            JNC INIT	
CONTINUE:   CPI 05H 	            ; (A >= 5) ? MSB : LSB 
            JNC MSB	
LSB:        MVI A,F0H  	            ; A is not(0000 1111) 
            STA 3000H 	            ; print A in 3000H
            CALL DELB	            ; delay to see result
            MVI A,FFH	            ; A is not (0000 0000)
            STA 3000H 	            ; print A in 3000H
            CALL DELB 	            ; delay to see result
            INR L 	            ; L++
            MOV A,L	            ; Move L to A so as to compare
            CPI 04H 	            ; compare A(which is L) with 4
            JZ INIT 	            ; repeat program
            JMP LSB	            ; else jump to LSB, to flicker L times
MSB:        MVI A,0FH  	            ; A IS NOT(1111 0000) 
            STA 3000H 	            ; print A in 3000H
            CALL DELB	            ; delay to see result
            MVI A,FFH	            ; A is not (0000 0000)
            STA 3000H 	            ; print A in 3000H
            CALL DELB 	            ; delay to see result
            INR L 	            ; L++
            MOV A,L	            ; Move L to A so as to compare
            CPI 04H 	            ; compare A(which is L) with 4
            JZ INIT 	            ; repeat program
            JMP MSB	            ; else jump to MSB, to flicker L times

END

