/* Linker script for RISC-V */

/* Define memory regions */
MEMORY
{
    ROM (rx)  : ORIGIN = 0x00010000, LENGTH = 0x1000  /* 1024 bytes for ROM */
    RAM (rwx) : ORIGIN = 0x00100000, LENGTH = 0x1000  /* 1024 bytes for RAM */
}

ENTRY(_start)

/* Define sections */
SECTIONS
{
    /* Code section */
    .text :
    {
        KEEP(*(.init))
        KEEP(*(.text))
        KEEP(*(.fini))
        KEEP(*(.rodata))
        _etext = .;
    } > ROM

    /* Initialized data section */
    .data : AT(_etext)
    {
        _sdata = .;
        KEEP(*(.data))
        _edata = .;
    } > RAM

    /* Uninitialized data section */
    .bss :
    {
        _sbss = .;
        KEEP(*(.bss))
        KEEP(*(COMMON))
        _ebss = .;
    } > RAM

    /* Stack section */
    .stack (NOLOAD) :
    {
        _stack_start = .;
        . += 0x100; /* Adjust the size as needed */
        _stack_end = .;
    } > RAM

    /* Heap section */
    .heap (NOLOAD) :
    {
        _heap_start = .;
        . += 0x100; /* Adjust the size as needed */
        _heap_end = .;
    } > RAM
}

/* Define symbols for memory initialization */
PROVIDE(_start = 0x00010000);
PROVIDE(_etext = _etext);
PROVIDE(_sdata = _sdata);
PROVIDE(_edata = _edata);
PROVIDE(_sbss = _sbss);
PROVIDE(_ebss = _ebss);
PROVIDE(_sstack = _sstack);
PROVIDE(_estack = _estack);