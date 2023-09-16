SHELL := /bin/bash

#Variables with default values or placeholders
BUILD_DIR ?= {{BUILD_DIR}}
TOKEN ?= {{TOKEN}}
LOG_FILE ?= {{LOG_FILE}}
EXEC_NAME_FILE = .exec_name

# If .exec_name exists, use its value as EXEC_NAME
ifeq ($(wildcard $(EXEC_NAME_FILE)),)
EXEC_NAME ?= {{EXEC_NAME}}
else
EXEC_NAME = $(shell cat $(EXEC_NAME_FILE))
endif

.PHONY: all debug update-vars

all: update-vars
        mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && cmake .. && make
        @if [ ! -f $(EXEC_NAME_FILE) ]; then \
                echo $$(ls $(BUILD_DIR) | head -1) > $(EXEC_NAME_FILE);
        fi
        TOKEN=$(TOKEN) ./$(BUILD_DIR)/$(EXEC_NAME) > $(LOG_FILE)&

debug: update-vars
        mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && cmake -DCMAKE_BUILD_TYPE=Debug .. && make
        gdb ./$(BUILD_DIR)/$(EXEC_NAME)

update-vars:
        @sed -i 's/{{BUILD_DIR}}/$(BUILD_DIR)/g' Makefile
        @sed -i 's/5/$(TOKEN)/g' Makefile
        @sed -i 's/{{LOG_FILE}}/$(LOG_FILE)/g' Makefile
        @sed -i 's/{{EXEC_NAME}}/$(EXEC_NAME)/g' Makefile
