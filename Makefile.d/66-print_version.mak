$(CACHE_DIR)/print_version.sh: config.mak | $(CACHE_DIR)/
	@$(info making $@)
	echo $(SHBANG)
	fstyle=$(FUNC_STYLE)
	printf "__print_version$${fstyle}\n" > $@                          
	printf '%s\n'                                            \
		"$(INDENT)>&2 printf '%s\n' \\"                        \
		"$(INDENT)$(INDENT)'$(NAME) - version: $(VERSION)' \\" \
		"$(INDENT)$(INDENT)'updated: $(UPDATED) by $(AUTHOR)'" \
		"}"                                                    \
		"" >> $@

