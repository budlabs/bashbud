$(MONOLITH): $(NAME) $(CACHE_DIR)/print_help.sh $(function_files) $(CACHE_DIR)/getopt
	@$(info making $@)
	printf '%s\n' '$(SHBANG)' '' 'exec 3>&2' '' > $@
	$(print_version)
	grep -vhE -e '^#!/' -e '#bashbud$$' $^ >> $@
	echo 'main "@$$"' >> $@
	
	chmod +x $@

