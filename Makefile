PROJ_NAME = riscv_cpu
TOP_MODULE = top

SRC_DIR = src
CONSTRAINTS_DIR = constraints
SIM_DIR = sim

SOURCES = $(wildcard $(SRC_DIR)/*.v)
TESTBENCH = $(SIM_DIR)/testbench.v
CONSTRAINTS = $(CONSTRAINTS_DIR)/tangnano9k.cst

BUILD_DIR = build
BITSTREAM = $(BUILD_DIR)/$(PROJ_NAME).fs

YOSYS = yosys
NEXTPNR = nextpnr-gowin
GOWIN_PACK = gowin_pack
PROGRAMMER = openFPGALoader
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5
BOARD = tangnano9k

all: $(BITSTREAM)

$(BUILD_DIR)/$(PROJ_NAME).json: $(SOURCES)
	@echo "=================================================="
	@echo "Synthesizing"
	@echo "=================================================="
	
	@mkdir -p $(BUILD_DIR)
	$(YOSYS) -p "synth_gowin -top $(TOP_MODULE)" -o $(BUILD_DIR)/$(PROJ_NAME).json $(SOURCES)
	
$(BUILD_DIR)/$(PROJ_NAME)_pnr.json: $(BUILD_DIR)/$(PROJ_NAME).json $(CONSTRAINTS)
	@echo "=================================================="
	@echo "Routing"
	@echo "=================================================="

	$(NEXTPNR) --json $(BUILD_DIR)/$(PROJ_NAME).json --write $(BUILD_DIR)/$(PROJ_NAME)_pnr.json --device $(DEVICE) --family $(FAMILY) --cst $(CONSTRAINTS)

$(BITSTREAM): $(BUILD_DIR)/$(PROJ_NAME)_pnr.json
	@echo "=================================================="
	@echo "Generating Bitstream"
	@echo "=================================================="

	$(GOWIN_PACK) -d $(FAMILY) -o $(BITSTREAM) $(BUILD_DIR)/$(PROJ_NAME)_pnr.json
	
program: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) $(BITSTREAM)

flash: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) -f $(BITSTREAM)

clean:
	rm -rf $(BUILD_DIR)

simulate: $(BUILD_DIR)/testbench.vcd

wave: $(BUILD_DIR)/testbench.vcd
	$(GTKWAVE) $(BUILD_DIR)/testbench.vcd

$(BUILD_DIR)/testbench: $(SOURCES) $(TESTBENCH)	
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/testbench $(SOURCES) $(TESTBENCH)

$(BUILD_DIR)/testbench.vcd: $(BUILD_DIR)/testbench
	cd $(BUILD_DIR); $(VVP) testbench

.PHONY: all program flash simulate wave clean
