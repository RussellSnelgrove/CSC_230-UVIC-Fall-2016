#define LCD_LIBONLY
.include "lcd.asm"

.cseg



;	call lcd_init			; call lcd_init to Initialize the LCD
;	call init_strings
;	call display_strings
	


	ldi r16, 0x21
	out SPH, r16
	ldi r16, 0XFF
	out SPL, r16

	

		; initialize the Analog to Digital conversion

		ldi r16, 0x87
		sts ADCSRA, r16
		ldi r16, 0x40
		sts ADMUX, r16


main:	
	call lcd_init
	call lcd_clr
	call init_strings
	.def ccounter = r25
	.def rcounter = r26
	ldi r20,0x00
	jmp looper

looper:
	inc r20
	ldi rcounter,0x00
	ldi ccounter,0x00
	call display_strings
	call delay
	call loop2
	cpi r20,0x03
	breq done
	jmp looper

done:
	rjmp star

delay:	
	push r20
	push r21
	push r22

	ldi r20,0x08
del1:		nop
		ldi r21, 0xFF
del2:		nop
		ldi r22, 0xFF
del3:		nop
		call check_button
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1
		
	pop r22
	pop r21
	pop r20	
		ret



check_button:
		push r16
		push r17
		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
wait:	lds r16, ADCSRA
		andi r16, 0x40
;		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

		; put your new logic here:


;base case
; value < 0x032 - right button pressed
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed

;if_button:
		cpi r17,0x01
		brsh returner

;c2:
		cpi r16,0x32
		brsh checker
		jmp returner

checker:
		cpi r16,0xC3
		brsh returner
		call breaker_tester



returner:
		pop r17
		pop r16
		ret




breaker_tester:

		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
waiter:	lds r16, ADCSRA
		andi r16, 0x40
;		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

	
	
		cpi r17,0x02
		brsh breaker_tester
		cpi r17,0x01
		brsh l
		jmp d

l:
		cpi r16,0x7C
		brsh breaker_tester
		ret


d:
		cpi r16,0xC3
		brsh turn
		jmp breaker_tester

turn:
	ret


loop2:
	call lcd_clr

	;sets point to print from (0,0)
	push r16;;;;
	mov r16, rcounter
	push r16
	mov r16, ccounter
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the first line
	ldi r16, high(msg1)
	push r16
	ldi r16, low(msg1)
	push r16
	call lcd_puts
	pop r16
	pop r16

	call delay

	call lcd_clr
	
	; Now display msg2 on the second line
	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	call lcd_puts
	pop r16
	pop r16


	pop r16;;;;
	
	call delay

	inc rcounter
	inc ccounter

	call lcd_clr

	push r16
	mov r16, rcounter
	push r16
	mov r16, ccounter
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the first line
	ldi r16, high(msg1)
	push r16
	ldi r16, low(msg1)
	push r16
	call lcd_puts
	pop r16
	pop r16

	call delay

	call lcd_clr


	mov r16, rcounter
	push r16
	mov r16, ccounter
	push r16
	call lcd_gotoxy
	pop r16
	pop r16
	
	; Now display msg2 on the second line
	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	call lcd_puts
	pop r16
	pop r16


	pop r16
	
	call delay


	ret



init_strings:
	push r16
	; copy strings from program memory to data memory
	ldi r16, high(msg1)		; this the destination
	push r16
	ldi r16, low(msg1)
	push r16
	ldi r16, high(msg1_p << 1) ; this is the source
	push r16
	ldi r16, low(msg1_p << 1)
	push r16
	call str_init			; copy from program to data
	pop r16					; remove the parameters from the stack
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	ldi r16, high(msg2_p << 1)
	push r16
	ldi r16, low(msg2_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	ldi r16, high(msg3_p << 1)
	push r16
	ldi r16, low(msg3_p << 1)
	push r16
	call str_init
	pop r16
	pop r16
	pop r16
	pop r16

	pop r16
	ret

display_strings:

	; This subroutine sets the position the next
	; character will be output on the lcd
	;
	; The first parameter pushed on the stack is the Y position
	; 
	; The second parameter pushed on the stack is the X position
	; 
	; This call moves the cursor to the top left (ie. 0,0)

	push r16

	call lcd_clr

	ldi r16, 0x00
	push r16
	ldi r16, 0x00
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the first line
	ldi r16, high(msg1)
	push r16
	ldi r16, low(msg1)
	push r16
	call lcd_puts
	pop r16
	pop r16

	; Now move the cursor to the second line (ie. 0,1)
	ldi r16, 0x01
	push r16
	ldi r16, 0x00
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg2 on the second line
	ldi r16, high(msg2)
	push r16
	ldi r16, low(msg2)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16
	ret






star:

	push r16
	call delay
	call lcd_clr
	call delay
	ldi r16, 0x00
	push r16
	ldi r16, 0x06
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg1 on the first line
	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	call lcd_puts
	pop r16
	pop r16

	; Now move the cursor to the second line (ie. 0,1)
	ldi r16, 0x01
	push r16
	ldi r16, 0x06
	push r16
	call lcd_gotoxy
	pop r16
	pop r16

	; Now display msg2 on the second line
	ldi r16, high(msg3)
	push r16
	ldi r16, low(msg3)
	push r16
	call lcd_puts
	pop r16
	pop r16

	pop r16


jmp star


.


msg1_p:	.db "Russell Snelgrove", 0	
msg2_p: .db "CSC 230: Fall 2016", 0
msg3_p:	.db "****", 0


.dseg
;
; The program copies the strings from program memory
; into data memory.  These are the strings
; that are actually displayed on the lcd
;
msg1:	.byte 200
msg2:	.byte 200
msg3:	.byte 200


line1: .byte 17
line2: .byte 17
