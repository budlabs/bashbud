$(CACHE_DIR)/synopsis.txt: $(OPTIONS_FILE)
	@$(info making $@)
	sed 's/^/$(NAME) /g;s/*//g' $< > $@

