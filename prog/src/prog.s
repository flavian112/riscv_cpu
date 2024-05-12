.section .text
.globl _start

_start:
  
  addi t0, zero, 3
  addi t1, zero, 5
  add  t2, t0, t1


halt_loop:
  j halt_loop

 
.section .data


.section .bss

.section .stack
  .space 0x1000  # Allocate stack space
stack_top:
