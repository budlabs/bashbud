$(README): $(README_LAYOUT) config.mak
	@$(info creating $@)
	cat $(README_LAYOUT) > $@

