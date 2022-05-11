$(CACHE_DIR)/copyright.txt: config.mak
	@$(info making $@)
	year_created=$(CREATED) year_created=$${year_created%%-*}
	year_updated=$$(date +'%Y')

	copy_text="Copyright (c) "

	((year_created == year_updated)) \
		&& copy_text+=$$year_created   \
		|| copy_text+="$${year_created}-$${year_updated}, $(AUTHOR)"

	[[ $${org:=$(ORGANISATION)} ]] \
		&& copy_text+=" of $(ORGANISATION)  "

	printf '%s\n' \
		"$$copy_text" "SPDX-License-Identifier: $(LICENSE)" > $@

