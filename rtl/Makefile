BUILD_DIR ?= build

# defines
TOP_MODULE = top
PRJ_NAME   = riscv_cpu

# dirs and files
SRC_DIR   = src
SOURCES   = $(wildcard $(SRC_DIR)/*.v)
CST_DIR   = cst
CST_FILES = $(wildcard $(CST_DIR)/*.cst)
BITSTREAM = $(BUILD_DIR)/$(PRJ_NAME).fs

# tools
YOSYS      = yosys
NEXTPNR    = nextpnr-himbaechel
GOWIN_PACK = gowin_pack
PROGRAMMER = openFPGALoader

# fpga
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5
BOARD  = tangnano9k


# targets
all: $(BITSTREAM)

# synthesize
$(BUILD_DIR)/$(PRJ_NAME).json: $(SOURCES) | $(BUILD_DIR)
	@echo "read_verilog -Irtl $(SOURCES)"                   > $(BUILD_DIR)/synth_gowin.ys
	@echo "chparam -set ROM_FILE \"../build/rom.hex\" rom" >> $(BUILD_DIR)/synth_gowin.ys
	@echo "synth_gowin -top $(TOP_MODULE)"                 >> $(BUILD_DIR)/synth_gowin.ys
	$(YOSYS) $(BUILD_DIR)/synth_gowin.ys -o $(BUILD_DIR)/$(PRJ_NAME).json

# place and route
$(BUILD_DIR)/$(PRJ_NAME)_pnr.json: $(BUILD_DIR)/$(PRJ_NAME).json $(CST_FILES)
	$(NEXTPNR) --json $(BUILD_DIR)/$(PRJ_NAME).json --write $(BUILD_DIR)/$(PRJ_NAME)_pnr.json --device $(DEVICE) --vopt family=$(FAMILY) --vopt cst=$(CST_FILES)

# generate bitstream
$(BITSTREAM): $(BUILD_DIR)/$(PRJ_NAME)_pnr.json
	$(GOWIN_PACK) -d $(FAMILY) -o $(BITSTREAM) $(BUILD_DIR)/$(PRJ_NAME)_pnr.json

bitstream: $(BITSTREAM)
	
upload: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) $(BITSTREAM)

flash: $(BITSTREAM)
	$(PROGRAMMER) -b $(BOARD) -f $(BITSTREAM)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean bitsream upload flash

