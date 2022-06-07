
other_maks := $(filter-out $(config_mak),$(wildcard *.mak))
-include $(other_maks)
