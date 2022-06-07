$(print_help): $(help_table) $(CACHE_DIR)/synopsis.txt 
	@$(info making $@)
	{
		echo $(SHBANG)
		fstyle=$(FUNC_STYLE)
		printf "__print_help$${fstyle}\n"
		echo "$(INDENT)cat << 'EOB' >&2  "
		if [[ options = "$(USAGE)" ]]; then
			cat $(CACHE_DIR)/synopsis.txt
			echo
		else 
			printf '%s\n' 'usage: $(USAGE)' ''
			echo
		fi
		cat $(help_table)
		printf '%s\n' 'EOB' '}'
	} > $@

