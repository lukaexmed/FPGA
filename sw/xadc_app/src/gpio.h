#ifndef GPIO_H
#define GPIO_H

#include "platform.h"
#include "xil_printf.h"

void write_output(uint16_t);
uint16_t read_input();
#endif
