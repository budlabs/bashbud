$(function_createconf): $(conf_files) | $(FUNCS_DIR)/
	@$(info making $@)
	{
		printf '%s\n' \
			'$(SHBANG)'                                                            \
			''                                                                     \
			'### _createconf() function is automatically generated'                \
			'### from makefile based on the content of the $(CONF_DIR)/ directory' \
			''


		fstyle=$(FUNC_STYLE)
		printf "_createconf$${fstyle}\n"

		echo 'local trgdir="$$1"'

		echo 'mkdir -p $(subst $(CONF_DIR),"$$trgdir",$(conf_dirs))'
		for f in $(conf_files); do

			echo ""
			echo 'if [[ -d $$__dir ]]; then #bashbud'
			echo "cat \"\$$__dir/$$f\" > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\" #bashbud"
			echo 'else #bashbud'
			echo "cat << 'EOCONF' > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\""
			cat "$$f"
			echo "EOCONF"
			echo 'fi #bashbud'
			[[ -x $$f ]] && echo "chmod +x \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\""
		done

		echo '}'
	} > $@

