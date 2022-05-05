ifneq ($(MANPAGE),)
MANPAGE_OUT ?= _$(MANPAGE)
MANPAGE_GENERATE := $(MANPAGE_OUT)
else ifneq ($(MANPAGE_OUT),)
ifeq ($(findstring _,$(MANPAGE_OUT)),)
MANPAGE = $(MANPAGE_OUT)
endif
endif

ifdef MANPAGE_OUT
manpage_section := $(subst .,,$(suffix $(MANPAGE_OUT)))
endif

$(MANPAGE_GENERATE): $(CACHE_DIR)/manpage.md
	@$(info generating $@ from $^)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		printf '%s\n' \
			"$$uppercase_name $(manpage_section) $(UPDATED) $(ORGANISATION) \"User Manuals\"" \
		  ======================================= \
		  ''   \
		  NAME \
		  ---- \
		  ''

		  cat $<
	} | go-md2man > $@

$(CACHE_DIR)/manpage.md: $(MANPAGE_LAYOUT) config.mak
	@$(info creating $@)
	cat $(MANPAGE_LAYOUT) > $@

