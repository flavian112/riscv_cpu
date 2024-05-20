PRJ_NAME = riscv_cpu
TOP_MODULE = top

# Directories
SRC_DIR = src
SIM_DIR = sim
GENTESTVEC_DIR = gentestvec
CST_DIR = cst
BUILD_DIR = build

# Source Files
SRC_FILES = $(wildcard $(SRC_DIR)/*.v)
SIM_FILES = $(wildcard $(SIM_DIR)/testbench_*.v)
GENTESTVEC_FILES = $(wildcard $(GENTESTVEC_DIR)/gentestvec_*.c)
CST_FILES = $(wildcard $(CST_DIR)/*.cst)

# Output Files
SIM_EXECUTABLES = $(patsubst $(SIM_DIR)/testbench_%.v, $(BUILD_DIR)/testbench_%,$(SIM_FILES))
GENTESTVEC_EXECUTABLES = $(patsubst $(GENTESTVEC_DIR)/gentestvec_%.c, $(BUILD_DIR)/gentestvec_%,$(GENTESTVEC_FILES))
TESTVECTOR_FILES = $(patsubst $(BUILD_DIR)/gentestvec_%, $(BUILD_DIR)/testvec_%.txt, $(GENTESTVEC_EXECUTABLES))
WAVEFORM_FILES = $(patsubst $(BUILD_DIR)/testbench_%, $(BUILD_DIR)/waveform_%.vcd, $(SIM_EXECUTABLES))

BITSTREAM = $(BUILD_DIR)/$(PRJ_NAME).fs

# Programs
CC = clang
CFLAGS = -O3

IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

YOSYS = yosys
NEXTPNR = nextpnr-himbaechel
GOWIN_PACK = gowin_pack
PROGRAMMER = openFPGALoader

FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5
BOARD = tangnano9k

# RISCV Toolchain
RISCV_TOOLCHAIN = riscv64-unknown-elf
RISCV_AS = $(RISCV_TOOLCHAIN)-as
RISCV_CC = $(RISCV_TOOLCHAIN)-gcc
RISCV_LD = $(RISCV_TOOLCHAIN)-ld
RISCV_OBJCOPY = $(RISCV_TOOLCHAIN)-objcopy
RISCV_OBJDUMP = $(RISCV_TOOLCHAIN)-objdump

RISCV_ASFLAGS = -march=rv32i -mabi=ilp32
RISCV_CFLAGS = -march=rv32i -mabi=ilp32
RISCV_LDFLAGS = -T prog/link.ld -m elf32lriscv

PROG_SOURCE_DIR = prog/src

PROG_ASSEMBLY_SOURCES = $(wildcard $(PROG_SOURCE_DIR)/*.s)
PROG_C_SOURCES = $(wildcard $(PROG_SOURCE_DIR)/*.c)
PROG_OBJECT_FILES = $(PROG_ASSEMBLY_SOURCES:$(PROG_SOURCE_DIR)/%.s=$(BUILD_DIR)/%.o) $(PROG_C_SOURCES:$(PROG_SOURCE_DIR)/%.c=$(BUILD_DIR)/%.o)
PROG_ELF_FILE = $(BUILD_DIR)/prog.elf
PROG_BINARY_FILE = $(BUILD_DIR)/prog.bin
PROG_ROM_FILE = $(BUILD_DIR)/rom.hex


all: simulate


$(BUILD_DIR)/$(PRJ_NAME).json: $(SRC_FILES) | $(BUILD_DIR)
	@echo
	@echo "=================================================="
	@echo " Synthesizing"
	@echo "=================================================="
	$(YOSYS) -p "synth_gowin -top $(TOP_MODULE)" -o $(BUILD_DIR)/$(PRJ_NAME).json $(SRC_FILES)
	@echo "=================================================="
	@echo " Completed Synthesis"
	@echo "=================================================="
	@echo

$(BUILD_DIR)/$(PRJ_NAME)_pnr.json: $(BUILD_DIR)/$(PRJ_NAME).json $(CST_FILES)
	@echo
	@echo "==================================================="
	@echo " Routing"
	@echo "==================================================="
	$(NEXTPNR) --json $(BUILD_DIR)/$(PRJ_NAME).json --write $(BUILD_DIR)/$(PRJ_NAME)_pnr.json --device $(DEVICE) --vopt family=$(FAMILY) --vopt cst=$(CST_FILES)
	@echo "==================================================="
	@echo " Completed Routing"	
	@echo "==================================================="
	@echo

$(BITSTREAM): $(BUILD_DIR)/$(PRJ_NAME)_pnr.json
	@echo
	@echo "==================================================="
	@echo " Generating Bitstream"
	@echo "==================================================="
	$(GOWIN_PACK) -d $(FAMILY) -o $(BITSTREAM) $(BUILD_DIR)/$(PRJ_NAME)_pnr.json
	@echo "==================================================="
	@echo " Generated Bitstream"
	@echo "==================================================="
	@echo

bitstream: $(BITSTREAM)
	
upload: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) $(BITSTREAM)

flash: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) -f $(BITSTREAM)

simulate: $(WAVEFORM_FILES)

# Build the testbench executables
$(BUILD_DIR)/testbench_%: $(SIM_DIR)/testbench_%.v $(SRC_FILES) | $(BUILD_DIR) $(PROG_ROM_FILE)
	$(IVERILOG) -o $@ $^

# Build the test vector generator executables
$(BUILD_DIR)/gentestvec_%: $(GENTESTVEC_DIR)/gentestvec_%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $<

# Generate the test vector files
$(BUILD_DIR)/testvec_%.txt: $(BUILD_DIR)/gentestvec_%
	$< > $@

# Run the simulation and generate the waveform files
$(BUILD_DIR)/waveform_%.vcd: $(BUILD_DIR)/testbench_% $(BUILD_DIR)/testvec_%.txt
	@echo
	@echo "==================================================="
	@echo " Running Testbench ($*)"
	@echo "==================================================="
	$(VVP) $< +testvec=$(BUILD_DIR)/testvec_$*.txt +waveform=$@
	@echo "==================================================="
	@echo " Completed Testbench ($*)"
	@echo "==================================================="
	@echo

rom: $(PROG_ROM_FILE)

# Assemble assembly source files into object files
$(BUILD_DIR)/%.o: $(PROG_SOURCE_DIR)/%.s | $(BUILD_DIR)
	$(RISCV_AS) $(RISCV_ASFLAGS) -o $@ $<

# Compile C source files into object files
$(BUILD_DIR)/%.o: $(PROG_SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -c -o $@ $<

# Link the object files to create an ELF file
$(PROG_ELF_FILE): $(PROG_OBJECT_FILES)
	$(RISCV_LD) $(RISCV_LDFLAGS) -o $@ $^

# Convert the ELF file to a binary file
$(PROG_BINARY_FILE): $(PROG_ELF_FILE)
	$(RISCV_OBJCOPY) -O binary $< $@

# Convert the binary file to a hex file
$(PROG_ROM_FILE): $(PROG_BINARY_FILE)
	xxd -g 4 -c 4 -p $< | awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' > $@

# Create the build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

wave:
	$(GTKWAVE) -a debug/cpu.gtkw $(BUILD_DIR)/waveform_cpu.vcd

objdump: $(PROG_ELF_FILE)
	$(RISCV_OBJDUMP) -d -x --disassembler-color=on $(PROG_ELF_FILE)

# Clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all simulate rom bitsream upload flash wave objdump clean

