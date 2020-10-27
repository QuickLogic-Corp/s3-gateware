#
# make all to make the 
#

#ql_symbiflow -compile -d ql-eos-s3 -P pu64 -v ../../../ip_modules/UART_16550/rtl/*.v ../../../ip_modules/GPIO/rtl/*.v *.v -t top -p quickfeather.pcf
IPMODULES = UART_16550 GPIO
MODULEDIRS = $(addsuffix /rtl/,$(addprefix ../../../ip_modules/,${IPMODULES}))
$(info MODULEDIRS = ${MODULEDIRS})
RTL_SRCS:=$(wildcard *.v) $(foreach subdir,$(MODULEDIRS),$(wildcard $(subdir)/*.v))
$(info RTL_SRCS = ${RTL_SRCS})
# RTL_SRCS:= $(wildcard ../*.v) $(wildcard *.v)
filters=
SRCS:=$(filter-out $(filters),${RTL_SRCS})

all: ../top_bit.h

top_bit.h: ${SRCS}
	ql_symbiflow -compile -d ql-eos-s3 -P pu64 -v ${RTL_SRCS} -t top -p quickfeather.pcf -dump header >build.log
		
../top_bit.h:	top_bit.h
	mv top_bit.h ../top_bit.h


clean:
	rm -rf build Makefile.symbiflow
