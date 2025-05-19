#include "timer.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT (2)

#define TIMER_CONF (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 0) * 4))  //0xC0000100
#define TIMER_CNTL (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 1) * 4)) //0xC0000104
#define TIMER_CNTH (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 2) * 4)) //0xC0000108

void timer_reset(){
	TIMER_CONF = 0x00000001;
}

void timer_start(){
	TIMER_CONF = 0x00000002;
}

void timer_restart(){
	timer_reset();
	timer_start();
}

uint64_t timer_read(){
	return (uint64_t)TIMER_CNTH << 32 | TIMER_CNTL;
}
