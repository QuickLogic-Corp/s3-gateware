`timescale 1ns / 10ps
module AL4S3B_FPGA_Registers ( 

                        // AHB-To_FPGA Bridge I/F
                        //
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

                        fsm_top_st_i, 
                        spi_fsm_st_i,

                        DEBUG_FIR_data_o,

                        Device_ID_o
                         );


//------Port Parameters----------------
//
parameter       ADDRWIDTH                   =  10;   // Allow for up to 128 registers in the FPGA
parameter       DATAWIDTH                   =  32;   // Allow for up to 128 registers in the FPGA

                                                                // these are byte offsets
                                                                //  the 2 LSB's (on the right) should be 0's.
parameter       FPGA_REG_ID_VALUE_ADR       = 10'h000       ; 
parameter       FPGA_REV_NUM_ADR            = 10'h004       ; 

// [RO] debug
parameter       DEBUG_FIR_DATA_ADR          = 10'h010       ;

parameter       AL4S3B_DEVICE_ID            = 32'h0         ;
parameter       AL4S3B_REV_LEVEL            = 32'h0         ;
parameter       AL4S3B_SCRATCH_REG          = 32'h12345678  ;

parameter       AL4S3B_DEF_REG_VALUE        = 32'hFAB_DEF_AC;

//------Port Signals-------------------
//

// AHB-To_FPGA Bridge I/F
//
input   [16:0]           WBs_ADR_i     ;  // Address Bus                to   FPGA
input                    WBs_CYC_i     ;  // Cycle Chip Select          to   FPGA 
input             [3:0]  WBs_BYTE_STB_i;  // Byte Select                to   FPGA
input                    WBs_WE_i      ;  // Write Enable               to   FPGA
input                    WBs_STB_i     ;  // Strobe Signal              to   FPGA
input   [DATAWIDTH-1:0]  WBs_DAT_i     ;  // Write Data Bus             to   FPGA
input                    WBs_CLK_i     ;  // FPGA Clock               from FPGA
input                    WBs_RST_i     ;  // FPGA Reset               to   FPGA
output  [DATAWIDTH-1:0]  WBs_DAT_o     ;  // Read Data Bus              from FPGA
output                   WBs_ACK_o     ;  // Transfer Cycle Acknowledge from FPGA

//
// Misc
//

// [RO] debug
output  [31:0]  DEBUG_FIR_data_o;

output  [31:0]  Device_ID_o   ;
     


input   [1:0]   fsm_top_st_i; 
input   [1:0]   spi_fsm_st_i;   


// FPGA Global Signals
//
wire                     WBs_CLK_i     ;  // Wishbone FPGA Clock
wire                     WBs_RST_i     ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
//
wire    [16:0]           WBs_ADR_i     ;  // Wishbone Address Bus
wire                     WBs_CYC_i     ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select) 
wire              [3:0]  WBs_BYTE_STB_i;  // Wishbone Byte   Enables
wire                     WBs_WE_i      ;  // Wishbone Write  Enable Strobe
wire                     WBs_STB_i     ;  // Wishbone Transfer      Strobe
wire    [DATAWIDTH-1:0]  WBs_DAT_i     ;  // Wishbone Write  Data Bus
 
reg     [DATAWIDTH-1:0]  WBs_DAT_o     ;  // Wishbone Read   Data Bus


reg                      WBs_ACK_o     ;  // Wishbone Client Acknowledge


// Misc
//
wire    [31:0]  Device_ID_o;
wire    [31:0]  Rev_Num;

// [RO] debug
wire    [31:0]  DEBUG_FIR_data_o;
reg     [31:0]  DEBUG_FIR_data_reg;
    



wire            Pop_Sig_int;
wire            Pop_Sig;
wire    [3:0]   pop_flag; 

reg     [9:0]   rx_fifo_cnt;  

wire    [1:0]   fsm_top_st_i;
wire    [1:0]   spi_fsm_st_i;

//------Define Parameters--------------
//
// None at this time
//
//------Internal Signals---------------
//


wire            fifo_ovrrun;

//------Logic Operations---------------
//

// [RO] debug
wire    DEBUG_REG_WE_FIR_DATA;
assign DEBUG_REG_WE_FIR_DATA = ( WBs_ADR_i[ADDRWIDTH-1:2] == DEBUG_FIR_DATA_ADR[ADDRWIDTH-1:2] ) && WBs_CYC_i && WBs_STB_i && WBs_WE_i && (~WBs_ACK_o);



// Define the Acknowledge back to the host for registers
//
assign WBs_ACK_o_nxt  =   (WBs_CYC_i) & WBs_STB_i & (~WBs_ACK_o);


// Define the FPGA's Local Registers
//
always @( posedge WBs_CLK_i or posedge WBs_RST_i)
begin
    if (WBs_RST_i)
    begin
        //DEBUG_FIR_data_reg <= 0;

        WBs_ACK_o <= 1'b0;
    end  
    else
    begin
        /*
        if (DEBUG_REG_WE_FIR_DATA) begin
            if (WBs_BYTE_STB_i[0])
                DEBUG_FIR_data_reg[7:0] <= WBs_DAT_i[7:0]   ;
            if (WBs_BYTE_STB_i[1])
                DEBUG_FIR_data_reg[15:8] <= WBs_DAT_i[15:8]   ;
            if (WBs_BYTE_STB_i[2])
                DEBUG_FIR_data_reg[23:16] <= WBs_DAT_i[23:16]   ;
            if (WBs_BYTE_STB_i[3])
                DEBUG_FIR_data_reg[31:24] <= WBs_DAT_i[31:24]   ;
        end
        */

        WBs_ACK_o <=  WBs_ACK_o_nxt;
    end  
end

// Define the how to read the local registers and memory
//
always @(*)
 begin
    case(WBs_ADR_i[ADDRWIDTH-1:2])
    FPGA_REG_ID_VALUE_ADR  [ADDRWIDTH-1:2]  : WBs_DAT_o <= AL4S3B_DEVICE_ID     ;
    FPGA_REV_NUM_ADR       [ADDRWIDTH-1:2]  : WBs_DAT_o <= AL4S3B_REV_LEVEL     ;
    //DEBUG_FIR_DATA_ADR     [ADDRWIDTH-1:2]  : WBs_DAT_o <= DEBUG_FIR_data_reg   ;
    default                                 : WBs_DAT_o <= AL4S3B_DEF_REG_VALUE ;
    endcase
end

assign Device_ID_o = AL4S3B_DEVICE_ID;
assign Rev_Num     = AL4S3B_REV_LEVEL;

// [RO] debug
//assign DEBUG_FIR_data_o = DEBUG_FIR_data_reg;
assign DEBUG_FIR_data_o = 0;


endmodule
