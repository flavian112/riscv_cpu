.section .text
.globl _start

_start:
  
  # testing alu
/*
  addi  t0, zero, 5
  addi  t1, zero, 3
  
  #add   t2, t0,   t1
  #sub   t2, t0,   t1
  
  xor   t2, t0,   t1
  or    t2, t0,   t1
  and   t2, t0,   t1

  slt   t2, t0,   t1
  slt   t2, t1,   t0

  addi  t0, zero, -1

  slt   t2, t0,   t1
  slt   t2, t1,   t0

  sltu  t2, t0,   t1
  sltu  t2, t1,   t0

  addi  t0, zero, 1

  sll   t2, t0,   31 
  sra   t2, t2,   31
  sll   t2, t0,   31 
  srl   t2, t2,   31
*/

 
#  jal target
#  addi  t0, zero, 2
#0010 0000

# addi  t0, zero, 0x0010
# slli  t0, t0,   16
# ori   t0, t0,   0x0000

# addi  t1, zero, 0xff
# sw    t1, 0(t0)
# lw     t2, 0(t0)

  addi t0, zero, 1
  addi t1, zero, 2
  bge t0, t1, branch_taken
  addi t2, zero, 1


halt_loop:
  j halt_loop

branch_taken:
  addi t2, zero, 2
  j halt_loop

#target:
#  addi  t0, zero, 1
#  jalr  zero, ra, 0
 
.section .data


.section .bss

.section .stack
  .space 0x1000  # Allocate stack space
stack_top:
