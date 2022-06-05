$(CACHE_DIR)/print_help$(FILE_EXT): $(CACHE_DIR)/help_table.txt $(CACHE_DIR)/synopsis.txt 
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
		cat $(CACHE_DIR)/help_table.txt
		printf '%s\n' 'EOB' '}'
	} > $@

