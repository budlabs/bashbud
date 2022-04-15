NAME           := bashbud
CREATED        := 2022-04-05
VERSION        := 1.99
AUTHOR         := budRich
ORGANISATION   := budlabs
CONTACT        := https://github.com/budlabs/bashbud
USAGE          := bashbud [OPTIONS] [DIRECTORY]

CUSTOM_TARGETS := conf/default/Makefile wiki/Home.md

conf/default/Makefile: $(wildcard Makefile.d/*)
	@$(info genearating Makefile from Makefile.d)
	cat $^ > $@
	cp -f $@ Makefile

wiki/Home.md: docs/tutorial.md
	[[ -d wiki ]] && git clone $(CONTACT).wiki.git wiki
	cp -f $< $@
	git -C wiki add .
	git -C wiki commit -m 'updated wiki'
	git -C wiki push

LICENSE     := LICENSE

# MANPAGE     := bashbud.1
README      := README.md

README_LAYOUT  =                \
	$(DOCS_DIR)/readme_banner.md  \
	$(DOCS_DIR)/readme_install.md \
	$(DOCS_DIR)/readme_usage.md   \
	$(CACHE_DIR)/help_table.txt

# MANPAGE_LAYOUT =            \
#  $(CACHE_DIR)/help_table.md \
#  $(DOCS_DIR)/description.md \
#  $(CACHE_DIR)/long_help.md


