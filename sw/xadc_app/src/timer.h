#ifndef TIMER_H
#define TIMER_H

#include "platform.h"
#include "xil_printf.h"

void timer_reset(void);
void timer_start(void);
uint64_t timer_read(void);
void timer_restart(void);
#endif
