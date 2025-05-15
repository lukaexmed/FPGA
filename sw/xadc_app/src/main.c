#include "timer.h"
#include "sevenSegment.h"
#include "xadc.h"
#include "input.h"

int main(){
    init_platform();

    uint64_t counter, limit;
    uint32_t seconds = 0;
    uint32_t choice = 4; //(default is temperature)

    limit = 50000000; //resfresh every 0.5 s

    display_enable();
    display_send(seconds);

    timer_reset();
    timer_start();
    while(1){

    	counter = timer_read();
    	choice = read_input();

    	if(counter >= limit){
    		seconds++;
    		uint32_t temp = (uint32_t)read_raw(0);
    		//double temp = 1234.7890;
    		uint32_t display = 0;
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
