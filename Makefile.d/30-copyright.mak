$(CACHE_DIR)/copyright.txt: $(config_mak)
	@$(info making $@)
	year_created=$(CREATED) year_created=$${year_created%%-*}
	year_updated=$$(date +'%Y')
	author="$(AUTHOR)" org=$(ORGANISATION)

	copy_text="Copyright (c) "

	((year_created == year_updated)) \
		&& copy_text+=$$year_created   \
		|| copy_text+="$${year_created}-$${year_updated}"

	[[ $$author ]] && copy_text+=", $$author"
	[[ $$org ]]    && copy_text+=" of $$org  "

	printf '%s\n' \
		"$$copy_text" "SPDX-License-Identifier: $(LICENSE)" > $@
