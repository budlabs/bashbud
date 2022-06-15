$(BASE): $(getopt) $(print_help) $(print_version) $(CACHE_DIR)/got_func
	@$(info making $@)
	{
		printf '%s\n' '$(SHBANG)' '' 

		[[ -f $${pv:=$(print_version)} ]] \
			&& grep -vhE -e '^#!/' $(print_version) | sed '0,/2/s//$$\{__stderr:-2\}/'
		[[ -f $${ph:=$(print_help)} ]] \
			&& grep -vhE -e '^#!/' $(print_help)    | sed '0,/2/s//$$\{__stderr:-2\}/'

		echo

		[[ -d $${fd:=$(FUNCS_DIR)} ]] && {
			printf '%s\n' \
			'for ___f in "$$__dir/$(FUNCS_DIR)"/*; do' \
			'$(INDENT). "$$___f" ; done ; unset -v ___f'
		}

		echo
		
		[[ -f $${go:=$(getopt)} ]] && cat $(getopt)

		echo "((BASHBUD_VERBOSE)) && _o[verbose]=1"
		echo

		echo 'main "$$@"'
	} > $@

