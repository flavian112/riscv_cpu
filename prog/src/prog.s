.section .text
.globl _start

_start:


  addi t0, zero, 31
reset_loop:
  addi t6, zero, 0
loop:
  addi t6, t6, 1
  beq t6, t0, reset_loop
  j loop


halt_loop:
  j halt_loop

 
.section .data


.section .bss

.section .stack
  .space 0x1000  # Allocate stack space
stack_top:
