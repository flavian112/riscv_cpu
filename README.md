# RISCV CPU

An attempt at building a simple RISCV CPU in verilog.

## Build

* `make all` to synthesize, place and route the design and to generate the bitstream.
* `make program` to upload the bitstream to the FPGA.
* `make flash` to flash the bitsream to the FPGA.
* `make simulate` to run the testbench (sim/testbench.v).
* `make wave` to view the simulation in GTKWave.
* `make clean` to clean build files.
