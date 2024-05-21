BUILD_DIR   ?= build
RTL_SOURCES ?= $(wildcard ../../rtl/src/*.v)
TESTVEC_DIR ?= ../../build
INCLUDE     = ../../rtl

TESTVECS ?= $(wildcard $(TESTVEC_DIR)/testvec_*.txt)

# tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# dirs and files
SOURCE_DIR = src
SOURCES = $(wildcard $(SOURCE_DIR)/*.v)
WAVEFORMS = $(patsubst testvec_%, $(BUILD_DIR)/waveform_%.vcd, $(basename $(notdir $(TESTVECS))))


# targets
all: $(WAVEFORMS)

# generate testbenches
$(BUILD_DIR)/testbench_%: $(SOURCE_DIR)/testbench_%.v $(RTL_SOURCES) | $(BUILD_DIR) always
	$(IVERILOG) -I $(INCLUDE) -o $@ $^

# run testbenches
$(BUILD_DIR)/waveform_%.vcd: $(BUILD_DIR)/testbench_% always
	$(VVP) $< +testvec=$(shell realpath $(TESTVEC_DIR)/testvec_$*.txt) +waveform=$@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

wave: all
	$(GTKWAVE) -a ../../debug/cpu.gtkw $(BUILD_DIR)/waveform_cpu.vcd > /dev/null 2>&1 & disown

# dummy target, s.t. other targets will always be run
always:

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean always