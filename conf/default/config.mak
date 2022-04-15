VERSION     := 0
AUTHOR      := anon
CONTACT     := address
USAGE       := $(NAME) [OPTIONS]


# if USAGE is set to the string options the content of OPTIONS_FILE
# will be used.
# USAGE       := options
# ---
# man page and readme will only be created if they are set
# MANPAGE     := $(NAME).1
# README      := README.md
# ---
# LICENSE is path to a file containg the license
# not the name of the license.
# if the file exist when target install: is invoked
# it will also install LICENSE
#
# LICENSE        := LICENSE
# ---
# SHBANG will be used in all generated scripts
#
# SHBANG         := \#!/bin/bash
# ---
# MONOLITH is the name of the "combined" script
# it will be installed (as NAME)
#
# MONOLITH        := _$(NAME).sh
# ---
# BASE holds automatically generated stuff like
# while getopts ... and __print_help() is must
# be sourced by NAME
#
# BASE            := _init.sh
# ---
# INDENT defines the indentation used in generated
# files. it defaults to two spaces ("  ").
# To use two tabs instead, set the variable to:
#   INDENT := $(shell echo -e "\t\t")
#
# INDENT          := $(shell echo -e "  ")
# ---
# the conent of man page and readme can be configured
# by setting the MANPAGE_LAYOUT and README_LAYOUT
#
# MANPAGE_LAYOUT =            \
#  $(CACHE_DIR)/help_table.md       \
#  $(DOCS_DIR)/description.md \
#  $(CACHE_DIR)/long_help.md
# ---
# README_LAYOUT  =              \
# 	$(DOCS_DIR)/readme_banner.md \
# 	$(MANPAGE_LAYOUT)
# ---
# leave UPDATED unset to auto set to current day
#
# UPDATED        := $(shell date +%Y-%m-%d)
# ---
# ORGANISATION is visible in the man page.
# ORGANISATION   :=
# ---
# FUNCS_DIR      != func
# ---
# if AWK_DIR or CONF_DIR are not empty
# special functions will get created in func/
# --- 
# AWK_DIR        := awklib
# CONF_DIR       := conf
# ---
# CACHE_DIR      := .cache
# DOCS_DIR       := docs
# OPTIONS_FILE   := options
# ---
#
# include custom targets in this file.
# be sure to add them to CUSTOM_TARGETS list
# to have them be part of the DEFAULT_GOAL (all)
# 
# custom_target.txt: options
# 	cat $< > $@
#
# CUSTOM_TARGETS :=
