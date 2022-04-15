$(function_createconf): $(conf_files) | $(FUNCS_DIR)/

	@printf '%s\n' \
		'#!/bin/bash'                                                          \
		''                                                                     \
		'### _createconf() function is automatically generated'                \
		'### from makefile based on the content of the $(CONF_DIR)/ directory' \
		''                                                                     \
		'_createconf() {'                                                      \
		'local trgdir="$$1"' > $@

	echo 'mkdir -p $(subst $(CONF_DIR),"$$trgdir",$(conf_dirs))' >> $@
	for f in $(conf_files); do

		echo "" >> $@
		echo 'if [[ -d $$__dir ]]; then #bashbud' >> $@
		echo "cat \"\$$__dir/$$f\" > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\" #bashbud" >> $@
		echo 'else #bashbud' >> $@
		echo "cat << 'EOCONF' > \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\"" >> $@
		cat "$$f" >> $@
		echo "EOCONF" >> $@
		echo 'fi #bashbud' >> $@
		[[ -x $$f ]] && echo "chmod +x \"$${f/$(subst /,\/,$(CONF_DIR))/\$$trgdir}\"" >> $@
	done

	echo '}' >> $@

