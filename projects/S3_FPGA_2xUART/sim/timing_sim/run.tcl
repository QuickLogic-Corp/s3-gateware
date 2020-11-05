quit -sim

vlib work

set TEST_NAME uart_test_6

vlog -work work +define+GSIM ./models/cells_sim.v
vlog -work work +define+GSIM ./models/ram_sim.v
vlog -work work +define+GSIM ./models/fifo_controller.sim.v
vlog -work work +define+GSIM ./models/ram.sim.v
vlog -work work +define+GSIM ./models/ramfifo.sim.v
vlog -work work +define+GSIM ./models/assp_bfm.sim.v

vlog -work work +define+GSIM top_post_synthesis.v

vlog -work work +define+GSIM ../../testbench/Serial_Rx_monitor.v
vlog -work work +define+GSIM ../../testbench/Serial_Tx_gen_bfm.v
vlog -work work +define+GSIM ../../testbench/testCases_AL4S3B_FPGA_IP_UART.v
vlog -work work +define+GSIM ../../testbench/testCases_AL4S3B_FPGA_IP.sv
vlog -work work +define+GSIM ../../testbench/Generic_tb_AL4S3B_FPGA_IP.v

vsim +define+SIMULATION -t ps -novopt work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME
#vsim +define+SIMULATION +no_tchk_msg -t ps -sdfmax /testbench_top/u_AL4S3B_FPGA_Top=top.sdf -novopt work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME


do wave.do
log -r *
run -all