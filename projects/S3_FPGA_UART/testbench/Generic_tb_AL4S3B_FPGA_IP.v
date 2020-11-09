/*******************************************************************
 *
 *    FILE:         Generic_tb_AL43B_FPGA.v 
 *   
 *    DESCRIPTION:  AL4S3B FPGA integration testbench
 *
 *    HIERARCHY:    Top-level
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
 *
 * ------------------------------------------------------------
 * Date: February 03, 2016
 * Engineer: Glen Gomes
 * Revision: 0.1
 * 1. Initial Revision
 *******************************************************************/

`timescale 1ns/10ps

module testbench_top;

// =======================================
//
//		SIGNAL / PARAMETER DEFINITIONS
//
// =======================================

parameter       ADDRWIDTH                   = 32            ;
parameter       DATAWIDTH                   = 32            ;

parameter       APERWIDTH                   = 17            ;
parameter       APERSIZE                    =  9            ;

//parameter       UART_BASE_ADDRESS           = 32'h40021000  ; // Assumes 128K Byte Aperture
parameter       UART0_BASE_ADDRESS          = 32'h40021000  ;
parameter       UART1_BASE_ADDRESS          = 32'h40022000  ;

parameter       SERIAL_DATA_5_BITS          =  2'b00        ;
parameter       SERIAL_DATA_6_BITS          =  2'b01        ;
parameter       SERIAL_DATA_7_BITS          =  2'b10        ;
parameter       SERIAL_DATA_8_BITS          =  2'b11        ;

parameter       SERIAL_PARITY_NONE          =  3'b000       ;
parameter       SERIAL_PARITY_ODD           =  3'b001       ;
parameter       SERIAL_PARITY_EVEN          =  3'b011       ;
parameter       SERIAL_PARITY_FORCE_1       =  3'b101       ;
parameter       SERIAL_PARITY_FORCE_0       =  3'b111       ;

parameter       SERIAL_STOP_1_BIT           =  1'b0         ;
parameter       SERIAL_STOP_1P5_BIT         =  1'b1         ;
parameter       SERIAL_STOP_2_BIT           =  1'b1         ;

parameter       SERIAL_BAUD_RATE_110        =  4'h0         ;
parameter       SERIAL_BAUD_RATE_300        =  4'h1         ;
parameter       SERIAL_BAUD_RATE_600        =  4'h2         ;
parameter       SERIAL_BAUD_RATE_1200       =  4'h3         ;
parameter       SERIAL_BAUD_RATE_2400       =  4'h4         ;
parameter       SERIAL_BAUD_RATE_4800       =  4'h5         ;
parameter       SERIAL_BAUD_RATE_9600       =  4'h6         ;
parameter       SERIAL_BAUD_RATE_14400      =  4'h7         ;
parameter       SERIAL_BAUD_RATE_19200      =  4'h8         ;
parameter       SERIAL_BAUD_RATE_38400      =  4'h9         ;
parameter       SERIAL_BAUD_RATE_57600      =  4'hA         ;
parameter       SERIAL_BAUD_RATE_115200     =  4'hB         ;
parameter       SERIAL_BAUD_RATE_230400     =  4'hC         ;
parameter       SERIAL_BAUD_RATE_921600     =  4'hD         ;


parameter       STD_CLK_DLY                 =  2            ;

parameter       TEST_MSG_ARRAY_SIZE         = (64 * 8)      ;     // 64 ASCII character array size

`ifdef GSIM
  defparam testbench_top.u_AL4S3B_FPGA_Top.ASSP_u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.T_CYCLE_CLK_SYS_CLK0 = 135.63;
`else
  defparam testbench_top.u_AL4S3B_FPGA_Top.u_qlal4s3b_cell_macro.u_ASSP_bfm_inst.T_CYCLE_CLK_SYS_CLK0 = 135.63;
`endif

// connections between modules


//	Define the reset signal
//
reg             sys_rst_N   ;


//  Application Specific signals
//
// 	Note:   These signals may be controlled by an external pull-up/down,
//          switches, jumpers, or GPIO port of a controller.
//
//          These should be controlled via reg to allow emulation of this
//          control.
//

//reg             SIN         ;
reg             UART0_SIN_i ;
reg             UART1_SIN_i ;
wire            SOUT        ;

wire            Null_Modem_Tx_to_Rx0;
wire            Null_Modem_Rx_to_Tx0;
wire            Null_Modem_Tx_to_Rx1;
wire            Null_Modem_Rx_to_Tx1;

reg     [3:0]   Serial_Baud_Rate_parameter        ;
reg     [1:0]   Serial_Data_Bits_parameter        ;
reg     [2:0]   Serial_Parity_Bit_parameter       ;
reg             Serial_Stop_Bit_parameter         ;

reg     [3:0]   Serial_Baud_Rate_parameter1        ;
reg     [1:0]   Serial_Data_Bits_parameter1        ;
reg     [2:0]   Serial_Parity_Bit_parameter1       ;
reg             Serial_Stop_Bit_parameter1         ;

wire            Rx_Baud_16x_Clk                   ;
wire            Rx_Capture_Trigger                ;

wire    [1:0]   Rx_Holding_Reg_Stop_Bit1           ;
wire            Rx_Holding_Reg_Parity_Bit1         ;
wire    [7:0]   Rx_Holding_Reg_Data_Bit1           ;
wire            Rx_Holding_Reg_Start_Bit1          ;
wire            Rx_Holding_Reg_Parity_Error_Flag1  ;
wire            Rx_Holding_Reg_Framing_Error_Flag1 ;
wire            Rx_Holding_Reg_Break_Flag1         ;
wire            Rx_Holding_Reg_False_Start_Flag1   ;

wire    [1:0]   Rx_Holding_Reg_Stop_Bit           ;
wire            Rx_Holding_Reg_Parity_Bit         ;
wire    [7:0]   Rx_Holding_Reg_Data_Bit           ;
wire            Rx_Holding_Reg_Start_Bit          ;
wire            Rx_Holding_Reg_Parity_Error_Flag  ;
wire            Rx_Holding_Reg_Framing_Error_Flag ;
wire            Rx_Holding_Reg_Break_Flag         ;
wire            Rx_Holding_Reg_False_Start_Flag   ;


// =======================================
//
//		INITIALIZE INTERFACE SIGNALS
//
// =======================================
//
//	Note:   These are signals that are normally controlled via a pull-up/down,
//          switches, jumpers, or GPIO of a controller.
//
//          The following always blocks sets the initial state of the signal.
//

initial
begin

    // Initialize the Serial UART Bus monitor
    //
    Serial_Data_Bits_parameter  = SERIAL_DATA_8_BITS    ;
    Serial_Parity_Bit_parameter = SERIAL_PARITY_NONE    ;
    Serial_Stop_Bit_parameter   = SERIAL_STOP_1_BIT     ;
    Serial_Baud_Rate_parameter  = SERIAL_BAUD_RATE_115200;
    
    //Serial_Data_Bits_parameter1  = SERIAL_DATA_8_BITS    ;
    //Serial_Parity_Bit_parameter1 = SERIAL_PARITY_NONE    ;
    //Serial_Stop_Bit_parameter1   = SERIAL_STOP_1_BIT     ;
    //Serial_Baud_Rate_parameter1  = SERIAL_BAUD_RATE_115200;

    //SIN              <=  1'b1;
    UART0_SIN_i      <=  1'b1;
    UART1_SIN_i      <=  1'b1;

    sys_rst_N        <=  1'b0;    // Start the simulation with the device reset
	#100;
    sys_rst_N        <=  1'b1;    // Start the simulation with the device reset

end


// =======================================
//
//		MODULE INSTANTIATIONS
//
// =======================================


// FPGA top level
//
// Note: This represents the board level connection to the FPGA IP.
//
top     u_AL4S3B_FPGA_Top 
	                           (
    .gnd_o                     (                                           ),
    .UART0_SIN_i               ( Null_Modem_Tx_to_Rx0                      ),
    .UART0_SOUT_o              ( Null_Modem_Rx_to_Tx0                      )
	);

//UART0
// Intantiate the Tx BFM
//
Serial_Tx_gen_bfm             #(

    .ENABLE_REG_WR_DEBUG_MSG   ( 1'b0                                    ),
    .ENABLE_REG_RD_DEBUG_MSG   ( 1'b0                                    ),

    .SERIAL_DATA_5_BITS        ( SERIAL_DATA_5_BITS                      ),
    .SERIAL_DATA_6_BITS        ( SERIAL_DATA_6_BITS                      ),
    .SERIAL_DATA_7_BITS        ( SERIAL_DATA_7_BITS                      ),
    .SERIAL_DATA_8_BITS        ( SERIAL_DATA_8_BITS                      ),

    .SERIAL_PARITY_NONE        ( SERIAL_PARITY_NONE                      ),
    .SERIAL_PARITY_ODD         ( SERIAL_PARITY_ODD                       ),
    .SERIAL_PARITY_EVEN        ( SERIAL_PARITY_EVEN                      ),
    .SERIAL_PARITY_FORCE_1     ( SERIAL_PARITY_FORCE_1                   ),
    .SERIAL_PARITY_FORCE_0     ( SERIAL_PARITY_FORCE_0                   ),

    .SERIAL_STOP_1_BIT         ( SERIAL_STOP_1_BIT                       ),
    .SERIAL_STOP_1P5_BIT       ( SERIAL_STOP_1P5_BIT                     ),
    .SERIAL_STOP_2_BIT         ( SERIAL_STOP_2_BIT                       ),

    .SERIAL_BAUD_RATE_110      ( SERIAL_BAUD_RATE_110                    ),
    .SERIAL_BAUD_RATE_300      ( SERIAL_BAUD_RATE_300                    ),
    .SERIAL_BAUD_RATE_600      ( SERIAL_BAUD_RATE_600                    ),
    .SERIAL_BAUD_RATE_1200     ( SERIAL_BAUD_RATE_1200                   ),
    .SERIAL_BAUD_RATE_2400     ( SERIAL_BAUD_RATE_2400                   ),
    .SERIAL_BAUD_RATE_4800     ( SERIAL_BAUD_RATE_4800                   ),
    .SERIAL_BAUD_RATE_9600     ( SERIAL_BAUD_RATE_9600                   ),
    .SERIAL_BAUD_RATE_14400    ( SERIAL_BAUD_RATE_14400                  ),
    .SERIAL_BAUD_RATE_19200    ( SERIAL_BAUD_RATE_19200                  ),
    .SERIAL_BAUD_RATE_38400    ( SERIAL_BAUD_RATE_38400                  ),
    .SERIAL_BAUD_RATE_57600    ( SERIAL_BAUD_RATE_57600                  ),
    .SERIAL_BAUD_RATE_115200   ( SERIAL_BAUD_RATE_115200                 ),
    .SERIAL_BAUD_RATE_230400   ( SERIAL_BAUD_RATE_230400                 ),
    .SERIAL_BAUD_RATE_921600   ( SERIAL_BAUD_RATE_921600                 )

    )

    u_Serial_Tx0_gen_bfm        (

    .Tx                        ( Null_Modem_Tx_to_Rx0                     ),
    .RTSn                      (                                         ),
    .CTSn                      (                                         )

    );
			
// Intantiate the Rx BFM
//
Serial_Rx_monitor             #(

    .ENABLE_DEBUG_MSGS         ( 1'b1                                    ),
    .ENABLE_DEBUG_ERROR_MSGS   ( 1'b1                                    ),

    .SERIAL_DATA_5_BITS        ( SERIAL_DATA_5_BITS                      ),
    .SERIAL_DATA_6_BITS        ( SERIAL_DATA_6_BITS                      ),
    .SERIAL_DATA_7_BITS        ( SERIAL_DATA_7_BITS                      ),
    .SERIAL_DATA_8_BITS        ( SERIAL_DATA_8_BITS                      ),

    .SERIAL_PARITY_NONE        ( SERIAL_PARITY_NONE                      ),
    .SERIAL_PARITY_ODD         ( SERIAL_PARITY_ODD                       ),
    .SERIAL_PARITY_EVEN        ( SERIAL_PARITY_EVEN                      ),
    .SERIAL_PARITY_FORCE_1     ( SERIAL_PARITY_FORCE_1                   ),
    .SERIAL_PARITY_FORCE_0     ( SERIAL_PARITY_FORCE_0                   ),

    .SERIAL_STOP_1_BIT         ( SERIAL_STOP_1_BIT                       ),
    .SERIAL_STOP_1P5_BIT       ( SERIAL_STOP_1P5_BIT                     ),
    .SERIAL_STOP_2_BIT         ( SERIAL_STOP_2_BIT                       ),

    .SERIAL_BAUD_RATE_110      ( SERIAL_BAUD_RATE_110                    ),
    .SERIAL_BAUD_RATE_300      ( SERIAL_BAUD_RATE_300                    ),
    .SERIAL_BAUD_RATE_600      ( SERIAL_BAUD_RATE_600                    ),
    .SERIAL_BAUD_RATE_1200     ( SERIAL_BAUD_RATE_1200                   ),
    .SERIAL_BAUD_RATE_2400     ( SERIAL_BAUD_RATE_2400                   ),
    .SERIAL_BAUD_RATE_4800     ( SERIAL_BAUD_RATE_4800                   ),
    .SERIAL_BAUD_RATE_9600     ( SERIAL_BAUD_RATE_9600                   ),
    .SERIAL_BAUD_RATE_14400    ( SERIAL_BAUD_RATE_14400                  ),
    .SERIAL_BAUD_RATE_19200    ( SERIAL_BAUD_RATE_19200                  ),
    .SERIAL_BAUD_RATE_38400    ( SERIAL_BAUD_RATE_38400                  ),
    .SERIAL_BAUD_RATE_57600    ( SERIAL_BAUD_RATE_57600                  ),
    .SERIAL_BAUD_RATE_115200   ( SERIAL_BAUD_RATE_115200                 ),
    .SERIAL_BAUD_RATE_230400   ( SERIAL_BAUD_RATE_230400                 ),
    .SERIAL_BAUD_RATE_921600   ( SERIAL_BAUD_RATE_921600                 )

    )

    u_Serial_Rx0_monitor                (

    .Rx                                ( Null_Modem_Rx_to_Tx0              ),
    .RTSn                              (                                   ),
    .CTSn                              (                                   ),

    .Serial_Baud_Rate_parameter        ( Serial_Baud_Rate_parameter        ),
    .Serial_Data_Bits_parameter        ( Serial_Data_Bits_parameter        ),
    .Serial_Parity_Bit_parameter       ( Serial_Parity_Bit_parameter       ),
    .Serial_Stop_Bit_parameter         ( Serial_Stop_Bit_parameter         ),

    .Rx_Baud_16x_Clk                   ( Rx_Baud_16x_Clk                   ),
    .Rx_Capture_Trigger                ( Rx_Capture_Trigger                ),

    .Rx_Holding_Reg_Stop_Bit           ( Rx_Holding_Reg_Stop_Bit           ),
    .Rx_Holding_Reg_Parity_Bit         ( Rx_Holding_Reg_Parity_Bit         ),
    .Rx_Holding_Reg_Data_Bit           ( Rx_Holding_Reg_Data_Bit           ),
    .Rx_Holding_Reg_Start_Bit          ( Rx_Holding_Reg_Start_Bit          ),
    .Rx_Holding_Reg_Parity_Error_Flag  ( Rx_Holding_Reg_Parity_Error_Flag  ),
    .Rx_Holding_Reg_Framing_Error_Flag ( Rx_Holding_Reg_Framing_Error_Flag ),
    .Rx_Holding_Reg_Break_Flag         ( Rx_Holding_Reg_Break_Flag         ),
    .Rx_Holding_Reg_False_Start_Flag   ( Rx_Holding_Reg_False_Start_Flag   )

    );
    
// Instantiate the test bench routines
//
// Note:    There should not be any test bench code at this level. 
//          This is only a test harness.
//
testCases_AL4S3B_FPGA_IP    #(

    .ADDRWIDTH                 ( ADDRWIDTH                               ),
    .DATAWIDTH                 ( DATAWIDTH                               ),
    .APERWIDTH                 ( APERWIDTH                               ),
    .APERSIZE                  ( APERSIZE                                ),

    .UART0_BASE_ADDRESS        ( UART0_BASE_ADDRESS                      ),
    .UART1_BASE_ADDRESS        ( UART1_BASE_ADDRESS                      ),

    .SERIAL_DATA_5_BITS        ( SERIAL_DATA_5_BITS                      ),
    .SERIAL_DATA_6_BITS        ( SERIAL_DATA_6_BITS                      ),
    .SERIAL_DATA_7_BITS        ( SERIAL_DATA_7_BITS                      ),
    .SERIAL_DATA_8_BITS        ( SERIAL_DATA_8_BITS                      ),

    .SERIAL_PARITY_NONE        ( SERIAL_PARITY_NONE                      ),
    .SERIAL_PARITY_ODD         ( SERIAL_PARITY_ODD                       ),
    .SERIAL_PARITY_EVEN        ( SERIAL_PARITY_EVEN                      ),
    .SERIAL_PARITY_FORCE_1     ( SERIAL_PARITY_FORCE_1                   ),
    .SERIAL_PARITY_FORCE_0     ( SERIAL_PARITY_FORCE_0                   ),

    .SERIAL_STOP_1_BIT         ( SERIAL_STOP_1_BIT                       ),
    .SERIAL_STOP_1P5_BIT       ( SERIAL_STOP_1P5_BIT                     ),
    .SERIAL_STOP_2_BIT         ( SERIAL_STOP_2_BIT                       ),

    .SERIAL_BAUD_RATE_110      ( SERIAL_BAUD_RATE_110                    ),
    .SERIAL_BAUD_RATE_300      ( SERIAL_BAUD_RATE_300                    ),
    .SERIAL_BAUD_RATE_600      ( SERIAL_BAUD_RATE_600                    ),
    .SERIAL_BAUD_RATE_1200     ( SERIAL_BAUD_RATE_1200                   ),
    .SERIAL_BAUD_RATE_2400     ( SERIAL_BAUD_RATE_2400                   ),
    .SERIAL_BAUD_RATE_4800     ( SERIAL_BAUD_RATE_4800                   ),
    .SERIAL_BAUD_RATE_9600     ( SERIAL_BAUD_RATE_9600                   ),
    .SERIAL_BAUD_RATE_14400    ( SERIAL_BAUD_RATE_14400                  ),
    .SERIAL_BAUD_RATE_19200    ( SERIAL_BAUD_RATE_19200                  ),
    .SERIAL_BAUD_RATE_38400    ( SERIAL_BAUD_RATE_38400                  ),
    .SERIAL_BAUD_RATE_57600    ( SERIAL_BAUD_RATE_57600                  ),
    .SERIAL_BAUD_RATE_115200   ( SERIAL_BAUD_RATE_115200                 ),
    .SERIAL_BAUD_RATE_230400   ( SERIAL_BAUD_RATE_230400                 ),
    .SERIAL_BAUD_RATE_921600   ( SERIAL_BAUD_RATE_921600                 ),

    .STD_CLK_DLY               ( STD_CLK_DLY                             ),
    .TEST_MSG_ARRAY_SIZE       ( TEST_MSG_ARRAY_SIZE                     )
                               )

    testCases_AL4S3B_FPGA_IP ();		// test cases


//`define Modelsim

// Save waveforms for analysis
//

initial
begin
    $timeformat(-9,1,"ns",20);
//    $dumpfile("AL4S3B_FPGA_sim.vcd");
//    $dumpvars;

`ifdef Modelsim
	$wlfdumpvars;
`endif

end

endmodule // testbench_top
