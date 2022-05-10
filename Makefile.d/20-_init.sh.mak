$(BASE): config.mak $(CACHE_DIR)/getopt $(CACHE_DIR)/print_help.sh $(CACHE_DIR)/print_version.sh $(CACHE_DIR)/got_func
	@$(info making $@)
	{
		printf '%s\n' '$(SHBANG)' '' 'exec 3>&2' ''
		grep -vhE -e '^#!/' $(CACHE_DIR)/print_version.sh
		grep -vhE -e '^#!/' $(CACHE_DIR)/print_help.sh

		echo

		[[ -d $(FUNCS_DIR) ]] && {
			printf '%s\n' \
			'for ___f in "$$__dir/$(FUNCS_DIR)"/*; do' \
			'$(INDENT). "$$___f" ; done ; unset -v ___f'
		}

		echo
		
		cat $(CACHE_DIR)/getopt

		echo 'main "$$@"'
	} > $@

