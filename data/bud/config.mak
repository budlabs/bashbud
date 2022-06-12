UPDATED      := today
VERSION      := 0
DESCRIPTION  := short description for the script
AUTHOR       := budRich
CONTACT      := https://github.com/budlabs
ORGANISATION := budlabs
USAGE        := $(NAME) [OPTIONS]

MONOLITH     := _$(NAME)

.PHONY: manpage
manpage: $(MANPAGE)

MANPAGE      := $(NAME).1

$(MANPAGE): config.mak $(CACHE_DIR)/help_table.txt
	@$(info making $@)
	uppercase_name=$(NAME)
	uppercase_name=$${uppercase_name^^}
	{
		echo "# $$uppercase_name "           \
				 "$(manpage_section) $(UPDATED)" \
				 "$(ORGANISATION) \"User Manuals\""

	  printf '%s\n' '## NAME' \
								  '$(NAME) - $(DESCRIPTION)' \
	                '## OPTIONS'

	  cat $(CACHE_DIR)/help_table.txt

	} | go-md2man > $@


README.md: $(CACHE_DIR)/help_table.txt
	@$(making $@)
	{
	  cat $(CACHE_DIR)/help_table.txt
	} > $@

