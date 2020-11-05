/*******************************************************************
 *
 *    FILE:         testCases_AL4S3B_FPGA_IP.v 
 *   
 *    DESCRIPTION:  AL4S3B FPGA integration test cases
 *
 *    HIERARCHY:    testbench_top\testCases
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
 * Date: February 02, 2016
 * Engineer: Glen Gomes
 * Revision: 0.1
 * Change:
 * 1. Intial Coding
 *******************************************************************/

`timescale 1ns/10ps


module testCases_AL4S3B_FPGA_IP;


//------Port Parameters----------------
//

parameter                ADDRWIDTH                   = 32   ;
parameter                DATAWIDTH                   = 32   ;

parameter                APERWIDTH                   = 17   ;
parameter                APERSIZE                    =  9   ;

//parameter                UART_BASE_ADDRESS           = 32'h40021000; // Assumes 128K Byte Aperture
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

parameter                TEST_MSG_ARRAY_SIZE         = (64 * 8);     // 64 ASCII character array size


//------Port Signals-------------------
//

//
// None at this time
//


//------Define Parameters--------------
//

//
// None at this time
//

//------Internal Signals---------------
//

//              AL4S3B FPGA IP UART Tests
//
reg             enable_uart_test_1;
reg             enable_uart_test_2;
reg             enable_uart_test_3;
reg             enable_uart_test_4;
reg             enable_uart_test_5;
reg             enable_uart_test_6;
reg             enable_uart_test_7;
reg             enable_uart_test_8;
reg             enable_uart_test_9;


//              Test Statistics
//
reg				enable_pass_test_message_display;
reg				enable_fail_test_message_display;
reg				enable_performance_message_display;


//              Test Statistics variables
//
integer			fail_count;				// Count the number of failing tests
integer			pass_count;				// Count the number of passing tests

integer 		pass_count_uart_tests;

integer 		fail_count_uart_tests;

//              Misc Test Selection Support
//
string          test_name;


//              Simulation ASCII Message Arrays
//
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg1;		// Bus used for depositing test messages in ASCII
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg2;		// Bus used for depositing test messages in ASCII
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg3;		// Bus used for depositing test messages in ASCII
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg4;		// Bus used for depositing test messages in ASCII
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg5;		// Bus used for depositing test messages in ASCII
reg	   [TEST_MSG_ARRAY_SIZE-1:0]	test_cases_msg6;		// Bus used for depositing test messages in ASCII



//------Instantiate Modules------------
//

// Instantiate the test bench modules for each design unit category
//

testCases_AL4S3B_FPGA_IP_UART
                                #(
    .ADDRWIDTH                   ( ADDRWIDTH                   ),
    .DATAWIDTH                   ( DATAWIDTH                   ),
    .APERWIDTH                   ( APERWIDTH                   ),
    .APERSIZE                    ( APERSIZE                    ),
	  //.BASE_AHB_ADDRESS            ( UART_BASE_ADDRESS           ),
    
    .UART0_BASE_ADDRESS          ( UART0_BASE_ADDRESS          ),
    .UART1_BASE_ADDRESS          ( UART1_BASE_ADDRESS          ),

    .SERIAL_DATA_5_BITS          ( SERIAL_DATA_5_BITS          ),
    .SERIAL_DATA_6_BITS          ( SERIAL_DATA_6_BITS          ),
    .SERIAL_DATA_7_BITS          ( SERIAL_DATA_7_BITS          ),
    .SERIAL_DATA_8_BITS          ( SERIAL_DATA_8_BITS          ),

    .SERIAL_PARITY_NONE          ( SERIAL_PARITY_NONE          ),
    .SERIAL_PARITY_ODD           ( SERIAL_PARITY_ODD           ),
    .SERIAL_PARITY_EVEN          ( SERIAL_PARITY_EVEN          ),
    .SERIAL_PARITY_FORCE_1       ( SERIAL_PARITY_FORCE_1       ),
    .SERIAL_PARITY_FORCE_0       ( SERIAL_PARITY_FORCE_0       ),

    .SERIAL_STOP_1_BIT           ( SERIAL_STOP_1_BIT           ),
    .SERIAL_STOP_1P5_BIT         ( SERIAL_STOP_1P5_BIT         ),
    .SERIAL_STOP_2_BIT           ( SERIAL_STOP_2_BIT           ),

    .SERIAL_BAUD_RATE_110        ( SERIAL_BAUD_RATE_110        ),
    .SERIAL_BAUD_RATE_300        ( SERIAL_BAUD_RATE_300        ),
    .SERIAL_BAUD_RATE_600        ( SERIAL_BAUD_RATE_600        ),
    .SERIAL_BAUD_RATE_1200       ( SERIAL_BAUD_RATE_1200       ),
    .SERIAL_BAUD_RATE_2400       ( SERIAL_BAUD_RATE_2400       ),
    .SERIAL_BAUD_RATE_4800       ( SERIAL_BAUD_RATE_4800       ),
    .SERIAL_BAUD_RATE_9600       ( SERIAL_BAUD_RATE_9600       ),
    .SERIAL_BAUD_RATE_14400      ( SERIAL_BAUD_RATE_14400      ),
    .SERIAL_BAUD_RATE_19200      ( SERIAL_BAUD_RATE_19200      ),
    .SERIAL_BAUD_RATE_38400      ( SERIAL_BAUD_RATE_38400      ),
    .SERIAL_BAUD_RATE_57600      ( SERIAL_BAUD_RATE_57600      ),
    .SERIAL_BAUD_RATE_115200     ( SERIAL_BAUD_RATE_115200     ),
    .SERIAL_BAUD_RATE_230400     ( SERIAL_BAUD_RATE_230400     ),
    .SERIAL_BAUD_RATE_921600     ( SERIAL_BAUD_RATE_921600     ),

	.STD_CLK_DLY                 ( STD_CLK_DLY                 ),
    .ENABLE_TEST_DEBUG_MSG       ( 1'b1                        )
                                 )
     u_testCases_AL4S3B_FPGA_IP_UART();


//------Logic Operations---------------
//

// Select the test cases to run
initial
begin
    test_cases_msg1	= "NO ACTIVITY";
    test_cases_msg2	= "NO ACTIVITY";
    test_cases_msg3	= "NO ACTIVITY";
    test_cases_msg4	= "NO ACTIVITY";
    test_cases_msg5	= "NO ACTIVITY";
    test_cases_msg6	= "NO ACTIVITY";

    // Enable the output to the screen for test messages
    enable_pass_test_message_display			= 1'b1;
    enable_fail_test_message_display			= 1'b1;
    enable_performance_message_display			= 1'b1;

    // Reset the Pass / Fail Counts
    pass_count									= 0;
    fail_count									= 0;

    pass_count_uart_tests                       = 0;

    fail_count_uart_tests                       = 0;

    enable_uart_test_1                          = 0;
    enable_uart_test_2                          = 0;
    enable_uart_test_3                          = 0;
    enable_uart_test_4                          = 0;
    enable_uart_test_5                          = 0;
    enable_uart_test_6                          = 0;
    enable_uart_test_7                          = 0;
    enable_uart_test_8                          = 0;
    enable_uart_test_9                          = 0;

    // Determine which test(s) to run

    if ($value$plusargs("TESTNAME=%s", test_name))
    begin
        $display("\nINFO: AL4S3B FPGA IP Simulation: Running test %0s.\n", test_name);

    //  AL4S3B FPGA IP UART Tests 

        if (test_name == "uart_test_1")
          enable_uart_test_1                    = 1'b1;
              
        else if (test_name == "uart_test_2")
          enable_uart_test_2                    = 1'b1;
              
        else if (test_name == "uart_test_3")
          enable_uart_test_3                    = 1'b1;
              
        else if (test_name == "uart_test_4")
          enable_uart_test_4                    = 1'b1;
              
        else if (test_name == "uart_test_5")
          enable_uart_test_5                    = 1'b1;
              
        else if (test_name == "uart_test_6")
          enable_uart_test_6                    = 1'b1;
              
        else if (test_name == "uart_test_7")
          enable_uart_test_7                    = 1'b1;
              
        else if (test_name == "uart_test_8")
          enable_uart_test_8                    = 1'b1;
              
        else if (test_name == "uart_test_9")
          enable_uart_test_9                    = 1'b1;
              
        else
	      $display("\nERROR! AL4S3B FPGA IP Simulation: Please give a valid test. %0s is not a valid test!!!\n",test_name);

    end 


    // Define a call to each test
    u_testCases_AL4S3B_FPGA_IP_UART.testCases_AL4S3B_FPGA_IP_UART_testRoutines(
        {23'h0,
         enable_uart_test_9,                                                // TEST_ENABLES[8]
         enable_uart_test_8,                                                // TEST_ENABLES[7]
         enable_uart_test_7,                                                // TEST_ENABLES[6]
         enable_uart_test_6,                                                // TEST_ENABLES[5]
         enable_uart_test_5,                                                // TEST_ENABLES[4]
         enable_uart_test_4,                                                // TEST_ENABLES[3]
         enable_uart_test_3,                                                // TEST_ENABLES[2]
         enable_uart_test_2,                                                // TEST_ENABLES[1]
         enable_uart_test_1},                                               // TEST_ENABLES[0]
         fail_count_uart_tests, 
         pass_count_uart_tests);
			 

    
    // Calculate the final results
    pass_count = pass_count_uart_tests;

    fail_count = fail_count_uart_tests;

    $display(" \n");
    // Display test execution statistics
    $display(" Passing Tests: %0d \n", pass_count);
    $display(" Failing Tests: %0d \n", fail_count);

    $stop;
    $finish;

end   


endmodule
