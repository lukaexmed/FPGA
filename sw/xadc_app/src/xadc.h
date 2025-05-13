#ifndef XADC_H
#define XADC_H

#include "platform.h"
#include "xil_printf.h"

uint16_t read_raw(int n);
double read_adc_in(int n);
double read_fpga_vcc();
double read_fpga_temp();
#endif
