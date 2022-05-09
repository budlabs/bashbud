# this is a different kind of template it will create 
# markdown fragments for readme and manpage, and delete
# itself (readme_fragments.mak) afterwards.

docs/readme_install.md:
	@$(info making $@)
	printf '%s\n' \
		'## installation' \
		'' \
		'If you use **Arch Linux** you can get **$(NAME)**' \
		'from [AUR].  ' \
		'' \
		'Make dependencies: **GNU** make, **GNU** awk, lowdown  ' \
		'' \
		'(*configure the installation in `config.mak`, if needed*)' \
		'' \
		'```' \
		'$ git clone $(CONTACT).git' \
		'$ cd $(NAME)' \
		'$ make' \
		'# make install' \
		'$ $(NAME) -v' \
		'$(NAME) - version: $(VERSION)' \
		'updated: $(UPDATED) by $(AUTHOR)' \
		'```  ' \
		'' \
		'[AUR]: https://aur.archlinux.org/packages/$(NAME)' > $@

docs/readme_banner.md:
	@$(info making $@)
	echo '## $(NAME) - $(DESCRIPTION)' > $@

docs/manpage_footer.md:
	@$(info making $@)
	printf '%s\n' \
		'CONTACT' \
		'=======' \
		'' \
		'File bugs and feature requests at the following URL:  ' \
		'<$(CONTACT)/issues>' > $@

docs/readme_usage.md:
	@$(info making $@)
	printf '%s\n' \
		'## usage' \
		'' \
		'`$(USAGE)`  ' \
		'' \
		'### options' \
		'' > $@

.PHONY: readme_fragments
readme_fragments: docs/readme_usage.md docs/readme_banner.md docs/manpage_footer.md docs/readme_install.md
	rm readme_fragments.mak

CUSTOM_TARGETS += readme_fragments
