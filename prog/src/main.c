#include <stdint.h>

//volatile uint32_t *io_in  = (volatile uint32_t *)0x00000000;
//volatile uint32_t *io_out = (volatile uint32_t *)0x00000004; 

int main(void) {
  while (1) {
    for (int i = 0; i < 32; ++i) {
      *((volatile uint32_t *)0x00000004) = i;
      for (int j = 0; j < 1024 * 128; ++j);
    }
  }
}
