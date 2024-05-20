MEMORY
{
  ROM (rx)  : ORIGIN = 0x00010000, LENGTH = 4K /* (1024 words, 0x0001_0000 to 0x0001_FFFF) */
  RAM (rwx) : ORIGIN = 0x00100000, LENGTH = 4K /* (1024 words, 0x0010_0000 to 0x0010_FFFF) */
}

ENTRY(_start)

SECTIONS
{
  .text :
  {
    _stext = .;
    . = ORIGIN(ROM);
    _start = .;                /* entry point address */
    *(.text.startup)
    *(.text)                   /* .text sections (code) */
    *(.text.*)
    . = ALIGN(4);
    _etext = .;                /* end of code section */
  } > ROM

  .rodata :
  {
    *(.rodata)                 /* Read-only data */
    *(.rodata.*)
  } > ROM

  .data : 
  {
    _sidata = LOADADDR(.data); /* start address of .data section in ROM */
    . = ALIGN(4);
    _sdata = .;                /* start of .data section in RAM */
    *(.data)                   /* .data sections (initialized data) */
    *(.data.*)
    *(.sdata)                  /* .sdata sections (small initialized data) */
    *(.sdata.*)
    . = ALIGN(4);
    _edata = .;                /* end of .data section in RAM */
  } > RAM AT > ROM

  .bss :
  {
    . = ALIGN(4);
    _sbss = .;                 /* start of .bss section */
    *(.bss)                    /* .bss sections (zero-initialized data) */
    *(.bss.*)
    *(.sbss)                   /* .sbss sections (small zero-initialized data) */
    *(.sbss.*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;                 /* end of .bss section */
  } > RAM

  .heap (NOLOAD) :
  {
    . = ALIGN(4);
    _sheap = .;                /* start of heap */
    . = . + 1K;                /* size of heap */
    _eheap = .;                /* end of heap */
    . = ALIGN(4);
  } > RAM

  .stack (NOLOAD) :
  {
    . = ALIGN(4);
    _sstack = .;              /* start of stack */
    . = . + 1K;               /* size of stack */
    _estack = .;              /* end of stack */
    . = ALIGN(4);
  } > RAM

  /DISCARD/ : 
  {
    *(.comment)
    *(.note)
    *(.note.*)
  }
}
