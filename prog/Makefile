BUILD_DIR ?= build

# risc-v toolchain
RISCV_TOOLCHAIN = riscv64-unknown-elf
RISCV_AS        = $(RISCV_TOOLCHAIN)-as
RISCV_CC        = $(RISCV_TOOLCHAIN)-gcc
RISCV_LD        = $(RISCV_TOOLCHAIN)-ld
RISCV_OBJCOPY   = $(RISCV_TOOLCHAIN)-objcopy
RISCV_OBJDUMP   = $(RISCV_TOOLCHAIN)-objdump
RISCV_SIZE      = $(RISCV_TOOLCHAIN)-size

# assembler / compiler / linker flags
RISCV_ASFLAGS = -march=rv32i -mabi=ilp32
RISCV_CFLAGS  = -march=rv32i -mabi=ilp32
RISCV_LDFLAGS = -T link.ld -m elf32lriscv

# dirs and files
SOURCE_DIR = src
AS_SOURCES = $(wildcard $(SOURCE_DIR)/*.s)
C_SOURCES  = $(wildcard $(SOURCE_DIR)/*.c)
OBJ_FILES  = $(AS_SOURCES:$(SOURCE_DIR)/%.s=$(BUILD_DIR)/%.o) $(C_SOURCES:$(SOURCE_DIR)/%.c=$(BUILD_DIR)/%.o)
ELF_FILE   = $(BUILD_DIR)/prog.elf
BIN_FILE   = $(BUILD_DIR)/prog.bin
ROM_FILE   = $(BUILD_DIR)/rom.hex


# targets
all: $(ROM_FILE)

# assemble assembly files to object files
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.s | $(BUILD_DIR)
	$(RISCV_AS) $(RISCV_ASFLAGS) -o $@ $<

# compile source files to object files
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(RISCV_CC) $(RISCV_CFLAGS) -c -o $@ $<

# link object files to elf file
$(ELF_FILE): $(OBJ_FILES)
	$(RISCV_LD) $(RISCV_LDFLAGS) -o $@ $^

# create binary file from elf file
$(BIN_FILE): $(ELF_FILE)
	$(RISCV_OBJCOPY) -O binary $< $@

# convert binary file hex file
$(ROM_FILE): $(BIN_FILE)
	xxd -g 4 -c 4 -p $< | awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' > $@

# create build dir
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# create objdump of elf file and print
objdump: $(ELF_FILE)
	$(RISCV_OBJDUMP) -d -x --disassembler-color=on $(ELF_FILE)

# display size information of elf file
size: $(ELF_FILE)
	$(RISCV_SIZE) $(ELF_FILE)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean objdump size