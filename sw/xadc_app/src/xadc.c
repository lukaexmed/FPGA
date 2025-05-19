#include "xadc.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT 3
#define TMP_REG	4
#define VCC_REG 5
#define read(offset)	(*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + offset) * 4))


double read_adc(int n){

	//0-3 are adc inputs, 4-5 are internals
	uint32_t data = (uint16_t) read(n) & 0x0000ffff; //mask to fit 16bit status register
	data = (data >> 4) /4096; // adc is 12 bit, hence the shift is needed, /4096
	if(n == VCC_REG){
		data *= 3.0;
	}
	else if(n == TMP_REG){
		data = data * 503.975 - 273.15;
	}
	return ((double)data);
}
