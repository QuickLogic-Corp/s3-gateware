onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WB_CLK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART0_SIN_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART0_SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART1_SIN_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART1_SOUT_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14700000 ps} 0} {{Cursor 2} {14900000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 50
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
WaveRestoreZoom {10571774 ps} {18697253 ps}
