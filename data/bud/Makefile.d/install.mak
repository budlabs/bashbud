.PHONY: install uninstall

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

