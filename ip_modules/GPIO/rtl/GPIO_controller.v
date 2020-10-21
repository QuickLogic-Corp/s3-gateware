`timescale 1ns / 10ps
module GPIO_controller ( 
                // AHB-To_FPGA Bridge I/F
                WBs_ADR_i,
                WBs_CYC_i,
                WBs_BYTE_STB_i,
                WBs_WE_i,
                WBs_STB_i,
                WBs_DAT_i,
                WBs_CLK_i,
                WBs_RST_i,
                WBs_DAT_o,
                WBs_ACK_o,
						
				// GPIO signals
				GPIO_io
);


//------Port Parameters----------------

    //  Address offsets shown below are byte offsets, so the 2 LSB's (on the right) should be 0's.

// This parameter can/should be over-ridden when this module is instantiated,
//  since it must be unique across all other modules in the FPGA.
parameter   MODULE_OFFSET       = 17'h0_1000;

// This is the value that is returned when a non-implemented register is read.
parameter   DEFAULT_REG_VALUE   = 32'hFAB_DEF_AC;


//------Port Signals-------------------

// AHB-To_FPGA Bridge I/F
input   [16:0]  WBs_ADR_i           ;  // Address Bus                to   FPGA
input           WBs_CYC_i           ;  // Cycle Chip Select          to   FPGA 
input   [3:0]   WBs_BYTE_STB_i      ;  // Byte Select                to   FPGA
input           WBs_WE_i            ;  // Write Enable               to   FPGA
input           WBs_STB_i           ;  // Strobe Signal              to   FPGA
input   [31:0]  WBs_DAT_i           ;  // Write Data Bus             to   FPGA
input           WBs_CLK_i           ;  // FPGA Clock               from FPGA
input           WBs_RST_i           ;  // FPGA Reset               to   FPGA
output  [31:0]  WBs_DAT_o           ;  // Read Data Bus              from FPGA
output          WBs_ACK_o           ;  // Transfer Cycle Acknowledge from FPGA


// GPIO
inout   [31:0]  GPIO_io             ;


// FPGA Global Signals
wire            WBs_CLK_i           ;  // Wishbone FPGA Clock
wire            WBs_RST_i           ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
wire    [16:0]  WBs_ADR_i           ;  // Wishbone Address Bus
wire            WBs_CYC_i           ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select) 
wire    [3:0]   WBs_BYTE_STB_i      ;  // Wishbone Byte   Enables
wire            WBs_WE_i            ;  // Wishbone Write  Enable Strobe
wire            WBs_STB_i           ;  // Wishbone Transfer      Strobe
wire    [31:0]  WBs_DAT_i           ;  // Wishbone Write  Data Bus
 
reg     [31:0]  WBs_DAT_o           ;  // Wishbone Read   Data Bus


reg             WBs_ACK_o           ;  // Wishbone Client Acknowledge


// GPIO
wire    [31:0]  GPIO_io             ;


//------Internal Parameters---------------

// Allow for up to 256 registers in this module
localparam  ADDRWIDTH   =  8;

// register offsets.
    //  Address offsets shown below are byte offsets, so the 2 LSB's (on the right) should be 0's.
localparam  REG_ADDR_GPIO_IN    =  8'h00        ; 
localparam  REG_ADDR_GPIO_OUT   =  8'h04        ; 
localparam  REG_ADDR_GPIO_OE    =  8'h08        ; 


//------Internal Signals---------------
wire    [31:0]  GPIO_in         ;
reg     [31:0]  GPIO_out        ;
reg     [31:0]  GPIO_OE         ;

wire            module_decode   ;
wire            REG_WE_GPIO_out ;
wire            REG_WE_GPIO_OE  ;
wire            WBs_ACK_o_nxt   ;


assign module_decode = (WBs_ADR_i[16:ADDRWIDTH] == MODULE_OFFSET[16:ADDRWIDTH]);

assign REG_WE_GPIO_out = ( WBs_ADR_i[ADDRWIDTH-1:2] == REG_ADDR_GPIO_OUT[ADDRWIDTH-1:2] ) && module_decode && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);
assign REG_WE_GPIO_OE  = ( WBs_ADR_i[ADDRWIDTH-1:2] == REG_ADDR_GPIO_OE[ADDRWIDTH-1:2]  ) && module_decode && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);

// Define the Acknowledge back to the host for registers
assign WBs_ACK_o_nxt  =  module_decode && (WBs_CYC_i) && WBs_STB_i && (~WBs_ACK_o);


// write logic for the registers
always @( posedge WBs_CLK_i or posedge WBs_RST_i)
begin
    if (WBs_RST_i)
    begin
		GPIO_out          <= 31'b0    ;
		GPIO_OE_o         <= 31'b0    ;

		WBs_ACK_o    	  <= 1'b0    ;
    end  
    else
    begin
			
        // GPIO Out Register 
        if (REG_WE_GPIO_out) begin
            if (WBs_BYTE_STB_i[0])
                GPIO_out[7:0]     <= WBs_DAT_i[7:0]   ;
            if (WBs_BYTE_STB_i[1])
                GPIO_out[15:8]    <= WBs_DAT_i[15:8]  ;
            if (WBs_BYTE_STB_i[2])
                GPIO_out[23:16]   <= WBs_DAT_i[23:16] ;
            if (WBs_BYTE_STB_i[3])
                GPIO_out[31:24]   <= WBs_DAT_i[31:24] ;
		end
			
        // GPIO OE Register 
        if (REG_WE_GPIO_OE) begin
            if (WBs_BYTE_STB_i[0])
			    GPIO_OE[7:0]        <= WBs_DAT_i[7:0]   ;
            if (WBs_BYTE_STB_i[1])
			    GPIO_OE[15:8]       <= WBs_DAT_i[15:8]  ;
            if (WBs_BYTE_STB_i[2])
			    GPIO_OE[23:16]      <= WBs_DAT_i[23:16] ;
            if (WBs_BYTE_STB_i[3])
			    GPIO_OE[31:24]      <= WBs_DAT_i[31:24] ;
		end

        WBs_ACK_o                   <=  WBs_ACK_o_nxt  ;
    end  
end


// read logic for the registers
always @(*)
 begin
    case(WBs_ADR_i[ADDRWIDTH-1:2])
        REG_ADDR_GPIO_IN    [ADDRWIDTH-1:2]  : WBs_DAT_o <= GPIO_in             ;
        REG_ADDR_GPIO_OUT   [ADDRWIDTH-1:2]  : WBs_DAT_o <= GPIO_out            ;
        REG_ADDR_GPIO_OE    [ADDRWIDTH-1:2]  : WBs_DAT_o <= GPIO_OE             ;
	    default                              : WBs_DAT_o <= DEFAULT_REG_VALUE   ;
	endcase
end


// GPIO pins
/*
assign GPIO_in = GPIO_io;

genvar i;
generate
    for (i=0; i<32; i++) begin
        assign GPIO_io[i] = GPIO_OE[i] ? GPIO_out[i] : 1'bz;
    end
endgenerate
*/

bipad u_bipad_I00    ( .A( GPIO_out[0]   ), .EN( GPIO_OE[0]      ), .Q( GPIO_in[0]   ), .P( GPIO_io[0]   ) );
bipad u_bipad_I01    ( .A( GPIO_out[1]   ), .EN( GPIO_OE[1]      ), .Q( GPIO_in[1]   ), .P( GPIO_io[1]   ) );
bipad u_bipad_I02    ( .A( GPIO_out[2]   ), .EN( GPIO_OE[2]      ), .Q( GPIO_in[2]   ), .P( GPIO_io[2]   ) );
bipad u_bipad_I03    ( .A( GPIO_out[3]   ), .EN( GPIO_OE[3]      ), .Q( GPIO_in[3]   ), .P( GPIO_io[3]   ) );
bipad u_bipad_I04    ( .A( GPIO_out[4]   ), .EN( GPIO_OE[4]      ), .Q( GPIO_in[4]   ), .P( GPIO_io[4]   ) );
bipad u_bipad_I05    ( .A( GPIO_out[5]   ), .EN( GPIO_OE[5]      ), .Q( GPIO_in[5]   ), .P( GPIO_io[5]   ) );
bipad u_bipad_I06    ( .A( GPIO_out[6]   ), .EN( GPIO_OE[6]      ), .Q( GPIO_in[6]   ), .P( GPIO_io[6]   ) );
bipad u_bipad_I07    ( .A( GPIO_out[7]   ), .EN( GPIO_OE[7]      ), .Q( GPIO_in[7]   ), .P( GPIO_io[7]   ) );
bipad u_bipad_I08    ( .A( GPIO_out[8]   ), .EN( GPIO_OE[8]      ), .Q( GPIO_in[8]   ), .P( GPIO_io[8]   ) );
bipad u_bipad_I09    ( .A( GPIO_out[9]   ), .EN( GPIO_OE[9]      ), .Q( GPIO_in[9]   ), .P( GPIO_io[9]   ) );

bipad u_bipad_I10    ( .A( GPIO_out[10]  ), .EN( GPIO_OE[10]     ), .Q( GPIO_in[10]  ), .P( GPIO_io[10]  ) );
bipad u_bipad_I11    ( .A( GPIO_out[11]  ), .EN( GPIO_OE[11]     ), .Q( GPIO_in[11]  ), .P( GPIO_io[11]  ) );
bipad u_bipad_I12    ( .A( GPIO_out[12]  ), .EN( GPIO_OE[12]     ), .Q( GPIO_in[12]  ), .P( GPIO_io[12]  ) );
bipad u_bipad_I13    ( .A( GPIO_out[13]  ), .EN( GPIO_OE[13]     ), .Q( GPIO_in[13]  ), .P( GPIO_io[13]  ) );
bipad u_bipad_I14    ( .A( GPIO_out[14]  ), .EN( GPIO_OE[14]     ), .Q( GPIO_in[14]  ), .P( GPIO_io[14]  ) );
bipad u_bipad_I15    ( .A( GPIO_out[15]  ), .EN( GPIO_OE[15]     ), .Q( GPIO_in[15]  ), .P( GPIO_io[15]  ) );
bipad u_bipad_I16    ( .A( GPIO_out[16]  ), .EN( GPIO_OE[16]     ), .Q( GPIO_in[16]  ), .P( GPIO_io[16]  ) );
bipad u_bipad_I17    ( .A( GPIO_out[17]  ), .EN( GPIO_OE[17]     ), .Q( GPIO_in[17]  ), .P( GPIO_io[17]  ) );
bipad u_bipad_I18    ( .A( GPIO_out[18]  ), .EN( GPIO_OE[18]     ), .Q( GPIO_in[18]  ), .P( GPIO_io[18]  ) );
bipad u_bipad_I19    ( .A( GPIO_out[19]  ), .EN( GPIO_OE[19]     ), .Q( GPIO_in[19]  ), .P( GPIO_io[19]  ) );

bipad u_bipad_I20    ( .A( GPIO_out[20]  ), .EN( GPIO_OE[20]     ), .Q( GPIO_in[20]  ), .P( GPIO_io[20]  ) );
bipad u_bipad_I21    ( .A( GPIO_out[21]  ), .EN( GPIO_OE[21]     ), .Q( GPIO_in[21]  ), .P( GPIO_io[21]  ) );
bipad u_bipad_I22    ( .A( GPIO_out[22]  ), .EN( GPIO_OE[22]     ), .Q( GPIO_in[22]  ), .P( GPIO_io[22]  ) );
bipad u_bipad_I23    ( .A( GPIO_out[23]  ), .EN( GPIO_OE[23]     ), .Q( GPIO_in[23]  ), .P( GPIO_io[23]  ) );
bipad u_bipad_I24    ( .A( GPIO_out[24]  ), .EN( GPIO_OE[24]     ), .Q( GPIO_in[24]  ), .P( GPIO_io[24]  ) );
bipad u_bipad_I25    ( .A( GPIO_out[25]  ), .EN( GPIO_OE[25]     ), .Q( GPIO_in[25]  ), .P( GPIO_io[25]  ) );
bipad u_bipad_I26    ( .A( GPIO_out[26]  ), .EN( GPIO_OE[26]     ), .Q( GPIO_in[26]  ), .P( GPIO_io[26]  ) );
bipad u_bipad_I27    ( .A( GPIO_out[27]  ), .EN( GPIO_OE[27]     ), .Q( GPIO_in[27]  ), .P( GPIO_io[27]  ) );
bipad u_bipad_I28    ( .A( GPIO_out[28]  ), .EN( GPIO_OE[28]     ), .Q( GPIO_in[28]  ), .P( GPIO_io[28]  ) );
bipad u_bipad_I29    ( .A( GPIO_out[29]  ), .EN( GPIO_OE[29]     ), .Q( GPIO_in[29]  ), .P( GPIO_io[29]  ) );

bipad u_bipad_I30    ( .A( GPIO_out[30]  ), .EN( GPIO_OE[30]     ), .Q( GPIO_in[30]  ), .P( GPIO_io[30]  ) );
bipad u_bipad_I31    ( .A( GPIO_out[31]  ), .EN( GPIO_OE[31]     ), .Q( GPIO_in[31]  ), .P( GPIO_io[31]  ) );

endmodule

