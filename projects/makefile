RAW_DIRS:=$(subst /,,$(wildcard */))

filters:=

DIRS:=$(filter-out $(filters),${RAW_DIRS})

all: 	;$(foreach dir,$(DIRS),(make --directory $(dir)/rtl all) &&) :

clean: 	;$(foreach dir,$(DIRS),(make --directory $(dir)/rtl clean) &&) :