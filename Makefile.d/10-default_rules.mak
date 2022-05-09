
clean:
	rm -rf $(wildcard _*) $(CACHE_DIR) $(generated_functions)

install-dev: $(BASE) $(NAME)
	ln -s $(realpath $(NAME)) $(PREFIX)/bin/$(NAME)
	
uninstall-dev: $(PREFIX)/bin/$(NAME)
	rm $^

check: all
	shellcheck $(MONOLITH)

