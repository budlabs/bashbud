LINKDIR = 
PREFIX  = /usr
DESTDIR =
INSTDIR = $(DESTDIR)$(PREFIX)
INSTBIN = $(INSTDIR)/bin
INSTMAN = $(INSTDIR)/share/man/man1
DOCDIR  = $(INSTDIR)/share/doc/bashbud
LIBDIR  = /lib

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)
	test -d $(DOCDIR)  || mkdir -p $(DOCDIR)

	install -m 0755 ./out/bashbud.sh $(INSTBIN)/bashbud 

	if test -f $(LIBDIR)/bblib.sh; then \
		cat ./lib/base.sh > $(LIBDIR)/bblib.sh ; \
	else \
		install -m 0777 ./lib/base.sh $(LIBDIR)/bblib.sh ; \
	fi
	
	install -m 0644 ./doc/man/bashbud.1 $(INSTMAN);

	@for fil in $$(find base); do \
		if test -d $$fil; then \
			test -d $(DOCDIR)/$${fil} \
				|| install -m 0777 -d $(DOCDIR)/$${fil} ; \
	  else \
	  	install -m 0777 $$fil $(DOCDIR)/$${fil} ; \
  	fi; \
	done
.PHONY: install

uninstall:
	$(RM) $(INSTBIN)/bashbud
	$(RM) $(LIBDIR)/bblib.sh
	$(RM) $(INSTMAN)/bashbud.1
.PHONY: uninstall
