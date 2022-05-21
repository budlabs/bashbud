$(function_awklib): $(awk_files) | $(FUNCS_DIR)/
	@$(info making $@)
	{
		printf '%s\n' \
			'$(SHBANG)'                                                             \
			''                                                                      \
			'### _awklib() function is automatically generated'                     \
			'### from makefile based on the content of the $(AWK_DIR)/ directory'   \
			''

		fstyle=$(FUNC_STYLE)
		printf "_awklib$${fstyle}\n"
		printf '%s\n' \
			'[[ -d $$__dir ]] && { cat "$$__dir/$(AWK_DIR)/"* ; return ;} #bashbud' \
			"cat << 'EOAWK'"
		cat $(awk_files)
		printf '%s\n' "EOAWK" '}'
	} > $@

