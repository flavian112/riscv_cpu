extern unsigned int _sidata; /* Start address for the .data section in ROM */
extern unsigned int _sdata;  /* Start address for the .data section in RAM */
extern unsigned int _edata;  /* End address for the .data section in RAM */
extern unsigned int _sbss;   /* Start address for the .bss section */
extern unsigned int _ebss;   /* End address for the .bss section */
extern unsigned int _estack; /* End address for the stack section */

void main(void);             /* The main function declaration */
void _start(void) __attribute__((section(".text.startup"), naked)); /* The entry point */

void _start(void)
{
    unsigned int *src, *dest;

    /* Copy .data section from ROM to RAM */
    src = &_sidata;  /* ROM address of the .data section */
    for (dest = &_sdata; dest < &_edata;)
    {
        *dest++ = *src++;
    }

    //while(1);

    /* Zero initialize .bss section */
    for (dest = &_sbss; dest < &_ebss;)
    {
        *dest++ = 0;
    }


    /* Initialize stack pointer */
    asm volatile ("la sp, _estack");

    /* Call the main function */
    main();

    /* If main returns, loop forever */
    while (1);
}
