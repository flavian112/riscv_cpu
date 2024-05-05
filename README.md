# RISCV CPU

An attempt at building a simple RISCV CPU in verilog.

## FPGA

The board used in this project is a [Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) with a GW1NR-LV9QN88PC6/I5 FPGA. There is a crystal clock onboard running at 27 MHz.

## Build

* `make all` alias for `make simulate`.
* `make simulate` to run all the testbenches (sim/testbench_*.v).
* `make bitstream` to synthesize, place and route the design and to generate the bitstream.
* `make program` to upload the bitstream to the FPGA.
* `make flash` to flash the bitsream to the FPGA.
* `make clean` to clean build files.
* `gtkwave build/waveform_*.vcd` to view waveform of corresponding testbench.

