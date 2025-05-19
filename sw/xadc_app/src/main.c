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
    bool rising = true;

    display_enable();
    display_send(seconds);

    timer_reset();
    timer_start();
    while(1){

    	counter = timer_read();
    	choice = read_input();

    	if(counter >= limit){
    		//light mechanism
    		if(lights == 0xFFFF)
    			rising = !rising;
    		lights = rising ? (lights << 1) + 1 : (lights >> 1) - 1 ;//rising lights
    		write_output(lights);

    		seconds++;
    		uint32_t temp = (uint32_t)read_adc(0);
    		//double temp = 1234.7890;
    		uint32_t display = 0;
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
