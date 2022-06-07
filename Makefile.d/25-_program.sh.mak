$(MONOLITH): $(print_version) $(NAME) $(print_help) $(function_files) $(getopt)
	@$(info making $@)
	{
		printf '%s\n' '$(SHBANG)' ''
		re='#bashbud$$'
		for f in $^; do
			# ignore files where the first line ends with '#bashbud'
			[[ $$(head -n1 $$f) =~ $$re ]] && continue	
			# ignore lines that ends with '#bashbud' (and shbangs)
			grep -vhE -e '^#!' -e '#bashbud$$' $$f
		done

		echo 'main "$$@"'
	} > $@
	
	chmod +x $@

