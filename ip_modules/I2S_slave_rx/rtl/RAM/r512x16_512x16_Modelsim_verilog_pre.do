#------------------------------------------------------------------------------
#- File            :r512x16_512x16_modelsim_verilog_pre.do
#- Design          : RAM
#- Last Modified   : 24/08/2012
#-
#- Company         : QuickLogic Corporation
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
#- description     : modelsim.do file to run QuickLogic RAM
#-                   prelayout simulation
#------------------------------------------------------------------------------
#- History         :
#-                  Date         Author          Version
#-                 24/08/2012    QuickLogic      1.0
#-               - Initial Release
#------------------------------------------------------------------------------

quit -sim
cd E:/Projects/Tamar2/AEC/IP/Top/I2S/IP/i2s_rtl/RAM

# create work library
vlib work

# compile RAM design and testbench file
vlog -work work C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/ram8k_2x1_cell.v
vlog -work work C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/rrw/ram_blk.v
vlog -work work r512x16_512x16.v
vlog -work work r512x16_512x16.tf


# start simulation
vsim -gui -novopt work.t

# open a waveform window
view wave

# add RAM signals
add wave m/WClk
add wave m/WD_SEL
add wave m/WEN
add wave -format Literal -radix unsigned m/WA
add wave -format Literal -radix unsigned m/WD
add wave m/RClk
add wave m/RD_SEL
add wave -format Literal -radix unsigned m/RA
add wave -format Literal -radix unsigned m/RD
add wave m/WClk_En
add wave m/RClk_En


# run simulation till end
run -all
write transcript r512x16_512x16_modelsim_verilog_pre.doc
