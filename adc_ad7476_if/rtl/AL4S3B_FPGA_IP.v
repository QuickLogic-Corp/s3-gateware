`timescale 1ns / 10ps
//`define USE_DEBUG_PORT
module AL4S3B_FPGA_IP ( 

                // AHB-To_FPGA Bridge I/F
                //
				CLK_IP_i,
				RST_IP_i,
				
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
				
				// DMA signals
				DMA_Active_i,  
				DMA_Done_i,	   
				DMA_Req_o,	   
				INTR_o,	

				CSn_o,
				SCLK_o,
				SDATA_i, 
				
`ifdef USE_DEBUG_PORT
				spi_ss_i,  
				spi_sck_i, 
				spi_miso_o,
`endif				
				Device_ID_o
                );


//------Port Parameters----------------
//

parameter       APERWIDTH                   = 17            ;
parameter       APERSIZE                    = 10            ;

                                                                // these are byte offsets.
parameter       FPGA_REG_BASE_ADDRESS     	= 17'h00000     ; // Assumes 128K Byte FPGA Memory Aperture
parameter       DMA_REG_BASE_ADDR           = 17'h10000     ;
parameter       DMA0_DPORT_BASE_ADDR        = 17'h11000     ;
parameter       QL_RESERVED_BASE_ADDRESS    = 17'h12000     ; // Assumes 128K Byte FPGA Memory Aperture

parameter       ADDRWIDTH_FAB_REG           =  10           ;
parameter       DATAWIDTH_FAB_REG           =  32           ;

                                                                // these are byte offsets
                                                                //  the 2 LSB's (on the right) should be 0's.
parameter       FPGA_REG_ID_VALUE_ADR       = 10'h000       ; 
parameter       FPGA_REV_NUM_ADR            = 10'h004       ; 
parameter       FPGA_FIFO_RST_ADR           = 10'h008       ; 
parameter       FPGA_SENSOR_EN_REG_ADR      = 10'h00C       ; 
parameter       FPGA_FIFO_OVERRUN_ADR       = 10'h010       ; 

parameter       FPGA_DBG1_REG_ADR           = 10'h030       ; 
parameter       FPGA_DBG2_REG_ADR           = 10'h034       ;
parameter       FPGA_DBG3_REG_ADR           = 10'h038       ;

parameter       DMA_EN_REG_ADR              = 10'h000       ;
parameter       DMA_STS_REG_ADR             = 10'h004       ;
parameter       DMA_INTR_EN_REG_ADR         = 10'h008       ;

parameter       AL4S3B_DEVICE_ID            = 16'h0         ;
parameter       AL4S3B_REV_LEVEL            = 32'h0         ;
parameter       AL4S3B_SCRATCH_REG          = 32'h12345678  ;

parameter       AL4S3B_DEF_REG_VALUE        = 32'hFAB_DEF_AC; // Distinguish access to undefined area

parameter       DEFAULT_READ_VALUE          = 32'hBAD_FAB_AC; // Bad FPGA Access
parameter       DEFAULT_CNTR_WIDTH          =  3            ;
parameter       DEFAULT_CNTR_TIMEOUT        =  7            ;

parameter       ADDRWIDTH_QL_RESERVED       = 10            ;
parameter       DATAWIDTH_QL_RESERVED       = 32            ;

parameter       QL_RESERVED_CUST_PROD_ADR   = 10'h1F8       ;
parameter       QL_RESERVED_REVISIONS_ADR   = 10'h1FC       ;

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

// Misc
//
input                	CLK_IP_i;  
input          			RST_IP_i; 
output 					CSn_o;
output 					SCLK_o;
input 					SDATA_i;

input 					DMA_Active_i;
input 					DMA_Done_i;
output 					DMA_Req_o;
output 					INTR_o;

output    [31:0]  		Device_ID_o;

`ifdef USE_DEBUG_PORT
input					spi_ss_i  ;
input					spi_sck_i ;
inout					spi_miso_o;
`endif

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

wire           	CLK_IP_i		 ;  
wire           	RST_IP_i		 ; 


wire			CSn_o;
wire 			SCLK_o;
wire 			SDATA_i;

wire			DMA_Active_i; 
wire			DMA_Done_i;
wire 			DMA_Req_o;
wire 			INTR_o;   

wire 			DMA0_Start; 
wire 			DMA0_Clr;  

wire            Sensor_Enable;

wire    [31:0]  Sensor_RD_Data;
wire 			Sensor_RD_Push;

wire 		    spi_start; 
wire 		    spi_rden;
wire 		    rx_fifo_full; 

wire 		    spi_clk; 

wire 			DMA_Enable;

wire    [31:0]  Device_ID_o;

wire 	[1:0]	fsm_top_st; 
wire 	[1:0]	spi_fsm_st;

wire			dbg_reset;

`ifdef USE_DEBUG_PORT
wire			spi_ss_i  ;
wire			spi_sck_i ;
wire			spi_miso_o;
`endif
//------Define Parameters--------------
//

// Default I/O timeout statemachine
//
parameter       DEFAULT_IDLE   =  0  ;
parameter       DEFAULT_COUNT  =  1  ;


//------Internal Signals---------------
//


// Wishbone Bus Signals
//
wire            WBs_CYC_FPGA_Reg   ; 
wire            WBs_CYC_DMA_Reg    ;
wire            WBs_CYC_DMA_Data   ;
wire            WBs_CYC_QL_Reserved  ;

wire            WBs_ACK_FPGA_Reg   ;
wire            WBs_ACK_QL_Reserved  ;

wire    [31:0]  WBs_DAT_o_FPGA_Reg ; 
wire    [31:0]  WBs_DMA_REG_DAT    ; 
wire    [31:0]  WBs_DMA_FIFO_DAT   ;
wire    [31:0]  WBs_DAT_o_QL_Reserved;

//------Logic Operations---------------
//
// Define the Chip Select for each interface
//
assign WBs_CYC_FPGA_Reg   = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == FPGA_REG_BASE_ADDRESS[APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );
							
assign WBs_CYC_DMA_Reg    = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] 	== DMA_REG_BASE_ADDR[APERWIDTH-1:APERSIZE+2] ) 
                                & (  WBs_CYC                                                                            );
								
assign WBs_CYC_DMA_Data   = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] 	== DMA0_DPORT_BASE_ADDR[APERWIDTH-1:APERSIZE+2] )	
                                & (  WBs_CYC                                                                            );
								
assign WBs_CYC_QL_Reserved  = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == QL_RESERVED_BASE_ADDRESS[APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC  																				);


// Define the Acknowledge back to the host for everything
//
assign WBs_ACK              =    WBs_ACK_FPGA_Reg | WBs_ACK_QL_Reserved;


// Define the how to read from each IP
//
always @(
         WBs_ADR               or
         WBs_DAT_o_FPGA_Reg    or
		 WBs_DMA_REG_DAT       or
		 WBs_DMA_FIFO_DAT      or
         WBs_DAT_o_QL_Reserved or
         WBs_RD_DAT    
        )
 begin
    case(WBs_ADR[APERWIDTH-1:APERSIZE+2])
    FPGA_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DAT_o_FPGA_Reg   	;
	DMA_REG_BASE_ADDR        [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DMA_REG_DAT   		;
	DMA0_DPORT_BASE_ADDR     [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DMA_FIFO_DAT  		;
    QL_RESERVED_BASE_ADDRESS [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DAT_o_QL_Reserved  ;
	default:                                           WBs_RD_DAT  <=    DEFAULT_READ_VALUE     ;
	endcase
end
//------Instantiate Modules------------
//
// Define the FPGA I/O Pad Signals
//
// Note: Use the Constraint manager in SpDE to assign these buffers to FBIO pads.
//
// General FPGA Resources 
//
AL4S3B_FPGA_Registers #(

    .ADDRWIDTH                  ( ADDRWIDTH_FAB_REG             ),
    .DATAWIDTH                  ( DATAWIDTH_FAB_REG             ),

    .FPGA_REG_ID_VALUE_ADR   	( FPGA_REG_ID_VALUE_ADR     	),
    .FPGA_REV_NUM_ADR   		( FPGA_REV_NUM_ADR    			),
	.FPGA_FIFO_RST_ADR   		( FPGA_FIFO_RST_ADR     		),
	.FPGA_SENSOR_EN_REG_ADR   	( FPGA_SENSOR_EN_REG_ADR    	),
	.FPGA_FIFO_OVERRUN_ADR   	( FPGA_FIFO_OVERRUN_ADR     	),
	
	.FPGA_DBG1_REG_ADR   		( FPGA_DBG1_REG_ADR   			),
	.FPGA_DBG2_REG_ADR   		( FPGA_DBG2_REG_ADR   			),
	.FPGA_DBG3_REG_ADR   		( FPGA_DBG3_REG_ADR   			),
	
	.DMA_EN_REG_ADR   			( DMA_EN_REG_ADR     			),
	.DMA_STS_REG_ADR   			( DMA_STS_REG_ADR     			),
	.DMA_INTR_EN_REG_ADR     	( DMA_INTR_EN_REG_ADR	    	),

    .AL4S3B_DEVICE_ID           ( AL4S3B_DEVICE_ID              ),
    .AL4S3B_REV_LEVEL           ( AL4S3B_REV_LEVEL              ),
    .AL4S3B_SCRATCH_REG         ( AL4S3B_SCRATCH_REG            ),

    .AL4S3B_DEF_REG_VALUE       ( AL4S3B_DEF_REG_VALUE          )
                                                                )

     u_AL4S3B_FPGA_Registers 
	                           ( 
    // AHB-To_FPGA Bridge I/F
    //
    .WBs_ADR_i                 ( WBs_ADR[ADDRWIDTH_FAB_REG+1:2] ),
    .WBs_CYC_i                 ( WBs_CYC_FPGA_Reg               ),
	.WBs_CYC_DMA_REG_i         ( WBs_CYC_DMA_Reg                ), 
	.WBs_CYC_DMA_DAT_i         ( WBs_CYC_DMA_Data               ),
    .WBs_BYTE_STB_i            ( WBs_BYTE_STB                   ),
    .WBs_WE_i                  ( WBs_WE                         ),
    .WBs_STB_i                 ( WBs_STB                        ),
    .WBs_DAT_i                 ( WBs_WR_DAT                     ),
    .WBs_CLK_i                 ( WB_CLK                         ),
    .WBs_RST_i                 ( WB_RST                         ),
    .WBs_DAT_o                 ( WBs_DAT_o_FPGA_Reg           	),
    .WBs_ACK_o                 ( WBs_ACK_FPGA_Reg             	), 
	
	.WBs_DMA_REG_o             ( WBs_DMA_REG_DAT 				),
	.WBs_DMA_DAT_o             ( WBs_DMA_FIFO_DAT 				),

    //
    // Sensor settings
	.Sensor_Enable_o           ( Sensor_Enable	             	),  
	
	.SPI_clk_i                 ( spi_clk                        ),
	.Sensor_RD_Data_i          ( Sensor_RD_Data             	), 
	.Sensor_RD_Push_i          ( Sensor_RD_Push             	), 
	.rx_fifo_full_o            ( rx_fifo_full                   ),
	
    //DMA
	.DMA0_Clr_i                ( DMA0_Clr 	 					),
	.DMA0_Done_i               ( DMA_Done_i     				),
	.DMA0_Start_o              ( DMA0_Start  					),
	.DMA_Active_i			   ( DMA_Active_i       		    ), 
	.DMA_REQ_i				   ( DMA_Req_o           		    ),
	.DMA_Enable_o			   ( DMA_Enable						),
							
	.DMA0_Done_IRQ_o           ( INTR_o             			),  
	
	.dbg_reset_o           	   ( dbg_reset             			), 
	
	.fsm_top_st_i              ( fsm_top_st			            ), 
	.spi_fsm_st_i              ( spi_fsm_st			            ),
    .Device_ID_o               ( Device_ID_o                    )

    );
	
	 
Dma_Ctrl u_Dma_Ctrl
	( 
	.clk_i					   ( WB_CLK     					),
	.rst_i					   ( WB_RST     					),
	
	.trig_i	            	   ( DMA0_Start						),    
	
	.DMA_Active_i			   ( DMA_Active_i       			),	
	.ASSP_DMA_Done_i		   ( DMA_Done_i    	    			),					
	.DMA_Done_o				   (  								),		
	.DMA_Clr_o				   ( DMA0_Clr						),	
	.DMA_Enable_i			   ( DMA_Enable 					),
	.DMA_REQ_o				   ( DMA_Req_o         			    )	  	 				
     );

Fsm_Top     u_Fsm_Top
					(
     //
	.clk_i                     ( WB_CLK	                         ),  
    .rst_i                     ( WB_RST                          ),
	
    .sensor_enable_i   		   ( Sensor_Enable         		 	 ),
	
	.fsm_top_st_o              ( fsm_top_st			             ),

    .spi_start_o               ( spi_start          			 ),
	.spi_rden_o                ( spi_rden          				 ),
	.spi_tfer_done_i           ( spi_tfer_done         			 )
    );	
	
Serializer_Deserializer     u_Serializer_Deserializer
					(
     //
	.clk_i                     ( WB_CLK                         ),  
    .rst_i                     ( WB_RST                         ),

    .spi_start_i               ( spi_start						),
	.spi_rden_i                ( spi_rden          				),
	.spi_tfer_done_o           ( spi_tfer_done					),
	
    .spi_ss_o        		   ( CSn_o               		 	),
    .spi_sck_o                 ( SCLK_o			                ), 
    .spi_mosi_o                (    			                ),
	.spi_miso_i         	   ( SDATA_i		                ), 
	
	.spi_fsm_st_o         	   ( spi_fsm_st		                ),
	
	.spi_clk_o         	       ( spi_clk    	                ),
	
	.rx_fifo_full_i            ( rx_fifo_full                   ),
    .Sensor_RD_Data_o          ( Sensor_RD_Data             	), 
	.Sensor_RD_Push_o          ( Sensor_RD_Push             	)
    );	

`ifdef USE_DEBUG_PORT	
Serializer_Deserializer_Test     u_Serializer_Deserializer_Test
					(
	.clk_i                     ( WB_CLK                         ),  
    .rst_i                     ( dbg_reset                      ),


    .count_up_i                ( spi_tfer_done					),
	
    .spi_ss_i        		   ( spi_ss_i              		 	),
    .spi_sck_i                 ( spi_sck_i		                ), 
    .spi_miso_o                ( spi_miso_o		                )
    );	
`endif
	
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

endmodule
