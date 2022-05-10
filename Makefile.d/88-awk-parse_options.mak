$(CACHE_DIR)/options_in_use $(CACHE_DIR)/getopt &: $(OPTIONS_FILE) | $(CACHE_DIR)/
	@$(info parsing $(OPTIONS_FILE))
	mkdir -p $(DOCS_DIR)/options
	gawk '
	BEGIN { RS=" |\\n" }

	/./ {
		if (match($$0,/^\[?--([^][|[:space:]]+)(([|]-)(\S))?\]?$$/,ma)) 
		{
			gsub(/[][]/,"",$$0)
			opt_name = ma[1]
			if (length(opt_name) > longest)
				longest = length(opt_name)
			options[opt_name]["long_name"]  = opt_name
			if (ma[4] ~ /./) 
				options[opt_name]["short_name"] = ma[4]
		}

		else if (match($$0,/^\[?-(\S)([|]--([^][:space:]]+))?\]?$$/,ma))
		{
			gsub(/[][]/,"",$$0)
			opt_name = ma[1]
			if (ma[3] ~ /./)
			{
				opt_name = ma[3]
				options[opt_name]["short_name"] = ma[1]
				options[opt_name]["long_name"]  = opt_name
			}
			else
				options[opt_name]["short_name"] = opt_name

		}

		else if (opt_name in options && !("arg" in options[opt_name]))
		{

			if ($$0 ~ /^[[]/)
				options[opt_name]["suffix"] = "::"
			else
				options[opt_name]["suffix"] = ":"

			gsub(/[][]/,"",$$0)
			if (length($$0) > longest_arg)
				longest_arg = length($$0)
			options[opt_name]["arg"] = $$0
		}
	}

	END {

		# sort array in alphabetical order
		# https://www.gnu.org/software/gawk/manual/html_node/Controlling-Scanning.html
		PROCINFO["sorted_in"] = "@ind_num_asc"

		for (o in options)
		{

			docfile = "$(DOCS_DIR)/options/" o
			docfile_fragment = "$(CACHE_DIR)/options/" o
			options_in_use = options_in_use " " o

			if(o ~ /./)
			{
				if ("short_name" in options[o])
				{
					out = "-" options[o]["short_name"]
					if ("long_name" in options[o])
						out = out ", "
					else
						out = out sprintf("%-" longest "s", " ")
				}
				else
					out = ""

				if ("long_name" in options[o]) {
					string_lenght = longest + ("short_name" in options[o] ? 0 : 4)
					out = out sprintf ("--%-" string_lenght "s", options[o]["long_name"])
				}
				
				if ("arg" in options[o])
					out = out sprintf (" %-" longest_arg "s", gensub (/\|/,"\\\\|","g",options[o]["arg"]))

				# 6 = -s, --
				# longest = longest long option name
				# 1 space after longoption
				# longest_arg + space
				fragment_length = 6+longest+1+longest_arg
				out = "    " sprintf ("%-" fragment_length "s | ", out)
				print out > docfile_fragment

				if (system("[ ! -f " docfile " ]") == 0)
					print "short description  " > docfile
			}
					
			if ("long_name" in options[o])
			{
				long_options = long_options "," options[o]["long_name"]
				if ("suffix" in options[o])
					long_options = long_options options[o]["suffix"]
			}

			if ("short_name" in options[o])
			{
				short_options = short_options "," options[o]["short_name"]
				if ("suffix" in options[o])
					short_options = short_options options[o]["suffix"]
			}
		}

		print options_in_use > "$(CACHE_DIR)/options_in_use"

	  print ""
	  print "declare -A $(OPTIONS_ARRAY_NAME)"
	  print ""
		print "options=$$(getopt \\"
		print "  --name \"[ERROR]:" name "\" \\"
		if (short_options ~ /./)
			printf ("  --options \"%s\" \\\n", gensub(/^,/,"",1,short_options))
		printf ("  --longoptions \"%s\"  -- \"$$@\"\n", gensub(/^,/,"",1,long_options))
		print ") || exit 98"
		print ""
		print "eval set -- \"$$options\""
		print "unset -v options"
		print ""
		print "while true; do"
		print "  case \"$$1\" in"
		printf ("    --%-" longest+1 "s| -%s ) __print_help && exit ;;\n", "help", "h")
		printf ("    --%-" longest+1 "s| -%s ) __print_version && exit ;;\n", "version", "v")
		for (o in options)
		{
			if (o !~ /^(version|help)$$/)
			{
				if ("long_name" in options[o])
					printf ("    --%-" longest+1 "s", options[o]["long_name"])
				else
					printf ("%-" longest+7 "s", "")

				if ("short_name" in options[o])
					printf ("%s -%s ", ("long_name" in options[o] ? "|" : " "), options[o]["short_name"])
				else
					printf ("%s", "     ")

				if ("suffix" in options[o])
				{
					if (options[o]["suffix"] == "::")
						printf (") _o[%s]=$${2:-1} ; shift ;;\n", o)
					else
						printf (") _o[%s]=$$2 ; shift ;;\n", o)
				}
				else
					printf (") _o[%s]=1 ;;\n", o)
			}
		}

		print "    -- ) shift ; break ;;"
		print "    *  ) break ;;"
		print "  esac"
		print "  shift"
		print "done"
		print ""
		print "((BASHBUD_VERBOSE)) && _o[verbose]=1 #bashbud"
		print ""
	}
	' $(OPTIONS_FILE)                  \
			cache=$(CACHE_DIR)             \
			name=$(NAME) > $(CACHE_DIR)/getopt
