RAW_DIRS:=$(subst /,,$(wildcard */))

filters:=usb2serial

DIRS:=$(filter-out $(filters),${RAW_DIRS})

all: 	;$(foreach dir,$(DIRS),(make --directory $(dir) all) &&) :

clean: 	;$(foreach dir,$(DIRS),(make --directory $(dir) clean) &&) :
