#include "xadc.h"

#define BRIDGE_BASE 0xC0000000
#define SLOT 3
#define ADC0_REG 0
#define TMP_REG	4
#define VCC_REG 5
#define read(base , offset)	(*(volatile uint32_t *)(base + (((SLOT) << 5) + offset) * 4))



uint16_t read_raw(int n){
	uint16_t rd_data;
	rd_data = (uint16_t) read(BRIDGE_BASE, ADC0_REG+n) & 0x0000ffff; //mask to fit 16bit status register
	rd_data = rd_data >> 4;
	return (double)(rd_data)/40.96;
}
double read_adc(int n){

	uint32_t data = (uint16_t) read(BRIDGE_BASE, ADC0_REG+n) & 0x0000ffff; //mask to fit 16bit status register
	data = (data >> 4) /0.40960; // adc is 12 bit, hence the shift is needed, first half of seven segs is whole, the other decimal
	if(n == VCC_REG){
		data *= 3.0;
	}
	else if(n == TMP_REG){
		data = data * 503.975 - 273.15;
	}
	return ((double)data);
}
double read_fpga_vcc(){
	return (read_adc_in(VCC_REG)*3.0); //-1 to 1 voltage to 3V
}
double read_fpga_temp(){
	return (read_adc_in(TMP_REG)*503.975 - 273.15); //
}
