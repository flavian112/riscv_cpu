.section .text
.globl test_prog


/*
  addi t0, zero, 31
reset_loop:
  addi t6, zero, 0
loop:
  addi t6, t6, 1
  beq t6, t0, reset_loop
  j loop
*/

test_prog:
  li t0, 0xFFFFFFFF
  li t1, 0x33333333
  li t2, 0x88888888
  li t3, 0x11111111

  add   t4, t1,   t2
  sub   t4, t1,   t2
  slt   t4, t3,   t0
  slt   t4, t0,   t3
  sltu  t4, t3,   t0
  sltu  t4, t0,   t3
  and   t4, zero, zero
  and   t4, zero, t0
  and   t4, t0,   t0
  or    t4, zero, zero
  or    t4, zero, t0
  or    t4, t0,   t0
  xor   t4, zero, zero
  xor   t4, zero, t0
  xor   t4, t0,   t0
  
  beq   t0, t0, branch_eq
  j branch_eq_nt
end:
  ret

branch_eq_ret:
  beq   t0, t3, branch_ne
  j branch_ne_nt

branch_ne_ret:
  addi sp, sp, -16  # Adjust stack pointer to make space for ra and s0
  sw ra, 0(sp)      # Save ra to the stack
  call func
  lw ra, 0(sp)      # Load ra from the stack
  addi sp, sp, 16   # Restore stack pointer

  li  t0, 0x00100000 
  sw  t1, 0(t0)
  lw  t2, 0(t0)

  j end


branch_eq:
  addi  t5, zero, 1
  j branch_eq_ret

branch_eq_nt:
  addi  t5, zero, 2
  j branch_eq_ret

branch_ne:
  addi  t5, zero, 3
  j branch_ne_ret

branch_ne_nt:
  addi  t5, zero, 4
  j branch_ne_ret

func:
  addi  t5, zero, 5
  ret
