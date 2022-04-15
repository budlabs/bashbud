NAME           := bashbud
CREATED        := 2022-04-05
VERSION        := 2.0
AUTHOR         := budRich
ORGANISATION   := budlabs
CONTACT        := https://github.com/budlabs/bashbud
USAGE          := bashbud [OPTIONS] [DIRECTORY]


ifdef DESTDIR
CUSTOM_TARGETS := conf/default/Makefile
else
CUSTOM_TARGETS := conf/default/Makefile wiki/Home.md
endif

conf/default/Makefile: $(wildcard Makefile.d/*)
	@$(info genearating Makefile from Makefile.d)
	cat $^ > $@
	cp -f $@ Makefile

wiki/Home.md: docs/tutorial.md
	[[ -d wiki ]] || git clone $(CONTACT).wiki.git wiki
	cp -f $< $@
	git -C wiki add .
	git -C wiki commit -m 'updated wiki'
	git -C wiki push

LICENSE     := LICENSE

MANPAGE     := bashbud.1
README      := README.md

README_LAYOUT  =                \
	$(DOCS_DIR)/readme_banner.md  \
	$(DOCS_DIR)/readme_install.md \
	$(DOCS_DIR)/readme_usage.md   \
	$(CACHE_DIR)/help_table.txt   \
	$(DOCS_DIR)/readme_footer.md

MANPAGE_LAYOUT =               \
 $(DOCS_DIR)/manpage_banner.md \
 $(DOCS_DIR)/manpage_usage.md  \
 $(CACHE_DIR)/help_table.txt   \
 $(CACHE_DIR)/long_help.md     \
 $(DOCS_DIR)/manpage_footer.md


