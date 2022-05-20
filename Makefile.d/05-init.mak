CUSTOM_TARGETS       =

PREFIX              := /usr
NAME                := $(notdir $(realpath .))
VERSION             := 0
UPDATED             := $(shell date +'%Y-%m-%d')
CREATED             := $(UPDATED)
AUTHOR              := anon
CONTACT             := address
ORGANISATION        :=
CACHE_DIR           := .cache
DOCS_DIR            := docs
CONF_DIR            := conf
AWK_DIR             := awklib
FUNCS_DIR           := func
INDENT              := $(shell echo -e "  ")
USAGE                = $(NAME) [OPTIONS]
OPTIONS_FILE        := options
MANPAGE              = $(NAME).1
MONOLITH             = _$(NAME).sh
BASE                := _init.sh
SHBANG              := \#!/bin/bash
OPTIONS_ARRAY_NAME  := _o
MANPAGE_OUT          = _$(MANPAGE)
FUNC_STYLE          := "() {"

ifneq ($(wildcard config.mak),)
include config.mak
endif

manpage_section      = $(subst .,,$(suffix $(MANPAGE)))
function_createconf := $(FUNCS_DIR)/_createconf.sh
function_awklib     := $(FUNCS_DIR)/_awklib.sh

ifneq ($(wildcard $(CONF_DIR)/*),)
include_createconf   = $(function_createconf)
conf_dirs            = $(shell find $(CONF_DIR) -type d)
conf_files           = $(shell find $(CONF_DIR) -type f)
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

