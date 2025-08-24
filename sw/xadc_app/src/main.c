#include "gpio.h"
#include "timer.h"
#include "sevenSegment.h"
#include "xadc.h"
#include "stdbool.h"
#include <stdint.h>
#include <float.h>
#include <math.h>
#include <assert.h>

/* ---------- User controls / channel IDs ---------- */
#define BTN_NEXT_BIT 0
#define TMP_REG      4
#define VCC_REG      5
#define BTN_PREV_BIT 1

/* ---------- Thermistor model (Beta equation) ---------- */
/* 1/T = 1/T25 + (1/Beta) * ln(R/R25)  =>  T(°C) = 1/(1/T25 + ln(R/R25)/Beta) - 273.15 */
#define TH_NTC_25DEG_FACTOR  (1.0f / 298.15f)   // 25 °C in Kelvin


static const float rth_nom = 100000.0f;   // R25 = 100 kOhm at 25 °C
static const float beta    = 4092.0f;     // Beta (K) ~4092 or 3950 depending on part

static const float Vsup     = 1.0f;        // node full-scale that maps to XADC 4095
static const float K_PRE    = 1.0f;        // pre-scaling factor between node and XADC
static const float R_SERIES = 20000.0f;    // series resistor in ohms (set to your actual value)

/* Simple assert alias so your existing macro compiles cleanly */
#define TH_ASSERT(x) assert(x)

/* Convert thermistor resistance to °C (Beta model) */
static float th_calc_ntc_temperature(const float rth, const float beta, const float rth_nom)
{
    TH_ASSERT(rth_nom > 0.0f);
    /* T = 1 / ( 1/T25 + (1/Beta) * ln(R/R25) ) - 273.15 */
    float tempC = (1.0f / (TH_NTC_25DEG_FACTOR + ((1.0f / beta) * logf(rth / rth_nom)))) - 273.15f;
    return tempC;
}

int main(void){
    init_platform();

    const uint64_t limit = 10000000ULL; // ~0.1 s @ 100 MHz (lower for snappier UI)
    uint64_t counter;

    uint8_t  channel     = 0;                 // 0..5 (0-3 ext, 4 temp, 5 vcc)
    uint16_t last_inputs = read_input();      // for button edge detect

    display_enable();
    display_send(0);

    timer_reset();
    timer_start();

    while (1) {
        /* --- Button rising edge -> next channel (0..5) --- */
    	uint16_t inputs = read_input();

    	bool next_now = (inputs      & (1u << BTN_NEXT_BIT)) != 0;
    	bool next_was = (last_inputs & (1u << BTN_NEXT_BIT)) != 0;
    	bool prev_now = (inputs      & (1u << BTN_PREV_BIT)) != 0;
    	bool prev_was = (last_inputs & (1u << BTN_PREV_BIT)) != 0;

    	bool next_rise = next_now && !next_was;
    	bool prev_rise = prev_now && !prev_was;

    	/* If exactly one rose, move accordingly; if both (or none), do nothing */
    	if (next_rise ^ prev_rise) {
    	    if (next_rise) {
    	        channel = (uint8_t)((channel + 1) % 6);      // 0->1->...->5->0
    	    } else { // prev_rise
    	        channel = (uint8_t)((channel + 5) % 6);      // decrement with wrap
    	        /* equivalent to: channel = (channel == 0) ? 5 : (channel - 1); */
    	    }
    	}

    	last_inputs = inputs;

        counter = timer_read();
        if (counter >= limit) {

            /* 1) Read the selected channel via YOUR API */
            uint32_t adc_val = read_adc(channel);

            /* 2) LED bar with per-channel ranges:
                  - ch 0,1,3,5 -> 0..4095
                  - ch 2,4     -> 0..100 (°C) */
            uint16_t mask = 0;
            if (channel == 0 || channel == 1 || channel == 3 || channel == VCC_REG) {
                /* 0..4095 range */
                uint16_t raw12 = (uint16_t)(adc_val & 0x0FFF);
                uint8_t leds_on = (uint32_t)(raw12 * 16u + 2047u) / 4095u; // rounded
                mask = (leds_on == 0) ? 0 : (uint16_t)((1u << leds_on) - 1u);
            } else if (channel == 2) {
                /* 0..100 °C range from thermistor */
                uint16_t raw12 = (uint16_t)(adc_val & 0x0FFF);
                float v_adc = (float)raw12 / 4095.0f;   // 0..1.000 V at XADC
                float Vnode = v_adc / K_PRE;
                if (Vnode < 1e-6f)         Vnode = 1e-6f;
                if (Vnode > Vsup - 1e-6f)  Vnode = Vsup - 1e-6f;
                float Rth = R_SERIES * Vnode / (Vsup - Vnode);
                float tempC = th_calc_ntc_temperature(Rth, beta, rth_nom);
                int32_t t = (tempC >= 0.0f) ? (int32_t)(tempC + 0.5f) : (int32_t)(tempC - 0.5f);
                if (t < 0)   t = 0;
                if (t > 100) t = 100;
                uint8_t leds_on = (uint32_t)(t * 16u + 50u) / 100u;       // rounded
                mask = (leds_on == 0) ? 0 : (uint16_t)((1u << leds_on) - 1u);
            } else if (channel == TMP_REG) {
                /* 0..100 °C range from internal temperature */
                uint16_t raw12 = (uint16_t)(adc_val & 0x0FFF);
                int32_t milliC = ((int32_t)raw12 * 503975 + 2048) / 4096 - 273150;
                int32_t degC = (milliC >= 0) ? (milliC + 500)/1000 : (milliC - 500)/1000;
                int32_t t = degC;
                if (t < 0)   t = 0;
                if (t > 100) t = 100;
                uint8_t leds_on = (uint32_t)(t * 16u + 50u) / 100u;       // rounded
                mask = (leds_on == 0) ? 0 : (uint16_t)((1u << leds_on) - 1u);
            }
            write_output(mask);

            /* 3) Decide what to show on 7-seg */
            uint32_t value_to_show;

            if (channel == TMP_REG) {
                /* XADC internal temperature (convert raw -> °C in fixed-point) */
                uint16_t raw12 = (uint16_t)(adc_val & 0x0FFF);
                // milliC = raw*503.975/4096 - 273.15
                int32_t milliC = ((int32_t)raw12 * 503975 + 2048) / 4096 - 273150;
                int32_t degC = (milliC >= 0) ? (milliC + 500)/1000 : (milliC - 500)/1000;
                value_to_show = (degC < 0) ? 0u : (uint32_t)degC;
            }
            else if (channel == VCC_REG) {
                /* VCC: using your existing scaling */
                value_to_show = adc_val * 24 / 10;
            }
            else if (channel == 2) {
                /* --- Thermistor on channel 2 ---
                   Convert ADC -> node voltage -> thermistor resistance -> °C */
                uint16_t raw12 = (uint16_t)(adc_val & 0x0FFF);
                float v_adc = (float)raw12 / 4095.0f;   // 0..1.000 V
                float Vnode = v_adc / K_PRE;
                if (Vnode < 1e-6f)         Vnode = 1e-6f;
                if (Vnode > Vsup - 1e-6f)  Vnode = Vsup - 1e-6f;
                float Rth = R_SERIES * Vnode / (Vsup - Vnode);
                float tempC = th_calc_ntc_temperature(Rth, beta, rth_nom);
                int32_t disp = (tempC >= 0.0f) ? (int32_t)(tempC + 0.5f) : (int32_t)(tempC - 0.5f);
                value_to_show = (disp < 0) ? 0u : (uint32_t)disp;
            }
            else {
                /* External channels 0,1,3: show exactly what read_adc() returns */
                value_to_show = adc_val;
            }

            /* 4) Encode to 8-digit BCD (LS nibble = ones) */
            uint32_t bcd = 0, tmp = value_to_show;
            for (int i = 0; i < 8; i++) {
                bcd |= ((tmp % 10u) << (i * 4));
                tmp /= 10u;
            }

            /* 5) Put CHANNEL index on the leftmost digit (digit 7).
               If your hardware only shows 4 digits, change <<28 to <<12. */
            bcd &= ~(0xFu << 28);
            bcd |= ((uint32_t)(channel & 0xF)) << 28;

            display_send(bcd);
            timer_restart();
        }
    }

    cleanup_platform();
    return 0;
}
