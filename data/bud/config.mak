UPDATED      := today
VERSION      := 0
DESCRIPTION  := short description for the script
AUTHOR       := budRich
CONTACT      := https://github.com/budlabs
ORGANISATION := budlabs
USAGE        := $(NAME) [OPTIONS]

MONOLITH     := _$(NAME)
MANPAGE      := $(NAME).1

$(MANPAGE): config.mak $(CACHE_DIR)/help_table.txt
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)' \
	                '## OPTIONS'

	  cat $(CACHE_DIR)/help_table.txt

	} | go-md2man > $@


README.md: $(CACHE_DIR)/help_table.txt
	@$(making $@)
	{
	  cat $(CACHE_DIR)/help_table.txt
	} > $@


.PHONY: check install uninstall manpage

manpage: $(MANPAGE)

check: all
	shellcheck $(MONOLITH)

installed_script    := $(DESTDIR)$(PREFIX)/bin/$(NAME)
installed_license   := $(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/LICENSE
installed_manpage   := \
	$(DESTDIR)$(PREFIX)/share/man/man$(subst .,,$(suffix $(MANPAGE)))/$(MANPAGE)

install: all
	@[[ -f $${manpage:=$(MANPAGE)} ]] && {
		echo "install -Dm644 $(MANPAGE) $(installed_manpage)"
		install -Dm644 $(MANPAGE) $(installed_manpage)
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
