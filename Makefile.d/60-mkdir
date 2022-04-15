$(CACHE_DIR)/:
	@$(info creating $(CACHE_DIR)/ dir)
	mkdir -p $(CACHE_DIR) $(DOCS_DIR)/options
	[[ -d $(FUNCS_DIR) ]] \
		&& echo 1 > $(CACHE_DIR)/got_func \
		|| echo 0 > $(CACHE_DIR)/got_func

$(FUNCS_DIR)/:
	@$(info creating $(FUNCS_DIR)/ dir)
	mkdir -p $(FUNCS_DIR)

