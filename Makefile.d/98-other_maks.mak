
other_maks := $(filter-out config.mak,$(wildcard *.mak))
-include $(other_maks)
