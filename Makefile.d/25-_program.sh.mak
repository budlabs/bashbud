$(MONOLITH): $(NAME) $(CACHE_DIR)/print_version.sh $(CACHE_DIR)/print_help.sh $(function_files) $(CACHE_DIR)/getopt
	@$(info making $@)
	{
		printf '%s\n' '$(SHBANG)' ''
		cat $(CACHE_DIR)/print_version.sh
		re='#bashbud$$'
		for f in $^; do
			# ignore files where the first line ends with '#bashbud'
			[[ $$(head -n1 $$f) =~ $$re ]] && continue	
			# ignore lines that ends with '#bashbud' (and shbangs)
			grep -vhE -e '^#!/' -e '#bashbud$$' $$f
		done

		printf '%s\n' '' 'main "@$$"'
	} > $@
	
	chmod +x $@

