#------------------------------------------------------------------------------
#- File           : f512x8_512x8_modelsim_vhdl_pre.do
#- Design         : FIFO
#- Last Modified  : July 18,2012
#-
#- Company        : QuickLogic Corporation
#-
#- Copyright      : Copyright (C) 2003, Licensed customers of QuickLogic may
#-                  copy and modify this file for use in designing with
#-                  QuickLogic devices only.
#-
#- IMPORTANT NOTICE: DISCLAIMER OF WARRANTY
#- This design is provided without warranty of any kind. QuickLogic Corporation does
#- not warrant, guarantee or make any representations regarding the use, or the
#- results of the use, of this design. QuickLogic disclaims all implied warranties,
#- including but not limited to implied warranties of merchantability and fitness
#- for a particular purpose. In addition and without limiting the generality of the
#- foregoing, QuickLogic does not make any warranty of any kind that any item
#- developed based on this design, or any portion of it, will not infringe any
#- copyright, patent, trade secret or other intellectual property right of any
#- person or entity in any country. It is the responsibility of the user of the
#- design to seek licenses for such intellectual property rights where applicable.
#- QuickLogic shall not be liable for any damages arising out of or in connection
#- with the use of the design including liability for lost profit, business
#- interruption, or any other damages whatsoever.
#------------------------------------------------------------------------------
#- description    : modelsim.do file to run QuickLogic FIFO
#-                  prelayout simulation
#------------------------------------------------------------------------------
#- History        :
#-                  Date         Author               Version
#-                  11/04/2005   Quicklogic            1.0
#-               - Initial Release
#------------------------------------------------------------------------------

quit -sim
cd C:/Work/Antmicro/QuickFeather/other_usb_cores/tinyfpga-bootloader-usb-fromrakesh/svn_2020.05.11a_serialport/USBbootloader_S3B/rtl/FIFO/FIFO_512x8_al4s3b_sync_noreg

# create work library
vlib work


# compile QuickLogic FIFO primitives
vcom -93 -work work C:/QuickLogic/QuickWorks_2016.2_Release/spde/data/PolarPro-III/AL4S3B/ram8k_2x1_cell.vhd

vcom -93 -work work C:/QuickLogic/QuickWorks_2016.2_Release/spde/data/PolarPro-III/AL4S3B/rrw/fifo_blk.vhd

# compile FIFO design files
vcom -93 -work work f512x8_512x8.vhd

# compile top level  testbench
vcom -93 -work work f512x8_512x8.tb


# start simulation
vsim -gui -novopt work.t

# open a waveform window
view wave

# add FIFO signals
add wave m/Clk
add wave m/Fifo_Push_Flush
add wave m/PUSH
add wave -format Literal -radix unsigned m/DIN
add wave m/Fifo_Pop_Flush
add wave m/Clk_En
add wave m/Fifo_Dir
add wave m/Async_Flush
add wave m/POP
add wave -format Literal -radix unsigned m/DOUT
add wave -format Literal -radix unsigned m/PUSH_FLAG
add wave -format Literal -radix unsigned m/POP_FLAG
add wave m/Almost_Full
add wave m/Almost_Empty


# run simulation till end
run 80 us
write transcript f512x8_512x8_modelsim_vhdl_pre.doc
