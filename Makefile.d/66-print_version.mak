$(CACHE_DIR)/print_version.sh: config.mak | $(CACHE_DIR)/
	@$(info making $@)
	printf '%s\n'                                            \
		"__print_version()"                                    \
		"{"                                                    \
		"$(INDENT)>&3 printf '%s\n' \\"                        \
		"$(INDENT)$(INDENT)'$(NAME) - version: $(VERSION)' \\" \
		"$(INDENT)$(INDENT)'updated: $(UPDATED) by $(AUTHOR)'" \
		"}"                                                    \
		"" > $@

