SHELL := /bin/bash

# File paths to store parameter values
TOKEN_FILE := .token_value
BUILD_DIR_FILE := .build_dir_value
LOG_FILE_FILE := .log_file_value
EXEC_NAME_FILE := .exec_name_value

# Default placeholders
PLACEHOLDER := {{VALUE}}

# Loading parameters from files or using default values
TOKEN := $(if $(wildcard $(TOKEN_FILE)), $(shell cat $(TOKEN_FILE)), $(PLACEHOLDER))
BUILD_DIR := $(if $(wildcard $(BUILD_DIR_FILE)), $(shell cat $(BUILD_DIR_FILE)), $(PLACEHOLDER))
LOG_FILE := $(if $(wildcard $(LOG_FILE_FILE)), $(shell cat $(LOG_FILE_FILE)), $(PLACEHOLDER))
EXEC_NAME := $(if $(wildcard $(EXEC_NAME_FILE)), $(shell cat $(EXEC_NAME_FILE)), $(PLACEHOLDER))

.PHONY: all debug save-params

all: save-params
        mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && cmake .. && make
        TOKEN=$(TOKEN) ./$(BUILD_DIR)/$(EXEC_NAME) > $(LOG_FILE)&

debug: save-params
        mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && cmake -DCMAKE_BUILD_TYPE=Debug .. && make
        gdb ./$(BUILD_DIR)/$(EXEC_NAME)

save-params:
        @if [ "$(origin TOKEN)" = "command line" ]; then echo $(TOKEN) > $(TOKEN_FILE); fi
        @if [ "$(origin BUILD_DIR)" = "command line" ]; then echo $(BUILD_DIR) > $(BUILD_DIR_FILE); fi
        @if [ "$(origin LOG_FILE)" = "command line" ]; then echo $(LOG_FILE) > $(LOG_FILE_FILE); fi
        @if [ "$(origin EXEC_NAME)" = "command line" ]; then echo $(EXEC_NAME) > $(EXEC_NAME_FILE); fi
