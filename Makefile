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
NEXTPNR = nextpnr-gowin
GOWIN_PACK = gowin_pack
PROGRAMMER = openFPGALoader

FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5
BOARD = tangnano9k

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
	$(NEXTPNR) --json $(BUILD_DIR)/$(PRJ_NAME).json --write $(BUILD_DIR)/$(PRJ_NAME)_pnr.json --device $(DEVICE) --family $(FAMILY) --cst $(CST_FILES)
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
	
program: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) $(BITSTREAM)

flash: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) -f $(BITSTREAM)

simulate: $(WAVEFORM_FILES)

# Build the testbench executables
$(BUILD_DIR)/testbench_%: $(SIM_DIR)/testbench_%.v $(SRC_FILES) | $(BUILD_DIR)
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

# Create the build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all simulate bitsream program flash clean

