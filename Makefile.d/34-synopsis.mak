$(CACHE_DIR)/synopsis.txt: $(OPTIONS_FILE) | $(CACHE_DIR)/
	@$(info making $@)
	sed 's/^/$(NAME) /g;s/*//g' $< > $@

