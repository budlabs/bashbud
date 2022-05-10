NAME           := bashbud
CREATED        := 2022-04-05
VERSION        := 2.1
AUTHOR         := budRich
ORGANISATION   := budlabs
CONTACT        := https://github.com/budlabs/bashbud
USAGE          := bashbud [OPTIONS] [DIRECTORY]

# ifdef DESTDIR
# else
# CUSTOM_TARGETS := data/default/Makefile wiki/Home.md
# endif

CUSTOM_TARGETS += data/default/Makefile

data/default/Makefile: $(wildcard Makefile.d/*)
	@$(info genearating Makefile from Makefile.d)
	cat $^ > $@
	cp -f $@ Makefile

# wiki/Home.md: docs/tutorial.md
# 	[[ -d wiki ]] || git clone $(CONTACT).wiki.git wiki
# 	cp -f $< $@
# 	git -C wiki add .
# 	git -C wiki commit -m 'updated wiki'
# 	git -C wiki push

# --- INSTALLATION RULES --- #
SHARE_DIR           := $(DESTDIR)$(PREFIX)/share
ASSET_DIR           := $(SHARE_DIR)/$(NAME)
installed_manpage    = $(SHARE_DIR)/man/man$(manpage_section)/$(MANPAGE)
installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(SHARE_DIR)/licenses/$(NAME)/LICENSE

$(CACHE_DIR)/$(NAME).out: $(MONOLITH)
	m4 -DETC_CONFIG_DIR=$(ASSET_DIR) $< >$@

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

# prefix generated manpage with _
# MANPAGE_OUT     := _$(NAME).1

# uncomment to automatically generate manpage
CUSTOM_TARGETS += $(MANPAGE_OUT)

$(MANPAGE_OUT): config.mak $(CACHE_DIR)/help_table.txt
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

# README_LAYOUT  =                \
# 	$(DOCS_DIR)/readme_banner.md  \
# 	$(DOCS_DIR)/readme_install.md \
# 	$(DOCS_DIR)/readme_usage.md   \
# 	$(CACHE_DIR)/help_table.txt   \
# 	$(DOCS_DIR)/readme_footer.md

# MANPAGE_LAYOUT =               \
#  $(DOCS_DIR)/manpage_banner.md \
#  $(DOCS_DIR)/manpage_usage.md  \
#  $(CACHE_DIR)/help_table.txt   \
#  $(CACHE_DIR)/long_help.md     \
#  $(DOCS_DIR)/manpage_footer.md


