quit -sim

vlib work

set TEST_NAME uart_test_6

vlog -work work  qlprim.v
vlog -work work  top.vq
vlog -work work  ../AL4S3B/FFE_fabric_to_ahb_async_bridge_interface.v
vlog -work work  ../AL4S3B/FFE_ahb_to_fabric_async_bridge_interface.v
vlog -work work  ../AL4S3B/FFE_ahb_to_fabric_async_bridge.v
vlog -work work  ../AL4S3B/oscillator_s1.v
vlog -work work  ../AL4S3B/ahb_gen_bfm.v
vlog -work work  ../AL4S3B/sdma_bfm.v
vlog -work work  ../AL4S3B/qlal4s3b_cell_macro_bfm.v
vlog -work work  ../UART/Serial_Rx_monitor.v
vlog -work work  ../UART/Serial_Tx_gen_bfm.v
vlog -work work  testCases_AL4S3B_FPGA_IP_UART.v
vlog -work work  testCases_AL4S3B_FPGA_IP.sv
vlog -work work  Generic_tb_AL4S3B_FPGA_IP.v


#vsim +define+SIMULATION -t ps -novopt work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME
vsim +define+SIMULATION +no_tchk_msg -t ps -sdfmax /testbench_top/u_AL4S3B_FPGA_Top=top.sdf -novopt work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME

#vsim +define+SIMULATION +notimingchecks -coverage -novopt +acc work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME

do wave.do
log -r *
run -all