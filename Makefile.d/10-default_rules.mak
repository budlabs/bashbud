
clean:
	rm -rf \
		$(MONOLITH)             \
		$(BASE)                 \
		$(CACHE_DIR)            \
		$(generated_functions)  \
		$(MANPAGE_OUT)          \
		$(README)               

install-dev: $(BASE) $(NAME)
	ln -s $(realpath $(NAME)) $(PREFIX)/bin/$(NAME)
	
uninstall-dev: $(PREFIX)/bin/$(NAME)
	rm $^



check: all
	shellcheck $(MONOLITH)

