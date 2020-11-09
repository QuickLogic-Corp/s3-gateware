quit -sim

vlib work

set TEST_NAME uart_test_6

vlog -work work  ./models/cells_sim.v
vlog -work work  ./models/pp3_cells_sim.v

vlog -work work  ../../../../ip_modules/UART_16550/rtl/f512x16_512x16.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/f512x8_512x8.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550_Tx_Rx_FIFOs.v  
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550_Tx_Logic.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550_Rx_Logic.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550_Interrupt_Control.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550_Registers.v
vlog -work work  ../../../../ip_modules/UART_16550/rtl/UART_16550.v
vlog -work work  ../../../../ip_modules/GPIO/rtl/GPIO_controller.v
vlog -work work  ../../rtl/AL4S3B_FPGA_QL_Reserved.v
vlog -work work  ../../rtl/AL4S3B_FPGA_Registers.v
vlog -work work  ../../rtl/AL4S3B_FPGA_IP.v
vlog -work work  ../../rtl/AL4S3B_FPGA_Top.v

vlog -work work  ../../testbench/Serial_Rx_monitor.v
vlog -work work  ../../testbench/Serial_Tx_gen_bfm.v
vlog -work work  ../../testbench/testCases_AL4S3B_FPGA_IP_UART.v
vlog -work work  ../../testbench/testCases_AL4S3B_FPGA_IP.sv
vlog -work work  ../../testbench/Generic_tb_AL4S3B_FPGA_IP.v

vsim +define+SIMULATION -t ps -novopt work.testbench_top -l $TEST_NAME\_run.log +TESTNAME=$TEST_NAME

do wave.do
log -r *
run -all