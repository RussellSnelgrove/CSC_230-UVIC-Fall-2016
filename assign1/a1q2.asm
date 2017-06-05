;
; CSc 230 Assignment 1 
; Question 2
; Author: Jason Corless
 ; Modified: Sudhakar Ganti
 
; This program should calculate:
; R0 = R16 + R17
; if the sum of R16 and R17 is > 255 (ie. there was a carry)
; then R1 = 1, otherwise R1 = 0
;

;--*1 Do not change anything between here and the line starting with *--
.cseg
	ldi	r16, 0xF0
	ldi r17, 0x21
;*--1 Do not change anything above this line to the --*

;***
;---------------------------
;Question: What are we trying to do in this program? What is the
;meaning of if sum > 255 then set R1=1?
;Why did we say that if sum > 255 then there was a carry?
;Answer: We are taking the sum of the two numbers and saying when the sum is larger than the allocated bits can
;		 represent to add 1 to R1. This is like a stack overflow and it is the equivalent of carrying a 1 in
;		 decimails when the tens column is over 9 then carry the 1 to the hundreds column. The maximum number
;		 the availble bits can represent is 255.
;---------------------------
; Your code goes here:

	add r16,r17 ;add r16 and r17
	mov r0,r16	;movs r16 number into r17
	sev			;sets v flag to 1 if the addition of r16 and r17 excends 255
	brvs overfl ; if overflow flag is caught jump to overfl
	jmp done	; if overflow flag is not triggered then the system is done


overfl:
	ldi r18, 0x01	; sets R18 to 1 to set R1 to 1 in the future.
	mov r1,r18	; sets R1 to 1

;****
;--*2 Do not change anything between here and the line starting with *--
done:	jmp done
;*--2 Do not change anything above this line to the --*


