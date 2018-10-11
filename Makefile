LINKDIR = 
PREFIX  = /usr
DESTDIR =
INSTDIR = $(DESTDIR)$(PREFIX)
INSTBIN = $(INSTDIR)/bin
INSTMAN = $(INSTDIR)/share/man/man1
DOCDIR  = $(INSTDIR)/share/doc/bashbud
LIBDIR  = /lib

# /usr/share/doc/bashbud && ~/.config/bashbud

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)
	test -d $(DOCDIR)  || mkdir -p $(DOCDIR)

	# ./bashbud.sh --publish bashbud ./pubBB || true
	install -m 0755 ./out/bashbud.sh $(INSTBIN)/bashbud 

	if test -f $(LIBDIR)/bblib.sh; then \
		cat ./lib/base.sh > $(LIBDIR)/bblib.sh ; \
	else \
		install -m 0777 ./lib/base.sh $(LIBDIR)/bblib.sh ; \
	fi
	
	install -m 0644 ./doc/man/bashbud.1 $(INSTMAN);

	@for fil in $$(find template); do \
		if test -d $$fil; then \
			test -d $(DOCDIR)/$${fil} \
				|| install -m 0777 -d $(DOCDIR)/$${fil} ; \
	  else \
	  	install -m 0777 $$fil $(DOCDIR)/$${fil} ; \
  	fi; \
	done

	$(RM) pubBB
.PHONY: install

uninstall:
	$(RM) $(INSTBIN)/bashbud
	$(RM) $(LIBDIR)/bblib.sh
	$(RM) $(INSTMAN)/bashbud.1
.PHONY: uninstall

tmpdir:
	test -d $(DOCDIR)  || mkdir -p $(DOCDIR)
	@for fil in $$(find template); do \
		if test -d $$fil; then \
			test -d $(DOCDIR)/$${fil} \
				|| install -m 0777 -d $(DOCDIR)/$${fil} ; \
	  else \
	  	install -m 0777 $$fil $(DOCDIR)/$${fil} ; \
  	fi; \
	done
.PHONY: tmpdir

		# @for fil in $$(find tmp); do \
		# 	if test -d $$fil; then \
		# 		test -d $(DOCDIR)/$${fil} \
		# 			|| mkdir -p $(DOCDIR)/$${fil} ; \
		#   else \
		#   	install -m 0777 $$fil $(DOCDIR)/$${fil} ; \
	 #  	fi; \
		# done
	# LINKDIR = 
	# PREFIX  = /usr
	# DESTDIR =
	# INSTDIR = $(DESTDIR)$(PREFIX)
	# INSTBIN = $(INSTDIR)/bin
	# INSTMAN = $(INSTDIR)/share/man/man1

	# install:
	# 	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	# 	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	# 	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	# 	@for fil in * ; do \
	# 		 if test -d $$fil ; then \
	# 		   manfile=$$fil/$${fil##*/}.1 ; \
	# 		   scriptfile=$$fil/$${fil##*/} ; \
	# 		   if test -f $$manfile ; then \
	# 		   	 install -m 0644 $$manfile $(INSTMAN); \
	# 		   	 install -m 0755 $$scriptfile $(INSTBIN); \
	# 		   fi; \
	# 		 fi; \
	# 	done
	# .PHONY: install

	# install-doc:
	# 	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	# 	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	# 	@for fil in * ; do \
	# 		 if test -d $$fil ; then \
	# 		   manfile=$$fil/$${fil##*/}.1 ; \
	# 		   if test -f $$manfile ; then \
	# 		   	 install -m 0644 $$manfile $(INSTMAN); \
	# 		   fi; \
	# 		 fi; \
	# 	done
	# .PHONY: install-doc

	# link-scripts:
	# 	test -d $(LINKDIR) || mkdir -p $(LINKDIR)

	# 	@for fil in * ; do \
	# 		 if test -d $$fil ; then \
	# 		   manfile=$$fil/$${fil##*/}.1 ; \
	# 		 	 scriptfile=$$fil/$${fil##*/} ; \
	# 		   if test -f $$manfile ; then \
	# 		   	 ln -s  $$scriptfile $(LINKDIR)/$${scriptfile##*/} ; \
	# 		   fi; \
	# 		 fi; \
	# 	done
	# .PHONY: link-scripts

	# uninstall:
	# 	@for fil in * ; do \
	# 		 if test -d $$fil ; then \
	# 		   manfile=$$fil/$${fil##*/}.1 ; \
	# 		   scriptfile=$$fil/$${fil##*/} ; \
	# 		   if test -f $$manfile ; then \
	# 		   	 $(RM) $(INSTMAN)/$${manfile##*/} ; \
	# 		   	 $(RM) $(INSTBIN)/$${scriptfile##*/} ; \
	# 		   fi; \
	# 		 fi; \
	# 	done
	# .PHONY: uninstall

