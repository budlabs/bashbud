# this hack writes 1 or 0 to the file .cache/got_func
# depending on existence of files in FUNC_DIR
# but it also makes sure to only update the file
# if the value has changed.
# this is needed for _init.sh (BASE) to know it needs
# to be rebuilt on this event.

ifneq ($(wildcard $(CACHE_DIR)/got_func),)
  ifneq ($(wildcard $(FUNCS_DIR)/*),)
    ifneq ($(file < $(CACHE_DIR)/got_func), 1)
      $(shell echo 1 > $(CACHE_DIR)/got_func)
    endif
  else
    ifneq ($(file < $(CACHE_DIR)/got_func), 0)
      $(shell echo 0 > $(CACHE_DIR)/got_func)
    endif
  endif
endif

$(CACHE_DIR)/got_func: | $(CACHE_DIR)/
	@$(info making $@)
	[[ -d $${tmp:=$(FUNCS_DIR)} ]] && tmp=1 || tmp=0
	echo $$tmp > $@
