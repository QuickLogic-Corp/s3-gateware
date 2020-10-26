#
# make all to make the 
#
#
RTL_SRCS:=$(wildcard *.v)
filters=
SRCS:=$(filter-out $(filters),$(notdir $(RTL_SRCS)))

all:		build/top.bit

build/top.bit:	${SRCS}
		ql_symbiflow -compile -d ql-eos-s3 -P pu64 -v ${SRCS} -t top -p quickfeather.pcf >build.log


clean:
		rm -rf build Makefile.symbiflow
