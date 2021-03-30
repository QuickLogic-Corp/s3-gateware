/* ----------------------------------------------------------------------------

---------------------------------------------------------------------------- */

module decimation_filter_3to1 (

    WBs_CLK_i                   ,
    WBs_RST_i                   ,
    
    WBs_ADR_i                   ,
    
    WBs_CYC_i                   ,
    WBs_CYC_FIR_COEFF_RAM_i     ,
    
    WBs_BYTE_STB_i              ,
    WBs_WE_i                    ,
    WBs_STB_i                   ,
    WBs_DAT_i                   ,
    WBs_DAT_o                   ,
    WBs_COEF_RAM_DAT_o          ,
    
    WBs_ACK_o                   ,
    
    Deci_Filter_Intr_o          ,
    Deci_Filter_DMA_Intr_o      ,
    
    I2S_S_EN_i                  ,
    FIR_RXRAM_w_Addr_i          ,
    FIR_I2S_RXRAM_w_ena_i       ,
    i2s_clk_gclk_i              ,
    
    FIR_DATA_RaDDR_o            ,
    FIR_RD_DATA_i               ,
    
    i2s_Clock_Stoped_i          ,
    
    SDMA_Req_deci_filter_o      ,
    SDMA_Sreq_deci_filter_o     ,
    SDMA_Active_deci_filter_i
    
    
);

//------Port Parameters----------------
//

parameter                ADDRWIDTH                   =   9           ;
parameter                DATAWIDTH                   =  32           ;

parameter                I2S_EN_REG_ADR          	 =  10'h0         ;
parameter                ACSLIP_REG_RST_ADR          =  10'h1         ;
parameter                INTR_STS_REG_ADR          	 =  10'h2         ;
parameter                INTR_EN_REG_ADR          	 =  10'h3         ;
parameter                DECI_FIFO_STS_REG_ADR       =  10'h4         ;
parameter                DECI_FIFO_DATA_REG_ADR		 =  10'h5         ;
parameter                ACSLIP_REG_ADR              =  10'h6         ;
parameter                DECI_FIFO_RST_ADR           =  10'h7         ;
parameter                DMA_EN_REG_ADR              =  10'h8         ;
parameter                DMA_STS_REG_ADR             =  10'h9         ;
parameter                DMA_CNT_REG_ADR             =  10'hA         ;
parameter                ACSLIP_TIMER_REG_ADR            =  10'hB         ;
parameter                FIR_DECI_CNTRL_REG_ADR      =  10'hC         ;
parameter                RESERVED_2             =  10'hD         ;
parameter                FIR_PREDECI_RAM_STRT_ADDR1  =  10'h200       ;
parameter                FIR_PREDECI_RAM_STRT_ADDR2  =  10'h000       ;
parameter                FIR_COEFF_RAM_ADDR1         =  10'h200       ;
parameter                RESERVED_3                  =  10'hB         ;

parameter                DMA_DEF_REG_VALUE           = 32'hDAD_DEF_AC; // Distinguish access to undefined area

parameter                ACSLIP_REG_WIDTH            = 32;


// Fabric Global Signals
//
input                    WBs_CLK_i           ; // Fabric Clock               from Fabric
input                    WBs_RST_i           ; // Fabric Reset               to   Fabric


// Wishbone Bus Signals
//
//input   [ADDRWIDTH-1:0]  WBs_ADR_i           ; // Address Bus                to   Fabric
input   [ADDRWIDTH:0]   WBs_ADR_i           ; // Address Bus                to   Fabric

input                    WBs_CYC_i   ; // Cycle Chip Select          to   Fabric
input                    WBs_CYC_FIR_COEFF_RAM_i      ; // Cycle Chip Select          to   Fabric    

input             [3:0]  WBs_BYTE_STB_i      ; // Byte Enable Strobes        to   Fabric
input                    WBs_WE_i            ; // Write Enable               to   Fabric
input                    WBs_STB_i           ; // Strobe Signal              to   Fabric
input   [DATAWIDTH-1:0]  WBs_DAT_i           ; // Write Data Bus             to   Fabric
output  [DATAWIDTH-1:0]  WBs_DAT_o ;
output  [DATAWIDTH-1:0]  WBs_COEF_RAM_DAT_o ;

output                   WBs_ACK_o           ; // Transfer Cycle Acknowledge from Fabric

output                  Deci_Filter_Intr_o;
output                  Deci_Filter_DMA_Intr_o;


input                   I2S_S_EN_i;

input   [8:0]           FIR_RXRAM_w_Addr_i;
input                   FIR_I2S_RXRAM_w_ena_i;
input                   i2s_clk_gclk_i;


output  [8:0]           FIR_DATA_RaDDR_o;
input   [15:0]          FIR_RD_DATA_i;

input                   i2s_Clock_Stoped_i;

output                  SDMA_Req_deci_filter_o;
output                  SDMA_Sreq_deci_filter_o;
input                   SDMA_Active_deci_filter_i;





// port types
wire   [ADDRWIDTH:0]   WBs_ADR_i           ; // Address Bus                to   Fabric

wire                    WBs_CYC_i   ; // Cycle Chip Select          to   Fabric
wire                    WBs_CYC_FIR_COEFF_RAM_i      ; // Cycle Chip Select          to   Fabric    

wire             [3:0]  WBs_BYTE_STB_i      ; // Byte Enable Strobes        to   Fabric
wire                    WBs_WE_i            ; // Write Enable               to   Fabric
wire                    WBs_STB_i           ; // Strobe Signal              to   Fabric
wire   [DATAWIDTH-1:0]  WBs_DAT_i           ; // Write Data Bus             to   Fabric
wire  [DATAWIDTH-1:0]  WBs_DAT_o ;
wire  [DATAWIDTH-1:0]  WBs_COEF_RAM_DAT_o ;

wire                   WBs_ACK_o           ; // Transfer Cycle Acknowledge from Fabric

wire                  Deci_Filter_Intr_o;
wire                  Deci_Filter_DMA_Intr_o;

wire                    I2S_S_EN_i;

wire    [8:0]           FIR_RXRAM_w_Addr_i;
wire                    FIR_I2S_RXRAM_w_ena_i;
wire                    i2s_clk_gclk_i;


wire    [8:0]           FIR_DATA_RaDDR_o;
wire    [15:0]          FIR_RD_DATA_i;

wire                    i2s_Clock_Stoped_i;

wire                    SDMA_Req_deci_filter_o;
wire                    SDMA_Sreq_deci_filter_o;
wire                    SDMA_Active_deci_filter_i;




// internal signals
wire    [15:0]  fir_dat_mul_sig;
wire    [15:0]  fir_coef_mul_sig;
wire    [1:0]   fir_mul_valid_sig;
wire    [31:0]  fir_cmult_sig;


wire            DeciData_Rx_FIFO_Flush;
wire    [15:0]  fir_deci_data_sig  ;
wire            fir_deci_data_push_sig;
wire            DeciData_RXFIFO_Pop;
wire    [3:0]   DeciData_Rx_FIFO_pop_flag_sig ;
wire    [15:0]  L_DeciData_RXFIFO_DAT;

wire            DMA_Clr;
wire            DMA_Req;
wire            DMA_Done;
wire            DMA_Active;
wire    [8:0]   DMA_CNT; 

wire    [8:0]   dma_cntr;
wire    [1:0]   dma_st;
wire            DMA_Busy;

wire            FIR_ena_sig;

wire    [8:0]   wb_Coeff_RAM_aDDR_sig;
wire            wb_Coeff_RAM_Wen_sig;
wire    [15:0]  wb_Coeff_RAM_Data_sig;
wire    [15:0]  wb_Coeff_RAM_rd_Data_sig;
wire            wb_coeff_RAM_access_ctrl_sig;

wire            FIR_DECI_Done_sig;

reg     [8:0]   DeciData_Rx_FIFO_Level;
reg     [8:0]   DeciData_Rx_FIFO_Level_nxt;

wire            Deci_Done_IRQ_EN_sig;
wire            Deci_Done_IRQ_sig;
wire            DeciData_Rx_DAT_AVL_IRQ_EN_sig;
wire            DeciData_Rx_DAT_AVL_IRQ_sig;

wire            DMA_Done_IRQ_EN;
wire            DMA_Done_IRQ;


deci_filter_registers             

    // parameters
    #(
    .ADDRWIDTH                          ( ADDRWIDTH                       ),
    .DATAWIDTH                          ( DATAWIDTH                       ),

    .I2S_EN_REG_ADR  					( I2S_EN_REG_ADR             ),            
    .ACSLIP_REG_RST_ADR                 ( ACSLIP_REG_RST_ADR         ),
    .INTR_STS_REG_ADR                   ( INTR_STS_REG_ADR           ),
    .INTR_EN_REG_ADR                    ( INTR_EN_REG_ADR            ),
    .DECI_FIFO_STS_REG_ADR 				( DECI_FIFO_STS_REG_ADR       ), 
    .DECI_FIFO_DATA_REG_ADR		    	( DECI_FIFO_DATA_REG_ADR	  ),
    .ACSLIP_REG_ADR                 	( ACSLIP_REG_ADR              ),
    .DECI_FIFO_RST_ADR              	( DECI_FIFO_RST_ADR           ),
    .DMA_EN_REG_ADR                 	( DMA_EN_REG_ADR              ),
    .DMA_STS_REG_ADR                	( DMA_STS_REG_ADR             ),
    .DMA_CNT_REG_ADR                	( DMA_CNT_REG_ADR             ),
    .ACSLIP_TIMER_REG_ADR                   ( ACSLIP_TIMER_REG_ADR                  ),
    .FIR_DECI_CNTRL_REG_ADR         	( FIR_DECI_CNTRL_REG_ADR      ),
    .RESERVED_2                	( RESERVED_2             ),
    .FIR_PREDECI_RAM_STRT_ADDR1     	( FIR_PREDECI_RAM_STRT_ADDR1  ),
    .FIR_PREDECI_RAM_STRT_ADDR2     	( FIR_PREDECI_RAM_STRT_ADDR2  ),
    .FIR_COEFF_RAM_ADDR1            	( FIR_COEFF_RAM_ADDR1         ),
    .RESERVED_3                     	( RESERVED_3                  ),
    
    .ACSLIP_REG_WIDTH					(ACSLIP_REG_WIDTH),
    
    .DMA_DEF_REG_VALUE                  ( DMA_DEF_REG_VALUE               )
                                                                          )
    // instance name
        u_i2s_slave_w_DMA_registers 
    // ports
                                        ( 
    .WBs_CLK_i                          ( WBs_CLK_i                       ),//
    .WBs_RST_i                          ( WBs_RST_i                       ),//
    
    //.sys_ref_clk_i					    (sys_ref_clk_16khz_sig),
    .sys_ref_clk_i					    (0),    // unused

    //.WBs_ADR_i                          ( WBs_ADR_i[ADDRWIDTH-1:0]        ),//
    .WBs_ADR_i                          ( WBs_ADR_i[ADDRWIDTH:0]        ),//
    .WBs_CYC_i                          ( WBs_CYC_i                     ),//

    //.WBs_CYC_I2S_PREDECI_RAM_i 			( WBs_CYC_I2S_PREDECI_RAM_i   ),
    .WBs_CYC_I2S_PREDECI_RAM_i 			( 0   ),    // unused

    .WBs_CYC_FIR_COEFF_RAM_i            ( WBs_CYC_FIR_COEFF_RAM_i     ),
    
    .WBs_BYTE_STB_i                     ( WBs_BYTE_STB_i[2:0]             ),//
    .WBs_WE_i                           ( WBs_WE_i                        ),//
    .WBs_STB_i                          ( WBs_STB_i                       ),//
    .WBs_DAT_i                          ( WBs_DAT_i                       ),//
    .WBs_DAT_o                          ( WBs_DAT_o                     ),//
    .WBs_COEF_RAM_DAT_o					(WBs_COEF_RAM_DAT_o),
    .WBs_ACK_o                          ( WBs_ACK_o                     ),//
    
    //.i2s_dis_i                       	( i2s_dis                         ),
    .i2s_dis_i                       	( 0                         ),  // unused

    .I2S_S_EN_o                       	(                                   ),        // use the one from the I2S RX module
    .ACSLIP_EN_o                       	(                           ),
    
    .ACSLIP_Reg_Rst_o                   (                       ),//Add Logic
    .ACLSIP_Reg_i                   	( 0                 ),//Add Logic
    
`ifdef AEC_1_0	 						
    //.cnt_mic_dat_i 						( cnt_mic_dat_sig    ),
    .cnt_mic_dat_i 						( 0    ),
    //.cnt_i2s_dat_i 						( cnt_i2s_dat_sig    ),
    .cnt_i2s_dat_i 						( 0    ),
`endif		
    
    
    
    .wb_FIR_L_PreDeci_RAM_aDDR_o		( ),    // unused
    .wb_FIR_L_PreDeci_RAM_Wen_o			( ),	// unused
    .wb_FIR_L_PreDeci_RAM_wrMASTER_CTRL_o	( ),    // unused
    
    .wb_Coeff_RAM_aDDR_o				( wb_Coeff_RAM_aDDR_sig ),
    .wb_Coeff_RAM_Wen_o					( wb_Coeff_RAM_Wen_sig  ),
    .wb_Coeff_RAM_Data_o				( wb_Coeff_RAM_Data_sig ),
    .wb_Coeff_RAM_Data_i				( wb_Coeff_RAM_rd_Data_sig ),
    .wb_Coeff_RAM_rd_access_ctrl_o      ( wb_coeff_RAM_access_ctrl_sig ),
    
    //FIR decimator	
    .FIR_DECI_Done_i                    ( FIR_DECI_Done_sig ),
    .FIR_ena_o                          ( FIR_ena_sig  ),
    
    .DeciData_Rx_FIFO_Flush_o           ( DeciData_Rx_FIFO_Flush         ),
    
    //.DeciData_Rx_FIFO_Pop_o             ( DeciData_RXFIFO_Pop_sig        ),//DMA
    .DeciData_Rx_FIFO_Pop_o             ( DeciData_RXFIFO_Pop  ),//DMA

    //.DeciData_Rx_FIFO_DAT_i             ( DeciData_RXFIFO_DAT_sig        ),
    .DeciData_Rx_FIFO_DAT_i             ( L_DeciData_RXFIFO_DAT         ),

    .DeciData_Rx_FIFO_Full_i            ( DeciData_Rx_FIFO_Full          ),
    .DeciData_Rx_FIFO_Empty_i           ( DeciData_Rx_FIFO_Empty         ),
    .DeciData_Rx_FIFO_Level_i           ( DeciData_Rx_FIFO_Level ),
    .DeciData_Rx_FIFO_Empty_flag_i      ( 0         ),  // unused

    .Deci_Done_IRQ_EN_o					( Deci_Done_IRQ_EN_sig			 ),   
    .Deci_Done_IRQ_o					( Deci_Done_IRQ_sig				 ),			
    .DeciData_Rx_DAT_AVL_IRQ_EN_o		( DeciData_Rx_DAT_AVL_IRQ_EN_sig ),   
    .DeciData_Rx_FIFO_DAT_IRQ_o			( DeciData_Rx_DAT_AVL_IRQ_sig   ),//L_RX_DAT_IRQ_o_
    
    .ACSLIP_timer_IRQ_EN_o				( ),
    .ACSLIP_timer_IRQ_o					( ),
    
    .DMA_Busy_i                         ( DMA_Busy                        ),//
    .DMA_Clr_i                          ( DMA_Clr                         ),//
    .DMA_Done_i                         ( DMA_Done                        ),//
    .DMA_Active_i                       ( DMA_Active            		  ),//
    .DMA_REQ_i                          ( DMA_Req            		  ),//
    .dma_cntr_i                       	( dma_cntr                        ),
    .dma_st_i                           ( dma_st                          ),
    
    .I2S_Dis_IRQ_o                      ( ),//
    .I2S_Dis_IRQ_EN_o                   ( ),// 	

    .I2S_Con_IRQ_o                      ( ),//
    .I2S_Con_IRQ_EN_o                   ( ),// 	
    
    .DMA_CNT_o                          ( DMA_CNT                		  ),//
    .DMA_Start_o                       	( DMA_Start                       ),//
    .DMA_Done_IRQ_o                     ( DMA_Done_IRQ                    ),//
    .DMA_Done_IRQ_EN_o                  ( DMA_Done_IRQ_EN                 )


    //.L_RX_DAT_IRQ_o                     ( L_RX_DAT_IRQ                    ),// 
    //.L_RX_DAT_IRQ_EN_o                  ( L_RX_DAT_IRQ_EN                 ),// 
    //.R_RX_DAT_IRQ_o                     ( R_RX_DAT_IRQ                    ),//
    //.R_RX_DAT_IRQ_EN_o                  ( R_RX_DAT_IRQ_EN                 ),// 	
    //.L_RXFIFO_DAT_i                     ( L_RXFIFO_DATOUT                 ),
    //.L_RXFIFO_Pop_o                     ( L_RXFIFO_Pop                    ),
    //.R_RXFIFO_DAT_i                     ( R_RXFIFO_DATOUT                 ),
    //.R_RXFIFO_Pop_o                     ( R_RXFIFO_Pop                    ),	
    //.STEREO_EN_o                        ( STEREO_EN                       ),
    //.LR_CHNL_SEL_o                      ( LR_CHNL_SEL                     ),
    //.L_Rx_FIFO_Empty_i                  ( DeciData_Rx_FIFO_Empty                 ),
    //.L_Rx_FIFO_Full_i                   ( L_Rx_FIFO_Full                  ),
    //.L_Rx_FIFO_Level_i                  ( L_Rx_FIFO_Level                 ),
    //.R_Rx_FIFO_Empty_i                  ( R_Rx_FIFO_Empty                 ),
    //.R_Rx_FIFO_Full_i                   ( R_Rx_FIFO_Full                  ),
    //.R_Rx_FIFO_Level_i                  ( R_Rx_FIFO_Level                 ),	
    
    );
            

assign Deci_Filter_Intr_o  = 	(Deci_Done_IRQ_EN_sig 			& Deci_Done_IRQ_sig) 			| 
                                (DeciData_Rx_DAT_AVL_IRQ_EN_sig & DeciData_Rx_DAT_AVL_IRQ_sig);

assign Deci_Filter_DMA_Intr_o = (DMA_Done_IRQ_EN)? DMA_Done_IRQ: 1'b0; 


deci_filter_fir128coeff u_deci_filter_fir128coeff (
        .fir_clk_i				( WBs_CLK_i           ),
        .fir_reset_i			( WBs_RST_i           ),
        .fir_deci_ena_i			( FIR_ena_sig  ),
        //.fir_filter_run_i		(FIR_FILTER_RUN_M4_CMD_SIG),
        .fir_filter_run_i		(0),
        
        //Coeff RAM Write interface
        .WBs_CLK_i                 ( WBs_CLK_i           ),
        .WBs_RST_i                 ( WBs_RST_i           ),

        .I2S_last_ram_write_i	   ( i2s_Clock_Stoped_i ),
        .I2S_last_ram_addr_i	   ( FIR_RXRAM_w_Addr_i ),
        .I2S_ram_write_ena_i 	   ( FIR_I2S_RXRAM_w_ena_i),
        .I2S_clk_i 	   			   ( i2s_clk_gclk_i),//( I2S_CLK_i),
                                
       //Data Ram interface.  
        .fir_dat_addr_o			( FIR_DATA_RaDDR_o  ),		
        .fir_indata_rd_en_o		(   ),//RAM Block's read enable in I2S_slave_Rx_FIFO is always asserted.

        // [RO] debug, override data from the I2S data RAM with a fixed register value (from FPGA reg block)
        //.fir_data_i				( FIR_RD_DATA_sig  ),
        //.fir_data_i				( debug_FIR_data  ),
        .fir_data_i				( FIR_RD_DATA_i               ),

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


wire    Rx_FIFO_Flush;
assign Rx_FIFO_Flush      			= WBs_RST_i | DeciData_Rx_FIFO_Flush;

//FIFO for storing decimation samples
//assign L_MONO_i2sblk_RXFIFO_PUSH 	= (STEREO_EN_i)? L_PreDeci_RXRAM_WR_i: 1'b0;
deci_filter_af512x16_512x16                u_af512x16_512x16_L 
                            (
        //.DIN                ( FIR_Deci_DATA_i	),
        .DIN                ( fir_deci_data_sig  ),

        .Fifo_Push_Flush    ( Rx_FIFO_Flush         ),
        .Fifo_Pop_Flush     ( Rx_FIFO_Flush         ),  

        //.PUSH               ( FIR_Deci_DATA_PUSH_i    ),
        .PUSH               ( fir_deci_data_push_sig  ),

        .POP                ( DeciData_RXFIFO_Pop ), //( L_RXFIFO_Pop          ),

        .Push_Clk           ( WBs_CLK_i     ),
        .Pop_Clk            ( WBs_CLK_i             ),
        .Push_Clk_En        ( 1'b1                  ),
        .Pop_Clk_En         ( 1'b1                  ),
        .Fifo_Dir           ( 1'b0                  ),
        .Async_Flush        ( Rx_FIFO_Flush         ),
        .Almost_Full        (                       ),
        .Almost_Empty       (                       ),
        .PUSH_FLAG          (                       ),
        .POP_FLAG           ( DeciData_Rx_FIFO_pop_flag_sig            ),//L_POP_FLAG_
        .DOUT               ( L_DeciData_RXFIFO_DAT         )//L_RXFIFO_DAT_
        );										

assign DeciData_Rx_FIFO_Empty = (DeciData_Rx_FIFO_pop_flag_sig == 4'h0)? 1'b1 : 1'b0;
assign DeciData_Rx_FIFO_Full = (DeciData_Rx_FIFO_pop_flag_sig == 4'hF)? 1'b1 : 1'b0;


always @(*)
begin
    case(DeciData_Rx_FIFO_Flush)
    1'b0:
    begin
        case({DeciData_RXFIFO_Pop, fir_deci_data_push_sig})
        2'b00: DeciData_Rx_FIFO_Level_nxt <= DeciData_Rx_FIFO_Level       ;  // No Operation -> Hold
        2'b01: DeciData_Rx_FIFO_Level_nxt <= DeciData_Rx_FIFO_Level + 1'b1;  // Push         -> add      one byte
        2'b10: DeciData_Rx_FIFO_Level_nxt <= DeciData_Rx_FIFO_Level - 1'b1;  // Pop          -> subtract one byte
        2'b11: DeciData_Rx_FIFO_Level_nxt <= DeciData_Rx_FIFO_Level       ;  // Push and Pop -> Hold
        endcase
    end
    1'b1:      DeciData_Rx_FIFO_Level_nxt <=  9'h0                 ;
    endcase

end 

always @( posedge WBs_CLK_i or posedge WBs_RST_i)
begin
    if (WBs_RST_i)
    begin
        DeciData_Rx_FIFO_Level  <= 9'h0;
    end  
    else
    begin
        DeciData_Rx_FIFO_Level  <= DeciData_Rx_FIFO_Level_nxt;
    end  
end





deci_filter_DMA_StateMachine        u_i2s_slave_w_DMA_StateMachine
                                                ( 
            .WBs_CLK_i                           ( WBs_CLK_i                       ),//
            .WBs_RST_i                           ( WBs_RST_i                       ),//

            .DMA_Clr_o                   		 ( DMA_Clr                         ),//
            
            .DMA_REQ_o                   		 ( DMA_Req		               ),//
            .DMA_DONE_o                   		 ( DMA_Done                  	   ),//
            .DMA_Active_i                    	 ( SDMA_Active_deci_filter_i       ),//
            .DMA_Active_o                    	 ( DMA_Active                      ),//

            //.LR_RXFIFO_Pop_i                     ( DeciData_RXFIFO_Pop_sig                   ),
            .LR_RXFIFO_Pop_i                     ( DeciData_RXFIFO_Pop              ),

            .DMA_CNT_i                           ( DMA_CNT                		  ),//

            .DMA_Start_i                       	 ( DMA_Start                       ),
            //.I2S_S_EN_i                       	 ( I2S_S_EN                        ),
            //.I2S_S_EN_i                       	 ( I2S_S_EN  | FIR_ena_o                      ),
            .I2S_S_EN_i                       	 ( I2S_S_EN_i  | FIR_ena_sig  ),
            
            .dma_cntr_o                       	 ( dma_cntr                        ),
            .dma_st_o                       	 ( dma_st                          ),
            .DMA_Busy_o                          ( DMA_Busy                        )
                                                                                  );  
                                                                                  
assign SDMA_Req_deci_filter_o = DMA_Req;
assign SDMA_Sreq_deci_filter_o = 0;



endmodule

