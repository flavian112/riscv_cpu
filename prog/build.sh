#!/bin/sh
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o main.o main.s
riscv64-unknown-elf-ld -T link.ld -m elf32lriscv -o main.elf main.o
riscv64-unknown-elf-objcopy -O binary main.elf main.bin
xxd -g 1 -c 1 -p main.bin >main.hex
cp -f main.hex ../rom/rom.hex
