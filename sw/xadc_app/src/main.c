#include "gpio.h"
#include "timer.h"
#include "sevenSegment.h"
#include "xadc.h"
#include "stdbool.h"

int main(){
    init_platform();

    uint64_t counter, limit;
    uint32_t seconds = 0;
    uint32_t choice = 4; //(default is temperature)

    limit = 100000000; //resfresh every 1s
    uint16_t lights = 0;
    bool rising = false;

    display_enable();
    display_send(seconds);

    timer_reset();
    timer_start();
    while(1){

    	counter = timer_read();
    	choice = read_input();

    	if(counter >= limit){
    		//light mechanism
    		//if(lights == 0xFFFF || lights == 0x0000)
    		//	rising = !rising;
    		//lights = rising ? (lights << 1) + 1 : (lights >> 1) ;//rising lights
    		//write_output(lights);

    		uint16_t raw = (uint16_t)read_adc(0) & 0x0FFF;

    		    	    // 2) compute how many LEDs: round(raw*16/4095)
    		    	    uint8_t leds_on = (raw * 16 + 2047) / 4095;

    		    	    // 3) build a 16-bit mask: lowest leds_on bits = 1
    		    	    uint16_t mask = (leds_on == 0)
    		    	    				? 0
    		    	    				: (uint16_t)((1U << leds_on) - 1);

    		    	    // 4) output to the LEDs
    		    	    write_output(mask);


    		seconds++;
    		uint16_t temp = (uint16_t)read_adc(5);
    		//uint16_t temp = 1234.7890;
    		uint16_t display = 0;
    		//converting from hex to dec
    		for(int i = 0; i < 8; i++){
    			display = display | ((temp % 10) << i*4); //
    			temp = temp / 10;
    		}

    	    display_send(display);
    	    timer_restart();
    	}
    }

	cleanup_platform();
	return 0;
}
