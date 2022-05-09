DESCRIPTION  := short description for the script
VERSION      := 0
AUTHOR       := anon
CONTACT      := address
USAGE        := $(NAME) [OPTIONS]
MANPAGE      := $(NAME).1
# if USAGE is set to the string 'options' 
# the content of OPTIONS_FILE will be used.
# USAGE        := options

# ---
# ORGANISATION is visible in the man page. (.cache/manpage_header.md)
# ORGANISATION :=

# --- INSTALLATION RULES --- #
installed_manpage    = $(DESTDIR)$(PREFIX)/share/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/LICENSE

install: all
	@[[ -n $${manpage:=$(MANPAGE_OUT)} && -f $$manpage ]] && {
		echo "install -Dm644 $(MANPAGE_OUT) $(installed_manpage)"
		install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	}
	[[ -f LICENSE ]] && {
		echo "install -Dm644 LICENSE $(installed_license)"
		install -Dm644 LICENSE $(installed_license)
	}

	echo "install -Dm755 $(MONOLITH) $(installed_script)"
	install -Dm755 $(MONOLITH) $(installed_script)

uninstall:
	@for f in $(installed_script) $(installed_manpage) $(installed_license); do
		[[ -f $$f ]] || continue
		echo "rm $$f"
		rm "$$f"
	done

# uncomment to automatically generate manpage
# CUSTOM_TARGETS += $(MANPAGE_OUT)

$(MANPAGE_OUT): config.mak
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		# this first "<h1>" adds "corner" info to the manpage
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

		# main sections (NAME|OPTIONS..) should be "<h2>" (##), sub (###) ...
	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)' \
	                '## OPTIONS'

	  cat $(CACHE_DIR)/help_table.txt

	} | go-md2man > $@

# uncomment to automatically generate README.md
# CUSTOM_TARGETS += README.md

# protip: bashbud --template readme
#         will create some boilerplate markdown in docs/
README.md:
	@$(making $@)
	{
	  # cat $(DOCS_DIR)/reame_banner.md
	  # cat $(DOCS_DIR)/reame_install.md
	  # cat $(DOCS_DIR)/reame_usage.md
	  cat $(CACHE_DIR)/help_table.txt
	} > $@


# ---------------------------------------------- #
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
# leave UPDATED unset to auto set to current day
#
# UPDATED        := $(shell date +%Y-%m-%d)
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
