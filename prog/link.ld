MEMORY
{
  ROM (rx)  : ORIGIN = 0x00010000, LENGTH = 4K
  RAM (rwx) : ORIGIN = 0x00100000, LENGTH = 4K
}

ENTRY(_start)

SECTIONS
{
  .text :
  {
    _stext = .;
    . = ORIGIN(ROM);
    _start = .;       /* Entry point address */
    KEEP(*(.text.startup)) /* Ensure startup code is kept */
    *(.text)          /* .text sections (code) */
    *(.text.*)
    . = ALIGN(4);
    _etext = .;       /* End of code section, needed for copying .data */
  } > ROM

  .rodata :
  {
    *(.rodata)               /* Read-only data */
    *(.rodata.*)
  } > ROM

  .data : 
  {
    _sidata = LOADADDR(.data); /* Start address of .data section in ROM */
    . = ALIGN(4);
    _sdata = .;       /* Start of .data section in RAM */
    *(.data)          /* .data sections (initialized data) */
    *(.data.*)
    *(.sdata)                  /* .sdata sections (small initialized data) */
    *(.sdata.*)
    . = ALIGN(4);
    _edata = .;       /* End of .data section in RAM */
  } > RAM AT > ROM

  .bss :
  {
    . = ALIGN(4);
    _sbss = .;        /* Start of .bss section */
    *(.bss)           /* .bss sections (zero-initialized data) */
    *(.bss.*)
    *(.sbss)                   /* .sbss sections (small zero-initialized data) */
    *(.sbss.*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;        /* End of .bss section */
  } > RAM

  .heap (NOLOAD) :
  {
    . = ALIGN(4);
    _sheap = .;       /* Start of heap */
    . = . + 1K;       /* Size of heap (adjust as needed) */
    _eheap = .;       /* End of heap */
    . = ALIGN(4);
  } > RAM

  .stack (NOLOAD) :
  {
    . = ALIGN(4);
    _sstack = .;      /* Start of stack */
    . = . + 1K;       /* Size of stack (adjust as needed) */
    _estack = .;      /* End of stack */
    . = ALIGN(4);
  } > RAM

  /DISCARD/ : 
  {
    *(.comment)
    *(.note)
    *(.note.*)
  }
}
