extern unsigned int _sidata; // start of .data section in ROM
extern unsigned int _sdata;  // start of .data section in RAM
extern unsigned int _edata;  // end   of .data section in RAM
extern unsigned int _sbss;   // start of .bss section
extern unsigned int _ebss;   // end   of .bss section
extern unsigned int _estack; // end   of .stack section (stack top)

void main(void); // main function declaration

void _start(void) __attribute__((section(".text.startup"), naked)); // entry point, cpu starts executing from here

void _start(void)
{
  unsigned int *src, *dst;

  // copy .data section from ROM to RAM
  src = &_sidata;
  for (dst = &_sdata; dst < &_edata;) {
    *dst++ = *src++;
  }

  // zero initialize .bss section
  for (dst = &_sbss; dst < &_ebss;) {
    *dst++ = 0;
  }

  // initialize stack pointer
  asm volatile ("la sp, _estack");

  // call main function
  main();

  // halt
  while (1);
}
