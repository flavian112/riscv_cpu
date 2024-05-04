# RISCV CPU

An attempt at building a simple RISCV CPU in verilog.

## Build

* `make all` alias for `make simulate`.
* `make simulate` to run all the testbenches (sim/testbench_*.v).
* `make bitstream` to synthesize, place and route the design and to generate the bitstream.
* `make program` to upload the bitstream to the FPGA.
* `make flash` to flash the bitsream to the FPGA.
* `make clean` to clean build files.
