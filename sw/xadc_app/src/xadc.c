#include "xadc.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT 3
#define TMP_REG	4
#define VCC_REG 5
#define read(offset)	(*(volatile uint32_t *)(BRIDGE_BASE + (((SLOT) << 5) + offset) * 4))


uint32_t read_adc(int n){
uint32_t read_adc(int n){

	//0-3 are adc inputs, 4-5 are internals
	uint32_t data = read(n) & 0x0000ffff; //mask to fit 16bit status register
	//data = (data >> 4) /4096;
	data = (data >> 4);// adc is 12 bit, hence the shift is needed, /4096
	/*if(n == VCC_REG){
		//data je med 0x000 in 0xfff to je med 0.0V in 1.0V
		data *= 24;
		data /= 10;
	}
	else if(n == TMP_REG){
		data = data * 503.975 - 273.15;
	}*/
	return data;
}
