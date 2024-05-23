#include <stdint.h>

volatile uint32_t *io_in  = (volatile uint32_t *)0x00000000;
volatile uint32_t *io_out = (volatile uint32_t *)0x00000004;


int main(void) {
  while (1) {
    if (*io_in) *io_out = 0b11111;
    else        *io_out = 0b00000;
  }
}
