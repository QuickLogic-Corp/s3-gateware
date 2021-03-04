
`timescale 1ns / 10ps

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

                // input clock, from the external master
                bitclk_master,

                // local bitclk
                bitclk_local,

                // interrupts to the M4 processor, to speed up or slow down the local clock
                Interrupt_speedup,
                Interrupt_slowdown,

				//I2S signals
				//I2S_CLK_i,        // same as bitclk_master
				I2S_WS_CLK_i,
				I2S_DIN_i,
				
				I2S_RX_Intr_o,
				I2S_DMA_Intr_o,
				I2S_Dis_Intr_o,
				UART_Intr_o,
				
				SDMA_Req_I2S_o,
                SDMA_Sreq_I2S_o,
                SDMA_Done_I2S_i,
                SDMA_Active_I2S_i,

                Device_ID_o,
                
                // debug signals
                master_wordcnt_is_ahead_o,
                local_wordcnt_is_ahead_o
);


//------Port Parameters----------------
//

parameter       APERWIDTH                   = 17            ;
parameter       APERSIZE                    = 10            ;

                                                                // these are byte offsets.
parameter       FPGA_REG_BASE_ADDRESS       = 17'h00000     ; 
parameter       FLL_BASE_ADDRESS            = 17'h01000     ;
parameter       I2S_RAM_REG_BASE_ADDRESS    = 17'h02000     ; 
parameter       I2S_S_REG_BASE_ADDRESS      = 17'h03000     ; 
parameter       FIR_COEFF_REG_BASE_ADDRESS  = 17'h04000     ; 
parameter       QL_RESERVED_BASE_ADDRESS    = 17'h05000     ; 

parameter       ADDRWIDTH_FAB_REG           =  10           ;
parameter       DATAWIDTH_FAB_REG           =  32           ;

                                                                // these are byte offsets
                                                                //  the 2 LSB's (on the right) should be 0's.
parameter       FPGA_REG_ID_VALUE_ADR       = 10'h000       ; 
parameter       FPGA_REV_NUM_ADR            = 10'h004       ; 

parameter       AL4S3B_DEVICE_ID            = 32'hABCD0200  ;
parameter       AL4S3B_REV_LEVEL            = 32'h00000100  ;
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

// AHB-To_FPGA Bridge I/F
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
input           CLK_IP_i;  
input           RST_IP_i; 


output  [31:0]  Device_ID_o;

input           bitclk_master;
input           bitclk_local;

output          Interrupt_speedup;
output          Interrupt_slowdown;

// I2S Slave I/F
//input 			I2S_CLK_i		;
input 			I2S_WS_CLK_i	;
input 			I2S_DIN_i		;

output          I2S_RX_Intr_o   ;				
output          I2S_DMA_Intr_o  ;	
output          I2S_Dis_Intr_o  ;
output          UART_Intr_o      ;

input 			SDMA_Done_I2S_i	;
input 			SDMA_Active_I2S_i;

output          SDMA_Req_I2S_o  ;				
output          SDMA_Sreq_I2S_o ;


// debug signals
output          master_wordcnt_is_ahead_o;
output          local_wordcnt_is_ahead_o;


// FPGA Global Signals
wire            WB_CLK          ;  // Wishbone FPGA Clock
wire            WB_RST          ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
wire    [16:0]  WBs_ADR         ;  // Wishbone Address Bus
wire            WBs_CYC         ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select)
wire     [3:0]  WBs_BYTE_STB    ;  // Wishbone Byte   Enables
wire            WBs_WE          ;  // Wishbone Write  Enable Strobe
wire            WBs_RD          ;  // Wishbone Read   Enable Strobe
wire            WBs_STB         ;  // Wishbone Transfer      Strobe

reg     [31:0]  WBs_RD_DAT      ;  // Wishbone Read   Data Bus
wire    [31:0]  WBs_WR_DAT      ;  // Wishbone Write  Data Bus
wire            WBs_ACK         ;  // Wishbone Client Acknowledge

wire            CLK_IP_i        ;
wire            RST_IP_i        ;


wire            bitclk_master;
wire            bitclk_local;

wire            Interrupt_speedup;
wire            Interrupt_slowdown;


//I2S slave signals
//wire 			I2S_CLK_i		;
wire 			I2S_WS_CLK_i	;
wire 			I2S_DIN_i		;

wire          	I2S_RX_Intr_o   ;				
wire          	I2S_DMA_Intr_o  ;	
wire          	I2S_Dis_Intr_o  ;

wire 			SDMA_Done_I2S_i	;
wire 			SDMA_Active_I2S_i;

wire      	    SDMA_Req_I2S_o  ;				
wire          	SDMA_Sreq_I2S_o ;

wire    [31:0]  Device_ID_o;

// debug signals
wire            master_wordcnt_is_ahead_o;
wire            local_wordcnt_is_ahead_o;


//------Internal Signals---------------

// Wishbone Bus Signals
wire            WBs_CYC_FPGA_Reg        ; 
wire            WBs_CYC_I2S_PREDECI_RAM           ; 
wire            WBs_CYC_I2S_S        ;
wire            WBs_CYC_I2S_SIG        ;
wire            WBs_CYC_FIR_COEFF_RAM        ;
wire            WBs_CYC_QL_Reserved     ;

wire            WBs_ACK_FPGA_Reg        ;
wire            WBs_ACK_FLL             ;
wire            WBs_ACK_IR           ;
wire            WBs_ACK_I2S_S        ; 
wire            WBs_ACK_QL_Reserved     ;

wire    [31:0]  WBs_DAT_o_FPGA_Reg      ; 
wire    [31:0]  WBs_DAT_o_FLL           ;
wire    [31:0]  WBs_DAT_I2S_S        ;
wire    [31:0]  WBs_COEF_RAM_DAT        ;
wire    [31:0]  WBs_DAT_o_QL_Reserved   ;

wire 	[8:0]  			 FIR_DATA_RaDDR_sig;
wire 	[15:0]  		 FIR_RD_DATA_sig;
wire 	 		 		 FIR_ena_sig;

wire   					fir_deci_data_push_sig;  
wire  [15:0]			fir_deci_data_sig; 

wire  [15:0]			fir_dat_mul_sig; 
wire  [15:0]			fir_coef_mul_sig; 
wire  [1:0]				fir_mul_valid_sig; 
wire  [31:0]			fir_cmult_sig;

wire        FIR_DECI_Done_sig;

wire  [8:0]             FIR_RXRAM_w_Addr_sig;
wire                    FIR_I2S_RXRAM_w_ena_sig;

wire  [8:0]  			wb_Coeff_RAM_aDDR_sig;		
wire 					wb_Coeff_RAM_Wen_sig;
wire  [15:0]            wb_Coeff_RAM_Data_sig;

wire 				    i2s_clk_gclk;

wire [15:0] 			wb_Coeff_RAM_rd_Data_sig;
wire 					wb_coeff_RAM_access_ctrl_sig;

wire 					sys_c21_div16_sig;
wire 					i2s_clk_div3_sig;

wire                    i2s_Clock_Stoped_sig;

wire                    sys_ref_clk_i;  // driven by C21 in old design, expected to be 256KHz
                                        // since C21 is now 3MHz, we need to div by 12 to generate this clock


//------Logic Operations---------------


// div by 12 to produce a 256KHz clock
reg                     sys_ref_clk_div12;
reg     [3:0]           sys_ref_clk_cnt;
wire                    sys_ref_clk_div12_gclk;

// 0 1 2 3 4 5 6 7 8 9 A B C D  - input clk cnt @3MHz
// 0 0 0 0 0 0 1 1 1 1 1 1 0 0  - div12 clk @256KHz
always @(posedge bitclk_local or posedge RST_IP_i)
    if (RST_IP_i) begin
        sys_ref_clk_cnt <= 0;
        sys_ref_clk_div12 <= 0;
    end else begin
        if (sys_ref_clk_cnt == 4'hB)
            sys_ref_clk_cnt <= 0;
        else
            sys_ref_clk_cnt <= sys_ref_clk_cnt + 1;

        if (sys_ref_clk_cnt == 4'h5 || sys_ref_clk_cnt == 4'hB)
            sys_ref_clk_div12 <= !sys_ref_clk_div12;
        else
            sys_ref_clk_div12 <= sys_ref_clk_div12;
    end

gclkbuff u_gclkbuff_sys_clk_div12  ( .A(sys_ref_clk_div12) , .Z(sys_ref_clk_div12_gclk) );



// Define the Chip Select for each interface
//  Note: this isn't needed for modules that properly decode the WB addr internally

assign WBs_CYC_FPGA_Reg   = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == FPGA_REG_BASE_ADDRESS[APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );

assign WBs_CYC_I2S_PREDECI_RAM  = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == I2S_RAM_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );							

assign WBs_CYC_I2S_S       		= (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == I2S_S_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );

assign WBs_CYC_FIR_COEFF_RAM    = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == FIR_COEFF_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );	

assign WBs_CYC_QL_Reserved  = (  WBs_ADR[APERWIDTH-1:APERSIZE+2] == QL_RESERVED_BASE_ADDRESS[APERWIDTH-1:APERSIZE+2] ) 
                            & (  WBs_CYC                                                                                );


// Combine the ACK's from each IP module
assign WBs_ACK              =    WBs_ACK_FPGA_Reg | WBs_ACK_FLL
                                    |    WBs_ACK_I2S_S 
                                    |    WBs_ACK_QL_Reserved;


// Multiplex the Read Data from each IP module
always @(*)
 begin
    case(WBs_ADR[APERWIDTH-1:APERSIZE+2])
    FPGA_REG_BASE_ADDRESS    [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DAT_o_FPGA_Reg     ;
    FLL_BASE_ADDRESS         [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DAT_o_FLL          ;
    I2S_S_REG_BASE_ADDRESS     [APERWIDTH-1:APERSIZE+2]		: WBs_RD_DAT  <=    WBs_DAT_I2S_S   ;
    FIR_COEFF_REG_BASE_ADDRESS [APERWIDTH-1:APERSIZE+2]		: WBs_RD_DAT  <=    WBs_COEF_RAM_DAT   ;
    QL_RESERVED_BASE_ADDRESS [APERWIDTH-1:APERSIZE+2]: WBs_RD_DAT  <=    WBs_DAT_o_QL_Reserved  ;
    default:                                           WBs_RD_DAT  <=    DEFAULT_READ_VALUE     ;
    endcase
end


//------Instantiate Modules------------

// General FPGA Resources 

AL4S3B_FPGA_Registers #(
        .ADDRWIDTH                  ( ADDRWIDTH_FAB_REG             ),
        .DATAWIDTH                  ( DATAWIDTH_FAB_REG             ),

        .FPGA_REG_ID_VALUE_ADR      ( FPGA_REG_ID_VALUE_ADR         ),
        .FPGA_REV_NUM_ADR           ( FPGA_REV_NUM_ADR              ),

        .AL4S3B_DEVICE_ID           ( AL4S3B_DEVICE_ID              ),
        .AL4S3B_REV_LEVEL           ( AL4S3B_REV_LEVEL              ),
        .AL4S3B_SCRATCH_REG         ( AL4S3B_SCRATCH_REG            ),

        .AL4S3B_DEF_REG_VALUE       ( AL4S3B_DEF_REG_VALUE          )
                                                                    )
     u_AL4S3B_FPGA_Registers    ( 
        // AHB-To_FPGA Bridge I/F
        .WBs_ADR_i          ( WBs_ADR[ADDRWIDTH_FAB_REG+1:2] ),
        .WBs_CYC_i          ( WBs_CYC_FPGA_Reg               ),
        .WBs_BYTE_STB_i     ( WBs_BYTE_STB                   ),
        .WBs_WE_i           ( WBs_WE                         ),
        .WBs_STB_i          ( WBs_STB                        ),
        .WBs_DAT_i          ( WBs_WR_DAT                     ),
        .WBs_CLK_i          ( WB_CLK                         ),
        .WBs_RST_i          ( WB_RST                         ),
        .WBs_DAT_o          ( WBs_DAT_o_FPGA_Reg             ),
        .WBs_ACK_o          ( WBs_ACK_FPGA_Reg               ), 

        .Device_ID_o        ( Device_ID_o                    )
);


FLL_I2S
    # ( 
        .MODULE_OFFSET      ( FLL_BASE_ADDRESS  )
    )
    FLL_I2S_0 (
        // AHB-To_FPGA Bridge I/F
        .WBs_ADR_i          ( WBs_ADR[16:0]     ),
        .WBs_CYC_i          ( WBs_CYC           ),
        .WBs_BYTE_STB_i     ( WBs_BYTE_STB      ),
        .WBs_WE_i           ( WBs_WE            ),
        .WBs_STB_i          ( WBs_STB           ),
        .WBs_DAT_i          ( WBs_WR_DAT        ),
        .WBs_CLK_i          ( WB_CLK            ),
        .WBs_RST_i          ( WB_RST            ),
        .WBs_DAT_o          ( WBs_DAT_o_FLL     ),
        .WBs_ACK_o          ( WBs_ACK_FLL       ),

        // input clock, from the external master
        .bitclk_master      ( bitclk_master      ),

        // local bitclk
        .bitclk_local       ( bitclk_local       ),

        // interrupts to the M4 processor, to speed up or slow down the local clock
        .Interrupt_speedup  ( Interrupt_speedup  ),
        .Interrupt_slowdown ( Interrupt_slowdown ),
        
        // debug signals
        .master_wordcnt_is_ahead_o  ( master_wordcnt_is_ahead_o ),
        .local_wordcnt_is_ahead_o   ( local_wordcnt_is_ahead_o  )
);

// I2S Slave (RX mode) support with DMA
parameter       ADDRWIDTH_DMA_REG           =  9            ;
parameter       DATAWIDTH_DMA_REG           = 32            ;
i2s_slave_w_DMA
    # (
        .ADDRWIDTH                 ( ADDRWIDTH_DMA_REG              ),
        .DATAWIDTH                 ( DATAWIDTH_DMA_REG              )
	)

    u_I2S_Slave_w_DMA (
        .WBs_CLK_i                 ( WB_CLK                      	),
        .WBs_RST_i                 ( WB_RST                      	),

        //.WBs_ADR_i                 ( WBs_ADR[ADDRWIDTH_DMA_REG+1:2] ),
        .WBs_ADR_i                 ( WBs_ADR[ADDRWIDTH_DMA_REG+2:2] ),// To accommodate the RAM access

        .WBs_CYC_i         		   ( WBs_CYC_I2S_S                  ),
        .WBs_CYC_I2S_PREDECI_RAM_i ( WBs_CYC_I2S_PREDECI_RAM        ),
        .WBs_CYC_FIR_COEFF_RAM_i   ( WBs_CYC_FIR_COEFF_RAM          ),

        .WBs_BYTE_STB_i            ( WBs_BYTE_STB                   ),
        .WBs_WE_i                  ( WBs_WE                       	),
        .WBs_STB_i                 ( WBs_STB                      	),
        .WBs_DAT_i                 ( WBs_WR_DAT                     ),
        .WBs_DAT_o                 ( WBs_DAT_I2S_S                  ),
        .WBs_COEF_RAM_DAT_o        ( WBs_COEF_RAM_DAT               ),
        .WBs_ACK_o                 ( WBs_ACK_I2S_S                  ),
        
        //.sys_ref_clk_i		   ( sys_ref_clk_i ),
        .sys_ref_clk_i		       (sys_ref_clk_div12_gclk          ),

        //.I2S_CLK_i                 ( I2S_CLK_i             			),  
        .I2S_CLK_i                 ( bitclk_master                  ),  
        .I2S_WS_CLK_i              ( I2S_WS_CLK_i              		),
        .I2S_DIN_i           	   ( I2S_DIN_i                      ),

        .I2S_RX_Intr_o             ( I2S_RX_Intr_o                  ), 
        .I2S_DMA_Intr_o            ( I2S_DMA_Intr_o                 ),
        .I2S_Dis_Intr_o            ( I2S_Dis_Intr_o                 ),
        
        //FIR Decimation
        .i2s_clk_o                 (i2s_clk_gclk),
        .FIR_DATA_RaDDR_i		   ( FIR_DATA_RaDDR_sig	),
        .FIR_RD_DATA_o			   ( FIR_RD_DATA_sig	),		
        .FIR_ena_o				   ( FIR_ena_sig   ),
        
        .wb_Coeff_RAM_aDDR_o	   ( wb_Coeff_RAM_aDDR_sig ),		
        .wb_Coeff_RAM_Wen_o		   ( wb_Coeff_RAM_Wen_sig  ),		
        .wb_Coeff_RAM_Data_o	   ( wb_Coeff_RAM_Data_sig ),
        .wb_Coeff_RAM_Data_i       (wb_Coeff_RAM_rd_Data_sig), 
        .wb_Coeff_RAM_rd_access_ctrl_o (wb_coeff_RAM_access_ctrl_sig), 
        
        .FIR_DECI_DATA_i		   ( fir_deci_data_sig	),
        .FIR_DECI_DATA_PUSH_i	   ( fir_deci_data_push_sig	),

        .FIR_I2S_RXRAM_w_Addr_o    ( FIR_RXRAM_w_Addr_sig),
        .FIR_I2S_RXRAM_w_ena_o     ( FIR_I2S_RXRAM_w_ena_sig),
        .i2s_Clock_Stoped_o        (i2s_Clock_Stoped_sig),	
        
        .FIR_DECI_Done_i		   ( FIR_DECI_Done_sig   ),	

        .sys_c21_div16_o           ( sys_c21_div16_sig ),	
        .i2s_clk_div3_o            ( i2s_clk_div3_sig ),	
        //

        .SDMA_Req_I2S_o            ( SDMA_Req_I2S_o                 ), 
        .SDMA_Sreq_I2S_o           ( SDMA_Sreq_I2S_o                ),
        .SDMA_Done_I2S_i           ( SDMA_Done_I2S_i                ),
        .SDMA_Active_I2S_i         ( SDMA_Active_I2S_i              )
    );

deci_filter_fir128coeff u_deci_filter_fir128coeff (
        .fir_clk_i				( WB_CLK  ),
        .fir_reset_i			( WB_RST  ),
        .fir_deci_ena_i			( FIR_ena_sig  ),
        //.fir_filter_run_i		(FIR_FILTER_RUN_M4_CMD_SIG),
        .fir_filter_run_i		(0),
        
        //Coeff RAM Write interface
        .WBs_CLK_i                 ( WB_CLK                      	),
        .WBs_RST_i                 ( WB_RST                      	),

        .I2S_last_ram_write_i	   ( i2s_Clock_Stoped_sig ),
        .I2S_last_ram_addr_i	   ( FIR_RXRAM_w_Addr_sig ),
        .I2S_ram_write_ena_i 	   ( FIR_I2S_RXRAM_w_ena_sig),
        .I2S_clk_i 	   			   ( i2s_clk_gclk),//( I2S_CLK_i),
                                
       //Data Ram interface.  
        .fir_dat_addr_o			( FIR_DATA_RaDDR_sig  ),		
        .fir_indata_rd_en_o		(   ),//RAM Block's read enable in I2S_slave_Rx_FIFO is always asserted.
        .fir_data_i				( FIR_RD_DATA_sig  ),
        
        .wb_Coeff_RAM_aDDR_i	( wb_Coeff_RAM_aDDR_sig ),		
        .wb_Coeff_RAM_Wen_i		( wb_Coeff_RAM_Wen_sig  ),		
        .wb_Coeff_RAM_Data_i	( wb_Coeff_RAM_Data_sig ),
        .wb_Coeff_RAM_Data_o    (wb_Coeff_RAM_rd_Data_sig),   
        .wb_Coeff_RAM_rd_access_ctrl_i (wb_coeff_RAM_access_ctrl_sig), 
                              
        //16*16 mult            
        .fir_dat_mul_o			( fir_dat_mul_sig  	),
        .fir_coef_mul_o			( fir_coef_mul_sig  ),
        .fir_mul_valid_o		( fir_mul_valid_sig  ),
        .fir_cmult_i			( fir_cmult_sig  	),
                                
        .fir_deci_data_o		( fir_deci_data_sig  ),
        .fir_deci_data_push_o   ( fir_deci_data_push_sig  ),
        .fir_deci_done_o        ( FIR_DECI_Done_sig )
);


qlal4s3_mult_16x16_cell u_qlal4s3_mult_16x16_cell ( 
        .Amult			(fir_dat_mul_sig), 
        .Bmult			(fir_coef_mul_sig), 
        .Valid_mult		(fir_mul_valid_sig),
        //.sel_mul_32x32  (1'b0),							
        .Cmult			(fir_cmult_sig)
);



// Reserved Resources Block

// Note: This block should be used in each QL FPGA design

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

