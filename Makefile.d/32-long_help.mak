# if a file in docs/options contains more than
# 2 lines, it will get added to the file .cache/long_help.md
# like this:
#   ### -s, --long-option ARG
#   text in docs/options/long-option after the first 2 lines
$(long_help): $(CACHE_DIR)/options_in_use $(option_docs)
	@$(info making $@)
	for option in $(file < $(CACHE_DIR)/options_in_use); do
		[[ $$(wc -l < $(DOCS_DIR)/options/$$option) -lt 2 ]] \
			&& continue
		printf '### '
		sed -r 's/\|\s*$$//g;s/^\s*//g' $(CACHE_DIR)/options/$$option
		echo
		tail -qn +3 "$(DOCS_DIR)/options/$$option"
		echo
	done > $@

