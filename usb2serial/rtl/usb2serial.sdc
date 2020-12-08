create_clock -period 83.33 Sys_Clk0
create_clock -period 20.8 clk_switch_0.clk_out
set_clock_groups -exclusive -group {Sys_Clk0} -group {clk_switch_0.clk_out}
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.serial_tx_data_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.data_shift_reg_dff_Q.QD\[0\]}] 3
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.data_shift_reg_dff_Q_*.QD\[0\]}] 3
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.serial_tx_se0_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.oe_shift_reg_dff_Q_*.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.oe_shift_reg_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.se0_shift_reg_dff_Q_*.QD\[0\]}] 3
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.pkt_state_dffe_Q.QEN\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.se0_shift_reg_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.pkt_state_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.serial_tx_oe_dff_Q.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.pkt_state_dff_Q_*.QD\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.data_payload_dffe_Q.QEN\[0\]}] 2
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.serial_tx_data_dff_Q.QD\[0\]}] 3
set_multicycle_path -setup -from [get_clocks {clk_switch_0.clk_out}] -to [get_pins {u_AL4S3B_FPGA_IP.u_usb2m4_serial.usb_fs_pe_inst.usb_fs_tx_inst.tx_data_get_48_dffe_Q.QEN\[0\]}] 2












