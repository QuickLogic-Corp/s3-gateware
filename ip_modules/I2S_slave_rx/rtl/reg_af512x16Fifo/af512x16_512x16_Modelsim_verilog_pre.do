#------------------------------------------------------------------------------
#- File            :af512x16_512x16_modelsim_verilog_pre.do
#- Design          : Async FIFO
#- Last Modified   : 11/04/2005
#-
#- Company         : QuickLogic India Development Centre
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
#- description     : modelsim.do file to run QuickLogic AsyncFIFO
#-                   prelayout simulation
#------------------------------------------------------------------------------
#- History         :
#-                  Date         Author               Version
#-                  18/07/2012   Quicklogic             1.0
#-               - Initial Release
#------------------------------------------------------------------------------

quit -sim
cd E:/Projects/Tamar2/AEC/IP/Top_new/I2S/IP/i2s_rtl/reg_af512x16Fifo

# create work library
vlib work

# compile AsyncFIFO design and testbench files
vlog -work work C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/ram8k_2x1_cell.v
vlog -work work C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/rrw/fifo_blk.v
vlog -work work af512x16_512x16.v
vlog -work work af512x16_512x16.tf


# start simulation
vsim -gui -novopt work.t

# open a waveform window
view wave

# add FIFO signals
add wave m/Push_Clk
add wave m/Fifo_Push_Flush
add wave  m/PUSH
add wave -format Literal -radix unsigned m/DIN
add wave m/Pop_Clk
add wave m/Push_Clk_En
add wave m/Pop_Clk_En
add wave m/Fifo_Dir
add wave m/Async_Flush
add wave m/Fifo_Pop_Flush
add wave  m/POP
add wave -format Literal -radix unsigned m/DOUT
add wave -format Literal -radix unsigned m/PUSH_FLAG
add wave -format Literal -radix unsigned m/POP_FLAG
add wave m/Almost_Empty
add wave m/Almost_Full


# run simulation till end
run -all
write transcript af512x16_512x16_modelsim_verilog_pre.doc
