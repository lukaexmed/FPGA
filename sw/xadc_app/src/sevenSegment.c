#include "sevenSegment.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT 4


#define SEG_CONF (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 0) * 4))  //0xC0000180
#define SEG_DATA (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 1) * 4)) //0xC0000184


void display_enable(){
	SEG_CONF = 0x00000001;
}

void display_send(uint32_t data){
	SEG_DATA = data;
}
