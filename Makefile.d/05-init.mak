CUSTOM_TARGETS       =

NAME                := $(notdir $(realpath .))
VERSION             := 0
UPDATED             := $(shell date +'%Y-%m-%d')
AUTHOR              := anon
CACHE_DIR           := .cache
DOCS_DIR            := docs
CONF_DIR            := conf
AWK_DIR             := awklib
FUNCS_DIR           := func
FILE_EXT            := .sh
INDENT              := $(shell echo -e "  ")
USAGE                = $(NAME) [OPTIONS]
OPTIONS_FILE        := options
MONOLITH             = _$(NAME)$(FILE_EXT)
BASE                := _init$(FILE_EXT)
SHBANG              := \#!/bin/bash
OPTIONS_ARRAY_NAME  := _o
FUNC_STYLE          := "() {"

config_mak          := config.mak
help_table          := $(CACHE_DIR)/help_table.txt
long_help           := $(CACHE_DIR)/long_help.md
getopt              := $(CACHE_DIR)/getopt
print_help          := $(CACHE_DIR)/print_help$(FILE_EXT)
print_version       := $(CACHE_DIR)/print_version$(FILE_EXT)

ifneq ($(wildcard $(config_mak)),)
  include config.mak
else
  config_mak    :=
endif

ifeq ($(wildcard $(OPTIONS_FILE)),)
  OPTIONS_FILE  :=
  help_table    :=
  long_help     :=
  getopt        :=
  print_help    :=
  print_version :=
endif

function_createconf := $(FUNCS_DIR)/_createconf$(FILE_EXT)
function_awklib     := $(FUNCS_DIR)/_awklib$(FILE_EXT)

ifneq ($(wildcard $(CONF_DIR)/*),)
  include_createconf   = $(function_createconf)
  conf_dirs            = $(patsubst ./%,%,$(shell find "./$(CONF_DIR)" -type d))
  conf_files           = $(patsubst ./%,%,$(shell find "./$(CONF_DIR)" -type f))
else
  $(shell rm -f $(function_createconf))
endif

ifneq ($(wildcard $(AWK_DIR)/*),)
  include_awklib       = $(function_awklib)
  awk_files            = $(wildcard $(AWK_DIR)/*)
else
  $(shell rm -f $(function_awklib))
endif

option_docs          = $(wildcard $(DOCS_DIR)/options/*)

generated_functions := $(function_err) $(include_createconf) $(include_awklib)
function_files := \
  $(generated_functions) \
  $(filter-out $(generated_functions),$(wildcard $(FUNCS_DIR)/*))

