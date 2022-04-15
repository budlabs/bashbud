#!/bin/bash

### _createconf() function is automatically generated
### from makefile based on the content of the conf/ directory

_createconf() {
local trgdir="$1"
mkdir -p "$trgdir" "$trgdir"/default "$trgdir"/default/docs "$trgdir"/default/docs/options "$trgdir"/ERR "$trgdir"/ERR/func "$trgdir"/TIMER "$trgdir"/TIMER/func "$trgdir"/LOG "$trgdir"/LOG/func "$trgdir"/install.mak "$trgdir"/watch "$trgdir"/manpage-docs "$trgdir"/manpage-docs/docs

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/docs/options/help" > "$trgdir/default/docs/options/help" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/docs/options/help"
print help and exit  
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/docs/options/version" > "$trgdir/default/docs/options/version" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/docs/options/version"
print version info and exit  
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/options" > "$trgdir/default/options" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/options"
--help|-h
--version|-v
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/Makefile" > "$trgdir/default/Makefile" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/Makefile"
.PHONY: clean check all install uninstall \
				install-dev uninstall-dev

.ONESHELL:
.DEFAULT_GOAL   := all

SHELL           := /bin/bash


ifneq ($(wildcard config.mak),)
include config.mak
endif

PREFIX          ?= /usr
NAME            ?= $(notdir $(realpath .))
VERSION         ?= 0
UPDATED         ?= $(shell date +'%Y-%m-%d')
CREATED         ?= $(UPDATED)
AUTHOR          ?= anon
CONTACT         ?= address
ORGANISATION    ?=
CACHE_DIR       ?= ./.cache
DOCS_DIR        ?= ./docs
CONF_DIR        ?= ./conf
AWK_DIR         ?= ./awklib
FUNCS_DIR       ?= ./func
INDENT          ?= $(shell echo -e "  ")
USAGE           ?= $(NAME) [OPTIONS]
OPTIONS_FILE    ?= options
DEFAULT_OPTIONS ?= --hello|-o WORD --help|-h --version|-v
MONOLITH        ?= _$(NAME).sh
BASE            ?= _init.sh
SHBANG          ?= \#!/bin/bash
MANPAGE         ?=
LICENSE         ?= LICENSE
README          ?=

ifneq ($(MANPAGE),)
MANPAGE_OUT = _$(MANPAGE)
endif

MANPAGE_LAYOUT  ?=             \
 $(CACHE_DIR)/help_table.txt

README_LAYOUT  ?=              \
	$(DOCS_DIR)/readme_banner.md \
	$(MANPAGE_LAYOUT)

function_createconf := $(FUNCS_DIR)/_createconf.sh
function_awklib     := $(FUNCS_DIR)/_awklib.sh

manpage_section     := $(subst .,,$(suffix $(MANPAGE)))
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_manpage   := \
	$(DESTDIR)$(PREFIX)/share/man/man$(manpage_section)/$(MANPAGE)
installed_license   := \
	$(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/$(LICENSE)

installed_all       := \
	$(installed_script)  \
	$(installed_manpage) \
	$(installed_license)

ifneq ($(wildcard $(CONF_DIR)/*),)
include_createconf = $(function_createconf)
conf_dirs      = $(shell find $(CONF_DIR) -type d)
conf_files     = $(shell find $(CONF_DIR) -type f)
else
$(shell rm -f $(function_createconf))
endif

ifneq ($(wildcard $(AWK_DIR)/*),)

include_awklib  = $(function_awklib)
awk_files       = $(wildcard $(AWK_DIR)/*)
else
$(shell rm -f $(function_awklib))
endif

option_docs = $(wildcard $(DOCS_DIR)/options/*)

generated_functions := $(function_err) $(include_createconf) $(include_awklib)
function_files := \
	$(generated_functions) \
	$(filter-out $(generated_functions),$(wildcard $(FUNCS_DIR)/*))

# this hack writes 1 or 0 to the file .cache/got_func
# depending on existence of files in FUNC_DIR
# but it also makes sure to only update the file
# if the value has changed.
# this is needed for _init.sh (BASE) to know it needs
# to be rebuilt on this event.

ifneq ($(wildcard $(CACHE_DIR)/got_func),)
ifneq ($(wildcard $(FUNCS_DIR)/*),)
ifneq ($(file < $(CACHE_DIR)/got_func), 1)
$(shell echo 1 > $(CACHE_DIR)/got_func)
endif
else
ifneq ($(file < $(CACHE_DIR)/got_func), 0)
$(shell echo 0 > $(CACHE_DIR)/got_func)
endif
endif
endif
all: $(MONOLITH) $(MANPAGE_OUT) $(README) $(BASE) $(CUSTOM_TARGETS)

clean:
	rm -rf \
		$(MONOLITH)             \
		$(BASE)                 \
		$(CACHE_DIR)            \
		$(generated_functions)  \
		$(MANPAGE_OUT)          \
		$(README)               

install-dev: $(BASE) $(NAME)
	ln -s $(realpath $(NAME)) $(PREFIX)/bin/$(NAME)
	
uninstall-dev: $(PREFIX)/bin/$(NAME)
	rm $^

install: $(MONOLITH) $(MANPAGE_OUT)
	@[[ -n $${manpage:=$(MANPAGE_OUT)} && -f $$manpage ]] && {
		echo "install -Dm644 $(MANPAGE_OUT) $(installed_manpage)"
		install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	}
	[[ -n $${license:=$(LICENSE)} && -f $$license ]] && {
		echo "install -Dm644 $(LICENSE) $(installed_license)"
		install -Dm644 $(LICENSE) $(installed_license)
	}

	echo "install -Dm755 $(MONOLITH) $(installed_script)"
	install -Dm755 $(MONOLITH) $(installed_script)

uninstall:
	@for f in $(installed_all); do
		[[ -f $$f ]] || continue
		echo "rm '$$f'"
		rm "$$f"
	done

check: all
	shellcheck $(MONOLITH)

$(BASE): config.mak $(CACHE_DIR)/getopt $(CACHE_DIR)/print_help.sh $(CACHE_DIR)/got_func
	@$(info making $@)
	printf '%s\n' '$(SHBANG)' '' 'exec 3>&2' '' > $@
	$(print_version)
	grep -vhE -e '^#!/' $(CACHE_DIR)/print_help.sh >> $@

	echo "" >> $@

	[[ -d $(FUNCS_DIR) ]] && {
		printf '%s\n' \
		'for ___f in "$$__dir/$(FUNCS_DIR)"/*; do' \
		'$(INDENT). "$$___f" ; done ; unset -v ___f' >> $@
	}

	cat $(CACHE_DIR)/getopt >> $@

	echo 'main "$$@"' >> $@

$(MONOLITH): $(NAME) $(CACHE_DIR)/print_help.sh $(function_files) $(CACHE_DIR)/getopt
	@$(info making $@)
	printf '%s\n' '$(SHBANG)' '' 'exec 3>&2' '' > $@
	$(print_version)
	grep -vhE -e '^#!/' -e '#bashbud$$' $^ >> $@
	echo 'main "@$$"' >> $@
	
	chmod +x $@

$(MANPAGE_OUT): $(CACHE_DIR)/manpage.md
	@$(info generating $@ from $^)
	lowdown -sTman                   \
		-M title=$(NAME)               \
		-M date=$(UPDATED)             \
		-M source=$(ORGANISATION)      \
		-M section=$(manpage_section)  \
		$^ > $@

$(CACHE_DIR)/manpage.md: $(MANPAGE_LAYOUT)
	@cat $^ > $@

# if a file in docs/options contains more than
# 2 lines, it will get added to the file .cache/longhelp.md
# like this:
#   # `-s`, `--long-option`
#   text in docs/options/long-option after the first 2 lines
$(CACHE_DIR)/long_help.md: $(CACHE_DIR)/options_in_use $(option_docs)
	@$(info making $@)
	printf '%s\n' '' '# OPTIONS' '' > $@
	for option in $(file < $(CACHE_DIR)/options_in_use); do
		[[ $$(wc -l < $(DOCS_DIR)/options/$$option) -lt 2 ]] \
			&& continue
		printf '## '
		sed -r 's/([^|]+).*/\1/' $(CACHE_DIR)/options/$$option
		echo
		tail -qn +3 "$(DOCS_DIR)/options/$$option"
	done >> $@

# syntax:ssHash
$(CACHE_DIR)/help_table.md : $(CACHE_DIR)/long_help.md
	@$(info generating help table)
	{
		echo
		printf '%s\n' '| option | description |' \
									'|:-------|:------------|'
		for option in $$(cat $(CACHE_DIR)/options_in_use); do
			[[ -f $(CACHE_DIR)/options/$$option ]]  \
				&& frag=$$(cat $(CACHE_DIR)/options/$$option) \
				|| frag="$$option | "

			[[ -f $(DOCS_DIR)/options/$$option ]]  \
				&& desc=$$(head -qn1 $(DOCS_DIR)/options/$$option) \
				|| desc='short description  '

			paste <(echo $$frag) <(echo $$desc)
		done

		# head -qn1 $(addprefix $(DOCS_DIR)/options/,$(file < $(CACHE_DIR)/options_in_use))
		echo
	} > $@ 


$(CACHE_DIR)/help_table.txt: $(CACHE_DIR)/help_table.md
	lowdown --term-no-ansi -Tterm $< | tail -qn +3 > $@


$(CACHE_DIR)/short_help.md: $(CACHE_DIR)/help_table.txt
	@$(info making $@)
	{
		if [[ options = "$(USAGE)" ]]
			then
				echo '# SYNOPSIS'
				echo
				sed 's/^/    $(NAME) /g;s/$$/  /g' $(OPTIONS_FILE)
			else printf '%s\n' '# USAGE' '' 'usage: $(USAGE)'
		fi
		echo
		cat $(CACHE_DIR)/help_table.txt
	} > $@
	

$(CACHE_DIR)/print_help.sh: $(CACHE_DIR)/help_table.txt
	@$(info making $@)
	{
		printf '%s\n' \
			'$(SHBANG)' '' "__print_help()" "{" "$(INDENT)cat << 'EOB' >&3  "
		if [[ options = "$(USAGE)" ]]
			then sed 's/^/    $(NAME) /g;s/$$/  /g' $(OPTIONS_FILE)
			else printf '%s\n' '$(INDENT)usage: $(USAGE)' ''
		fi
		cat $<
		printf '%s\n' 'EOB' '}'
	} > $@

$(README): $(README_LAYOUT)
	@cat $^ > $@

$(function_awklib): $(awk_files) | $(FUNCS_DIR)/
	@printf '%s\n' \
		'#!/bin/bash'                                                           \
		''                                                                      \
		'### _awklib() function is automatically generated'                     \
		'### from makefile based on the content of the $(AWK_DIR)/ directory'   \
		''                                                                      \
		'_awklib() {'                                                           \
		'[[ -d $$__dir ]] && { cat "$$__dir/$(AWK_DIR)/"* ; return ;} #bashbud' \
		"cat << 'EOAWK'"   > $@
		cat $(awk_files)  >> $@
		printf '%s\n' "EOAWK" '}' >> $@

$(function_createconf): $(conf_files) | $(FUNCS_DIR)/

	@printf '%s\n' \
		'#!/bin/bash'                                                          \
		''                                                                     \
		'### _createconf() function is automatically generated'                \
		'### from makefile based on the content of the $(CONF_DIR)/ directory' \
		''                                                                     \
		'_createconf() {'                                                      \
		'local trgdir="$$1"' > $@

	echo 'mkdir -p $(subst $(CONF_DIR),"$$trgdir",$(conf_dirs))' >> $@
	for f in $(conf_files); do

		echo "" >> $@
		echo 'if [[ -d $$__dir ]]; then #bashbud' >> $@
		echo "cat \"\$$__dir/$$f\" > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\" #bashbud" >> $@
		echo 'else #bashbud' >> $@
		echo "cat << 'EOCONF' > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\"" >> $@
		cat "$$f" >> $@
		echo "EOCONF" >> $@
		echo 'fi #bashbud' >> $@
		[[ -x $$f ]] && echo "chmod +x \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\"" >> $@
	done

	echo '}' >> $@

$(CACHE_DIR)/:
	@$(info creating $(CACHE_DIR)/ dir)
	mkdir -p $(CACHE_DIR) $(DOCS_DIR)/options
	[[ -d $(FUNCS_DIR) ]] \
		&& echo 1 > $(CACHE_DIR)/got_func \
		|| echo 0 > $(CACHE_DIR)/got_func

$(FUNCS_DIR)/:
	@$(info creating $(FUNCS_DIR)/ dir)
	mkdir -p $(FUNCS_DIR)

define print_version =
@printf '%s\n'                                \
	"__print_version()"                         \
	"{"                                         \
	"$(INDENT)>&3 printf '%s\n' \\"                    \
	"$(INDENT)$(INDENT)'$(NAME) - version: $(VERSION)' \\"    \
	"$(INDENT)$(INDENT)'updated: $(UPDATED) by $(AUTHOR)'"    \
	"}"                                                       \
	"" >> $@
endef

$(CACHE_DIR)/options_in_use $(CACHE_DIR)/getopt &: $(OPTIONS_FILE) | $(CACHE_DIR)/
	@$(info parsing $(OPTIONS_FILE))
	mkdir -p $(CACHE_DIR)/options
	$(parse_options) > $(CACHE_DIR)/getopt


define parse_options =
@gawk '
BEGIN { RS=" |\\n" }

/./ {
	if (match($$0,/^\[?--([^][|[:space:]]+)(([|]-)(\S))?\]?$$/,ma)) 
	{
		gsub(/[][]/,"",$$0)
		opt_name = ma[1]
		if (length(opt_name) > longest)
			longest = length(opt_name)
		options[opt_name]["long_name"]  = opt_name
		if (ma[4] ~ /./) 
			options[opt_name]["short_name"] = ma[4]
	}

	else if (match($$0,/^\[?-(\S)([|]--([^][:space:]]+))?\]?$$/,ma))
	{
		gsub(/[][]/,"",$$0)
		opt_name = ma[1]
		if (ma[3] ~ /./)
		{
			opt_name = ma[3]
			options[opt_name]["short_name"] = ma[1]
			options[opt_name]["long_name"]  = opt_name
		}
		else
			options[opt_name]["short_name"] = opt_name

	}

	else if (opt_name in options && !("arg" in options[opt_name]))
	{

		if ($$0 ~ /^[[]/)
			options[opt_name]["suffix"] = "::"
		else
			options[opt_name]["suffix"] = ":"

		gsub(/[][]/,"",$$0)
		options[opt_name]["arg"] = $$0
	}
}

END {

	for (o in options)
	{

		docfile = "$(DOCS_DIR)/options/" o
		docfile_fragment = "$(CACHE_DIR)/options/" o
		options_in_use = options_in_use " " o

		if(o ~ /./)
		{
			out = ""

			if ("short_name" in options[o])
				out = "`-" options[o]["short_name"] "`" ("long_name" in options[o] ? ", " : "")
			else
				out = ""

			if ("long_name" in options[o])
				out = out sprintf ("`--%-" longest+2 "s", options[o]["long_name"]"`")
			
			if ("arg" in options[o])
				out = out sprintf ("%s | ", gensub (/\|/,"\\\\|","g",options[o]["arg"]))
			else
				out = out " | "

			print out > docfile_fragment

			if (system("[ ! -f " docfile " ]") == 0)
				print "short description  " > docfile
		}
				
		if ("long_name" in options[o])
		{
			long_options = long_options "," options[o]["long_name"]
			if ("suffix" in options[o])
				long_options = long_options options[o]["suffix"]
		}

		if ("short_name" in options[o])
		{
			short_options = short_options "," options[o]["short_name"]
			if ("suffix" in options[o])
				short_options = short_options options[o]["suffix"]
		}
	}

	print options_in_use > "$(CACHE_DIR)/options_in_use"

  print ""
  print "declare -A _o"
  print ""
	print "options=$$(getopt \\"
	print "  --name \"[ERROR]:" name "\" \\"
	if (short_options ~ /./)
		printf ("  --options \"%s\" \\\n", gensub(/^,/,"",1,short_options))
	printf ("  --longoptions \"%s\"  -- \"$$@\"\n", gensub(/^,/,"",1,long_options))
	print ") || exit 98"
	print ""
	print "eval set -- \"$$options\""
	print "unset -v options"
	print ""
	print "while true; do"
	print "  case \"$$1\" in"
	printf ("    --%-" longest+1 "s| -%s ) __print_help && exit ;;\n", "help", "h")
	printf ("    --%-" longest+1 "s| -%s ) __print_version && exit ;;\n", "version", "v")
	for (o in options)
	{
		if (o !~ /^(version|help)$$/)
		{
			if ("long_name" in options[o])
				printf ("    --%-" longest+1 "s", options[o]["long_name"])
			else
				printf ("%-" longest+7 "s", "")

			if ("short_name" in options[o])
				printf ("%s -%s ", ("long_name" in options[o] ? "|" : " "), options[o]["short_name"])
			else
				printf ("%s", "     ")

			if ("suffix" in options[o])
			{
				if (options[o]["suffix"] == "::")
					printf (") _o[%s]=$${2:-1} ; shift ;;\n", o)
				else
					printf (") _o[%s]=$$2 ; shift ;;\n", o)
			}
			else
				printf (") _o[%s]=1 ;;\n", o)
		}
	}

	print "    -- ) shift ; break ;;"
	print "    *  ) break ;;"
	print "  esac"
	print "  shift"
	print "done"
	print ""
}
' $(OPTIONS_FILE)                  \
		cache=$(CACHE_DIR)             \
		name=$(NAME)
endef

other_maks := $(filter-out config.mak,$(wildcard *.mak))
-include $(other_maks)

EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/.gitignore" > "$trgdir/default/.gitignore" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/.gitignore"
.cache/
**/_*
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/main.sh" > "$trgdir/default/main.sh" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/main.sh"
#!/bin/bash

main(){
  
  :
  # add main logic here
}

__dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")") #bashbud
source "$__dir/_init.sh"                              #bashbud
EOCONF
fi #bashbud
chmod +x "$trgdir/default/main.sh"

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/default/config.mak" > "$trgdir/default/config.mak" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/default/config.mak"
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

EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/ERR/func/ERR.sh" > "$trgdir/ERR/func/ERR.sh" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/ERR/func/ERR.sh"
#!/bin/bash

set -E
trap '(($? == 98)) && exit 98' ERR

ERX() { >&2 echo  "[ERROR] $*" ; exit 98 ;}
ERR() { >&2 echo  "[WARNING] $*"  ;}
ERM() { >&2 echo  "$*"  ;}
ERT() { >&3 echo  "$*"  ;}

EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/TIMER/func/TIMER.sh" > "$trgdir/TIMER/func/TIMER.sh" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/TIMER/func/TIMER.sh"
#!/bin/bash

trap 'CLEANUP' EXIT INT HUP

start_timer=0
[[ $* =~ --verbose || $BASHBUD_VERBOSE -eq 1 ]] && start_timer=1
[[ $* =~ --dryrun ]] && start_timer=0

((start_timer)) && {
  ___t=$(( 10#${EPOCHREALTIME//[!0-9]} ))

  for ((___arg=0; ___arg<${#@}+1;___arg++)); do
    [[ ${!___arg} = --verbose ]] && break
  done

  printf -v ___cmd "%s " "${0##*/}" "${@:1:___arg}"
  unset -v ___arg
  >&2 echo ">>> $___cmd"
}

CLEANUP() {
  ((start_timer)) \
    && >&2 echo "<<< $___cmd" \
      "$(( (10#${EPOCHREALTIME//[!0-9]} - ___t) / 1000 ))ms"
}

EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/LOG/func/LOG.sh" > "$trgdir/LOG/func/LOG.sh" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/LOG/func/LOG.sh"
#!/bin/bash

[[ $BASHBUD_LOG ]] && {
  [[ -f $BASHBUD_LOG ]] || mkdir -p "${BASHBUD_LOG%/*}"
  exec 2>> "$BASHBUD_LOG"
}
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/install.mak/install.mak" > "$trgdir/install.mak/install.mak" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/install.mak/install.mak"
.PHONE: install-a
install-a:
	$(info install A)
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/watch/watch" > "$trgdir/watch/watch" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/watch/watch"
#!/bin/bash
_src=$(realpath ${BASH_SOURCE[0]})
_dir=${_src%/*}
_name=${_dir##*/}

[[ -d "$_dir"/func/ ]]      && to_watch+=("$_dir"/func/)
[[ -d "$_dir"/conf/ ]]      && to_watch+=("$_dir"/conf/)
[[ -d "$_dir"/docs/ ]]      && to_watch+=("$_dir"/docs/)
[[ -f "$_dir"/$_name ]]     && to_watch+=("$_dir"/$_name)
[[ -f "$_dir"/config.mak ]] && to_watch+=("$_dir"/config.mak)

echo "$_name"
while read -r ; do
  clear
  make check
done < <(
  inotifywait --event close_write          \
              --recursive --monitor        \
              --exclude '/_[^.]+[.]sh$'    \
              "${to_watch[@]}"
)
EOCONF
fi #bashbud
chmod +x "$trgdir/watch/watch"

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/manpage-docs/docs/manpage_banner.md" > "$trgdir/manpage-docs/docs/manpage_banner.md" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/manpage-docs/docs/manpage_banner.md"
# NAME

MyScript - just a simple demo script

## this is h2 header

this is h2 body in motion HELLLLO

# SYNOPSIS
EOCONF
fi #bashbud

if [[ -d $__dir ]]; then #bashbud
cat "$__dir/conf/manpage-docs/docs/manpage_description.md" > "$trgdir/manpage-docs/docs/manpage_description.md" #bashbud
else #bashbud
cat << 'EOCONF' > "$trgdir/manpage-docs/docs/manpage_description.md"
# DESCRIPTION

Just to showcase **markdown** to *troff* works.  
(*notice this and above line ends with two spaces*)  
<https://github.com/budlabs>

    indent with four spaces to make
    a "codeblock"
EOCONF
fi #bashbud
}
