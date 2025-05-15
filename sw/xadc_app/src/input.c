#include "input.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT 1
#define READ (*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + 0) * 4))



uint16_t read_input(){
	return READ & 0x0000ffff;
}
