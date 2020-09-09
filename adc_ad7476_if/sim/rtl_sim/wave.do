onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/CSn_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SCLK_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDATA_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SIN_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WB_CLK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_ADR
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_CYC
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_BYTE_STB
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_WE
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_RD
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_STB
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_RD_DAT
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_WR_DAT
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WBs_ACK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WB_RST
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA_Done_Extra
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA_Active_Extra
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA0_Active
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA0_Done
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA0_Req
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/SDMA0_INT
add wave -noupdate /testbench_top/u_SPI_s_LTC1857/data_transmit
add wave -noupdate /testbench_top/u_SPI_s_LTC1857/mem_index
add wave -noupdate /testbench_top/u_SPI_s_LTC1857/mem_adc_sens_data
add wave -noupdate /testbench_top/u_SPI_s_LTC1857/s_data_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {112500000 ps} 0} {{Cursor 2} {112300000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 74
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4357500 ps}
