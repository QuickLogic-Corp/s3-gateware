// -----------------------------------------------------------------------------
// title          : AL4S3B Example FPGA IP Module
// project        : Tamar2 Device
// -----------------------------------------------------------------------------
// file           : AL4S3B_FPGA_IP.v
// author         : SSG
// company        : QuickLogic Corp
// created        : 2016/02/03	
// last update    : 2016/02/03
// platform       : ArcticLink 4 S3B
// standard       : Verilog 2001
// -----------------------------------------------------------------------------
// description: The FPGA example IP design contains the essential logic for
//              interfacing the ASSP of the AL4S3B to registers and memory 
//              located in the programmable FPGA.
// -----------------------------------------------------------------------------
// copyright (c) 2016
// -----------------------------------------------------------------------------
// revisions  :
// date            version       author             description
// -----------------------------------------------------------------------------
// Comments: This solution is specifically for use with the QuickLogic
//           AL4S3B device. 
// -----------------------------------------------------------------------------
//

`timescale 1ns / 10ps
module AL4S3B_FPGA_IP ( 

                // AHB-To_FPGA Bridge I/F
                //
                WBs_ADR,
                WBs_CYC,
                WBs_BYTE_STB,
                WBs_WE,
                WBs_RD,
                WBs_STB,
                WBs_WR_DAT,
                WB_CLK,
                WB_RST,
                WBs_RD_DAT,
                WBs_ACK,
				
                //FPGA IP
				usbp_io,
				usbn_io,
				
				clk_48mhz_i,
				clk_12mhz_i,
				reset_i,
				
				spi_cs_o,
				spi_sck_o,
				spi_mosi_o,
				spi_miso_i,
				
				led_o,
				boot_o,
			    Interrupt_o,
                clk_sel_o,

                // Misc
                Device_ID_o
                );


//------Port Parameters----------------
//

parameter       APERWIDTH                   = 17            ;
parameter       APERSIZE                    =  9            ;

                                                             // these are byte offsets.
parameter       FPGA_REG_BASE_ADDRESS       = 17'h00000     ; // Assumes 128K Byte FPGA Memory Aperture
parameter       QL_RESERVED_BASE_ADDRESS    = 17'h00800     ; // Assumes 128K Byte FPGA Memory Aperture

parameter       ADDRWIDTH_FAB_REG           =  7            ;
parameter       DATAWIDTH_FAB_REG           = 32            ;
	
                                                              // these are byte offsets
                                                              //  the 2 LSB's (on the right) should be 0's.
parameter       FPGA_REG_ID_VALUE_ADR     =  10'h000; 
parameter       FPGA_REV_NUM_ADR          =  10'h004; 
parameter       FPGA_SCRATCH_REG_ADR      =  10'h008; 


parameter       AL4S3B_DEF_REG_VALUE        = 32'hFAB_DEF_AC; // Distinguish access to undefined area

parameter       DEFAULT_READ_VALUE          = 32'hBAD_FAB_AC; // Bad FPGA Access
parameter       DEFAULT_CNTR_WIDTH          =  3            ;
parameter       DEFAULT_CNTR_TIMEOUT        =  7            ;

parameter       ADDRWIDTH_QL_RESERVED       =  7            ;
parameter       DATAWIDTH_QL_RESERVED       = 32            ;

parameter       QL_RESERVED_CUST_PROD_ADR   =  10'h1F8       ;  
parameter       QL_RESERVED_REVISIONS_ADR   =  10'h1FC       ;  

parameter       QL_RESERVED_CUSTOMER_ID     =  8'h01        ;
parameter       QL_RESERVED_PRODUCT_ID      =  8'h00        ;
parameter       QL_RESERVED_MAJOR_REV       = 16'h0001      ; 
parameter       QL_RESERVED_MINOR_REV       = 16'h0000      ;

parameter       QL_RESERVED_DEF_REG_VALUE   = 32'hDEF_FAB_AC; // Distinguish access to undefined area


//------Port Signals-------------------
//

// AHB-To_FPGA Bridge I/F
//
input   [16:0]  WBs_ADR          ;  // Address Bus                to   FPGA
input           WBs_CYC          ;  // Cycle Chip Select          to   FPGA
input    [3:0]  WBs_BYTE_STB     ;  // Byte Select                to   FPGA
input           WBs_WE           ;  // Write Enable               to   FPGA
input           WBs_RD           ;  // Read  Enable               to   FPGA
input           WBs_STB          ;  // Strobe Signal              to   FPGA
input   [31:0]  WBs_WR_DAT       ;  // Write Data Bus             to   FPGA
input           WB_CLK           ;  // FPGA Clock               from FPGA
input           WB_RST           ;  // FPGA Reset               to   FPGA
output  [31:0]  WBs_RD_DAT       ;  // Read Data Bus              from FPGA
output          WBs_ACK          ;  // Transfer Cycle Acknowledge from FPGA

output    [31:0]  Device_ID_o    ;

inout 			usbp_io;
inout 			usbn_io;
	
input 			clk_48mhz_i;
input           clk_12mhz_i;

input 			reset_i;
	
output 			spi_cs_o;
output 			spi_sck_o;
output 			spi_mosi_o;
input 			spi_miso_i;
	
output 			led_o;
output 			boot_o;
output          Interrupt_o;
output          clk_sel_o;


assign led_o = 0;
assign boot_o = 0;
assign spi_cs_o = 0;
assign spi_sck_o = 0;
assign spi_mosi_o = 0;


// FPGA IP Internal Signals

wire usb_p_tx, usb_n_tx, usb_p_rx, usb_n_rx, usb_tx_en ;
wire usb_p_rx_int, usb_n_rx_int ;


// FPGA Global Signals
//
wire            WB_CLK           ;  // Wishbone FPGA Clock
wire            WB_RST           ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
//
wire    [16:0]  WBs_ADR          ;  // Wishbone Address Bus
wire            WBs_CYC          ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select)
wire     [3:0]  WBs_BYTE_STB     ;  // Wishbone Byte   Enables
wire            WBs_WE           ;  // Wishbone Write  Enable Strobe
wire            WBs_RD           ;  // Wishbone Read   Enable Strobe
wire            WBs_STB          ;  // Wishbone Transfer      Strobe

reg     [31:0]  WBs_RD_DAT       ;  // Wishbone Read   Data Bus
wire    [31:0]  WBs_WR_DAT       ;  // Wishbone Write  Data Bus
wire            WBs_ACK          ;  // Wishbone Client Acknowledge


//------Internal Signals---------------
//

// Wishbone Bus Signals
//
wire            WBs_CYC_FPGA_Reg   ;
wire            WBs_CYC_QL_Reserved  ;

wire            WBs_ACK_FPGA_Reg   ;
wire            WBs_ACK_QL_Reserved  ;

wire    [31:0]  WBs_DAT_o_FPGA_Reg ;
wire    [31:0]  WBs_DAT_o_QL_Reserved;

//
wire    [31:0]  Device_ID_o    ;

wire 			clk_12mhz;


wire            FIFO_u2m_push         ;
wire    [7:0]   FIFO_u2m_din          ;
wire            FIFO_u2m_af           ;
wire            FIFO_u2m_full         ;
wire    [3:0]   FIFO_u2m_pushflag     ;

wire            FIFO_u2m_pop          ;
wire    [7:0]   FIFO_u2m_dout         ;
wire            FIFO_u2m_ae           ;
wire            FIFO_u2m_empty        ;
wire    [3:0]   FIFO_u2m_popflag      ;


wire            FIFO_m2u_push         ;
wire    [7:0]   FIFO_m2u_din          ;
wire            FIFO_m2u_af           ;
wire            FIFO_m2u_full         ;
wire    [3:0]   FIFO_m2u_pushflag     ;

wire            FIFO_m2u_pop          ;
wire    [7:0]   FIFO_m2u_dout         ;
wire            FIFO_m2u_ae           ;
wire            FIFO_m2u_empty        ;
wire    [3:0]   FIFO_m2u_popflag      ;

wire            Interrupt_o           ;

wire    [15:0]  usb_pid               ;


// Define the Chip Select for each interface
//
assign WBs_CYC_FPGA_Reg   = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == FPGA_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );

assign WBs_CYC_QL_Reserved  = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == QL_RESERVED_BASE_ADDRESS   [APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC  																				);


// Define the Acknowledge back to the host for everything
//
assign WBs_ACK              =    WBs_ACK_FPGA_Reg
                            |    WBs_ACK_QL_Reserved;


// Define the how to read from each IP
//
always @(
         WBs_ADR               or
         WBs_DAT_o_FPGA_Reg  or
         WBs_DAT_o_QL_Reserved or
         WBs_RD_DAT    
        )
 begin
    case(WBs_ADR[APERWIDTH-1:APERSIZE+2])
    FPGA_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT    <=          WBs_DAT_o_FPGA_Reg     ;
    QL_RESERVED_BASE_ADDRESS   [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=          WBs_DAT_o_QL_Reserved  ;
	default:                                             WBs_RD_DAT  <=          DEFAULT_READ_VALUE     ;
	endcase
end


//------Instantiate Modules------------
//

// Define the FPGA I/O Pad Signals
//
// Note: Use the Constraint manager in SpDE to assign these buffers to FBIO pads.
//

bipad u_bipad_I0  ( .A( usb_p_tx ), .EN( usb_tx_en ), .Q( usb_p_rx_int ), .P( usbp_io ) );
bipad u_bipad_I1  ( .A( usb_n_tx ), .EN( usb_tx_en ), .Q( usb_n_rx_int ), .P( usbn_io ) );

assign usb_p_rx = usb_tx_en ? 1'b1 : usb_p_rx_int;
assign usb_n_rx = usb_tx_en ? 1'b0 : usb_n_rx_int;

//assign clk_12mhz = WB_CLK;
assign clk_12mhz = clk_12mhz_i;

// USB-Serial Bridge
usb2m4_serial  u_usb2m4_serial  ( 
    .clk_48mhz          ( clk_48mhz_i ),
    .clk                ( clk_12mhz   ),
    .reset              ( reset_i     ),
    .usb_p_tx           ( usb_p_tx    ),
    .usb_n_tx           ( usb_n_tx    ),
    .usb_p_rx           ( usb_p_rx    ),
    .usb_n_rx           ( usb_n_rx    ),
    .usb_tx_en          ( usb_tx_en   ),

    .FIFO_u2m_push      ( FIFO_u2m_push      ),
    .FIFO_u2m_din       ( FIFO_u2m_din       ),
    .FIFO_u2m_af        ( FIFO_u2m_af        ),
    .FIFO_u2m_full      ( FIFO_u2m_full      ),
    .FIFO_u2m_pushflag  ( FIFO_u2m_pushflag  ),

    .FIFO_m2u_pop       ( FIFO_m2u_pop       ),
    .FIFO_m2u_dout      ( FIFO_m2u_dout      ),
    .FIFO_m2u_ae        ( FIFO_m2u_ae        ),
    .FIFO_m2u_empty     ( FIFO_m2u_empty     ),
    .FIFO_m2u_popflag   ( FIFO_m2u_popflag   ),

    .usb_pid_i          ( usb_pid            )
);


// FIFO to capture serial data from USB to M4
FPGA_FIFO FPGA_FIFO_u2m (
    .Async_Flush    ( reset_i               ),
    .Clk            ( clk_12mhz             ),
    .Clk_En         ( 1'b1                  ),

    // write port
    .Push_Flush     ( 1'b0                  ),
    .Push           ( FIFO_u2m_push         ),
    .Din            ( FIFO_u2m_din          ),
    .Almost_Full    ( FIFO_u2m_af           ),
    .Full           ( FIFO_u2m_full         ),
    .Push_flag      ( FIFO_u2m_pushflag     ),

    // read port
    .Pop_Flush      ( 1'b0                  ),
    .Pop            ( FIFO_u2m_pop          ),
    .Dout           ( FIFO_u2m_dout         ),
    .Almost_Empty   ( FIFO_u2m_ae           ),
    .Empty          ( FIFO_u2m_empty        ),
    .Pop_flag       ( FIFO_u2m_popflag      )
);


// FIFO to capture serial data from M4 to USB
FPGA_FIFO FPGA_FIFO_m2u (
    .Async_Flush    ( reset_i               ),
    .Clk            ( clk_12mhz             ),
    .Clk_En         ( 1'b1                  ),

    // write port
    .Push_Flush     ( 1'b0                  ),
    .Push           ( FIFO_m2u_push         ),
    .Din            ( FIFO_m2u_din          ),
    .Almost_Full    ( FIFO_m2u_af           ),
    .Full           ( FIFO_m2u_full         ),
    .Push_flag      ( FIFO_m2u_pushflag     ),

    // read port
    .Pop_Flush      ( 1'b0                  ),
    .Pop            ( FIFO_m2u_pop          ),
    .Dout           ( FIFO_m2u_dout         ),
    .Almost_Empty   ( FIFO_m2u_ae           ),
    .Empty          ( FIFO_m2u_empty        ),
    .Pop_flag       ( FIFO_m2u_popflag      )
);


// General FPGA Resources 
//
AL4S3B_FPGA_Registers #(

    .ADDRWIDTH                  ( ADDRWIDTH_FAB_REG             ),
    .DATAWIDTH                  ( DATAWIDTH_FAB_REG             ),

    .FPGA_REG_ID_VALUE_ADR    	( FPGA_REG_ID_VALUE_ADR       	),
    .FPGA_REV_NUM_ADR         	( FPGA_REV_NUM_ADR            	),     
    .FPGA_SCRATCH_REG_ADR     	( FPGA_SCRATCH_REG_ADR        	),

    .AL4S3B_DEF_REG_VALUE       ( AL4S3B_DEF_REG_VALUE          )
                                                                )

     u_AL4S3B_FPGA_Registers 
	                           ( 
    // AHB-To_FPGA Bridge I/F
    //
    .WBs_ADR_i                 ( WBs_ADR[ADDRWIDTH_FAB_REG+1:2] ),
    .WBs_CYC_i                 ( WBs_CYC_FPGA_Reg             	),
    .WBs_BYTE_STB_i            ( WBs_BYTE_STB                   ),
    .WBs_WE_i                  ( WBs_WE                         ),
    .WBs_STB_i                 ( WBs_STB                        ),
    .WBs_DAT_i                 ( WBs_WR_DAT                     ),
    .WBs_CLK_i                 ( WB_CLK                         ),
    .WBs_RST_i                 ( WB_RST                         ),
    .WBs_DAT_o                 ( WBs_DAT_o_FPGA_Reg           	),
    .WBs_ACK_o                 ( WBs_ACK_FPGA_Reg             	),

    // USB to M4 FIFO interface
    .FIFO_u2m_pop           ( FIFO_u2m_pop          ),
    .FIFO_u2m_dout          ( FIFO_u2m_dout         ),
    .FIFO_u2m_ae            ( FIFO_u2m_ae           ),
    .FIFO_u2m_empty         ( FIFO_u2m_empty        ),
    .FIFO_u2m_popflag       ( FIFO_u2m_popflag      ),

    // M4 to USB FIFO interface
    .FIFO_m2u_push          ( FIFO_m2u_push         ),
    .FIFO_m2u_din           ( FIFO_m2u_din          ),
    .FIFO_m2u_af            ( FIFO_m2u_af           ),
    .FIFO_m2u_full          ( FIFO_m2u_full         ),
    .FIFO_m2u_pushflag      ( FIFO_m2u_pushflag     ),

    .Interrupt_o            ( Interrupt_o           ),
    .clk_sel_o              ( clk_sel_o             ),
    .usb_pid_o              ( usb_pid               ),

    //
    // Misc
    //
    .Device_ID_o               ( Device_ID_o                     )
   );


// Reserved Resources Block
//
// Note: This block should be used in each QL FPGA design
//
AL4S3B_FPGA_QL_Reserved     #(

    .ADDRWIDTH                 ( ADDRWIDTH_QL_RESERVED          ),
    .DATAWIDTH                 ( DATAWIDTH_QL_RESERVED          ),

    .QL_RESERVED_CUST_PROD_ADR ( QL_RESERVED_CUST_PROD_ADR      ),
    .QL_RESERVED_REVISIONS_ADR ( QL_RESERVED_REVISIONS_ADR      ),

    .QL_RESERVED_CUSTOMER_ID   ( QL_RESERVED_CUSTOMER_ID        ),
    .QL_RESERVED_PRODUCT_ID    ( QL_RESERVED_PRODUCT_ID         ),
    .QL_RESERVED_MAJOR_REV     ( QL_RESERVED_MAJOR_REV          ),
    .QL_RESERVED_MINOR_REV     ( QL_RESERVED_MINOR_REV          ),
    .QL_RESERVED_DEF_REG_VALUE ( QL_RESERVED_DEF_REG_VALUE      ),

    .DEFAULT_CNTR_WIDTH        ( DEFAULT_CNTR_WIDTH             ),
    .DEFAULT_CNTR_TIMEOUT      ( DEFAULT_CNTR_TIMEOUT           )
                                                                )	
                                 u_AL4S3B_FPGA_QL_Reserved
							   (
     // AHB-To_FPGA Bridge I/F
     //
    .WBs_CLK_i                 ( WB_CLK                         ),
    .WBs_RST_i                 ( WB_RST                         ),

    .WBs_ADR_i                 ( WBs_ADR[ADDRWIDTH_FAB_REG+1:2] ),
    .WBs_CYC_QL_Reserved_i     ( WBs_CYC_QL_Reserved            ),
    .WBs_CYC_i                 ( WBs_CYC                        ),
    .WBs_STB_i                 ( WBs_STB                        ),
    .WBs_DAT_o                 ( WBs_DAT_o_QL_Reserved          ),
    .WBs_ACK_i                 ( WBs_ACK                        ),
    .WBs_ACK_o                 ( WBs_ACK_QL_Reserved            )

                                                                );



//pragma attribute u_AL4S3B_FPGA_Registers   preserve_cell true
//pragma attribute u_AL4S3B_FPGA_QL_Reserved preserve_cell true 

//pragma attribute u_bipad_I0                  preserve_cell true
//pragma attribute u_bipad_I1                  preserve_cell true 

endmodule
