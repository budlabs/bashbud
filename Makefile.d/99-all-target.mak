# by having all:  last, it is possible to add CUSTOM_TARGETS
# in "other_maks", and have them automatically apply
all: $(CUSTOM_TARGETS) $(MONOLITH) $(MANPAGE_GENERATE) $(README) $(BASE)
