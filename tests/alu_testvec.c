#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef enum {
  ADD = 0b0000,
  SUB = 0b0001,
  SLT = 0b0011,

  AND = 0b0100,
  OR = 0b0101,
  XOR = 0b0110,

  SLL = 0b1000,
  SRL = 0b1001,
  SRA = 0b1011,
} OP;

void test_op(OP op, uint32_t a, uint32_t b) {
  uint32_t result;
  bool zero;

  switch (op) {
  case ADD:
    result = a + b;
    break;
  case SUB:
    result = a - b;
    break;
  case SLT:
    result = (int32_t)a < (int32_t)b;
    break;

  case AND:
    result = a & b;
    break;
  case OR:
    result = a | b;
    break;
  case XOR:
    result = a ^ b;
    break;

  case SLL:
    result = a << b % 32;
    break;
  case SRL:
    result = a >> b % 32;
    break;
  case SRA:
    result = ((int32_t)a) >> b % 32;
    break;
  }

  zero = result == 0;

  printf("%01X__%08X_%08X__%08X_%01X\n", op & 0x0f, a, b, result, zero);
}

void test_op_random(OP op, int num) {
  for (int i = 0; i < num; ++i) {
    uint32_t a = (rand() << 16) | rand();
    uint32_t b = (rand() << 16) | rand();
    test_op(op, a, b);
  }
}

int main(int argc, const char *argv[]) {
  srand(time(NULL));

  test_op_random(ADD, 1000);
  test_op(ADD, 0x00000000, 0x00000000);
  test_op(ADD, 0xffffffff, 0xffffffff);
  test_op(ADD, 0xffffffff, 0x00000001);
  test_op_random(SUB, 1000);
  test_op(SUB, 0xffffffff, 0xffffffff);
  test_op_random(SLT, 1000);
  test_op(SLT, 0x8fffffff, 0xffffffff);
  test_op(SLT, 0xffffffff, 0x00000001);
  test_op(SLT, 0x00000001, 0xffffffff);

  test_op_random(OR, 1000);
  test_op(OR, 0x00000000, 0x00000000);
  test_op(OR, 0xffffffff, 0x00000000);
  test_op(OR, 0x00000000, 0xffffffff);
  test_op(OR, 0xffffffff, 0xffffffff);
  test_op_random(AND, 1000);
  test_op(AND, 0x00000000, 0x00000000);
  test_op(AND, 0xffffffff, 0x00000000);
  test_op(AND, 0x00000000, 0xffffffff);
  test_op(AND, 0xffffffff, 0xffffffff);
  test_op_random(XOR, 1000);
  test_op(XOR, 0x00000000, 0x00000000);
  test_op(XOR, 0xffffffff, 0x00000000);
  test_op(XOR, 0x00000000, 0xffffffff);
  test_op(XOR, 0xffffffff, 0xffffffff);

  test_op_random(SLL, 1000);
  test_op(SLL, 0x0000000f, 0x00000004);
  test_op(SLL, 0xffffffff, 0x0000001c);
  test_op(SLL, 0xf0000000, 0x00000002);
  test_op(SLL, 0x01234567, 0x00000001);
  test_op_random(SRL, 1000);
  test_op(SRL, 0xf0000000, 0x0000001c);
  test_op(SRL, 0x0000000f, 0x0000004);
  test_op_random(SRA, 1000);
  test_op(SRA, 0xf0000000, 0x0000001c);
  test_op(SRA, 0x0000000f, 0x0000004);

  return 0;
}
