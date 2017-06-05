#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include<avr/io.h>
#include <avr/interrupt.h>


#include "main.h"
#include "lcd_drv.h"
#include "lcd_drv.c"
#define _mydefs_h_


char *time = "00:00:00:00";
int checker = 0;





void button_pressed()
{
	// start conversion
	ADCSRA |= 0x40;

	while (ADCSRA & 0x40)
		;
	unsigned int val = ADCL;
	unsigned int val2 = ADCH;

	val += (val2 << 8);

	
	if (val > 1000 )
	{	
		return;
	}else{
		if (checker ==0){
			checker = 1;
		}else{
			checker =0;
		}
	

	}

}


ISR(TIMER1_OVF_vect){
	interrupt();
  
}


void interrupt(){
	int hr_1 = (int)time[0];
	int hr_2 = (int)time[1];
	int min_1 = (int)time[3];
	int min_2 = (int)time[4];
	int sec_1 = (int)time[6];
	int sec_2 = (int)time[7];
	int mill_1 = (int)time[9];
	int mill_2 = (int)time[10];



	if (mill_2>57){
		mill_2 = 48;
		mill_1 +=1;
	}
	if(mill_1>57){
		mill_1 = 48;
		sec_2 += 1;
	}
	if (sec_2>57){
		sec_2 = 48;
		sec_1 += 1;
	}
	if (sec_1>53){
		sec_1 = 48;
		min_2 +=1;
	}
	if(min_2>57){
		min_2 = 48;
		min_1 += 1;
	}
	if (min_1>53){
		min_1 = 48;
		hr_2 +=1;
	}
	if(hr_2>57){
		hr_2 = 48;
		hr_1 += 1;
	}
	if (hr_1 >53){
		hr_1 =47;
	}

	mill_2 += 3.8;

	time[10] = (char)mill_2;
	time[9] = (char)mill_1;
	time[7] = (char)sec_2;
	time[6] = (char)sec_1;
	time[4] = (char)min_2;
	time[3] = (char)min_1;
	time[1] = (char)hr_2;
	time[0] = (char)hr_1;



	if (checker){
			display_1();
	}else{
			display();

	}



}
void init_timer(){

{
	/* set PORTL and PORTB for output*/
  

	// enable timer overflow interrupt for both Timer0 and Timer1
	TIMSK1 |=(1<<TOIE1);
	
  
  // set timer1 counter initial value to 0
	TCNT1=0x00;

	// lets turn on 16 bit timer1 also with /1024
	TCCR1B = 0x02;
	
	// enable interrupts
	sei(); 
	for(;;) {
	button_pressed();
	}


}

}




void init_button(){

	ADCSRA = 0x87;
	ADMUX = 0x40;
}

void display (){
	lcd_xy(0,0);
	lcd_puts(time);
	lcd_xy(0,1);
	lcd_puts(time);	
}


void display_1 (){
	lcd_xy(0,0);
	lcd_puts(time);
	}




int main (void)
{
	lcd_init();
	init_button();
	init_timer();

	return 0;	
}

