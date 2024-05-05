#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

uint32_t registers[32];

uint32_t read_reg(uint32_t addr) { return addr == 0 ? 0 : registers[addr]; }

void write_reg(uint32_t addr, uint32_t data, bool we) {
  if (addr != 0 && we)
    registers[addr] = data;
}

void test(uint32_t addr_rs0, uint32_t addr_rs1, uint32_t addr_rd2,
          uint32_t data_rd2, bool we) {
  write_reg(addr_rd2, data_rd2, we);
  uint32_t data_rs0 = read_reg(addr_rs0);
  uint32_t data_rs1 = read_reg(addr_rs1);
  printf("%08X_%08X__%08X_%08X__%08X_%08X_%01X\n", addr_rs0, data_rs0, addr_rs1,
         data_rs1, addr_rd2, data_rd2, we);
}

void tests(int num) {
  for (int i = 0; i < num; ++i) {
    uint32_t addr_rs0 = ((uint32_t)((rand() << 16) | rand())) % 32;
    uint32_t addr_rs1 = ((uint32_t)((rand() << 16) | rand())) % 32;
    uint32_t addr_rd2 = ((uint32_t)((rand() << 16) | rand())) % 32;
    uint32_t data_rd2 = ((uint32_t)((rand() << 16) | rand()));
    bool we = ((uint32_t)rand()) % 2;
    test(addr_rs0, addr_rs1, addr_rd2, data_rd2, we);
  }
}

int main(int argc, const char *argv[]) {
  srand(time(NULL));
  for (int i = 0; i < 32; ++i)
    registers[0] = 0;

  for (int i = 0; i < 32; ++i)
    test(i, i, 0, 0, false);

  for (int i = 0; i < 32; ++i)
    test(i, i, i, 0xffffffff, true);

  tests(1000);
  return 0;
}
