;
; a2q2.asm
;
;
; Turn the code you wrote in a2q1.asm into a subroutine
; and then use that subroutine with the delay subroutine
; to have the LEDs count up in binary.
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B


; Your code here
; Be sure that your code is an infite loop


ldi r16, 0x00		; display the value
mov r0, r16			; in r0 on the LEDs

start:
call display
inc r0
ldi r20,0x0C
call delay
jmp start

done:		jmp done	; if you get here, you're doing it wrong

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:


ldi r17,0x00
ldi r18,0x00

case1:
	mov r24,r0
	andi r24,1
	cpi r24,1
	brne case2
	ori r17,0b10000000

case2:
	mov r24,r0
	andi r24,2
	cpi r24,2
	brne case3
	ori r17,0b00100000

case3:
	mov r24,r0
	andi r24,4
	cpi r24,4
	brne case4
	ori r17,0b00001000

case4:
	mov r24,r0
	andi r24,8
	cpi r24,8
	brne case5
	ori r17,0b00000010

case5:
	mov r24,r0
	andi r24,16
	cpi r24,16
	brne case6
	ori r18,0x08

case6:
	mov r24,r0
	andi r24,32
	cpi r24,32
	brne final
	ori r18,0x02

final:

	sts PORTL, r17		; PORTB all output
	sts PORTB, r18		; PORTL all output


		ret
;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; registers used:
;	r20
;	r21
;	r22
;
delay:	
del1:	nop
		ldi r21,0xFF
del2:	nop
		ldi r22, 0xFF
del3:	nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret
