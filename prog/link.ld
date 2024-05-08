OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY
{
  ROM (rx)  : ORIGIN = 0x00010000, LENGTH = 0xF0000    # 0x0001_0000 - 0x000F_FFFF
  RAM (rwx) : ORIGIN = 0x00100000, LENGTH = 0xFEFFFFF  # 0x0010_0000 - 0xFF0F_FFFF
}

SECTIONS
{
  .text  : { *(.text) }  > ROM
  .data  : { *(.data) }  > RAM
  .bss   : { *(.bss) }   > RAM
  .stack : { *(.stack) } > RAM
}
