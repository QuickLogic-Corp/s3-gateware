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
add wave -noupdate -color Gold /testbench_top/u_AL4S3B_FPGA_Top/WBs_ACK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WB_RST
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/WB_CLK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART0_SIN_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART0_SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART1_SIN_i
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/UART1_SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/ahb_write_word_al4s3b_fabric/TARGET_ADDRESS
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/ahb_write_word_al4s3b_fabric/TARGET_DATA
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HCLK
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HWRITES
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HWDATAS
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HREADYOUTS
add wave -noupdate -color Gold /testbench_top/testCases_AL4S3B_FPGA_IP/u_testCases_AL4S3B_FPGA_IP_UART/Generic_AL4S3B_FPGA_IP_UART_Test_6/m
add wave -noupdate /testbench_top/testCases_AL4S3B_FPGA_IP/u_testCases_AL4S3B_FPGA_IP_UART/Generic_AL4S3B_FPGA_IP_UART_Test_6/n
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/A2F_HREADYOUTS_nxt
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/A2F_HREADYOUTS
add wave -noupdate -color Gold /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/trans_req
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/ahb_to_fabric_state
add wave -noupdate -color Gold /testbench_top/u_AL4S3B_FPGA_Top/WBs_ACK
add wave -noupdate -color Yellow /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/fabric_async_ack
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/A2F_HSEL
add wave -noupdate {/testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/A2F_HTRANSS[1]}
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ffe_ahb_to_fabric_async_bridge/u_FFE_ahb_to_fabric_async_bridge_interface/A2F_HREADYS
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HSEL
add wave -noupdate {/testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HTRANSS[1]}
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/A2F_HREADYS
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/ahb_read_word_al4s3b_fabric/TARGET_ADDRESS
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_qlal4s3b_cell_macro/u_ASSP_bfm_inst/u_ahb_gen_bfm/ahb_read_word_al4s3b_fabric/TARGET_DATA
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Rx_FIFOs/u_Tx_fifo/PUSH
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Rx_FIFOs/u_Tx_fifo/POP
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Rx_FIFOs/u_Tx_fifo/DIN
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Rx_FIFOs/u_Tx_fifo/DOUT
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_Shift_Reg
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_Shift_Reg_nxt
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_Shift_Reg_Data
add wave -noupdate -color Gold /testbench_top/u_AL4S3B_FPGA_Top/UART0_SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_SOUT_o
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_Baud_16x_cntr_tc
add wave -noupdate /testbench_top/u_AL4S3B_FPGA_Top/u_AL4S3B_FPGA_IP/u_UART_16550_0/u_UART_16550_Tx_Logic/Tx_Bit_Time_cntr_tc
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx_monitor_state
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx_Data_Bit
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx_Baud_16x_Clk
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx_Bit_Count
add wave -noupdate /testbench_top/u_Serial_Rx0_monitor/Rx_2ff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {25642405 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
configure wave -valuecolwidth 108
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
WaveRestoreZoom {10433936 ps} {28814724 ps}
