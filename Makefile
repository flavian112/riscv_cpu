BUILD_DIR = build

# dirs
PROG_DIR = prog
GENTESTVEC_DIR = sim/gentestvec
TESTBENCH_DIR = sim/testbenches
RTL_DIR = rtl

# tools
MAKE = make

all: simulate

# generate rom
rom:
	$(MAKE) -C $(PROG_DIR) BUILD_DIR=../$(BUILD_DIR) all

# print objdump of rom
objdump:
	$(MAKE) -C $(PROG_DIR) BUILD_DIR=../$(BUILD_DIR) objdump

# print size information of rom
size:
	$(MAKE) -C $(PROG_DIR) BUILD_DIR=../$(BUILD_DIR) size



# generate testvec files
testvec:
	$(MAKE) -C $(GENTESTVEC_DIR) BUILD_DIR=../../$(BUILD_DIR) all



# run testbenches (simulate)
simulate: rom testvec
	$(MAKE) -C $(TESTBENCH_DIR) BUILD_DIR=../../$(BUILD_DIR) all

# display waveform of cpu testbench
wave: rom testvec
	$(MAKE) -C $(TESTBENCH_DIR) BUILD_DIR=../../$(BUILD_DIR) wave



# generate bitstream
bitstream: rom
	$(MAKE) -C $(RTL_DIR) BUILD_DIR=../$(BUILD_DIR) all

# upload bitstream
upload: rom
	$(MAKE) -C $(RTL_DIR) BUILD_DIR=../$(BUILD_DIR) upload

# flash bitstream
flash: rom
	$(MAKE) -C $(RTL_DIR) BUILD_DIR=../$(BUILD_DIR) flash



clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean rom rom_objdump rom_size testvec simulate wave bitstream upload flash