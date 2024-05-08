.section .text
.globl _start

_start:
  #la sp, stack_top
    
  #li a0, 10
  #li a1, 20
  #add a2, a0, a1
  addi  t0, zero, 5
  addi  t1, zero, 3
  add   t2, t0,   t1

halt_loop:
  j halt_loop

.section .data


.section .bss

.section .stack
  .space 0x1000  # Allocate stack space
stack_top:
