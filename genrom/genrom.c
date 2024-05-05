#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int rom_size = 1024;

  for (uint32_t i = 0; i < rom_size; ++i) {
    printf("%02x\n", i % 32);
  }
}
