NAME           := bashbud
DESCRIPTION    := make(1) bash scripting better
UPDATED        := 2022-06-06
CREATED        := 2022-04-05
VERSION        := 2.2
AUTHOR         := bud
ORGANISATION   := budlabs
LICENSE        := MIT
CONTACT        := https://github.com/budlabs/bashbud
USAGE          := bashbud [OPTIONS] [DIRECTORY]

.PHONY: makefile
makefile: data/default/GNUmakefile
CUSTOM_TARGETS += makefile

data/default/GNUmakefile: $(wildcard Makefile.d/*)
	@$(info genearating Makefile from Makefile.d)
	cat $^ > $@

all: $(CUSTOM_TARGETS) $(MONOLITH) $(BASE)

MANPAGE_DEPS =                       \
 $(CACHE_DIR)/help_table.txt         \
 $(CACHE_DIR)/long_help.md           \
 $(DOCS_DIR)/description.md          \
 $(CACHE_DIR)/copyright.txt

MANPAGE_OUT = $(MANPAGE)

$(MANPAGE_OUT): config.mak $(MANPAGE_DEPS) 
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)'

		printf '%s\n' "## USAGE" "$(USAGE)"
		cat $(DOCS_DIR)/description.md
		echo "## OPTIONS"
		sed 's/^/    /g' $(CACHE_DIR)/help_table.txt
		cat $(CACHE_DIR)/long_help.md
		printf '%s\n' '## CONTACT' \
			"Send bugs and feature requests to:  " "$(CONTACT)/issues"

		printf '%s\n' '## COPYRIGHT'
		cat $(CACHE_DIR)/copyright.txt
	} | go-md2man > $@

README.md:
	@$(making $@)
	{
	  # cat $(DOCS_DIR)/reame_banner.md
	  # cat $(DOCS_DIR)/reame_install.md
	  # cat $(DOCS_DIR)/reame_usage.md
	  cat $(CACHE_DIR)/help_table.txt
	} > $@

# README_LAYOUT  =                \
# 	$(DOCS_DIR)/readme_banner.md  \
# 	$(DOCS_DIR)/readme_install.md \
# 	$(DOCS_DIR)/readme_usage.md   \
# 	$(CACHE_DIR)/help_table.txt   \
# 	$(DOCS_DIR)/readme_footer.md

.PHONY: check install uninstall manpage

manpage: $(MANPAGE)

check: all
	shellcheck $(MONOLITH)

SHARE_DIR           := $(DESTDIR)$(PREFIX)/share
ASSET_DIR           := $(SHARE_DIR)/$(NAME)
installed_manpage    = $(SHARE_DIR)/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(SHARE_DIR)/licenses/$(NAME)/LICENSE

$(CACHE_DIR)/$(NAME).out: $(MONOLITH)
	m4 -DETC_CONFIG_DIR=$(PREFIX)/share/$(NAME) $< >$@

install: all $(CACHE_DIR)/$(NAME).out
	install -Dm644 $(MANPAGE_OUT) $(installed_manpage)
	install -Dm644 LICENSE $(installed_license)
	install -Dm755 $(CACHE_DIR)/$(NAME).out $(installed_script)
	mkdir -p $(ASSET_DIR)
	cp -r data/* -t $(ASSET_DIR)

uninstall:
	@for f in $(installed_script) $(installed_manpage) $(installed_license); do
		[[ -f $$f ]] || continue
		echo "rm $$f"
		rm "$$f"
	done
	
	[[ -d $(ASSET_DIR) ]] && rm -r $(ASSET_DIR)
