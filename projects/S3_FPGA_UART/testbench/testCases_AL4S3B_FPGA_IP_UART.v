/*******************************************************************
 *
 *    FILE:         testCases_AL4S3B_FPGA_IP_UART.v 
 *   
 *    DESCRIPTION:  AL4S3B FPGA IP integration test cases for UART
 *
 *    HIERARCHY:   testbench_top\testCases\testCases_AL4S3B_FPGA_IP_UART
 *
 *    AUTHOR:	    Glen Gomes
 *
 *    HISTORY:
 *			        - 02/03/2016	Initial coding.
 *			
 *
 * Copyright (C) 2016, Licensed Customers of QuickLogic may copy and modify this
 * file for use in designing QuickLogic devices only.
 *
 * IMPORTANT NOTICE: DISCLAIMER OF WARRANTY
 * This design is provided without warranty of any kind.
 * QuickLogic Corporation does not warrant, guarantee or make any representations
 * regarding the use, or the results of the use, of this design. QuickLogic
 * disclaims all implied warranties, including but not limited to implied
 * warranties of merchantability and fitness for a particular purpose. In addition
 * and without limiting the generality of the foregoing, QuickLogic does not make
 * any warranty of any kind that any item developed based on this design, or any
 * portion of it, will not infringe any copyright, patent, trade secret or other
 * intellectual property right of any person or entity in any country. It is the
 * responsibility of the user of the design to seek licenses for such intellectual
 * property rights where applicable. QuickLogic shall not be liable for any
 * damages arising out of or in connection with the use of the design including
 * liability for lost profit, business interruption, or any other damages whatsoever.
 *
 * ------------------------------------------------------------
 * Date: February 03, 2016
 * Engineer: Glen Gomes
 * Revision: 0.1
 * Change:
 * 1. Initial Codeing
 *******************************************************************/
`timescale 1ns/10ps


module testCases_AL4S3B_FPGA_IP_UART;
 

//------Port Parameters----------------
//

parameter                ADDRWIDTH                   = 32     ;
parameter                DATAWIDTH                   = 32     ;

parameter                APERWIDTH                   = 17     ;
parameter                APERSIZE                    =  9     ;

parameter                BASE_AHB_ADDRESS            = 32'h40022000;
parameter                UART0_BASE_ADDRESS          = 32'h40021000;
parameter                UART1_BASE_ADDRESS          = 32'h40022000;

parameter                SERIAL_DATA_5_BITS          =  2'b00 ;
parameter                SERIAL_DATA_6_BITS          =  2'b01 ;
parameter                SERIAL_DATA_7_BITS          =  2'b10 ;
parameter                SERIAL_DATA_8_BITS          =  2'b11 ;

parameter                SERIAL_PARITY_NONE          =  3'b000;
parameter                SERIAL_PARITY_ODD           =  3'b001;
parameter                SERIAL_PARITY_EVEN          =  3'b011;
parameter                SERIAL_PARITY_FORCE_1       =  3'b101;
parameter                SERIAL_PARITY_FORCE_0       =  3'b111;

parameter                SERIAL_STOP_1_BIT           =  1'b0  ;
parameter                SERIAL_STOP_1P5_BIT         =  1'b1  ;
parameter                SERIAL_STOP_2_BIT           =  1'b1  ;

parameter                SERIAL_BAUD_RATE_110        =  4'h0  ;
parameter                SERIAL_BAUD_RATE_300        =  4'h1  ;
parameter                SERIAL_BAUD_RATE_600        =  4'h2  ;
parameter                SERIAL_BAUD_RATE_1200       =  4'h3  ;
parameter                SERIAL_BAUD_RATE_2400       =  4'h4  ;
parameter                SERIAL_BAUD_RATE_4800       =  4'h5  ;
parameter                SERIAL_BAUD_RATE_9600       =  4'h6  ;
parameter                SERIAL_BAUD_RATE_14400      =  4'h7  ;
parameter                SERIAL_BAUD_RATE_19200      =  4'h8  ;
parameter                SERIAL_BAUD_RATE_38400      =  4'h9  ;
parameter                SERIAL_BAUD_RATE_57600      =  4'hA  ;
parameter                SERIAL_BAUD_RATE_115200     =  4'hB  ;
parameter                SERIAL_BAUD_RATE_230400     =  4'hC  ;
parameter                SERIAL_BAUD_RATE_921600     =  4'hD  ;

parameter                STD_CLK_DLY                 =  2     ;
parameter                ENABLE_TEST_DEBUG_MSG       =  1'b1  ;


//------Port Signals-------------------
//

//
// None at this time
//


//------Define Parameters--------------
//

//
// UART 16750 Memory Map is:
//
// Register Name              IP Adr   Fab Adr  Comments
//
// UART Xmt Buffer  Reg      -  0x00     0x00    RBR - (Read  Only) with DLAB = 0
// UART Xmt Holding Reg      -  0x00     0x00    THR - (Write Only) with DLAB = 0
//
// UART Divisor Latch (LSB)  -  0x00     0x00    DLL -              with DLAB = 1
//
// UART Interrupt Enable Reg -  0x01     0x04    IER -              with DLAB = 0
// UART Divisor Latch (MSB)  -  0x01     0x04    DLM -              with DLAB = 1
//
// UART Interrupt ID  Reg    -  0x02     0x08    IIR - (Read  Only)
// UART FIFO Control  Reg    -  0x02     0x08    FCR - (Write Only)
//
// UART Line  Control Reg    -  0x03     0x0C    LCR - Contains the DLAB Bit
// UART Modem Control Reg    -  0x04     0x10    MCR
// UART Line  Status  Reg    -  0x05     0x14    LSR
// UART Modem Status  Reg    -  0x06     0x18    MSR
// UART Scratch       Reg    -  0x07     0x1C    SCR
//

parameter                UART_RBR                    =  8'h00;
parameter                UART_THR                    =  8'h00;

parameter                UART_DLL                    =  8'h00;

parameter                UART_IER                    =  8'h04;
parameter                UART_DLM                    =  8'h04;


parameter                UART_IIR                    =  8'h08;
parameter                UART_FCR                    =  8'h08;


parameter                UART_LCR                    =  8'h0C;
parameter                UART_MCR                    =  8'h10;
parameter                UART_LSR                    =  8'h14;
parameter                UART_MSR                    =  8'h18;
parameter                UART_SCR                    =  8'h1C;
parameter                UART_RX_FIFO_LEVEL          =  8'h20;
parameter                UART_TX_FIFO_LEVEL          =  8'h24;


// UART Parameters
//
parameter                BREAK_ON                    =  1'b1 ;
parameter                BREAK_OFF                   =  1'b0 ;


//------Internal Signals---------------
//


reg				enable_pass_test_message_display;
reg				enable_fail_test_message_display;
reg				enable_performance_message_display;


integer			fail_count;				// Count the number of failing tests
integer			pass_count;				// Count the number of passing tests


//------Instantiate Modules------------
//

//
// None at this time
//


//------Logic Operations---------------
//


// Set the Status for displaying messages
//
initial
begin

	// Reset the Pass / Fail Counts
	//
	pass_count									= 0;
	fail_count									= 0;

	// Wait until after the variable is initially set
	//
	// Note: All initial blocks are executed in parallel
	//
	#5;

	// Enable the output to the screen for test messages
	//
	enable_pass_test_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_pass_test_message_display;
	enable_fail_test_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_fail_test_message_display;
	enable_performance_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_performance_message_display;

end


// Dynamically update the Status for displaying messages
//
always @(testbench_top.testCases_AL4S3B_FPGA_IP.enable_pass_test_message_display   or
	     testbench_top.testCases_AL4S3B_FPGA_IP.enable_fail_test_message_display   or
	     testbench_top.testCases_AL4S3B_FPGA_IP.enable_performance_message_display)
begin

	// Enable the output to the screen for test messages
	//
	enable_pass_test_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_pass_test_message_display;
	enable_fail_test_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_fail_test_message_display;
	enable_performance_message_display		   <= testbench_top.testCases_AL4S3B_FPGA_IP.enable_performance_message_display;

end


//------Test Routines------------------
//


// Define the top level task that controls all of the ULPSensor Hub's Memory I/O tests.
//
task testCases_AL4S3B_FPGA_IP_UART_testRoutines;

input  [31:0] TEST_ENABLES;
output [31:0] TOTAL_FAIL_COUNT;            // Count the number of failing tests
output [31:0] TOTAL_PASS_COUNT;            // Count the number of passing tests

integer initial_mem_contents_file;
integer std_mem_addrs_file;
integer final_mem_contents_file;

begin

	// Define a call to each test
	//
	if (TEST_ENABLES[0])
        Generic_AL4S3B_FPGA_IP_UART_Test_1(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[1])
        Generic_AL4S3B_FPGA_IP_UART_Test_2(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[2])
        Generic_AL4S3B_FPGA_IP_UART_Test_3(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[3])
        Generic_AL4S3B_FPGA_IP_UART_Test_4(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[4])
        Generic_AL4S3B_FPGA_IP_UART_Test_5(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[5])
      begin
        //Generic_AL4S3B_FPGA_IP_UART_Test_6(BASE_AHB_ADDRESS);
        $display("test 6 - UART0 ");
        Generic_AL4S3B_FPGA_IP_UART_Test_6(UART0_BASE_ADDRESS);
        $display("test 6 - UART0 done");
       #100
        $display("test 7 - UART0 ");
        Generic_AL4S3B_FPGA_IP_UART_Test_7(UART0_BASE_ADDRESS);
        $display("test 7 - UART0 done"); 
      end

	if (TEST_ENABLES[6])
      begin
        //Generic_AL4S3B_FPGA_IP_UART_Test_7(BASE_AHB_ADDRESS); 
        Generic_AL4S3B_FPGA_IP_UART_Test_7(UART0_BASE_ADDRESS);
      end
        
	if (TEST_ENABLES[7])
        Generic_AL4S3B_FPGA_IP_UART_Test_8(BASE_AHB_ADDRESS);

	if (TEST_ENABLES[8])
        Generic_AL4S3B_FPGA_IP_UART_Test_9(BASE_AHB_ADDRESS);


	// Display test execution statistics
	//
	// Note: pass_count and fail_count are global in this module
	//       but total_fail_count, and total_pass_count are not.
	//
	TOTAL_FAIL_COUNT = fail_count;
	TOTAL_PASS_COUNT = pass_count;

end       
endtask


//--------------------------------------------------------------------
// The following task performs a simple register test on the available
// read/write registers of the UART
//
// Operations: Each register will have a series of patterns written, read, and
//             checked for correctness.
//
// Limitation: This test does not check status registers for correct
//             operation. This will be done in various other tests.
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_1;
input    [ADDRWIDTH-1:0]  base_address;
	
reg      [DATAWIDTH-1:0]  read_data;
reg      [DATAWIDTH-1:0]  write_data;

reg	     [DATAWIDTH-1:0]  expected_data;
reg	     [DATAWIDTH-1:0]  target_address;
reg	     [DATAWIDTH-1:0]  target_data;
reg	     [DATAWIDTH-1:0]  target_mask;

integer                   i, j, k, m;


begin

	// Initialize variables to a default value
	//
	//$stop();
    read_data  = 32'h0;
	write_data = 32'h0;

	// Wait for release of reset
    //
`ifdef GSIM
    wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0); 
`else
    wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0); 
`endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
`ifdef GSIM
    @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK);
`else
		@(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK);
`endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_1";

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Reading from UART 0 - 16750";

	// UART 16750 Memory Map is:
	//
	// Register Name              IP Adr   Fab Adr  Comments
	//
	// UART Xmt Buffer  Reg      -  0x00     0x00    RBR - (Read  Only) with DLAB = 0
	// UART Xmt Holding Reg      -  0x00     0x00    THR - (Write Only) with DLAB = 0
	//
	// UART Divisor Latch (LSB)  -  0x00     0x00    DLL -              with DLAB = 1
	//
	// UART Interrupt Enable Reg -  0x01     0x04    IER -              with DLAB = 0
	// UART Divisor Latch (MSB)  -  0x01     0x04    DML -              with DLAB = 1
	//
	// UART Interrupt ID  Reg    -  0x02     0x08    IIR - (Read  Only)
	// UART FIFO Control  Reg    -  0x02     0x08    FCR - (Write Only)
	//
	// UART Line  Control Reg    -  0x03     0x0C    LCR
	// UART Modem Control Reg    -  0x04     0x10    MCR
	// UART Line  Status  Reg    -  0x05     0x14    LSR
	// UART Modem Status  Reg    -  0x06     0x18    MSR
	// UART Scratch       Reg    -  0x07     0x1C    SCR
	//

	// Write a Useful Diagnostic Message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to LCR";

	// Write a value to the UART 16750's Line Control Register
	//
	// Note: This selects the Divisor Latch Registers rather than the Tx/Rx register
	//
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), 32'h0080);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), 32'h0080);
`endif
	// Issue a debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Testing UART Registers";

	for (k = 0; k < 6; k = k + 1)
	begin

        // Clear the LAB bit
        //
        if (k == 2)
        begin
	        // Write a Useful Diagnostic Message
	        //
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to LCR";

	        // Write a value to the UART 16750's Line Control Register
	        //
	        // Note: This selects the Divisor Latch Registers rather than the Tx/Rx register
	        //
        `ifdef GSIM
          testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), 32'h0000);
        `else
	        testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), 32'h0000);
        `endif 
        end

		// Select the target address within the ASSP
		//
		case(k[2:0])
		3'h0:    target_address = 32'h0000_0000; // Divisor LSB
		3'h1:    target_address = 32'h0000_0004; // Divisor MSB
		3'h2:    target_address = 32'h0000_0004; // Interrupt Enable
		3'h3:    target_address = 32'h0000_000c; // LCR
		3'h4:    target_address = 32'h0000_0010; // MCR
		3'h5:    target_address = 32'h0000_001c; // SCR
		default: target_address = 32'h0000_0000;
		endcase

		// Select a mask to allow for accurate determinations
		// of what we are expecting back
		//
		case(k[2:0])
		3'h0:    target_mask = 32'h0000_00ff; // Divisor LSB
		3'h1:    target_mask = 32'h0000_00ff; // Divisor MSB
		3'h2:    target_mask = 32'h0000_0007; // Interrupt Enable
		3'h3:    target_mask = 32'h0000_00ff; // LCR
		3'h4:    target_mask = 32'h0000_0010; // MCR
		3'h5:    target_mask = 32'h0000_00ff; // SCR
		default: target_mask = 32'h0000_0000;
		endcase

	    // Wait for a few clocks
	    //
	    for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK);
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK);
    `endif

		// Loop to send a variety of data to the target
		//
		for (j = 0; j < 9; j = j + 1)
		begin

			// Select the data to send
			//
			case (j[3:0])
			3'h0:    target_data = 32'h12_34_56_78;	// Endian  Pattern
			3'h1:    target_data = 32'h87_65_43_21;	// Reverse Pattern
			3'h2:    target_data = 32'h56_78_12_34;	// Endian  Pattern
			3'h3:    target_data = 32'h34_12_78_56;	// Endian  Pattern
			3'h4:    target_data = 32'h78_56_34_12;	// Endian  Pattern
			3'h5:    target_data = 32'haa_aa_aa_aa;	// Toggle  Pattern
			3'h6:    target_data = 32'h55_55_55_55;	// Toggle  Pattern
			3'h7:    target_data = 32'h99_99_99_99;	// Toggle  Pattern
			3'h8:    target_data = 32'h66_66_66_66;	// Toggle  Pattern
			default: target_data = 32'hDE_AD_DE_AD;	// Default Pattern
			endcase


			// Select the diagnostic message to post
			//
			case(k[2:0])
			3'h0:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Divisor LSB Register";
			3'h1:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Divisor MSB Register";
			3'h2:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Interrupt Enable Register";
			3'h3:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Line Control Register";
			3'h4:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Modem Control Register";
			3'h5:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Scratch Register";
			default: testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing Unknown Register";
			endcase

			// Wait for a few clocks
			//
			for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

			// Write to the target FPGA register
			//
          `ifdef GSIM
            testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((BASE_AHB_ADDRESS + target_address[7:0]), target_data);
          `else
            testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((BASE_AHB_ADDRESS + target_address[7:0]), target_data);
          `endif
			// Clear the status between reads
			//
			testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "NO ACTIVITY";

			// Wait for a few clocks
			//
			for (i = 0; i < 64; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

			case(k[2:0])
			3'h0:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Divisor LSB Register";
			3'h1:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Divisor MSB Register";
			3'h2:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Interrupt Enable Register";
			3'h3:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Line Control Register";
			3'h4:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Modem Control Register";
			3'h5:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Line Status Register";
			3'h6:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Modem Status Register";
			3'h7:    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Scratch Register";
			default: testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Unknown Register";
			endcase

			// Read from the FPGA Register
			//
          `ifdef GSIM
            testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((BASE_AHB_ADDRESS + target_address[7:0]), read_data);
          `else
            testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((BASE_AHB_ADDRESS + target_address[7:0]), read_data);
          `endif
			// Check the value read back for correctness
			//
			expected_data = target_data & target_mask;

            if (read_data[7:0] !== expected_data[7:0])
            begin
                $display("[Error] Generic_AL4S3B_FPGA_Fab_Reg_Test_1: UART Register Address=0x%x , read=0x%x , expected=0x%x at time %0t", 
                                                                                                   (BASE_AHB_ADDRESS + target_address[7:0]), 
						                                                                                                     read_data[7:0], 
                                                                                                                         expected_data[7:0], 
                                                                                                                                  $realtime );
                fail_count = fail_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
            end	
            else
            begin
                $display("[Pass]  Generic_AL4S3B_FPGA_Fab_Reg_Test_1: UART Register Address=0x%x , read=0x%x , expected=0x%x at time %0t",  
                                                                                                   (BASE_AHB_ADDRESS + target_address[7:0]),
                                                                                                                             read_data[7:0],
                                                                                                                         expected_data[7:0],
                                                                                                                                  $realtime );
                pass_count = pass_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
            end
		end
	end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Rx operations w/o Rx FIFO
//
// Operations: This routine use the Rx logic without FIFO to check the
//             interrupt and status generation for various Rx errors.
//
// Limitation: This test is focused on the Rx logic without using the FIFO.
//             The Rx FIFO based tests will be done in another routine.
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_2;
input    [ADDRWIDTH-1:0]  base_address     ;
	
reg      [DATAWIDTH-1:0]  read_data        ;
reg      [DATAWIDTH-1:0]  write_data       ;

reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_address   ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg      [DATAWIDTH-1:0]  IIR_read_data    ;

integer                   i, j, k, m, n    ;

begin

	// Initialize variables to a default value
	//
    read_data  = 32'h0;
	write_data = 32'h0;
	
	//$stop();

	// Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_2";

	// UART 16750 Memory Map is:
	//
	// Register Name              IP Adr   Fab Adr  Comments
	//
	// UART Xmt Buffer  Reg      -  0x00     0x00    RBR - (Read  Only) with DLAB = 0
	// UART Xmt Holding Reg      -  0x00     0x00    THR - (Write Only) with DLAB = 0
	//
	// UART Divisor Latch (LSB)  -  0x00     0x00    DLL -              with DLAB = 1
	//
	// UART Interrupt Enable Reg -  0x01     0x04    IER -              with DLAB = 0
	// UART Divisor Latch (MSB)  -  0x01     0x04    DML -              with DLAB = 1
	//
	// UART Interrupt ID  Reg    -  0x02     0x08    IIR - (Read  Only)
	// UART FIFO Control  Reg    -  0x02     0x08    FCR - (Write Only)
	//
	// UART Line  Control Reg    -  0x03     0x0C    LCR
	// UART Modem Control Reg    -  0x04     0x10    MCR
	// UART Line  Status  Reg    -  0x05     0x14    LSR
	// UART Modem Status  Reg    -  0x06     0x18    MSR
	// UART Scratch       Reg    -  0x07     0x1C    SCR
	//

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to only use the Rx receive register
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`endif
    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to IER";

    // Set the Interrupt Enable register to enable all interrupts 
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`endif
    // Set the Communication Parameters
    //
    word_length      = SERIAL_DATA_8_BITS;
    stop_bit_length  = SERIAL_STOP_2_BIT ;
    parity_selection = SERIAL_PARITY_ODD ;
	target_data      = 32'h0000_00AA;

    // Set the Baud Rate on the UART
    //
    Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
                                                 word_length,
                                            parity_selection,
                                             stop_bit_length,
                                      SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                   BREAK_OFF );

    // Set a diagnostic message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Issue a serial stream";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Using a BFM to emulate an external UART";

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                          target_data[7:0] );



    // Initialize variable
    //
    read_data = 0;

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete";

	// Poll for serial tranmission complete
	//
	while ((read_data & 32'h0000_0001) === 32'h0)
    begin
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `endif
        // Debug Message
        //
//      $display("        Generic_AL4S3B_FPGA_UART_Test_2:  UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
    end

    // Set a diagnostic message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Check for FIFO Clear";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Use FCR to apply FIFO Clear";

    // Apply FIFO Clear to the Rx Holding Register
    //
    // Note: The FIFO Clear operation should do nothing
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h2);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h2);
`endif
    // Issue diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Checking LSR for FIFO Clear";

    // Read the Line Status register to see if the status has changed
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
`endif
    // The expected status shows that the Tx logic is empty, and the Receive Holding register is full.
    //
    expected_data = 32'h61;

    // Determine if there was a data error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set a diagnostic message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Check for Overrun";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Use BFM to emulate external UART";

    // Now see if we get an overflow for an extra serial transfer to the UART
	//
    target_data[7:0] = 32'h66;

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                          target_data[7:0] );

    
    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete";

    // Clear the variable
    //
	read_data = 0;

	// Poll for serial tranmission complete
	//
	while ((read_data & 32'h0000_0002) === 32'h0)
    begin
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `endif
        // Debug Message
        //
//      $display("        Generic_AL4S3B_FPGA_UART_Test_2:  UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
    end

    // The expected status shows that the Tx logic is empty, the Receive Holding register is full, and there is an overrun.
    //
    expected_data = 32'h63;

    // Determine if there was a overrun error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

    // Check if an interrupt was generated
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
`endif
    // Check that there are:
    //
    //     - FIFOs are not enabled
    //     - Interrupt priority bits show that the Rx Holding register contains the last value written
    //     - Interrupt status shows an interrupt pending due to the Rx Holding Register
    //     - There is no Line Status error because the overrun was cleared by reading the Line Status register.
    //
	//  The last read should have cleared the interrupt
	//
    expected_data = 32'h4;

    // Determine if there was a interrupt generated 
	//
    if (IIR_read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t", 
                                                                                                 IIR_read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                 IIR_read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Re-read LSR to check if bits are cleared";

    // Read the Line Status register to see if the status has cleared
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
`endif
    // The expected status shows that the Tx logic is empty, and the Receive Holding register is full but the overrun is cleared.
    //
    expected_data = 32'h61;

    // Determine if there was a data error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx Data to empty Rx Holding Reg";

    // Read value received from the external UART
    //
    // Note: This will empty the Rx Holding register prior to the next serial stream.
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RBR), read_data);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RBR), read_data);
`endif
    // The last serial stream should be in the Rx Holding register
	//
    expected_data = target_data[7:0];

    // Determine if there was a data error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Serial Rx data  read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Serial Rx data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to IER";

    // Set the Interrupt Enable register to enable all interrupts 
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`endif
    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

    // Check if an interrupt was generated
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
`endif
    // Check that there are:
    //
    //     - FIFOs are not enabled
    //     - Interrupt priority bits are clear (no interrupt)
    //     - The Rx Holding register is now empty
    //     - Interrupt status shows no interrupts (interrupt not pending == "1" not "0")
    //
    expected_data = 32'h1;

    // Determine if there was a interrupt generated 
	//
    if (IIR_read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t", 
                                                                                                 IIR_read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                 IIR_read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set a diagnostic message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Check for Frame Error";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Use BFM to emulate external UART";

    // Change the Serial Stream Format
	//
    stop_bit_length  = SERIAL_STOP_1_BIT ;


    // Now see if we get a frame error by sending the wrong format to the UART
	//
	// Note: This will require two serial streams
	//
    target_data[7:0] = 32'h99;

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                          target_data[7:0] );

    // Now see if we get a frame error for an extra serial transfer to the UART
	//
    target_data[7:0] = 32'h11;

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                          target_data[7:0] );


    // Wait for the UART to complete capturing the serial stream
    //
    // Note: Polling the LSR will clear some of the status bits. This will
	//       affect the results of the interrupt ID (i.e. Status) Register
    //
	for (i = 0; i < 20; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif


    // Loop to check each valid interrupt status
    //
    // Note: The interrupt status has a set of priorities. The LSR is first
	//       and the "Received Data Available" is second.
    //
	for (i = 0; i < 3; i = i + 1)
    begin
        // Set Diagnostic Message
        //
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

        // Check if an interrupt was generated
        //
      `ifdef GSIM
        testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
      `else
	      testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
      `endif
        // Check that there are:
        //
        //     - FIFOs are not enabled
        //     - Interrupt priority bits are clear (no interrupt)
        //     - Interrupt status shows no interrupts (interrupt not pending == "1" not "0")
        //
		case(i[1:0])
        2'h0: expected_data = 32'h6;
        2'h1: expected_data = 32'h4;
        2'h2: expected_data = 32'h1;
        endcase

        // Determine if there was a interrupt generated 
	    //
        if (IIR_read_data[7:0] !== expected_data[7:0])
        begin
            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t", 
                                                                                                     IIR_read_data[7:0], 
                                                                                                     expected_data[7:0], 
                                                                                                              $realtime );
            fail_count = fail_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
        end	
        else
        begin
            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                     IIR_read_data[7:0],
                                                                                                     expected_data[7:0],
                                                                                                              $realtime );
            pass_count = pass_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
        end
    end

    // Initialize the variable
    //
    read_data = 0;

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete on 1st transfer";

    // Poll for serial tranmission complete for the first serial stream
    //
    while ((read_data & 32'h0000_0001) === 32'h0)
    begin
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `endif
        // Debug Message
        //
//      $display("  Generic_AL4S3B_FPGA_IP_UART_Test_1:  UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
    end
   
    // The expected status shows that the Tx logic is empty, and the Receive Holding register is full.
    //
    // Note: This is check the result of the first serial transfer. The second one is still in progress.
    //
    expected_data = 32'h69;

    // Determine if there was a Frame Error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Wait for the UART to complete capturing the serial stream
    //
    // Note: Polling the LSR will clear some of the status bits. This will
	//       affect the results of the interrupt ID (i.e. Status) Register
    //
	for (i = 0; i < 260; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif


    // Loop to check each valid interrupt status
    //
    // Note: The interrupt status has a set of priorities. The LSR is first
	//       and the "Received Data Available" is second.
    //
	for (i = 0; i < 3; i = i + 1)
    begin
        // Set Diagnostic Message
        //
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

        // Check if an interrupt was generated
        //
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), IIR_read_data);
    `endif
        // Check that there are:
        //
        //     - FIFOs are not enabled
        //     - Interrupt priority bits are clear (no interrupt)
        //     - Interrupt status shows no interrupts (interrupt not pending == "1" not "0")
        //
		case(i[1:0])
        2'h0: expected_data = 32'h6;
        2'h1: expected_data = 32'h4;
        2'h2: expected_data = 32'h1;
        endcase

        // Determine if there was a interrupt generated 
	    //
        if (IIR_read_data[7:0] !== expected_data[7:0])
        begin
            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t", 
                                                                                                     IIR_read_data[7:0], 
                                                                                                     expected_data[7:0], 
                                                                                                              $realtime );
            fail_count = fail_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
        end	
        else
        begin
            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Intr. ID  data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                     IIR_read_data[7:0],
                                                                                                     expected_data[7:0],
                                                                                                              $realtime );
            pass_count = pass_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
        end
    end
    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete on second transfer";

    // Poll for serial tranmission complete of the second serial stream
    //
    // Note: This should cause an overrun. 
    //
    //       Keep in mind that since this transfer is incorrectly 
    //       applied due to the serial format difference, the 
    //       resulting value transferred is different than the 
    //       one applied above.
    //
    while ((read_data & 32'h0000_0002) === 32'h0)
    begin
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
    `endif
        // Debug Message
        //
//      $display("        Generic_AL4S3B_FPGA_UART_Test_2: UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
    end
    
    // The expected status shows that the Tx logic is empty, and the Receive Holding register is full, there was an overrun and parity error.
    //
    // Note: The extra serial stream was in the wrong format. This also produced a parity error.
    //
    expected_data = 32'h67;

    // Determine if there was a data error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Getting UART Line Status";

    // Read the Line Status register to see if the status has cleared the overrun and parity errors
    //
  `ifdef GSIM
    testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
  `else
  	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
  `endif
    // The expected status shows that the Tx logic is empty, and the Receive Holding register is full and errors are cleared.
    //
    expected_data = 32'h61;

    // Determine if there was a data error 
	//
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t", 
                                                                                                     read_data[7:0], 
                                                                                                 expected_data[7:0], 
                                                                                                          $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_2: Line Status     read=0x%x , expected=0x%x at time %0t",  
                                                                                                     read_data[7:0],
                                                                                                 expected_data[7:0],
                                                                                                          $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Wait for the Timeout Interrupt
	//
	for (i = 0; i < 666; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif


    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Rx operations w/o Rx FIFO
//
// Operations: Each Rx format is checked for correct operation. 
//             This routine does not use the Rx FIFO; therefore, 
//             the Receive Holding Register is checked on a transfer 
//             by transfer basis.
//
// Limitation: There are no error injected into the serial input stream.
//             Therefore, there is no checking for error generation or 
//             interrupt generation. This is left to another routine.
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_3;

input    [ADDRWIDTH-1:0]  base_address     ;
	
integer                   i, j, k, m       ;

reg      [DATAWIDTH-1:0]  RBR_read_data    ;
reg      [DATAWIDTH-1:0]  read_data        ;

reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

begin

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif
		
//	$stop();	

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_3";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to only use the Rx receive register
    //
    // Note: FIFO operations will be tested in a different routine
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`endif

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Looping to test UART Rx Formats";

    // Check each Rx format for correctness
    //
	for (i = 0; i < 4; i = i + 1)
    begin

        case(i[1:0])
        2'h0: word_length = SERIAL_DATA_5_BITS;
        2'h1: word_length = SERIAL_DATA_6_BITS;
        2'h2: word_length = SERIAL_DATA_7_BITS;
        2'h3: word_length = SERIAL_DATA_8_BITS;
        endcase

		// Select a mask to allow for accurate determinations
		// of what we are expecting back
		//
		case(i[1:0])
		2'h0:    target_mask = 32'h0000_001f;
		2'h1:    target_mask = 32'h0000_003f;
		2'h2:    target_mask = 32'h0000_007f;
		2'h3:    target_mask = 32'h0000_00ff;
		endcase

        // Try different Stop bit configurations
        //
        for (j = 0; j < 2; j = j + 1)
        begin

            case(j[0])
            1'b0: stop_bit_length = SERIAL_STOP_1_BIT;
            1'b1: stop_bit_length = SERIAL_STOP_2_BIT; // this is 1.5Bits for 5bit word lengths
            endcase

            // Try different Parity bit configurations
            //
            for (k = 0; k < 5; k = k + 1)
            begin

                case(k[2:0])
                3'h0: parity_selection = SERIAL_PARITY_NONE;
                3'h1: parity_selection = SERIAL_PARITY_ODD;
                3'h2: parity_selection = SERIAL_PARITY_EVEN;
                3'h3: parity_selection = SERIAL_PARITY_FORCE_1;
                3'h4: parity_selection = SERIAL_PARITY_FORCE_0;
                endcase
        

                // Set diagnostic message
	            //
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

                // Set the Baud Rate on the UART
                //
                Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
						                                     word_length,
                                                        parity_selection,
                                                         stop_bit_length,
                                                  SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                               BREAK_OFF );

                // Try different data patterns
                //
                for (m =0; m < 38; m = m + 1)
                begin

				    // Select the data to send
                    //
                    case (m[5:0])
                    6'h00:   target_data = 32'h00_00_00_01;
                    6'h01:   target_data = 32'h00_00_00_02;
                    6'h02:   target_data = 32'h00_00_00_04;
                    6'h03:   target_data = 32'h00_00_00_08;
                    6'h04:   target_data = 32'h00_00_00_10;
                    6'h05:   target_data = 32'h00_00_00_20;
                    6'h06:   target_data = 32'h00_00_00_40;
                    6'h07:   target_data = 32'h00_00_00_80;
                    6'h08:   target_data = 32'h00_00_00_01;
                    6'h09:   target_data = 32'h00_00_00_02;
                    6'h0a:   target_data = 32'h00_00_00_03;
                    6'h0b:   target_data = 32'h00_00_00_04;
                    6'h0c:   target_data = 32'h00_00_00_05;
                    6'h0d:   target_data = 32'h00_00_00_06;
                    6'h0e:   target_data = 32'h00_00_00_07;
                    6'h0f:   target_data = 32'h00_00_00_08;
                    6'h10:   target_data = 32'h00_00_00_09;
                    6'h11:   target_data = 32'h00_00_00_0a;
                    6'h12:   target_data = 32'h00_00_00_0b;
                    6'h13:   target_data = 32'h00_00_00_0c;
                    6'h14:   target_data = 32'h00_00_00_0d;
                    6'h15:   target_data = 32'h00_00_00_0e;
                    6'h16:   target_data = 32'h00_00_00_0f;
                    6'h17:   target_data = 32'h00_00_00_10;
                    6'h18:   target_data = 32'h00_00_00_21;
                    6'h19:   target_data = 32'h00_00_00_32;
                    6'h1a:   target_data = 32'h00_00_00_43;
                    6'h1b:   target_data = 32'h00_00_00_54;
                    6'h1c:   target_data = 32'h00_00_00_65;
                    6'h1d:   target_data = 32'h00_00_00_76;
                    6'h1e:   target_data = 32'h00_00_00_87;
                    6'h1f:   target_data = 32'h00_00_00_98;
                    6'h20:   target_data = 32'h00_00_00_a9;
                    6'h21:   target_data = 32'h00_00_00_ba;
                    6'h22:   target_data = 32'h00_00_00_cb;
                    6'h23:   target_data = 32'h00_00_00_dc;
                    6'h24:   target_data = 32'h00_00_00_ed;
                    6'h25:   target_data = 32'h00_00_00_fe;
                    default: target_data = 32'h00_00_00_AD;
                    endcase

                    // Set diagnostic message
	                //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats from External UART";

                    // Transmit a value from the external BFM
                    //
                    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
				    		                                   word_length,
                                                          parity_selection,
                                                           stop_bit_length,
                                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
							    			              target_data[7:0] );

                    // Initialize variable
                    //
                    read_data = 0;

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete";

		            // Poll for serial tranmission complete
		            //
		            while ((read_data & 32'h0000_0001) === 32'h0)
                    begin
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `endif
                        // Debug Message
                        //
//                      $display("        Generic_AL4S3B_FPGA_UART_Test_3:  UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
                    end

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx Data";

                    // Read value received from the external UART
                    //
                `ifdef GSIM
                  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_THR), RBR_read_data);
                `else
	                testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_THR), RBR_read_data);
                `endif
                    // Check the ouptut value for correctness
                    //
                    expected_data = target_data & target_mask;

                    // Determine if there was a data error 
					//
                    if (RBR_read_data[7:0] !== expected_data[7:0])
                    begin
                        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx data read=0x%x , expected=0x%x at time %0t", 
                                                                                                                RBR_read_data[7:0], 
                                                                                                                expected_data[7:0], 
                                                                                                                         $realtime );
                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end	
                    else
                    begin
                        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                                 RBR_read_data[7:0],
                                                                                                                 expected_data[7:0],
                                                                                                                          $realtime );
                        pass_count = pass_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                    end

                    // Check for various potential errors
                    //
                    if ({read_data[7], read_data[4:1]} !== 0)
                    begin
                        case({read_data[7], read_data[4:1]})
                        5'b00001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b00111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b01111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                        5'b10000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b10111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        5'b11111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                        endcase

                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end	
                    else
                    begin
                        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_3: Serial Rx with No Overrun Error, No Parity Error, No Framing Error, No Break Interrupt, and No FIFO Data Error at time %0t",  $realtime);
                        pass_count = pass_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                    end
				end
            end
        end
    end
    // Sent a value through the receive interface
    //
	
    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Rx operations with the Rx FIFO
//
// Operations: Each Rx format is checked for correct operation. 
//             This routine does use the Rx FIFO; therefore, 
//             the Receive FIFO is filled prior to reading back the Rx data.
//
// Limitation: There are no error injected into the serial input stream.
//             Therefore, there is no checking for error generation or 
//             interrupt generation. This is left to another routine.
//
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_4;

input    [ADDRWIDTH-1:0]  base_address     ;
	
integer                   i, j, k, m       ;

reg      [DATAWIDTH-1:0]  Rx_FIFO_Level    ;
reg      [DATAWIDTH-1:0]  RBR_read_data    ;
reg      [DATAWIDTH-1:0]  read_data        ;

reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

begin

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	//$stop();	
	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_4";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to enable the use the Rx and Tx FIFOs
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`endif

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Looping to test UART Rx Formats";

    // Check each Rx format for correctness
    //
	for (i = 0; i < 4; i = i + 1)
    begin

        case(i[1:0])
        2'h0: word_length = SERIAL_DATA_5_BITS;
        2'h1: word_length = SERIAL_DATA_6_BITS;
        2'h2: word_length = SERIAL_DATA_7_BITS;
        2'h3: word_length = SERIAL_DATA_8_BITS;
        endcase

		// Select a mask to allow for accurate determinations
		// of what we are expecting back
		//
		case(i[1:0])
		2'h0:    target_mask = 32'h0000_001f;
		2'h1:    target_mask = 32'h0000_003f;
		2'h2:    target_mask = 32'h0000_007f;
		2'h3:    target_mask = 32'h0000_00ff;
		endcase

        // Try different Stop bit configurations
        //
        for (j = 0; j < 2; j = j + 1)
        begin

            case(j[0])
            1'b0: stop_bit_length = SERIAL_STOP_1_BIT;
            1'b1: stop_bit_length = SERIAL_STOP_2_BIT; // this is 1.5Bits for 5bit word lengths
            endcase

            // Try different Parity bit configurations
            //
            for (k = 0; k < 5; k = k + 1)
            begin

                case(k[2:0])
                3'h0: parity_selection = SERIAL_PARITY_NONE;
                3'h1: parity_selection = SERIAL_PARITY_ODD;
                3'h2: parity_selection = SERIAL_PARITY_EVEN;
                3'h3: parity_selection = SERIAL_PARITY_FORCE_1;
                3'h4: parity_selection = SERIAL_PARITY_FORCE_0;
                endcase
        

                // Set diagnostic message
	            //
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

                // Set the Baud Rate on the UART
                //
                Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
						                                     word_length,
                                                        parity_selection,
                                                         stop_bit_length,
                                                  SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                               BREAK_OFF );

                // Try different data patterns
                //
                for (m =0; m < 38; m = m + 1)
                begin

				    // Select the data to send
                    //
                    case (m[5:0])
                    6'h00:   target_data = 32'h00_00_00_01;
                    6'h01:   target_data = 32'h00_00_00_02;
                    6'h02:   target_data = 32'h00_00_00_04;
                    6'h03:   target_data = 32'h00_00_00_08;
                    6'h04:   target_data = 32'h00_00_00_10;
                    6'h05:   target_data = 32'h00_00_00_20;
                    6'h06:   target_data = 32'h00_00_00_40;
                    6'h07:   target_data = 32'h00_00_00_80;
                    6'h08:   target_data = 32'h00_00_00_01;
                    6'h09:   target_data = 32'h00_00_00_02;
                    6'h0a:   target_data = 32'h00_00_00_03;
                    6'h0b:   target_data = 32'h00_00_00_04;
                    6'h0c:   target_data = 32'h00_00_00_05;
                    6'h0d:   target_data = 32'h00_00_00_06;
                    6'h0e:   target_data = 32'h00_00_00_07;
                    6'h0f:   target_data = 32'h00_00_00_08;
                    6'h10:   target_data = 32'h00_00_00_09;
                    6'h11:   target_data = 32'h00_00_00_0a;
                    6'h12:   target_data = 32'h00_00_00_0b;
                    6'h13:   target_data = 32'h00_00_00_0c;
                    6'h14:   target_data = 32'h00_00_00_0d;
                    6'h15:   target_data = 32'h00_00_00_0e;
                    6'h16:   target_data = 32'h00_00_00_0f;
                    6'h17:   target_data = 32'h00_00_00_10;
                    6'h18:   target_data = 32'h00_00_00_21;
                    6'h19:   target_data = 32'h00_00_00_32;
                    6'h1a:   target_data = 32'h00_00_00_43;
                    6'h1b:   target_data = 32'h00_00_00_54;
                    6'h1c:   target_data = 32'h00_00_00_65;
                    6'h1d:   target_data = 32'h00_00_00_76;
                    6'h1e:   target_data = 32'h00_00_00_87;
                    6'h1f:   target_data = 32'h00_00_00_98;
                    6'h20:   target_data = 32'h00_00_00_a9;
                    6'h21:   target_data = 32'h00_00_00_ba;
                    6'h22:   target_data = 32'h00_00_00_cb;
                    6'h23:   target_data = 32'h00_00_00_dc;
                    6'h24:   target_data = 32'h00_00_00_ed;
                    6'h25:   target_data = 32'h00_00_00_fe;
                    default: target_data = 32'h00_00_00_AD;
                    endcase

                    // Set diagnostic message
	                //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx FIFO Level";

                    // Check that the push is working correctly by checking the Rx FIFO Level
                    //
                `ifdef GSIM
                  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RX_FIFO_LEVEL), Rx_FIFO_Level);
                `else
	                testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RX_FIFO_LEVEL), Rx_FIFO_Level);
                `endif
                    // Determine if there was a FIFO Level error 
					//
                    if (Rx_FIFO_Level[7:0] !== m[7:0])
                    begin
                        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx FIFO Level read= %d , expected= %d at time %0t", 
                                                                                                                    Rx_FIFO_Level[7:0], 
                                                                                                                                m[7:0], 
                                                                                                                             $realtime );
                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end	
                    else
                    begin
                        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx FIFO Level read= %d , expected= %d at time %0t",  
                                                                                                                    Rx_FIFO_Level[7:0],
                                                                                                                                m[7:0],
                                                                                                                             $realtime );
                        pass_count = pass_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                    end

                    // Set diagnostic message
	                //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats from External UART";

                    // Transmit a value from the external BFM
                    //
                    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
				    		                                   word_length,
                                                          parity_selection,
                                                           stop_bit_length,
                                                    SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
							    			              target_data[7:0] );

                end

                // Set Diagnostic Message
                //
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx complete";

                // Initialize the variable
                //
		        read_data = 0;

		        // Poll for serial tranmission complete
		        //
		        while ((read_data & 32'h0000_0001) === 32'h0)
                begin
                `ifdef GSIM
                  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                `else
	                testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                `endif
                    // Debug Message
                    //
//                  $display("        Generic_AL4S3B_FPGA_UART_Test_4:  UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
                end

                // Try different data patterns
                //
                for (m =0; m < 38; m = m + 1)
                begin

				    // Select the data to send
                    //
                    case (m[5:0])
                    6'h00:   target_data = 32'h00_00_00_01;
                    6'h01:   target_data = 32'h00_00_00_02;
                    6'h02:   target_data = 32'h00_00_00_04;
                    6'h03:   target_data = 32'h00_00_00_08;
                    6'h04:   target_data = 32'h00_00_00_10;
                    6'h05:   target_data = 32'h00_00_00_20;
                    6'h06:   target_data = 32'h00_00_00_40;
                    6'h07:   target_data = 32'h00_00_00_80;
                    6'h08:   target_data = 32'h00_00_00_01;
                    6'h09:   target_data = 32'h00_00_00_02;
                    6'h0a:   target_data = 32'h00_00_00_03;
                    6'h0b:   target_data = 32'h00_00_00_04;
                    6'h0c:   target_data = 32'h00_00_00_05;
                    6'h0d:   target_data = 32'h00_00_00_06;
                    6'h0e:   target_data = 32'h00_00_00_07;
                    6'h0f:   target_data = 32'h00_00_00_08;
                    6'h10:   target_data = 32'h00_00_00_09;
                    6'h11:   target_data = 32'h00_00_00_0a;
                    6'h12:   target_data = 32'h00_00_00_0b;
                    6'h13:   target_data = 32'h00_00_00_0c;
                    6'h14:   target_data = 32'h00_00_00_0d;
                    6'h15:   target_data = 32'h00_00_00_0e;
                    6'h16:   target_data = 32'h00_00_00_0f;
                    6'h17:   target_data = 32'h00_00_00_10;
                    6'h18:   target_data = 32'h00_00_00_21;
                    6'h19:   target_data = 32'h00_00_00_32;
                    6'h1a:   target_data = 32'h00_00_00_43;
                    6'h1b:   target_data = 32'h00_00_00_54;
                    6'h1c:   target_data = 32'h00_00_00_65;
                    6'h1d:   target_data = 32'h00_00_00_76;
                    6'h1e:   target_data = 32'h00_00_00_87;
                    6'h1f:   target_data = 32'h00_00_00_98;
                    6'h20:   target_data = 32'h00_00_00_a9;
                    6'h21:   target_data = 32'h00_00_00_ba;
                    6'h22:   target_data = 32'h00_00_00_cb;
                    6'h23:   target_data = 32'h00_00_00_dc;
                    6'h24:   target_data = 32'h00_00_00_ed;
                    6'h25:   target_data = 32'h00_00_00_fe;
                    default: target_data = 32'h00_00_00_AD;
                    endcase

                    // Initialize variable
                    //
                    read_data = 0;

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Rx FIFO Data Available";

                    // Get the value in the Line Status Register
                    //
                `ifdef GSIM
                  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                `else
	                testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                `endif
                    if (read_data[0] !== 1'b1)
                    begin
                        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Line Status register value read=0x%x shows FIFO unexpectely empty at time %0t", 
                                                                                                                                                  read_data, 
                                                                                                                                                  $realtime );
                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end
                    else
                    begin
                        // Set diagnostic message
	                    //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx FIFO Level";

                        // Check that the push is working correctly by checking the Rx FIFO Level
                        //
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RX_FIFO_LEVEL), Rx_FIFO_Level);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RX_FIFO_LEVEL), Rx_FIFO_Level);
                    `endif
                        // Check the ouptut value for correctness
                        //
                        expected_data = 38 - m;

                        // Determine if there was a FIFO Level error 
					    //
                        if (Rx_FIFO_Level[7:0] !== expected_data[7:0])
                        begin
                            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx FIFO Level read= %d , expected= %d at time %0t", 
                                                                                                                        Rx_FIFO_Level[7:0], 
                                                                                                                        expected_data[7:0], 
                                                                                                                                 $realtime );
                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx FIFO Level read= %d , expected= %d at time %0t",  
                                                                                                                        Rx_FIFO_Level[7:0],
                                                                                                                        expected_data[7:0],
                                                                                                                                 $realtime );
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Set Diagnostic Message
                        //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx Data";

                        // Read value received from the external UART
                        //
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_THR), RBR_read_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_THR), RBR_read_data);
                    `endif
                        // Check the ouptut value for correctness
                        //
                        expected_data = target_data & target_mask;

                        // Determine if there was a data error 
					    //
                        if (RBR_read_data[7:0] !== expected_data[7:0])
                        begin
                            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx data       read=0x%x , expected=0x%x at time %0t", 
                                                                                                                          RBR_read_data[7:0], 
                                                                                                                          expected_data[7:0], 
                                                                                                                                   $realtime );
                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx data       read=0x%x , expected=0x%x at time %0t",  
                                                                                                                          RBR_read_data[7:0],
                                                                                                                          expected_data[7:0],
                                                                                                                                   $realtime );
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Check for various potential errors
                        //
                        if ({read_data[7], read_data[4:1]} !== 0)
                        begin
                            case({read_data[7], read_data[4:1]})
                            5'b00001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b00111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b01111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and No  FIFO Data Error at time %0t",  $realtime);
                            5'b10000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b10111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, No  Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11000: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11001: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11010: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11011: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, No  Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11100: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11101: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, No  Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11110: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No  Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            5'b11111: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with Yes Overrun Error, Yes Parity Error, Yes Framing Error, Yes Break Interrupt, and Yes FIFO Data Error at time %0t",  $realtime);
                            endcase

                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_4: Serial Rx with No Overrun Error, No Parity Error, No Framing Error, No Break Interrupt, and No FIFO Data Error at time %0t",  $realtime);
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end
                    end
				end
            end
        end
    end
    // Sent a value through the receive interface
    //
	
    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Tx operations w/o Tx FIFO
//
// Operations: Each Tx format is checked for correct operation. 
//             This routine does not use the Tx FIFO; therefore, 
//             the Transmit Holding Register is checked on a transfer 
//             by transfer basis.
//
// Limitation: There are no error injected into the serial input stream.
//             Therefore, there is no checking for error generation or 
//             interrupt generation. This is left to another routine.
//
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_5;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m       ;

begin

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif
    //$stop();
    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_5";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to disable the use the Rx and Tx FIFOs
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h0);
`endif
    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Looping to test UART Tx Formats";

    // Check each Rx format for correctness
    //
	for (i = 0; i < 4; i = i + 1)
    begin

        case(i[1:0])
        2'h0: word_length = SERIAL_DATA_5_BITS;
        2'h1: word_length = SERIAL_DATA_6_BITS;
        2'h2: word_length = SERIAL_DATA_7_BITS;
        2'h3: word_length = SERIAL_DATA_8_BITS;
        endcase

        // Set the Rx Monitor parameter
        //
        testbench_top.Serial_Data_Bits_parameter = word_length;

		// Select a mask to allow for accurate determinations
		// of what we are expecting back
		//
		case(i[1:0])
		2'h0:    target_mask = 32'h0000_001f;
		2'h1:    target_mask = 32'h0000_003f;
		2'h2:    target_mask = 32'h0000_007f;
		2'h3:    target_mask = 32'h0000_00ff;
		endcase

        // Try different Stop bit configurations
        //
        for (j = 0; j < 2; j = j + 1)
        begin

            case(j[0])
            1'b0: stop_bit_length = SERIAL_STOP_1_BIT;
            1'b1: stop_bit_length = SERIAL_STOP_2_BIT; // this is 1.5Bits for 5bit word lengths
            endcase

            // Set the Rx Monitor Parameter
            //
            testbench_top.Serial_Stop_Bit_parameter = stop_bit_length;

            // Try different Parity bit configurations
            //
            for (k = 0; k < 5; k = k + 1)
            begin

                case(k[2:0])
                3'h0: parity_selection = SERIAL_PARITY_NONE;
                3'h1: parity_selection = SERIAL_PARITY_ODD;
                3'h2: parity_selection = SERIAL_PARITY_EVEN;
                3'h3: parity_selection = SERIAL_PARITY_FORCE_1;
                3'h4: parity_selection = SERIAL_PARITY_FORCE_0;
                endcase

                // Set the Rx Monitor Parameter
                //
                testbench_top.Serial_Parity_Bit_parameter = parity_selection;

                // Set diagnostic message
	            //
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

                // Set the Baud Rate on the UART
                //
                Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
						                                     word_length,
                                                        parity_selection,
                                                         stop_bit_length,
                                                  SERIAL_BAUD_RATE_115200,//,//SERIAL_BAUD_RATE_38400,
                                                               BREAK_OFF );
                // Try different data patterns
                //
                for (m =0; m < 38; m = m + 1)
                begin

				    // Select the data to send
                    //
                    case (m[5:0])
                    6'h00:   target_data = 32'h00_00_00_01;
                    6'h01:   target_data = 32'h00_00_00_02;
                    6'h02:   target_data = 32'h00_00_00_04;
                    6'h03:   target_data = 32'h00_00_00_08;
                    6'h04:   target_data = 32'h00_00_00_10;
                    6'h05:   target_data = 32'h00_00_00_20;
                    6'h06:   target_data = 32'h00_00_00_40;
                    6'h07:   target_data = 32'h00_00_00_80;
                    6'h08:   target_data = 32'h00_00_00_01;
                    6'h09:   target_data = 32'h00_00_00_02;
                    6'h0a:   target_data = 32'h00_00_00_03;
                    6'h0b:   target_data = 32'h00_00_00_04;
                    6'h0c:   target_data = 32'h00_00_00_05;
                    6'h0d:   target_data = 32'h00_00_00_06;
                    6'h0e:   target_data = 32'h00_00_00_07;
                    6'h0f:   target_data = 32'h00_00_00_08;
                    6'h10:   target_data = 32'h00_00_00_09;
                    6'h11:   target_data = 32'h00_00_00_0a;
                    6'h12:   target_data = 32'h00_00_00_0b;
                    6'h13:   target_data = 32'h00_00_00_0c;
                    6'h14:   target_data = 32'h00_00_00_0d;
                    6'h15:   target_data = 32'h00_00_00_0e;
                    6'h16:   target_data = 32'h00_00_00_0f;
                    6'h17:   target_data = 32'h00_00_00_10;
                    6'h18:   target_data = 32'h00_00_00_21;
                    6'h19:   target_data = 32'h00_00_00_32;
                    6'h1a:   target_data = 32'h00_00_00_43;
                    6'h1b:   target_data = 32'h00_00_00_54;
                    6'h1c:   target_data = 32'h00_00_00_65;
                    6'h1d:   target_data = 32'h00_00_00_76;
                    6'h1e:   target_data = 32'h00_00_00_87;
                    6'h1f:   target_data = 32'h00_00_00_98;
                    6'h20:   target_data = 32'h00_00_00_a9;
                    6'h21:   target_data = 32'h00_00_00_ba;
                    6'h22:   target_data = 32'h00_00_00_cb;
                    6'h23:   target_data = 32'h00_00_00_dc;
                    6'h24:   target_data = 32'h00_00_00_ed;
                    6'h25:   target_data = 32'h00_00_00_fe;
                    default: target_data = 32'h00_00_00_AD;
                    endcase

                    // Set diagnostic message
	                //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats to External UART";

                    // Send value to the external UART
                    //
                `ifdef GSIM
                  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                `else
	                testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                `endif
                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Tx complete";

                    // Initialize the variable
                    //
		            read_data = 0;

		            // Poll for serial tranmission complete
		            //
		            while ((read_data & 32'h0000_0040) === 32'h0)
                    begin
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `endif
                        // Debug Message
                        //
//                      $display("        Generic_AL4S3B_FPGA_UART_Test_5: UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
                    end

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Rx Data";

                    // Get the data just transmitted by the UART
                    //
                    read_data = testbench_top.Rx_Holding_Reg_Data_Bit;

                    // Check the ouptut value for correctness
                    //
                    expected_data = target_data & target_mask;

                    // Determine if there was a data error 
					//
                    if (read_data[7:0] !== expected_data[7:0])
                    begin
                        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx data read=0x%x , expected=0x%x at time %0t", 
                                                                                                                    read_data[7:0], 
                                                                                                                expected_data[7:0], 
                                                                                                                         $realtime );
                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end	
                    else
                    begin
                        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx data  read=0x%x , expected=0x%x at time %0t",  
                                                                                                                     read_data[7:0],
                                                                                                                 expected_data[7:0],
                                                                                                                          $realtime );
                        pass_count = pass_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                    end

                    // Check for various potential errors
                    //
                    if ({testbench_top.Rx_Holding_Reg_Parity_Error_Flag , 
                         testbench_top.Rx_Holding_Reg_Framing_Error_Flag } !== 0)
                    begin
                        case({testbench_top.Rx_Holding_Reg_Parity_Error_Flag , 
					          testbench_top.Rx_Holding_Reg_Framing_Error_Flag })
                        2'b01: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx with No  Parity Error  and Yes Framing Error at time %0t",  $realtime);
                        2'b10: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx with Yes Parity Error  and No  Framing Error at time %0t",  $realtime);
                        2'b11: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx with Yes Parity Error  and Yes Framing Error at time %0t",  $realtime);
                        endcase

                        fail_count = fail_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                    end	
                    else
                    begin
                        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_5: Serial Tx with No Parity Error  and No Framing Error at time %0t",  $realtime);
                        pass_count = pass_count + 1;
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                    end
                end
            end
        end
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Tx operations with the Tx FIFO
//
// Operations: Each Tx format is checked for correct operation. 
//             This routine uses the Tx FIFO; therefore, the Transmit
//             FIFO is filled in parallel with the Tx output being checked.
//
// Limitation: There are no error injected into the serial input stream.
//             Therefore, there is no checking for error generation or 
//             interrupt generation. This is left to another routine.
//
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_6;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  Tx_FIFO_Level    ;
reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_data_tx   ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m, n    ;
integer                   Tx_FIFO_Loop_cnt ;


begin

  //$display("rakesh test 6 - uart0 start");

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
`ifdef GSIM
    @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
`else
		@(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY; 
`endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_6";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to disable the use the Rx and Tx FIFOs
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`endif
    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Looping to test UART Tx Formats";

    // Check each Rx format for correctness
    //
	for (i = 0; i < 1; i = i + 1)
    begin

        case(i[1:0])
        //2'h0: word_length = SERIAL_DATA_5_BITS;
        //2'h1: word_length = SERIAL_DATA_6_BITS;
        //2'h2: word_length = SERIAL_DATA_7_BITS;
        2'h0: word_length = SERIAL_DATA_8_BITS;
        2'h1: word_length = SERIAL_DATA_8_BITS;
        2'h2: word_length = SERIAL_DATA_8_BITS;
        2'h3: word_length = SERIAL_DATA_8_BITS;
        endcase

        // Set the Rx Monitor parameter
        //
        testbench_top.Serial_Data_Bits_parameter = word_length;

        // Select a mask to allow for accurate determinations
        // of what we are expecting back
        //
        case(i[1:0])
        //2'h0:    target_mask = 32'h0000_001f;
        //2'h1:    target_mask = 32'h0000_003f;
        //2'h2:    target_mask = 32'h0000_007f;
        2'h0:    target_mask = 32'h0000_00ff;
        2'h1:    target_mask = 32'h0000_00ff;
        2'h2:    target_mask = 32'h0000_00ff;
        2'h3:    target_mask = 32'h0000_00ff;
        endcase

        // Try different Stop bit configurations
        //
        for (j = 0; j < 1; j = j + 1)
        begin

            case(j[0])
            1'b0: stop_bit_length = SERIAL_STOP_1_BIT;
            1'b1: stop_bit_length = SERIAL_STOP_1_BIT;
            //1'b1: stop_bit_length = SERIAL_STOP_2_BIT; // this is 1.5Bits for 5bit word lengths
            endcase

            // Set the Rx Monitor parameter
            //
            testbench_top.Serial_Stop_Bit_parameter = stop_bit_length;

            // Try different Parity bit configurations
            //
            for (k = 0; k < 1; k = k + 1)
            begin

                case(k[2:0])
                3'h0: parity_selection = SERIAL_PARITY_NONE;
                3'h1: parity_selection = SERIAL_PARITY_NONE;
                3'h2: parity_selection = SERIAL_PARITY_NONE;
                3'h3: parity_selection = SERIAL_PARITY_NONE;
                3'h4: parity_selection = SERIAL_PARITY_NONE;
                //3'h1: parity_selection = SERIAL_PARITY_ODD;
                //3'h2: parity_selection = SERIAL_PARITY_EVEN;
                //3'h3: parity_selection = SERIAL_PARITY_FORCE_1;
                //3'h4: parity_selection = SERIAL_PARITY_FORCE_0;
                endcase


                // Set the Rx Monitor parameter
                //
                testbench_top.Serial_Parity_Bit_parameter = parity_selection;

                // Set diagnostic message
	              //
	              testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

                // Set the Baud Rate on the UART
                //
                Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
						                                     word_length,
                                                        parity_selection,
                                                         stop_bit_length,
                                                  SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                               BREAK_OFF );
                //$display("rakesh test 6 - uart0 config done");
                // While loading the Tx FIFO, capture the outgoing Tx serial stream, and check the Tx FIFO Level
                //
                fork
				        begin
                    //
                    // Load the Tx FIFO
                    //

                    // Try different data patterns
                    //
                    for (m =0; m < 128; m = m + 1)
                    begin

				        // Select the data to send
                        //
                        case (m[6:0])
                        7'h00:   target_data = 32'h00_00_00_F1;
                        7'h01:   target_data = 32'h00_00_00_52;
                        7'h02:   target_data = 32'h00_00_00_F4;
                        7'h03:   target_data = 32'h00_00_00_58;
                        7'h04:   target_data = 32'h00_00_00_10;
                        7'h05:   target_data = 32'h00_00_00_20;
                        7'h06:   target_data = 32'h00_00_00_40;
                        7'h07:   target_data = 32'h00_00_00_80;
                        7'h08:   target_data = 32'h00_00_00_01;
                        7'h09:   target_data = 32'h00_00_00_02;
                        7'h0a:   target_data = 32'h00_00_00_03;
                        7'h0b:   target_data = 32'h00_00_00_04;
                        7'h0c:   target_data = 32'h00_00_00_05;
                        7'h0d:   target_data = 32'h00_00_00_06;
                        7'h0e:   target_data = 32'h00_00_00_07;
                        7'h0f:   target_data = 32'h00_00_00_08;
                        7'h10:   target_data = 32'h00_00_00_09;
                        7'h11:   target_data = 32'h00_00_00_0a;
                        7'h12:   target_data = 32'h00_00_00_0b;
                        7'h13:   target_data = 32'h00_00_00_0c;
                        7'h14:   target_data = 32'h00_00_00_0d;
                        7'h15:   target_data = 32'h00_00_00_0e;
                        7'h16:   target_data = 32'h00_00_00_0f;
                        7'h17:   target_data = 32'h00_00_00_10;
                        7'h18:   target_data = 32'h00_00_00_21;
                        7'h19:   target_data = 32'h00_00_00_32;
                        7'h1a:   target_data = 32'h00_00_00_43;
                        7'h1b:   target_data = 32'h00_00_00_54;
                        7'h1c:   target_data = 32'h00_00_00_65;
                        7'h1d:   target_data = 32'h00_00_00_76;
                        7'h1e:   target_data = 32'h00_00_00_87;
                        7'h1f:   target_data = 32'h00_00_00_98;
                        7'h20:   target_data = 32'h00_00_00_a9;
                        7'h21:   target_data = 32'h00_00_00_ba;
                        7'h22:   target_data = 32'h00_00_00_cb;
                        7'h23:   target_data = 32'h00_00_00_dc;
                        7'h24:   target_data = 32'h00_00_00_ed;
                        7'h25:   target_data = 32'h00_00_00_fe;
                        7'h26:   target_data = 32'h00_00_00_61;
                        7'h27:   target_data = 32'h00_00_00_41;
                        7'h28:   target_data = 32'h00_00_00_62;
                        7'h29:   target_data = 32'h00_00_00_42;
                        7'h2a:   target_data = 32'h00_00_00_63;
                        7'h2b:   target_data = 32'h00_00_00_43;
                        7'h2c:   target_data = 32'h00_00_00_64;
                        7'h2d:   target_data = 32'h00_00_00_44;
                        7'h2e:   target_data = 32'h00_00_00_65;
                        7'h2f:   target_data = 32'h00_00_00_45;
                        7'h30:   target_data = 32'h00_00_00_55;
                        7'h31:   target_data = 32'h00_00_00_aa;
                        7'h32:   target_data = 32'h00_00_00_55;
                        7'h33:   target_data = 32'h00_00_00_aa;
                        7'h34:   target_data = 32'h00_00_00_55;
                        7'h35:   target_data = 32'h00_00_00_aa;
                        7'h36:   target_data = 32'h00_00_00_55;
                        7'h37:   target_data = 32'h00_00_00_aa;
                        7'h38:   target_data = 32'h00_00_00_55;
                        7'h39:   target_data = 32'h00_00_00_aa;
                        7'h3a:   target_data = 32'h00_00_00_55;
                        7'h3b:   target_data = 32'h00_00_00_aa;
                        7'h3c:   target_data = 32'h00_00_00_55;
                        7'h3d:   target_data = 32'h00_00_00_aa;
                        7'h3e:   target_data = 32'h00_00_00_55;
                        7'h3f:   target_data = 32'h00_00_00_aa;
                        7'h40:   target_data = 32'h00_00_00_55;
                        7'h41:   target_data = 32'h00_00_00_aa;
                        7'h42:   target_data = 32'h00_00_00_55;
                        7'h43:   target_data = 32'h00_00_00_aa;
                        7'h44:   target_data = 32'h00_00_00_55;
                        7'h45:   target_data = 32'h00_00_00_aa;
                        7'h46:   target_data = 32'h00_00_00_55;
                        7'h47:   target_data = 32'h00_00_00_aa;
                        7'h48:   target_data = 32'h00_00_00_55;
                        7'h49:   target_data = 32'h00_00_00_aa;
                        7'h4a:   target_data = 32'h00_00_00_55;
                        7'h4b:   target_data = 32'h00_00_00_aa;
                        7'h4c:   target_data = 32'h00_00_00_55;
                        7'h4d:   target_data = 32'h00_00_00_aa;
                        7'h4e:   target_data = 32'h00_00_00_55;
                        7'h4f:   target_data = 32'h00_00_00_aa;
                        7'h50:   target_data = 32'h00_00_00_55;
                        7'h51:   target_data = 32'h00_00_00_aa;
                        7'h52:   target_data = 32'h00_00_00_55;
                        7'h53:   target_data = 32'h00_00_00_aa;
                        7'h54:   target_data = 32'h00_00_00_55;
                        7'h55:   target_data = 32'h00_00_00_aa;
                        7'h56:   target_data = 32'h00_00_00_55;
                        7'h57:   target_data = 32'h00_00_00_aa;
                        7'h58:   target_data = 32'h00_00_00_55;
                        7'h59:   target_data = 32'h00_00_00_aa;
                        7'h5a:   target_data = 32'h00_00_00_55;
                        7'h5b:   target_data = 32'h00_00_00_aa;
                        7'h5c:   target_data = 32'h00_00_00_55;
                        7'h5d:   target_data = 32'h00_00_00_aa;
                        7'h5e:   target_data = 32'h00_00_00_55;
                        7'h5f:   target_data = 32'h00_00_00_aa;
                        7'h60:   target_data = 32'h00_00_00_55;
                        7'h61:   target_data = 32'h00_00_00_aa;
                        7'h62:   target_data = 32'h00_00_00_55;
                        7'h63:   target_data = 32'h00_00_00_aa;
                        7'h64:   target_data = 32'h00_00_00_55;
                        7'h65:   target_data = 32'h00_00_00_aa;
                        7'h66:   target_data = 32'h00_00_00_55;
                        7'h67:   target_data = 32'h00_00_00_aa;
                        7'h68:   target_data = 32'h00_00_00_55;
                        7'h69:   target_data = 32'h00_00_00_aa;
                        7'h6a:   target_data = 32'h00_00_00_55;
                        7'h6b:   target_data = 32'h00_00_00_aa;
                        7'h6c:   target_data = 32'h00_00_00_55;
                        7'h6d:   target_data = 32'h00_00_00_aa;
                        7'h6e:   target_data = 32'h00_00_00_55;
                        7'h6f:   target_data = 32'h00_00_00_aa;
                        7'h70:   target_data = 32'h00_00_00_55;
                        7'h71:   target_data = 32'h00_00_00_aa;
                        7'h72:   target_data = 32'h00_00_00_55;
                        7'h73:   target_data = 32'h00_00_00_aa;
                        7'h74:   target_data = 32'h00_00_00_55;
                        7'h75:   target_data = 32'h00_00_00_aa;
                        7'h76:   target_data = 32'h00_00_00_55;
                        7'h77:   target_data = 32'h00_00_00_aa;
                        7'h78:   target_data = 32'h00_00_00_55;
                        7'h79:   target_data = 32'h00_00_00_aa;
                        7'h7a:   target_data = 32'h00_00_00_55;
                        7'h7b:   target_data = 32'h00_00_00_aa;
                        7'h7c:   target_data = 32'h00_00_00_55;
                        7'h7d:   target_data = 32'h00_00_00_aa;
                        7'h7e:   target_data = 32'h00_00_00_55;
                        7'h7f:   target_data = 32'h00_00_00_aa;
                        default: target_data = 32'h00_00_00_AD;
                        endcase

                        // Set diagnostic message
	                    //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats to External UART";

                        // Send value to the external UART
                        //
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                    `endif
                    end
                end
                begin
                    //
                    // Capture the Tx Serial Stream
                    //

                    // Initialize the loop variable
                    n = 0;

                    // Try different data patterns
                    //
                    while (n < 128)
                    begin

				        // Select the data to send
                        //
                        case (n[6:0])
                        7'h00:   target_data_tx = 32'h00_00_00_F1;
                        7'h01:   target_data_tx = 32'h00_00_00_52;
                        7'h02:   target_data_tx = 32'h00_00_00_F4;
                        7'h03:   target_data_tx = 32'h00_00_00_58;
                        7'h04:   target_data_tx = 32'h00_00_00_10;
                        7'h05:   target_data_tx = 32'h00_00_00_20;
                        7'h06:   target_data_tx = 32'h00_00_00_40;
                        7'h07:   target_data_tx = 32'h00_00_00_80;
                        7'h08:   target_data_tx = 32'h00_00_00_01;
                        7'h09:   target_data_tx = 32'h00_00_00_02;
                        7'h0a:   target_data_tx = 32'h00_00_00_03;
                        7'h0b:   target_data_tx = 32'h00_00_00_04;
                        7'h0c:   target_data_tx = 32'h00_00_00_05;
                        7'h0d:   target_data_tx = 32'h00_00_00_06;
                        7'h0e:   target_data_tx = 32'h00_00_00_07;
                        7'h0f:   target_data_tx = 32'h00_00_00_08;
                        7'h10:   target_data_tx = 32'h00_00_00_09;
                        7'h11:   target_data_tx = 32'h00_00_00_0a;
                        7'h12:   target_data_tx = 32'h00_00_00_0b;
                        7'h13:   target_data_tx = 32'h00_00_00_0c;
                        7'h14:   target_data_tx = 32'h00_00_00_0d;
                        7'h15:   target_data_tx = 32'h00_00_00_0e;
                        7'h16:   target_data_tx = 32'h00_00_00_0f;
                        7'h17:   target_data_tx = 32'h00_00_00_10;
                        7'h18:   target_data_tx = 32'h00_00_00_21;
                        7'h19:   target_data_tx = 32'h00_00_00_32;
                        7'h1a:   target_data_tx = 32'h00_00_00_43;
                        7'h1b:   target_data_tx = 32'h00_00_00_54;
                        7'h1c:   target_data_tx = 32'h00_00_00_65;
                        7'h1d:   target_data_tx = 32'h00_00_00_76;
                        7'h1e:   target_data_tx = 32'h00_00_00_87;
                        7'h1f:   target_data_tx = 32'h00_00_00_98;
                        7'h20:   target_data_tx = 32'h00_00_00_a9;
                        7'h21:   target_data_tx = 32'h00_00_00_ba;
                        7'h22:   target_data_tx = 32'h00_00_00_cb;
                        7'h23:   target_data_tx = 32'h00_00_00_dc;
                        7'h24:   target_data_tx = 32'h00_00_00_ed;
                        7'h25:   target_data_tx = 32'h00_00_00_fe;
                        7'h26:   target_data_tx = 32'h00_00_00_61;
                        7'h27:   target_data_tx = 32'h00_00_00_41;
                        7'h28:   target_data_tx = 32'h00_00_00_62;
                        7'h29:   target_data_tx = 32'h00_00_00_42;
                        7'h2a:   target_data_tx = 32'h00_00_00_63;
                        7'h2b:   target_data_tx = 32'h00_00_00_43;
                        7'h2c:   target_data_tx = 32'h00_00_00_64;
                        7'h2d:   target_data_tx = 32'h00_00_00_44;
                        7'h2e:   target_data_tx = 32'h00_00_00_65;
                        7'h2f:   target_data_tx = 32'h00_00_00_45;
                        7'h30:   target_data_tx = 32'h00_00_00_55;
                        7'h31:   target_data_tx = 32'h00_00_00_aa;
                        7'h32:   target_data_tx = 32'h00_00_00_55;
                        7'h33:   target_data_tx = 32'h00_00_00_aa;
                        7'h34:   target_data_tx = 32'h00_00_00_55;
                        7'h35:   target_data_tx = 32'h00_00_00_aa;
                        7'h36:   target_data_tx = 32'h00_00_00_55;
                        7'h37:   target_data_tx = 32'h00_00_00_aa;
                        7'h38:   target_data_tx = 32'h00_00_00_55;
                        7'h39:   target_data_tx = 32'h00_00_00_aa;
                        7'h3a:   target_data_tx = 32'h00_00_00_55;
                        7'h3b:   target_data_tx = 32'h00_00_00_aa;
                        7'h3c:   target_data_tx = 32'h00_00_00_55;
                        7'h3d:   target_data_tx = 32'h00_00_00_aa;
                        7'h3e:   target_data_tx = 32'h00_00_00_55;
                        7'h3f:   target_data_tx = 32'h00_00_00_aa;
                        7'h40:   target_data_tx = 32'h00_00_00_55;
                        7'h41:   target_data_tx = 32'h00_00_00_aa;
                        7'h42:   target_data_tx = 32'h00_00_00_55;
                        7'h43:   target_data_tx = 32'h00_00_00_aa;
                        7'h44:   target_data_tx = 32'h00_00_00_55;
                        7'h45:   target_data_tx = 32'h00_00_00_aa;
                        7'h46:   target_data_tx = 32'h00_00_00_55;
                        7'h47:   target_data_tx = 32'h00_00_00_aa;
                        7'h48:   target_data_tx = 32'h00_00_00_55;
                        7'h49:   target_data_tx = 32'h00_00_00_aa;
                        7'h4a:   target_data_tx = 32'h00_00_00_55;
                        7'h4b:   target_data_tx = 32'h00_00_00_aa;
                        7'h4c:   target_data_tx = 32'h00_00_00_55;
                        7'h4d:   target_data_tx = 32'h00_00_00_aa;
                        7'h4e:   target_data_tx = 32'h00_00_00_55;
                        7'h4f:   target_data_tx = 32'h00_00_00_aa;
                        7'h50:   target_data_tx = 32'h00_00_00_55;
                        7'h51:   target_data_tx = 32'h00_00_00_aa;
                        7'h52:   target_data_tx = 32'h00_00_00_55;
                        7'h53:   target_data_tx = 32'h00_00_00_aa;
                        7'h54:   target_data_tx = 32'h00_00_00_55;
                        7'h55:   target_data_tx = 32'h00_00_00_aa;
                        7'h56:   target_data_tx = 32'h00_00_00_55;
                        7'h57:   target_data_tx = 32'h00_00_00_aa;
                        7'h58:   target_data_tx = 32'h00_00_00_55;
                        7'h59:   target_data_tx = 32'h00_00_00_aa;
                        7'h5a:   target_data_tx = 32'h00_00_00_55;
                        7'h5b:   target_data_tx = 32'h00_00_00_aa;
                        7'h5c:   target_data_tx = 32'h00_00_00_55;
                        7'h5d:   target_data_tx = 32'h00_00_00_aa;
                        7'h5e:   target_data_tx = 32'h00_00_00_55;
                        7'h5f:   target_data_tx = 32'h00_00_00_aa;
                        7'h60:   target_data_tx = 32'h00_00_00_55;
                        7'h61:   target_data_tx = 32'h00_00_00_aa;
                        7'h62:   target_data_tx = 32'h00_00_00_55;
                        7'h63:   target_data_tx = 32'h00_00_00_aa;
                        7'h64:   target_data_tx = 32'h00_00_00_55;
                        7'h65:   target_data_tx = 32'h00_00_00_aa;
                        7'h66:   target_data_tx = 32'h00_00_00_55;
                        7'h67:   target_data_tx = 32'h00_00_00_aa;
                        7'h68:   target_data_tx = 32'h00_00_00_55;
                        7'h69:   target_data_tx = 32'h00_00_00_aa;
                        7'h6a:   target_data_tx = 32'h00_00_00_55;
                        7'h6b:   target_data_tx = 32'h00_00_00_aa;
                        7'h6c:   target_data_tx = 32'h00_00_00_55;
                        7'h6d:   target_data_tx = 32'h00_00_00_aa;
                        7'h6e:   target_data_tx = 32'h00_00_00_55;
                        7'h6f:   target_data_tx = 32'h00_00_00_aa;
                        7'h70:   target_data_tx = 32'h00_00_00_55;
                        7'h71:   target_data_tx = 32'h00_00_00_aa;
                        7'h72:   target_data_tx = 32'h00_00_00_55;
                        7'h73:   target_data_tx = 32'h00_00_00_aa;
                        7'h74:   target_data_tx = 32'h00_00_00_55;
                        7'h75:   target_data_tx = 32'h00_00_00_aa;
                        7'h76:   target_data_tx = 32'h00_00_00_55;
                        7'h77:   target_data_tx = 32'h00_00_00_aa;
                        7'h78:   target_data_tx = 32'h00_00_00_55;
                        7'h79:   target_data_tx = 32'h00_00_00_aa;
                        7'h7a:   target_data_tx = 32'h00_00_00_55;
                        7'h7b:   target_data_tx = 32'h00_00_00_aa;
                        7'h7c:   target_data_tx = 32'h00_00_00_55;
                        7'h7d:   target_data_tx = 32'h00_00_00_aa;
                        7'h7e:   target_data_tx = 32'h00_00_00_55;
                        7'h7f:   target_data_tx = 32'h00_00_00_aa;
                        default: target_data_tx = 32'h00_00_00_AD;
                        endcase

                        // Wait for the capture of a data value
                        //
                        @(negedge testbench_top.Rx_Capture_Trigger);

                        // Set Diagnostic Message
                        //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Tx Data";

                        // Get the data just transmitted by the UART
                        //
                        read_data = testbench_top.Rx_Holding_Reg_Data_Bit;

                        // Check the ouptut value for correctness
                        //
                        expected_data = target_data_tx & target_mask;

                        // Determine if there was a data error 
					    //
                        if (read_data[7:0] !== expected_data[7:0])
                        begin
                            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx data       read=0x%x , expected=0x%x at time %0t", 
                                                                                                                              read_data[7:0], 
                                                                                                                          expected_data[7:0], 
                                                                                                                                   $realtime );
                            fail_count = fail_count + 1;
	                          testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                            $stop;
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx data       read=0x%x , expected=0x%x at time %0t",  
                                                                                                                              read_data[7:0],
                                                                                                                          expected_data[7:0],
                                                                                                                                   $realtime );
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Check for various potential errors
                        //
                        if ({testbench_top.Rx_Holding_Reg_Parity_Error_Flag , 
                             testbench_top.Rx_Holding_Reg_Framing_Error_Flag } !== 0)
                        begin
                            case({testbench_top.Rx_Holding_Reg_Parity_Error_Flag , 
                                  testbench_top.Rx_Holding_Reg_Framing_Error_Flag })
                            2'b01: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx with No  Parity Error  and Yes Framing Error at time %0t",  $realtime);
                            2'b10: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx with Yes Parity Error  and No  Framing Error at time %0t",  $realtime);
                            2'b11: $display("[Error] Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx with Yes Parity Error  and Yes Framing Error at time %0t",  $realtime);
                            endcase

                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_6: Serial Tx with No Parity Error  and No Framing Error at time %0t",  $realtime);
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Increment the loop variable
                        //
						n = n + 1;
                    end

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Tx complete";

                    // Initialize the variable
                    //
		            read_data = 0;

		            // Poll for serial tranmission complete
		            //
		            while ((read_data & 32'h0000_0040) === 32'h0)
                    begin
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `endif
                        // Debug Message
                        //
//                      $display("        Generic_AL4S3B_FPGA_UART_Test_6: UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
                    end

                end
              join
            end
        end
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask

task Generic_AL4S3B_FPGA_IP_UART_Test_6a;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  Tx_FIFO_Level    ;
reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_data_tx   ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m, n    ;
integer                   Tx_FIFO_Loop_cnt ;


begin

  //$display("rakesh test 6 - uart1 start");

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 1; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_UART_Test_6";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Set FIFO Control Register to disable the use the Rx and Tx FIFOs
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h1);
`endif
    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Looping to test UART Tx Formats";

    // Check each Rx format for correctness
    //
	for (i = 0; i < 1; i = i + 1)
    begin

        case(i[1:0])
        //2'h0: word_length = SERIAL_DATA_5_BITS;
        //2'h1: word_length = SERIAL_DATA_6_BITS;
        //2'h2: word_length = SERIAL_DATA_7_BITS;
        2'h0: word_length = SERIAL_DATA_8_BITS;
        2'h1: word_length = SERIAL_DATA_8_BITS;
        2'h2: word_length = SERIAL_DATA_8_BITS;
        2'h3: word_length = SERIAL_DATA_8_BITS;
        endcase

        // Set the Rx Monitor parameter
        //
        testbench_top.Serial_Data_Bits_parameter = word_length;

        // Select a mask to allow for accurate determinations
        // of what we are expecting back
        //
        case(i[1:0])
        //2'h0:    target_mask = 32'h0000_001f;
        //2'h1:    target_mask = 32'h0000_003f;
        //2'h2:    target_mask = 32'h0000_007f;
        2'h0:    target_mask = 32'h0000_00ff;
        2'h1:    target_mask = 32'h0000_00ff;
        2'h2:    target_mask = 32'h0000_00ff;
        2'h3:    target_mask = 32'h0000_00ff;
        endcase

        // Try different Stop bit configurations
        //
        for (j = 0; j < 1; j = j + 1)
        begin

            case(j[0])
            1'b0: stop_bit_length = SERIAL_STOP_1_BIT;
            1'b1: stop_bit_length = SERIAL_STOP_1_BIT;
            //1'b1: stop_bit_length = SERIAL_STOP_2_BIT; // this is 1.5Bits for 5bit word lengths
            endcase

            // Set the Rx Monitor parameter
            //
            testbench_top.Serial_Stop_Bit_parameter = stop_bit_length;

            // Try different Parity bit configurations
            //
            for (k = 0; k < 1; k = k + 1)
            begin

                case(k[2:0])
                3'h0: parity_selection = SERIAL_PARITY_NONE;
                3'h1: parity_selection = SERIAL_PARITY_NONE;
                3'h2: parity_selection = SERIAL_PARITY_NONE;
                3'h3: parity_selection = SERIAL_PARITY_NONE;
                3'h4: parity_selection = SERIAL_PARITY_NONE;
                //3'h1: parity_selection = SERIAL_PARITY_ODD;
                //3'h2: parity_selection = SERIAL_PARITY_EVEN;
                //3'h3: parity_selection = SERIAL_PARITY_FORCE_1;
                //3'h4: parity_selection = SERIAL_PARITY_FORCE_0;
                endcase


                // Set the Rx Monitor parameter
                //
                testbench_top.Serial_Parity_Bit_parameter = parity_selection;

                // Set diagnostic message
	              //
	              testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

                // Set the Baud Rate on the UART
                //
                Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
						                                     word_length,
                                                        parity_selection,
                                                         stop_bit_length,
                                                  SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                               BREAK_OFF );
                //$display("rakesh test 6 - uart1 config done");
                // While loading the Tx FIFO, capture the outgoing Tx serial stream, and check the Tx FIFO Level
                //
                fork
                begin
                    //
                    // Load the Tx FIFO
                    //

                    // Try different data patterns
                    //
                    for (m =0; m < 128; m = m + 1)
                    begin

				        // Select the data to send
                        //
                        case (m[6:0])
                        7'h00:   target_data = 32'h00_00_00_01;
                        7'h01:   target_data = 32'h00_00_00_02;
                        7'h02:   target_data = 32'h00_00_00_04;
                        7'h03:   target_data = 32'h00_00_00_08;
                        7'h04:   target_data = 32'h00_00_00_10;
                        7'h05:   target_data = 32'h00_00_00_20;
                        7'h06:   target_data = 32'h00_00_00_40;
                        7'h07:   target_data = 32'h00_00_00_80;
                        7'h08:   target_data = 32'h00_00_00_01;
                        7'h09:   target_data = 32'h00_00_00_02;
                        7'h0a:   target_data = 32'h00_00_00_03;
                        7'h0b:   target_data = 32'h00_00_00_04;
                        7'h0c:   target_data = 32'h00_00_00_05;
                        7'h0d:   target_data = 32'h00_00_00_06;
                        7'h0e:   target_data = 32'h00_00_00_07;
                        7'h0f:   target_data = 32'h00_00_00_08;
                        7'h10:   target_data = 32'h00_00_00_09;
                        7'h11:   target_data = 32'h00_00_00_0a;
                        7'h12:   target_data = 32'h00_00_00_0b;
                        7'h13:   target_data = 32'h00_00_00_0c;
                        7'h14:   target_data = 32'h00_00_00_0d;
                        7'h15:   target_data = 32'h00_00_00_0e;
                        7'h16:   target_data = 32'h00_00_00_0f;
                        7'h17:   target_data = 32'h00_00_00_10;
                        7'h18:   target_data = 32'h00_00_00_21;
                        7'h19:   target_data = 32'h00_00_00_32;
                        7'h1a:   target_data = 32'h00_00_00_43;
                        7'h1b:   target_data = 32'h00_00_00_54;
                        7'h1c:   target_data = 32'h00_00_00_65;
                        7'h1d:   target_data = 32'h00_00_00_76;
                        7'h1e:   target_data = 32'h00_00_00_87;
                        7'h1f:   target_data = 32'h00_00_00_98;
                        7'h20:   target_data = 32'h00_00_00_a9;
                        7'h21:   target_data = 32'h00_00_00_ba;
                        7'h22:   target_data = 32'h00_00_00_cb;
                        7'h23:   target_data = 32'h00_00_00_dc;
                        7'h24:   target_data = 32'h00_00_00_ed;
                        7'h25:   target_data = 32'h00_00_00_fe;
                        7'h26:   target_data = 32'h00_00_00_61;
                        7'h27:   target_data = 32'h00_00_00_41;
                        7'h28:   target_data = 32'h00_00_00_62;
                        7'h29:   target_data = 32'h00_00_00_42;
                        7'h2a:   target_data = 32'h00_00_00_63;
                        7'h2b:   target_data = 32'h00_00_00_43;
                        7'h2c:   target_data = 32'h00_00_00_64;
                        7'h2d:   target_data = 32'h00_00_00_44;
                        7'h2e:   target_data = 32'h00_00_00_65;
                        7'h2f:   target_data = 32'h00_00_00_45;
                        7'h30:   target_data = 32'h00_00_00_55;
                        7'h31:   target_data = 32'h00_00_00_aa;
                        7'h32:   target_data = 32'h00_00_00_55;
                        7'h33:   target_data = 32'h00_00_00_aa;
                        7'h34:   target_data = 32'h00_00_00_55;
                        7'h35:   target_data = 32'h00_00_00_aa;
                        7'h36:   target_data = 32'h00_00_00_55;
                        7'h37:   target_data = 32'h00_00_00_aa;
                        7'h38:   target_data = 32'h00_00_00_55;
                        7'h39:   target_data = 32'h00_00_00_aa;
                        7'h3a:   target_data = 32'h00_00_00_55;
                        7'h3b:   target_data = 32'h00_00_00_aa;
                        7'h3c:   target_data = 32'h00_00_00_55;
                        7'h3d:   target_data = 32'h00_00_00_aa;
                        7'h3e:   target_data = 32'h00_00_00_55;
                        7'h3f:   target_data = 32'h00_00_00_aa;
                        7'h40:   target_data = 32'h00_00_00_55;
                        7'h41:   target_data = 32'h00_00_00_aa;
                        7'h42:   target_data = 32'h00_00_00_55;
                        7'h43:   target_data = 32'h00_00_00_aa;
                        7'h44:   target_data = 32'h00_00_00_55;
                        7'h45:   target_data = 32'h00_00_00_aa;
                        7'h46:   target_data = 32'h00_00_00_55;
                        7'h47:   target_data = 32'h00_00_00_aa;
                        7'h48:   target_data = 32'h00_00_00_55;
                        7'h49:   target_data = 32'h00_00_00_aa;
                        7'h4a:   target_data = 32'h00_00_00_55;
                        7'h4b:   target_data = 32'h00_00_00_aa;
                        7'h4c:   target_data = 32'h00_00_00_55;
                        7'h4d:   target_data = 32'h00_00_00_aa;
                        7'h4e:   target_data = 32'h00_00_00_55;
                        7'h4f:   target_data = 32'h00_00_00_aa;
                        7'h50:   target_data = 32'h00_00_00_55;
                        7'h51:   target_data = 32'h00_00_00_aa;
                        7'h52:   target_data = 32'h00_00_00_55;
                        7'h53:   target_data = 32'h00_00_00_aa;
                        7'h54:   target_data = 32'h00_00_00_55;
                        7'h55:   target_data = 32'h00_00_00_aa;
                        7'h56:   target_data = 32'h00_00_00_55;
                        7'h57:   target_data = 32'h00_00_00_aa;
                        7'h58:   target_data = 32'h00_00_00_55;
                        7'h59:   target_data = 32'h00_00_00_aa;
                        7'h5a:   target_data = 32'h00_00_00_55;
                        7'h5b:   target_data = 32'h00_00_00_aa;
                        7'h5c:   target_data = 32'h00_00_00_55;
                        7'h5d:   target_data = 32'h00_00_00_aa;
                        7'h5e:   target_data = 32'h00_00_00_55;
                        7'h5f:   target_data = 32'h00_00_00_aa;
                        7'h60:   target_data = 32'h00_00_00_55;
                        7'h61:   target_data = 32'h00_00_00_aa;
                        7'h62:   target_data = 32'h00_00_00_55;
                        7'h63:   target_data = 32'h00_00_00_aa;
                        7'h64:   target_data = 32'h00_00_00_55;
                        7'h65:   target_data = 32'h00_00_00_aa;
                        7'h66:   target_data = 32'h00_00_00_55;
                        7'h67:   target_data = 32'h00_00_00_aa;
                        7'h68:   target_data = 32'h00_00_00_55;
                        7'h69:   target_data = 32'h00_00_00_aa;
                        7'h6a:   target_data = 32'h00_00_00_55;
                        7'h6b:   target_data = 32'h00_00_00_aa;
                        7'h6c:   target_data = 32'h00_00_00_55;
                        7'h6d:   target_data = 32'h00_00_00_aa;
                        7'h6e:   target_data = 32'h00_00_00_55;
                        7'h6f:   target_data = 32'h00_00_00_aa;
                        7'h70:   target_data = 32'h00_00_00_55;
                        7'h71:   target_data = 32'h00_00_00_aa;
                        7'h72:   target_data = 32'h00_00_00_55;
                        7'h73:   target_data = 32'h00_00_00_aa;
                        7'h74:   target_data = 32'h00_00_00_55;
                        7'h75:   target_data = 32'h00_00_00_aa;
                        7'h76:   target_data = 32'h00_00_00_55;
                        7'h77:   target_data = 32'h00_00_00_aa;
                        7'h78:   target_data = 32'h00_00_00_55;
                        7'h79:   target_data = 32'h00_00_00_aa;
                        7'h7a:   target_data = 32'h00_00_00_55;
                        7'h7b:   target_data = 32'h00_00_00_aa;
                        7'h7c:   target_data = 32'h00_00_00_55;
                        7'h7d:   target_data = 32'h00_00_00_aa;
                        7'h7e:   target_data = 32'h00_00_00_55;
                        7'h7f:   target_data = 32'h00_00_00_aa;
                        default: target_data = 32'h00_00_00_AD;
                      endcase

                        // Set diagnostic message
	                    //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats to External UART";

                        // Send value to the external UART
                        //
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_THR), target_data);
                    `endif
                    end
                end
                begin
                    //
                    // Capture the Tx Serial Stream
                    //

                    // Initialize the loop variable
                    n = 0;

                    // Try different data patterns
                    //
                    while (n < 128)
                    begin

				        // Select the data to send
                        //
                      case (n[6:0])
                        7'h00:   target_data_tx = 32'h00_00_00_01;
                        7'h01:   target_data_tx = 32'h00_00_00_02;
                        7'h02:   target_data_tx = 32'h00_00_00_04;
                        7'h03:   target_data_tx = 32'h00_00_00_08;
                        7'h04:   target_data_tx = 32'h00_00_00_10;
                        7'h05:   target_data_tx = 32'h00_00_00_20;
                        7'h06:   target_data_tx = 32'h00_00_00_40;
                        7'h07:   target_data_tx = 32'h00_00_00_80;
                        7'h08:   target_data_tx = 32'h00_00_00_01;
                        7'h09:   target_data_tx = 32'h00_00_00_02;
                        7'h0a:   target_data_tx = 32'h00_00_00_03;
                        7'h0b:   target_data_tx = 32'h00_00_00_04;
                        7'h0c:   target_data_tx = 32'h00_00_00_05;
                        7'h0d:   target_data_tx = 32'h00_00_00_06;
                        7'h0e:   target_data_tx = 32'h00_00_00_07;
                        7'h0f:   target_data_tx = 32'h00_00_00_08;
                        7'h10:   target_data_tx = 32'h00_00_00_09;
                        7'h11:   target_data_tx = 32'h00_00_00_0a;
                        7'h12:   target_data_tx = 32'h00_00_00_0b;
                        7'h13:   target_data_tx = 32'h00_00_00_0c;
                        7'h14:   target_data_tx = 32'h00_00_00_0d;
                        7'h15:   target_data_tx = 32'h00_00_00_0e;
                        7'h16:   target_data_tx = 32'h00_00_00_0f;
                        7'h17:   target_data_tx = 32'h00_00_00_10;
                        7'h18:   target_data_tx = 32'h00_00_00_21;
                        7'h19:   target_data_tx = 32'h00_00_00_32;
                        7'h1a:   target_data_tx = 32'h00_00_00_43;
                        7'h1b:   target_data_tx = 32'h00_00_00_54;
                        7'h1c:   target_data_tx = 32'h00_00_00_65;
                        7'h1d:   target_data_tx = 32'h00_00_00_76;
                        7'h1e:   target_data_tx = 32'h00_00_00_87;
                        7'h1f:   target_data_tx = 32'h00_00_00_98;
                        7'h20:   target_data_tx = 32'h00_00_00_a9;
                        7'h21:   target_data_tx = 32'h00_00_00_ba;
                        7'h22:   target_data_tx = 32'h00_00_00_cb;
                        7'h23:   target_data_tx = 32'h00_00_00_dc;
                        7'h24:   target_data_tx = 32'h00_00_00_ed;
                        7'h25:   target_data_tx = 32'h00_00_00_fe;
                        7'h26:   target_data_tx = 32'h00_00_00_61;
                        7'h27:   target_data_tx = 32'h00_00_00_41;
                        7'h28:   target_data_tx = 32'h00_00_00_62;
                        7'h29:   target_data_tx = 32'h00_00_00_42;
                        7'h2a:   target_data_tx = 32'h00_00_00_63;
                        7'h2b:   target_data_tx = 32'h00_00_00_43;
                        7'h2c:   target_data_tx = 32'h00_00_00_64;
                        7'h2d:   target_data_tx = 32'h00_00_00_44;
                        7'h2e:   target_data_tx = 32'h00_00_00_65;
                        7'h2f:   target_data_tx = 32'h00_00_00_45;
                        7'h30:   target_data_tx = 32'h00_00_00_55;
                        7'h31:   target_data_tx = 32'h00_00_00_aa;
                        7'h32:   target_data_tx = 32'h00_00_00_55;
                        7'h33:   target_data_tx = 32'h00_00_00_aa;
                        7'h34:   target_data_tx = 32'h00_00_00_55;
                        7'h35:   target_data_tx = 32'h00_00_00_aa;
                        7'h36:   target_data_tx = 32'h00_00_00_55;
                        7'h37:   target_data_tx = 32'h00_00_00_aa;
                        7'h38:   target_data_tx = 32'h00_00_00_55;
                        7'h39:   target_data_tx = 32'h00_00_00_aa;
                        7'h3a:   target_data_tx = 32'h00_00_00_55;
                        7'h3b:   target_data_tx = 32'h00_00_00_aa;
                        7'h3c:   target_data_tx = 32'h00_00_00_55;
                        7'h3d:   target_data_tx = 32'h00_00_00_aa;
                        7'h3e:   target_data_tx = 32'h00_00_00_55;
                        7'h3f:   target_data_tx = 32'h00_00_00_aa;
                        7'h40:   target_data_tx = 32'h00_00_00_55;
                        7'h41:   target_data_tx = 32'h00_00_00_aa;
                        7'h42:   target_data_tx = 32'h00_00_00_55;
                        7'h43:   target_data_tx = 32'h00_00_00_aa;
                        7'h44:   target_data_tx = 32'h00_00_00_55;
                        7'h45:   target_data_tx = 32'h00_00_00_aa;
                        7'h46:   target_data_tx = 32'h00_00_00_55;
                        7'h47:   target_data_tx = 32'h00_00_00_aa;
                        7'h48:   target_data_tx = 32'h00_00_00_55;
                        7'h49:   target_data_tx = 32'h00_00_00_aa;
                        7'h4a:   target_data_tx = 32'h00_00_00_55;
                        7'h4b:   target_data_tx = 32'h00_00_00_aa;
                        7'h4c:   target_data_tx = 32'h00_00_00_55;
                        7'h4d:   target_data_tx = 32'h00_00_00_aa;
                        7'h4e:   target_data_tx = 32'h00_00_00_55;
                        7'h4f:   target_data_tx = 32'h00_00_00_aa;
                        7'h50:   target_data_tx = 32'h00_00_00_55;
                        7'h51:   target_data_tx = 32'h00_00_00_aa;
                        7'h52:   target_data_tx = 32'h00_00_00_55;
                        7'h53:   target_data_tx = 32'h00_00_00_aa;
                        7'h54:   target_data_tx = 32'h00_00_00_55;
                        7'h55:   target_data_tx = 32'h00_00_00_aa;
                        7'h56:   target_data_tx = 32'h00_00_00_55;
                        7'h57:   target_data_tx = 32'h00_00_00_aa;
                        7'h58:   target_data_tx = 32'h00_00_00_55;
                        7'h59:   target_data_tx = 32'h00_00_00_aa;
                        7'h5a:   target_data_tx = 32'h00_00_00_55;
                        7'h5b:   target_data_tx = 32'h00_00_00_aa;
                        7'h5c:   target_data_tx = 32'h00_00_00_55;
                        7'h5d:   target_data_tx = 32'h00_00_00_aa;
                        7'h5e:   target_data_tx = 32'h00_00_00_55;
                        7'h5f:   target_data_tx = 32'h00_00_00_aa;
                        7'h60:   target_data_tx = 32'h00_00_00_55;
                        7'h61:   target_data_tx = 32'h00_00_00_aa;
                        7'h62:   target_data_tx = 32'h00_00_00_55;
                        7'h63:   target_data_tx = 32'h00_00_00_aa;
                        7'h64:   target_data_tx = 32'h00_00_00_55;
                        7'h65:   target_data_tx = 32'h00_00_00_aa;
                        7'h66:   target_data_tx = 32'h00_00_00_55;
                        7'h67:   target_data_tx = 32'h00_00_00_aa;
                        7'h68:   target_data_tx = 32'h00_00_00_55;
                        7'h69:   target_data_tx = 32'h00_00_00_aa;
                        7'h6a:   target_data_tx = 32'h00_00_00_55;
                        7'h6b:   target_data_tx = 32'h00_00_00_aa;
                        7'h6c:   target_data_tx = 32'h00_00_00_55;
                        7'h6d:   target_data_tx = 32'h00_00_00_aa;
                        7'h6e:   target_data_tx = 32'h00_00_00_55;
                        7'h6f:   target_data_tx = 32'h00_00_00_aa;
                        7'h70:   target_data_tx = 32'h00_00_00_55;
                        7'h71:   target_data_tx = 32'h00_00_00_aa;
                        7'h72:   target_data_tx = 32'h00_00_00_55;
                        7'h73:   target_data_tx = 32'h00_00_00_aa;
                        7'h74:   target_data_tx = 32'h00_00_00_55;
                        7'h75:   target_data_tx = 32'h00_00_00_aa;
                        7'h76:   target_data_tx = 32'h00_00_00_55;
                        7'h77:   target_data_tx = 32'h00_00_00_aa;
                        7'h78:   target_data_tx = 32'h00_00_00_55;
                        7'h79:   target_data_tx = 32'h00_00_00_aa;
                        7'h7a:   target_data_tx = 32'h00_00_00_55;
                        7'h7b:   target_data_tx = 32'h00_00_00_aa;
                        7'h7c:   target_data_tx = 32'h00_00_00_55;
                        7'h7d:   target_data_tx = 32'h00_00_00_aa;
                        7'h7e:   target_data_tx = 32'h00_00_00_55;
                        7'h7f:   target_data_tx = 32'h00_00_00_aa;
                        default: target_data_tx = 32'h00_00_00_AD;
                      endcase

                        // Wait for the capture of a data value
                        //
                        @(negedge testbench_top.Rx_Capture_Trigger);

                        // Set Diagnostic Message
                        //
	                    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading Tx Data";

                        // Get the data just transmitted by the UART
                        //
                        read_data = testbench_top.Rx_Holding_Reg_Data_Bit1;

                        // Check the ouptut value for correctness
                        //
                        expected_data = target_data_tx & target_mask;

                        // Determine if there was a data error 
					    //
                        if (read_data[7:0] !== expected_data[7:0])
                        begin
                            $display("[Error] Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx data       read=0x%x , expected=0x%x at time %0t", 
                                                                                                                              read_data[7:0], 
                                                                                                                          expected_data[7:0], 
                                                                                                                                   $realtime );
                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx data       read=0x%x , expected=0x%x at time %0t",  
                                                                                                                              read_data[7:0],
                                                                                                                          expected_data[7:0],
                                                                                                                                   $realtime );
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Check for various potential errors
                        //
                        if ({testbench_top.Rx_Holding_Reg_Parity_Error_Flag1 , 
                             testbench_top.Rx_Holding_Reg_Framing_Error_Flag1 } !== 0)
                        begin
                            case({testbench_top.Rx_Holding_Reg_Parity_Error_Flag1 , 
                                  testbench_top.Rx_Holding_Reg_Framing_Error_Flag1 })
                            2'b01: $display("[Error] Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx with No  Parity Error  and Yes Framing Error at time %0t",  $realtime);
                            2'b10: $display("[Error] Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx with Yes Parity Error  and No  Framing Error at time %0t",  $realtime);
                            2'b11: $display("[Error] Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx with Yes Parity Error  and Yes Framing Error at time %0t",  $realtime);
                            endcase

                            fail_count = fail_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
                        end	
                        else
                        begin
                            $display("[Pass]  Generic_AL4S3B_FPGA_UART1_Test_6: Serial Tx with No Parity Error  and No Framing Error at time %0t",  $realtime);
                            pass_count = pass_count + 1;
	                        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
                        end

                        // Increment the loop variable
                        //
						n = n + 1;
                    end

                    // Set Diagnostic Message
                    //
	                testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Polling for Tx complete";

                    // Initialize the variable
                    //
		            read_data = 0;

		            // Poll for serial tranmission complete
		            //
		            while ((read_data & 32'h0000_0040) === 32'h0)
                    begin
                    `ifdef GSIM
                      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `else
	                    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_LSR), read_data);
                    `endif
                        // Debug Message
                        //
//                      $display("        Generic_AL4S3B_FPGA_UART_Test_6: UART Line Status Reg - Read the value 0x%0x at time: %0t \n", read_data, $realtime);
                    end

                end
              join
            end
        end
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs Rx operations with the Rx FIFO
//
// Operations: The following routine checks the ability to generate an
//             interrupt based on the contents of either the Rx Holding
//             Register or the Rx FIFO. 
//
//             The Interrupt Controller is checked for each interrupt "level"
//             to insure that an interrupt will be passed to the CPU when the
//             Rx FIFO fills to a preset level. This routine also checks the
//             abilty to service this interrupt.
//
// Limitation: There are no error injected into the serial input stream.
//             Therefore, there is no checking for error generation or 
//             interrupt generation. This is left to another routine.
//
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//

task Generic_AL4S3B_FPGA_IP_UART_Test_7;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  Tx_FIFO_Level    ;
reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_data_tx   ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m, n    ;
integer                   Rx_FIFO_Loop_cnt ;


begin

  //$display("rakesh test 7 - UART0 ");

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_IP_UART_Test_7";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    word_length      = SERIAL_DATA_8_BITS;
    stop_bit_length  = SERIAL_STOP_1_BIT ;
    parity_selection = SERIAL_PARITY_NONE;

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

    // Set the Baud Rate on the UART
    //
    Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
                                                 word_length,
                                            parity_selection,
                                             stop_bit_length,
                                      SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                   BREAK_OFF );

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to IER";

    // Enable interrupt capture
    //
    // Note: All interrupts are enabled to check that only expected interrupts happen.
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`endif
    // Write the Modem Control Register
    //
    // Note: The Automatic Flow Control is turned on for RTSn
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_MCR), 8'h22);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_MCR), 8'h22);
`endif
    // Loop to check each Interrupt Trigger value
    //
	for (i = 0; i < 8; i = i + 1)
    begin
        // Set Diagnostic Message
        //
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

        // Set FIFO Control Register to disable the use the Rx and Tx FIFOs
        //
        // Note: The RXDRYn "DMA" mode is turned on for the 512 entry FIFO modes.
		//      This is only for testing and the two are not linked in any 
		//      way in the RTL.
        //
        case(i[2:0])
    `ifdef GSIM
	    3'h0: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h01); // trigger on 1
	    3'h1: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h41); // trigger on 4
	    3'h2: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h81); // trigger on 8
	    3'h3: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hC1); // trigger on 14
	    3'h4: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h29); // trigger on 1
	    3'h5: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h69); // trigger on 128
	    3'h6: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hA9); // trigger on 256
	    3'h7: testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hE9); // trigger on 496
    `else
	    3'h0: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h01); // trigger on 1
	    3'h1: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h41); // trigger on 4
	    3'h2: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h81); // trigger on 8
	    3'h3: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hC1); // trigger on 14
	    3'h4: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h29); // trigger on 1
	    3'h5: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h69); // trigger on 128
	    3'h6: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hA9); // trigger on 256
	    3'h7: testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'hE9); // trigger on 496
    `endif
        endcase

        case(i[2:0])
        3'h0: Rx_FIFO_Loop_cnt = 2;
        3'h1: Rx_FIFO_Loop_cnt = 5;
        3'h2: Rx_FIFO_Loop_cnt = 9;
        3'h3: Rx_FIFO_Loop_cnt = 15;
        3'h4: Rx_FIFO_Loop_cnt = 2;
        3'h5: Rx_FIFO_Loop_cnt = 129;
        3'h6: Rx_FIFO_Loop_cnt = 257;
        3'h7: Rx_FIFO_Loop_cnt = 497;
        endcase

        // Loop to fill the Rx Holding Register/FIFO
        //
        for (j = 0; j < Rx_FIFO_Loop_cnt; j = j + 1)
        begin
            // Set diagnostic message
	        //
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Data from External UART";

            // Transmit a value from the external BFM
            //
            testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                                       word_length,
                                                  parity_selection,
                                                   stop_bit_length,
                                            SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                             j[7:0] );


            // Wait for the received value to be stored in the FIFO
            //
            for (k = 0; k < 20; k = k + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif


            // Set Diagnostic Message
            //
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

            // Check if an interrupt was generated
            //
        `ifdef GSIM
          testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
        `else
	        testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
        `endif
            // Determine the expected status value
            //
            if ( j >= (Rx_FIFO_Loop_cnt - 2) )
            begin
                // Allow for the "64-bit FIFO" bit in the status register
                //
				if ( i > 3)
                   expected_data  = 8'hE4 ;
                else
                   expected_data  = 8'hC4 ;
            end  
            else
            begin
                // Allow for the "64-bit FIFO" bit in the status register
                //
				if ( i > 3)
                   expected_data  = 8'hE1 ;
                else
                   expected_data  = 8'hC1 ;
            end  

            // Determine if there was a FIFO Level error 
            //
            if (read_data[7:0] !== expected_data[7:0])
            begin
                $display("[Error] Generic_AL4S3B_FPGA_UART_Test_7: Interrupt ID Value   read=0x%x , expected=0x%x at time %0t", 
                                                                                                                  read_data[7:0], 
                                                                                                              expected_data[7:0], 
                                                                                                                       $realtime );
                fail_count = fail_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
            end	
            else
            begin
                $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_7: Interrupt ID Value   read=0x%x , expected=0x%x at time %0t",  
                                                                                                                  read_data[7:0],
                                                                                                              expected_data[7:0],
                                                                                                                       $realtime );
                pass_count = pass_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
            end
        end

        // Loop to read the values stored in the Rx Holding Register/FIFO
        //
        for (j = 0; j < Rx_FIFO_Loop_cnt; j = j + 1)
        begin
            // Set diagnostic message
	        //
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from the Rx FIFO";

            // Read the value from the Rx FIFO
        `ifdef GSIM
          testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RBR), read_data);
        `else
	        testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_RBR), read_data);
        `endif
            // Determine if there was a Interrupt Status error
            //
            if (read_data[7:0]  !== j[7:0])
            begin
                $display("[Error] Generic_AL4S3B_FPGA_UART_Test_7: Rx FIFO      Data    read=0x%x , expected=0x%x at time %0t", 
                                                                                                                  read_data[7:0], 
                                                                                                                          j[7:0], 
                                                                                                                       $realtime );
                fail_count = fail_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
            end	
            else
            begin
                $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_7: Rx FIFO      Data    read=0x%x , expected=0x%x at time %0t",  
                                                                                                                  read_data[7:0],
                                                                                                                          j[7:0],
                                                                                                                       $realtime );
                pass_count = pass_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
            end
            // Set Diagnostic Message
            //
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read from IIR";

            // Check if an interrupt was generated
            //
        `ifdef GSIM
          testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
        `else
	        testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
        `endif
            // Determine the expected status value
            //
            // Note: the values chosen for looping exceed the expected
            //       interrupt limit by 2.
            //
            //       The "read" above lowers FIFO contents by one.
            //
            if ( j <  1 )
            begin
                // Allow for the "64-bit FIFO" bit in the status register
                //
				if ( i > 3)
                   expected_data  = 8'hE4 ;
                else
                   expected_data  = 8'hC4 ;
            end  
            else
            begin
                // Allow for the "64-bit FIFO" bit in the status register
                //
				if ( i > 3)
                   expected_data  = 8'hE1 ;
                else
                   expected_data  = 8'hC1 ;
            end  


            // Determine if there was a Interrupt Status error
            //
            if (read_data[7:0]  !== expected_data[7:0])
            begin
                $display("[Error] Generic_AL4S3B_FPGA_UART_Test_7: Interrupt    Status  read=0x%x , expected=0x%x at time %0t", 
                                                                                                                  read_data[7:0], 
                                                                                                              expected_data[7:0], 
                                                                                                                       $realtime );
                fail_count = fail_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
            end	
            else
            begin
                $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_7: Interrupt    Status  read=0x%x , expected=0x%x at time %0t",  
                                                                                                                  read_data[7:0],
                                                                                                              expected_data[7:0],
                                                                                                                       $realtime );
                pass_count = pass_count + 1;
	            testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
            end
        end
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask

//--------------------------------------------------------------------
// The following task checks various handshaking signals
//
// Operations: The following routine checks various handshaking signals in the
//             Modem Control/Status Register and the FIFO Control Register.
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_8;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  Tx_FIFO_Level    ;
reg	     [DATAWIDTH-1:0]  write_data       ;
reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_data_tx   ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m, n    ;
integer                   Rx_FIFO_Loop_cnt ;

begin

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif
    //$stop();
    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_IP_UART_Test_8";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    word_length      = SERIAL_DATA_8_BITS;
    stop_bit_length  = SERIAL_STOP_1_BIT ;
    parity_selection = SERIAL_PARITY_NONE;

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

    // Set the Baud Rate on the UART
    //
    Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
                                                 word_length,
                                            parity_selection,
                                             stop_bit_length,
                                      SERIAL_BAUD_RATE_115200,//SERIAL_BAUD_RATE_38400,
                                                   BREAK_OFF );

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to IER";

    // Enable interrupt capture
    //
    // Note: All interrupts are enabled to check that only expected interrupts happen.
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`endif
    // Loop to check the Modem Status Register and Interrupt ID Register Operations
    //
	for (i = 0; i < 2; i = i + 1)
    begin

        expected_data = 32'b0000_0000_0000_0000_0000_0000_0000_0001;

        // Set Diagnostic Message
        //
        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read the Interrupt ID Reg";

        // Read the Interrupt Status Register
        //
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data);
    `endif
        // Determine if there was a Modem Status Change 
        //
        if (read_data[7:0] !== expected_data[7:0])
        begin
            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_8: Interrupt ID Value   read=0x%x , expected=0x%x at time %0t", 
                                                                                                          read_data[7:0], 
                                                                                                      expected_data[7:0], 
                                                                                                               $realtime );
            fail_count = fail_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
        end	
        else
        begin
            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_8: Interrupt ID Value   read=0x%x , expected=0x%x at time %0t",  
                                                                                                           read_data[7:0],
                                                                                                       expected_data[7:0],
                                                                                                                $realtime );
            pass_count = pass_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
        end

        expected_data = 32'b0000_0000_0000_0000_0000_0000_000_0000;

        // Set Diagnostic Message
        //
        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Read the MSR";

        // Read the Modem Status Register
        //
    `ifdef GSIM
      testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_MSR), read_data);
    `else
	    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_MSR), read_data);
    `endif
        // Determine if there was a Modem Status Change 
        //
        if (read_data[7:0] !== expected_data[7:0])
        begin
            $display("[Error] Generic_AL4S3B_FPGA_UART_Test_8: Modem Status Reg     read=0x%x , expected=0x%x at time %0t", 
                                                                                                          read_data[7:0], 
                                                                                                      expected_data[7:0], 
                                                                                                               $realtime );
            fail_count = fail_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
        end	
        else
        begin
            $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_8: Modem Status Reg     read=0x%x , expected=0x%x at time %0t",  
                                                                                                           read_data[7:0],
                                                                                                       expected_data[7:0],
                                                                                                                $realtime );
            pass_count = pass_count + 1;
	        testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
        end

    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs "TBD" operations
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Test_9;

input    [ADDRWIDTH-1:0]  base_address     ;
	
reg                [1:0]  word_length      ;
reg                       stop_bit_length  ;
reg                [2:0]  parity_selection ;

reg	     [DATAWIDTH-1:0]  Tx_FIFO_Level    ;
reg	     [DATAWIDTH-1:0]  write_data       ;
reg	     [DATAWIDTH-1:0]  read_data        ;
reg	     [DATAWIDTH-1:0]  expected_data    ;
reg	     [DATAWIDTH-1:0]  target_data      ;
reg	     [DATAWIDTH-1:0]  target_data_tx   ;
reg	     [DATAWIDTH-1:0]  target_mask      ;

integer                   i, j, k, m, n    ;
integer                   Rx_FIFO_Loop_cnt ;

begin

    // Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1 = "Generic_AL4S3B_FPGA_IP_UART_Test_9";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2 = "Configuring the UART";

    word_length      = SERIAL_DATA_8_BITS;
    stop_bit_length  = SERIAL_STOP_1_BIT ;
    parity_selection = SERIAL_PARITY_NONE;

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Selecting Rx Formats";

    // Set the Baud Rate on the UART
    //
    Generic_AL4S3B_FPGA_IP_UART_Comm_Config ( base_address,
                                                 word_length,
                                            parity_selection,
                                             stop_bit_length,
                                      SERIAL_BAUD_RATE_38400,
                                                   BREAK_OFF );

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to IER";

    // Enable interrupt capture
    //
    // Note: All interrupts are enabled to check that only expected interrupts happen.
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_IER), 8'hf);
`endif
    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Writing to FCR";

    // Enable the FIFO Operations
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h81); // trigger on 8
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_FCR), 8'h81); // trigger on 8
`endif

    // Set diagnostic message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Sending Rx Formats from External UART";

    // Use an example value
    //
	target_data = 32'hAA;

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_38400,
	                                       target_data[7:0] );

    // Wait for a few clocks
	//
	for (i = 0; i < 44; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

    // Transmit a value from the external BFM
    //
    testbench_top.u_Serial_Tx0_gen_bfm.serial_tx_write_data( 
                                               word_length,
                                          parity_selection,
                                           stop_bit_length,
                                    SERIAL_BAUD_RATE_38400,
	                                       target_data[7:0] );
    // Wait for a few clocks
	//
	for (i = 0; i < 580; i = i + 1)
		@(posedge testbench_top.Rx_Baud_16x_Clk) #STD_CLK_DLY;

    // Set Diagnostic Message
    //
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3 = "Reading from IIR";

    // Enable the FIFO Operations
    //
`ifdef GSIM
  testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data); // trigger on 8
`else
	testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_read_word_al4s3b_fabric((base_address + UART_IIR), read_data); // trigger on 8
`endif
	expected_data = 32'hCC;

    // Check the Interrupt ID value for timeout
    //
    if (read_data[7:0] !== expected_data[7:0])
    begin
        $display("[Error] Generic_AL4S3B_FPGA_UART_Test_9: Interrupt ID value   read=0x%x  , expected=0x%x at time %0t", 
                                                                                                           read_data[7:0], 
                                                                                                       expected_data[7:0], 
                                                                                                                $realtime );
        fail_count = fail_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST FAILED";
    end	
    else
    begin
        $display("[Pass]  Generic_AL4S3B_FPGA_UART_Test_9: Interrupt ID value   read=0x%x  , expected=0x%x at time %0t",  
                                                                                                           read_data[7:0],
                                                                                                       expected_data[7:0],
                                                                                                                $realtime );
        pass_count = pass_count + 1;
	    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "<-TEST PASSED";
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


//--------------------------------------------------------------------
// The following task performs "TBD" operations
//
// Note: This routine allows data used on the actual hardware to be loaded
//       into simulation for additional evaluation.
//--------------------------------------------------------------------
//
task Generic_AL4S3B_FPGA_IP_UART_Comm_Config   ;

input    [ADDRWIDTH-1:0]  base_address           ;
	
input              [1:0]  SERIAL_DATA            ;
input              [2:0]  SERIAL_PARITY          ;
input                     SERIAL_STOP            ;
input              [3:0]  BAUD_RATE              ;
input                     SET_BREAK              ;

reg      [DATAWIDTH-1:0]  read_data              ;
reg      [DATAWIDTH-1:0]  write_data             ;

integer                   i                      ;
integer                   divisor                ;
integer                   divisor_minus_one      ;

real                      serial_data_rate       ;
real                      serial_data_rate_check ;

real                      t_cycle_sys_clk_0      ;
real                      serial_data_rate_error ;

begin

	// Initialize variables to a default value
	//
  //$display("rakesh test 6 - uart config");
    read_data  = 32'h0;
	  write_data = 32'h0;

	// Wait for release of reset
    //
    `ifdef GSIM
        wait (testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_RST === 1'b0);
    `else
        wait (testbench_top.u_AL4S3B_FPGA_Top.WB_RST === 1'b0);
    `endif

    // Wait for a few clocks
	//
	for (i = 0; i < 4; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif
    
	// Set the debug message
	//
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4 = "Generic_AL4S3B_FPGA_IP_UART_Comm_Config";

	// UART 16750 Memory Map is:
	//
	// Register Name              IP Adr   Fab Adr  Comments
	//
	// UART Xmt Buffer  Reg      -  0x00     0x00    RBR - (Read  Only) with DLAB = 0
	// UART Xmt Holding Reg      -  0x00     0x00    THR - (Write Only) with DLAB = 0
	//
	// UART Divisor Latch (LSB)  -  0x00     0x00    DLL -              with DLAB = 1
	//
	// UART Interrupt Enable Reg -  0x01     0x04    IER -              with DLAB = 0
	// UART Divisor Latch (MSB)  -  0x01     0x04    DML -              with DLAB = 1
	//
	// UART Interrupt ID  Reg    -  0x02     0x08    IIR - (Read  Only)
	// UART FIFO Control  Reg    -  0x02     0x08    FCR - (Write Only)
	//
	// UART Line  Control Reg    -  0x03     0x0C    LCR
	// UART Modem Control Reg    -  0x04     0x10    MCR
	// UART Line  Status  Reg    -  0x05     0x14    LSR
	// UART Modem Status  Reg    -  0x06     0x18    MSR
	// UART Scratch       Reg    -  0x07     0x1C    SCR
	//

	// Check that the UART is responding
	//

    // Write a Useful Diagnostic Message
    //
    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5 = "Configuring UART";
    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6 = "Writing to LCR";

    // Set the line Control Register
    //
    // Note: Be sure to set the DLAB bit to the correct value for other registers to come.
    // 

    // Serial Character Length
    //
    // 5 bits = 2'b00
    // 6 bits = 2'b01
    // 7 bits = 2'b10
    // 8 bits = 2'b11
    //
    case(SERIAL_DATA)
    2'b00: write_data[1:0] = 2'b00 ;
    2'b01: write_data[1:0] = 2'b01 ;
    2'b10: write_data[1:0] = 2'b10 ;
    2'b11: write_data[1:0] = 2'b11 ;
    endcase

    // Stop Bits
    //
    // Bit[2]    Word Length   Number of Stop Bits
    //   0         Any                 1
    //   1         5 bits              1.5
    //   1         6 bits              2
    //   1         7 bits              2
    //   1         8 bits              2
    //
    case(SERIAL_STOP)
    1'b0: write_data[2] = 1'b0 ;
    1'b1: write_data[2] = 1'b1 ;
    endcase

    // Parity Enable
    //
    // (Note: this works with bit[4])
    //
    //   0 - No Parity
    //   1 -    Parity
    //

    // Parity Type
    //
    // (Note: This works with bit[3])
    //
    //   0 - Odd  Parity
    //   1 - Even Parity
    //

    // Stick Parity Bit
    //
    // (Note: This works with bits[3:2])
    //
    //   0 - Sticky Parity Operation Disabled
    //   1 - Sticky Parity Operation Enabled
    //

    case(SERIAL_PARITY)
    3'b000: write_data[5:3] = 3'b000 ; // None
    3'b001: write_data[5:3] = 3'b001 ; // Odd   Parity
    3'b010: write_data[5:3] = 3'b010 ; // None
    3'b011: write_data[5:3] = 3'b011 ; // Even  Parity
    3'b100: write_data[5:3] = 3'b100 ; // None
    3'b101: write_data[5:3] = 3'b101 ; // Force 1
    3'b110: write_data[5:3] = 3'b110 ; // None
    3'b111: write_data[5:3] = 3'b111 ; // Force 0
    endcase

    // Break Control Bit
    //
    //   0 - Do nothing
    //   1 - Force a break condition
    //
    write_data[6] =  SET_BREAK ;

    // Divisor Latch
    //
    //   0 - Divisor Latches not selected
    //   1 - Divisor Latches     selected
    //
    write_data[7] = 1'b1;

    // Write to the UART's Line Control Register
    //
  `ifdef GSIM
    testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), write_data);
  `else
    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), write_data);
  `endif
    // Get the current value of the fabric clock
	//
  `ifdef GSIM
    t_cycle_sys_clk_0 = testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.T_CYCLE_CLK_SYS_CLK0;
  `else
    t_cycle_sys_clk_0 = testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.T_CYCLE_CLK_SYS_CLK0;
  `endif
    // Get the serial data rate (Baud Rate)
    //
    case(BAUD_RATE)
    4'h0:    serial_data_rate =    110.0 ;
    4'h1:    serial_data_rate =    300.0 ;
    4'h2:    serial_data_rate =    600.0 ;
    4'h3:    serial_data_rate =   1200.0 ;
    4'h4:    serial_data_rate =   2400.0 ;
    4'h5:    serial_data_rate =   4800.0 ;
    4'h6:    serial_data_rate =   9600.0 ;
    4'h7:    serial_data_rate =  14400.0 ;
    4'h8:    serial_data_rate =  19200.0 ;
    4'h9:    serial_data_rate =  38400.0 ;
    4'ha:    serial_data_rate =  57600.0 ;
    4'hb:    serial_data_rate = 115200.0 ;
    4'hc:    serial_data_rate = 230400.0 ;
    default: serial_data_rate = 921600.0 ;
    endcase

    // Calculate the divisor needed to get the correct Baud Rate
    //
    // Note: The value must be within 2% of target for it to work correctly.
    //
    //divisor = (t_cycle_sys_clk_0 * 1000000)/(serial_data_rate * 16);
    divisor = (1000000000)/(t_cycle_sys_clk_0 * serial_data_rate * 16);

    // Binary Counters are being used so the value should be n-1
	//
    divisor_minus_one = divisor - 1;

    // Debug Message
    //
    //$display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Divisor value: %0x, value: %0f at time: %0t \n", divisor, divisor, $realtime);

    // Write a useful diagnostic message
    //
    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6 = "Writing to DLL";

    // Program the Divisor LSB Register
    //
  `ifdef GSIM
    testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_DLL), divisor_minus_one[7:0]);
  `else
    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_DLL), divisor_minus_one[7:0]);
  `endif
    // Write a useful diagnostic message
    //
    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6 = "Writing to DLM";

    // Program the Divisor MSB Register
    //
  `ifdef GSIM
    testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_DLM), divisor_minus_one[15:8]);
  `else
    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_DLM), divisor_minus_one[15:8]);
  `endif
    // Divisor Latch
    //
    //   0 - Divisor Latches not selected
    //   1 - Divisor Latches     selected
    //
    write_data[7] = 1'b0;

    // Write a useful diagnostic message
    //
    testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6 = "Writing to LCR";

    // Clear the Latch Enable bit so that the Rx/Tx data registers may be used.
	//
  `ifdef GSIM
    testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), write_data);
  `else
    testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.u_ahb_gen_bfm.ahb_write_word_al4s3b_fabric((base_address + UART_LCR), write_data);
  `endif
    // Determine what the actual rate is based on the current AL4S3B clock divisor
    //
    //serial_data_rate_check = (t_cycle_sys_clk_0 * 1000000)/(divisor * 16);
    serial_data_rate_check = (1000000000)/(t_cycle_sys_clk_0 * divisor * 16);

    // Proper Serial Communication Baud rate requires an error of no more than +/- 2%
    //
    serial_data_rate_error = ((serial_data_rate_check - serial_data_rate)/serial_data_rate) * 100;

    // Generate a helpful message
    //

//Anand Comment --July21,2017
	
    case({ SERIAL_STOP, SERIAL_PARITY, SERIAL_DATA })
    6'b0_000_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Buad Rate: %0f, 5 Data Bits, No Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_000_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, No Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_000_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, No Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_000_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, No Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_001_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Odd Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_001_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Odd Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_001_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Odd Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_001_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Odd Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_011_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Even Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_011_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Even Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_011_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Even Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_011_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Even Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_101_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Force 1 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_101_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Force 1 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_101_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Force 1 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_101_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Force 1 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_111_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Force 0 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_111_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Force 0 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_111_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Force 0 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b0_111_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Force 0 Parity Bit, and 1 Stop Bit at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_000_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, No Parity Bit, and 1.5 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_000_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, No Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_000_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, No Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_000_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, No Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_001_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Odd Parity Bit, and 1.5 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_001_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Odd Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_001_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Odd Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_001_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Odd Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_011_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Even Parity Bit, and 1.5 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_011_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Even Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_011_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Even Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_011_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Even Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_101_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Force 1 Parity Bit, and 1.5 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_101_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Force 1 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_101_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Force 1 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_101_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Force 1 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_111_00: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 5 Data Bits, Force 0 Parity Bit, and 1.5 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_111_01: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 6 Data Bits, Force 0 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_111_10: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 7 Data Bits, Force 0 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    6'b1_111_11: $display("[Info]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  Ideal Baud Rate: %0d, Actual Baud Rate: %0f, 8 Data Bits, Force 0 Parity Bit, and 2 Stop Bits at time: %0t", 
			                                                                                                                   serial_data_rate, serial_data_rate_check, $realtime );
    endcase 

    // Check that the selected baud rate value will work and errors are not due to Baud Rate mismatches.
    //
    if ((serial_data_rate_error > 2.0) || (serial_data_rate_error < -2.0) )
    begin
	  //Temp comment Anand-July 21
      // $display("[Error] Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  The Baud Rate Error of %0f%% is greater than +/-2%% and may cause communications failures starting at time: %0t",
      //                                                                                                                                          serial_data_rate_error, $realtime );
      // fail_count = fail_count + 1;
    end	
    else
    begin
       $display("[Pass]  Generic_AL4S3B_FPGA_IP_UART_Comm_Config:  The Baud Rate Error of %0f%% is less than +/-2%% and should not cause communications failures starting at time: %0t", 
                                                                                                                                                      serial_data_rate_error, $realtime );
       pass_count = pass_count + 1;
    end

    // Wait for a few clocks
	//
	for (i = 0; i < 14; i = i + 1)
    `ifdef GSIM
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.WB_CLK) #STD_CLK_DLY;
    `else
        @(posedge testbench_top.u_AL4S3B_FPGA_Top.WB_CLK) #STD_CLK_DLY;
    `endif
    
  //$display("rakesh test 6 - uart config done");

	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg1	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg2	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg3	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg4	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg5	= "NO ACTIVITY";
	testbench_top.testCases_AL4S3B_FPGA_IP.test_cases_msg6	= "NO ACTIVITY";

end
endtask


endmodule
