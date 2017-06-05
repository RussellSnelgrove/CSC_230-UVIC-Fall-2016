;
; a2q1.asm
;
; Write a program that displays the binary value in r16
; on the LEDs.
;
; See the assignment PDF for details on the pin numbers and ports.
;
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B



		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output

		ldi r16, 0x33		; display the value
		mov r0, r16			; in r0 on the LEDs

; Your code here
clr r17
clr r18
mov r20,r0
.def right=r17
.def left=r18

case1:
	mov r20,r0
	andi r20,1
	cpi r20,1
	brne case2
	ori r17,0b10000000

case2:
	mov r20,r0
	andi r20,2
	cpi r20,2
	brne case3
	ori r17,0b00100000

case3:
	mov r20,r0
	andi r20,4
	cpi r20,4
	brne case4
	ori r17,0b00001000

case4:
	mov r20,r0
	andi r20,8
	cpi r20,8
	brne case5
	ori r17,0b00000010

case5:
	mov r20,r0
	andi r20,16
	cpi r20,16
	brne case6
	ori r18,0b00000010

case6:
	mov r20,r0
	andi r20,32
	cpi r20,32
	brne final
	ori r18,0b00001000

final:

	sts PORTL, r17		; PORTB all output
	sts PORTB, r18		; PORTL all output


;
; Don't change anything below here
;
done:	jmp done
