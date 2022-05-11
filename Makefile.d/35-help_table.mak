$(CACHE_DIR)/help_table.txt: $(CACHE_DIR)/long_help.md
	@$(info making $@)
	for option in $$(cat $(CACHE_DIR)/options_in_use); do
		[[ -f $(CACHE_DIR)/options/$$option ]]  \
			&& frag=$$(cat $(CACHE_DIR)/options/$$option) \
			|| frag="$$option | "

		[[ -f $(DOCS_DIR)/options/$$option ]]  \
			&& desc=$$(head -qn1 $(DOCS_DIR)/options/$$option) \
			|| desc='short description  '

		paste <(echo "$$frag") <(echo "$$desc") | tr -d '\t'
	done > $@


$(CACHE_DIR)/print_help.sh: $(CACHE_DIR)/help_table.txt $(CACHE_DIR)/synopsis.txt 
	@$(info making $@)
	{
		printf '%s\n' \
			'$(SHBANG)' '' "__print_help()" "{" "$(INDENT)cat << 'EOB' >&3  "
		if [[ options = "$(USAGE)" ]]; then
			cat $(CACHE_DIR)/synopsis.txt
			echo
		else 
			printf '%s\n' 'usage: $(USAGE)' ''
			echo
		fi
		cat $(CACHE_DIR)/help_table.txt
		printf '%s\n' 'EOB' '}'
	} > $@

