$(function_awklib): $(awk_files) | $(FUNCS_DIR)/
	@$(info making $@)
	printf '%s\n' \
		'#!/bin/bash'                                                           \
		''                                                                      \
		'### _awklib() function is automatically generated'                     \
		'### from makefile based on the content of the $(AWK_DIR)/ directory'   \
		''                                                                      \
		'_awklib() {'                                                           \
		'[[ -d $$__dir ]] && { cat "$$__dir/$(AWK_DIR)/"* ; return ;} #bashbud' \
		"cat << 'EOAWK'"   > $@
		cat $(awk_files)  >> $@
		printf '%s\n' "EOAWK" '}' >> $@

