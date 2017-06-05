;
; CSc 230 Assignment 1 
; Question 1
; Author: Jason Corless
; Modified: Sudhakar Ganti

; This program should calculate:
; R0 = R16 + R17 + R18
;
;--*1 Do not change anything between here and the line starting with *--
.cseg
	ldi	r16, 0x20
	ldi r17, 0x21
	ldi r18, 0x22

;*--1 Do not change anything above this line to the --*

;***
;-------------------------
; Question: Why did we use r16 to r18? Can we use r0 to 15?
; Answer: The registers 16 to 18 were chossen because the allocated memory is 4 bits and when the 
; 		  langauge was created the programers decieded to use the upper end of the availble numbers
;         this meaning that 16,17,18 would be most logical to use because they are the first numbers in the upper half.
;		  We cannot use registers 0 to 15.
;		  
;-------------------------
; Your code goes here:
;
;	lds r0,0x00
	add r16,r17 ;add R16 and R17
	add r16,r18 ;add R16 and R18
	mov r0,r16	;copying the numerical value in R16 to R0

;****

;--*2 Do not change anything between here and the line starting with *--
done:	jmp done
;*--2 Do not change anything above this line to the --*


