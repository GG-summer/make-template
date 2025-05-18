TARGET_EXEC := unnamed
SHELL = /bin/sh

CC = gcc
CFLAGS = -Wall -Werror
LDFLAGS := -static -lm

PREFIX ?= /usr/local
BUILD_DIR := build
SRC_DIRS := src
SOURCES := $(shell find $(SRC_DIRS) -name '*.c') main.c
OBJS := $(SOURCES:%.c=$(BUILD_DIR)/%.o)
INC_DIRS := $(dir $(SOURCES))
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(INC_FLAGS) $(CFLAGS) -c $< -o $@

.PHONY: install uninstall clean run
.SILENT: run

install: $(BUILD_DIR)/$(TARGET_EXEC)
	install -Dm755 $< $(PREFIX)/bin/$(TARGET_EXEC)

uninstall:
	rm -f $(PREFIX)/bin/$(TARGET_EXEC)

clean:
	rm -r $(BUILD_DIR)

run: $(BUILD_DIR)/$(TARGET_EXEC)
	echo "MAKE: Running the program...\n"
	./$<
	echo "\nMAKE: Program finished.\n"
