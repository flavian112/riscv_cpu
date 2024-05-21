BUILD_DIR ?= build

# tools
CC = clang

# flags
CFLAGS = -O3

# dirs and files
SOURCE_DIR = src
SOURCES = $(wildcard $(SOURCE_DIR)/*.c)
GENTESTVECS = $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/gentestvec_%, $(SOURCES))
TESTVECS = $(patsubst $(BUILD_DIR)/gentestvec_%, $(BUILD_DIR)/testvec_%.txt, $(GENTESTVECS))


# targets
all: $(TESTVECS)

# build testvec generator executables
$(BUILD_DIR)/gentestvec_%: $(SOURCE_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $<

# generate testvecs
$(BUILD_DIR)/testvec_%.txt: $(BUILD_DIR)/gentestvec_%
	$< > $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean