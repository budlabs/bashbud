SCRIPT  = bashbud
MANPAGE = $(SCRIPT).1
LINKDIR = 
PREFIX  = /usr
DESTDIR =
INSTDIR = $(DESTDIR)$(PREFIX)
INSTBIN = $(INSTDIR)/bin
INSTMAN = $(INSTDIR)/share/man/man1
LIBDIR  = $(INSTDIR)/share/bashbud

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	install -m 0755  program.sh $(INSTBIN)/$(SCRIPT)
	install -m 0644 $(MANPAGE) $(INSTMAN)

	mkdir -p $(LIBDIR)/awklib
	@for fil in awklib/*.awk ; do \
		   install -m 0644 $$fil $(LIBDIR)/awklib; \
	done
	
	mkdir -p $(LIBDIR)/licenses
	@for fil in licenses/* ; do \
		   install -m 0644 $$fil $(LIBDIR)/licenses; \
	done

	@for f in $(shell find default -type f); do \
		mkdir -p $(LIBDIR)/generators/$${f%/*} ; \
		cp $${f} $(LIBDIR)/generators/$${f%/*} ; \
	done
.PHONY: install


uninstall:
	$(RM) $(INSTBIN)/$(SCRIPT)
	$(RM) $(INSTMAN)/$(MANPAGE)
	rm -rf $(LIBDIR)
.PHONY: uninstall
