# if a file in docs/options contains more than
# 2 lines, it will get added to the file .cache/longhelp.md
# like this:
#   # `-s`, `--long-option`
#   text in docs/options/long-option after the first 2 lines
$(CACHE_DIR)/long_help.md: $(CACHE_DIR)/options_in_use $(option_docs)
	@$(info making $@)
	printf '%s\n' '' '# OPTIONS' '' > $@
	for option in $(file < $(CACHE_DIR)/options_in_use); do
		[[ $$(wc -l < $(DOCS_DIR)/options/$$option) -lt 2 ]] \
			&& continue
		printf '## '
		sed -r 's/([^|]+).*/\1/' $(CACHE_DIR)/options/$$option
		echo
		tail -qn +3 "$(DOCS_DIR)/options/$$option"
	done >> $@

# syntax:ssHash
