#include "gpio.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT_IN 1
#define SLOT_OUT 0
#define READ (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT_IN) << 5) + 0) * 4))
#define WRITE(data32)	(*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT_OUT) << 5) + 0) * 4) = (data32))

//vsak od 16 bitov predstavlja eno ledico, ko je 1 je prizgana, ko je 0 je vgasnjena
void write_output(uint16_t data16){
	WRITE((uint32_t)data16);
}

//prebere 32 bitni register, prvi 16 predstavlja input switche, ko je 1 je switch prizgan, ko je 0 je vgasjen
uint16_t read_input(){
	return READ & 0x0000ffff;
}
