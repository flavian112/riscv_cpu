# RISCV CPU

An attempt at building a simple RISCV CPU in verilog.

## FPGA

The board used in this project is a [Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) with a GW1NR-LV9QN88PC6/I5 FPGA. There is a crystal clock onboard running at 27 MHz.

## Build

* `make all` alias for `make simulate`.
* `make simulate` to run all the testbenches (sim/testbench_*.v).
* `make bitstream` to synthesize, place and route the design and to generate the bitstream.
* `make upload` to upload the bitstream to the FPGA.
* `make flash` to flash the bitsream to the FPGA.
* `make clean` to clean build files.
* `gtkwave build/waveform_*.vcd` to view waveform of corresponding testbench.
* `make rom` to compile source files in prog/src, link and generate rom file.
* `make wave` to view waveform of cpu running build/rom.hex.

## Tools

### Simulation

* [clang](https://llvm.org) for compiling testvector generator sources
* [iverilog](https://github.com/steveicarus/iverilog) for building simulation
* [vvp](https://steveicarus.github.io/iverilog/developer/guide/vvp/vvp.html) for running simulation

### ROM

* [riscv64 toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) for building prog source files, although here used for compiling for riscv32

### Synthesis

* [yosys](https://github.com/YosysHQ/oss-cad-suite-build) for synthesis
* [nextpnr-gowin](https://github.com/YosysHQ/apicula) for place and route
* [gowin_pack](https://github.com/YosysHQ/apicula) for generating bitstream
* [openFPGALoader](https://github.com/trabucayre/openFPGALoader) for uploading bitstream to FPGA

### Debugging

* [gtkwave](https://github.com/gtkwave/gtkwave) for viewing waveforms
* [openocd](https://openocd.org) for debugging

## Currently Supported Instructions

* R-type: add, sub, and, or, xor, sll, srl, sra, slt, sltu
* I-type: addi, andi, ori, xori, slti, sltiu, slli, srli, srai, lw
* S-type: sw
* B-type: beq, bne, blt, bge, bltu, bgeu
* U-type:
* J-type: jal, jalr

## Resources

* [RISC-V ISA](https://riscv.org/specifications/)
* [Digital Design and Computer Architecture by David and Sarah Harris](https://pages.hmc.edu/harris/ddca/)
* [Computer Organization and Design by David Patterson](https://shop.elsevier.com/books/computer-organization-and-design-risc-v-edition/patterson/978-0-12-820331-6)
* [Operating Systems: Three Easy Pieces by Remzi and Andrea Arpaci-Dusseau](https://pages.cs.wisc.edu/~remzi/OSTEP/)
* [Example RISCV Cores](https://github.com/yunchenlo/awesome-RISCV-Cores)


## Waveform Example

Here we can see the waveforms of various internal signal of the CPU, executing the following instructions:

```(asm)
  addi  t0, zero, 5
  addi  t1, zero, 3
  add   t2, t0,   t1
```

![Waveform adding two numbers](res/waveform_add_two_numbers.png)
