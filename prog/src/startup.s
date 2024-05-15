.section .init
.globl _start
_start:
    /* Set up stack pointer */
    la sp, _stack_end

    /* Initialize .data section (copy from LMA to VMA) */
    la t0, _sdata       /* VMA start of .data */
    la t1, _edata       /* VMA end of .data */
    la t2, _etext       /* LMA start of .data in flash */
copy_data:
    beq t0, t1, clear_bss
    lw t3, 0(t2)
    sw t3, 0(t0)
    addi t0, t0, 4
    addi t2, t2, 4
    j copy_data

clear_bss:
    /* Clear .bss section */
    la t0, _sbss        /* VMA start of .bss */
    la t1, _ebss        /* VMA end of .bss */
clear_loop:
    beq t0, t1, init_libc
    sw x0, 0(t0)
    addi t0, t0, 4
    j clear_loop

init_libc:
    /* Call libc initialization functions */
    /* call _init */

    /* Call main function */
    call main

finalize_libc:
    /* Call libc finalization functions */
    /* call _fini */

halt:
    /* Infinite loop after main returns */
    j halt
