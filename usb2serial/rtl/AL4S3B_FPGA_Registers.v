// -----------------------------------------------------------------------------
// title          : AL4S3B Example FPGA Register Module
// project        : Tamar2 Device
// -----------------------------------------------------------------------------
// file           : AL4S3B_FPGA_Registers.v
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
// date            version       author              description
// 2016/02/03      1.0        Rakesh Moolacheri     Initial Release
//
// -----------------------------------------------------------------------------
// Comments: This solution is specifically for use with the QuickLogic
//           AL4S3B device. 
// -----------------------------------------------------------------------------
//

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

                         // USB to M4 FIFO interface
                        FIFO_u2m_pop,
                        FIFO_u2m_dout,
                        FIFO_u2m_ae,
                        FIFO_u2m_empty,
                        FIFO_u2m_popflag,

                        // M4 to USB FIFO interface
                        FIFO_m2u_push,
                        FIFO_m2u_din,
                        FIFO_m2u_af,
                        FIFO_m2u_full,
                        FIFO_m2u_pushflag,

                        Interrupt_o,
                        clk_sel_o,
                        usb_pid_o,

                         //
                         // Misc
                         //
                         Device_ID_o
                         );


//------Port Parameters----------------
//

parameter                ADDRWIDTH                   =   7  ;   // Allow for up to 128 registers in the FPGA
parameter                DATAWIDTH                   =  32  ;   // Allow for up to 128 registers in the FPGA

parameter                FPGA_REG_ID_VALUE_ADR       =  10'h000;   // 0x00
parameter                FPGA_REV_NUM_ADR            =  10'h004;   // 0x04
parameter                FPGA_SCRATCH_REG_ADR        =  10'h008;   // 0x08
parameter                FPGA_CLKCTRL_REG_ADR        =  10'h00C;   // 0x0C
parameter                FPGA_USBPID_REG_ADR         =  10'h010;   // 0x10

// USB to M4, and M4 to USB registers
parameter                FPGA_U2M_FIFO_FLAGS        =  10'h040;
parameter                FPGA_U2M_FIFO_RDATA        =  10'h044;
parameter                FPGA_M2U_FIFO_FLAGS        =  10'h080;
parameter                FPGA_M2U_FIFO_WDATA        =  10'h084;
parameter                FPGA_U2M_FIFO_INT_EN       =  10'h0C0;

parameter                AL4S3B_DEF_REG_VALUE        = 32'hFAB_DEF_AC;


//------Port Signals-------------------
//

// AHB-To_FPGA Bridge I/F
//
input   [ADDRWIDTH-1:0]  WBs_ADR_i     ;  // Address Bus                to   FPGA
input                    WBs_CYC_i     ;  // Cycle Chip Select          to   FPGA
input             [3:0]  WBs_BYTE_STB_i;  // Byte Select                to   FPGA
input                    WBs_WE_i      ;  // Write Enable               to   FPGA
input                    WBs_STB_i     ;  // Strobe Signal              to   FPGA
input   [DATAWIDTH-1:0]  WBs_DAT_i     ;  // Write Data Bus             to   FPGA
input                    WBs_CLK_i     ;  // FPGA Clock               from FPGA
input                    WBs_RST_i     ;  // FPGA Reset               to   FPGA
output  [DATAWIDTH-1:0]  WBs_DAT_o     ;  // Read Data Bus              from FPGA
output                   WBs_ACK_o     ;  // Transfer Cycle Acknowledge from FPGA

// USB to M4 FIFO interface
output          FIFO_u2m_pop;
input   [7:0]   FIFO_u2m_dout;
input           FIFO_u2m_ae;
input           FIFO_u2m_empty;
input   [3:0]   FIFO_u2m_popflag;
                    
// M4 to USB FIFO interface
output          FIFO_m2u_push;
output  [7:0]   FIFO_m2u_din;
input           FIFO_m2u_af;
input           FIFO_m2u_full;
input   [3:0]   FIFO_m2u_pushflag;

output          Interrupt_o;
output          clk_sel_o;
output  [15:0]  usb_pid_o;

//
// Misc
//
output           [31:0]  Device_ID_o   ;


wire            clk_sel_o;
wire  [15:0]    usb_pid_o;

// FPGA Global Signals
//
wire                     WBs_CLK_i     ;  // Wishbone FPGA Clock
wire                     WBs_RST_i     ;  // Wishbone FPGA Reset

// Wishbone Bus Signals
//
wire    [ADDRWIDTH-1:0]  WBs_ADR_i     ;  // Wishbone Address Bus
wire                     WBs_CYC_i     ;  // Wishbone Client Cycle  Strobe (i.e. Chip Select)
wire              [3:0]  WBs_BYTE_STB_i;  // Wishbone Byte   Enables
wire                     WBs_WE_i      ;  // Wishbone Write  Enable Strobe
wire                     WBs_STB_i     ;  // Wishbone Transfer      Strobe
wire    [DATAWIDTH-1:0]  WBs_DAT_i     ;  // Wishbone Write  Data Bus
 
reg     [DATAWIDTH-1:0]  WBs_DAT_o     ;  // Wishbone Read   Data Bus

reg                      WBs_ACK_o     ;  // Wishbone Client Acknowledge

// Misc
//
wire              [31:0]  Device_ID_o;
wire              [31:0]  Rev_Num;

reg 			  [15:0] Scratch_reg;
reg               [7:0]  M2U_FIFO_WDATA_reg;
reg                      M2U_FIFO_WDATA_valid;
reg                      Interrupt_en;

reg                      clk_ctrl_reg;
reg             [15:0]   usb_pid_reg;

//------Define Parameters--------------
//

//
// None at this time
//

//------Internal Signals---------------
//
wire					 FB_SCRATCH_REG_Wr_Dcd;
wire                     M2U_FIFO_WDATA_WE;
wire                     INTERRUPT_EN_WE;
wire                     CLKCTRL_WE;
wire                     USBPID_WE;

wire					 WBs_ACK_o_nxt;


//------Logic Operations---------------

// Define the FPGA's local register write enables
//
assign FB_SCRATCH_REG_Wr_Dcd  = (WBs_ADR_i[ADDRWIDTH-2:0] == FPGA_SCRATCH_REG_ADR[ADDRWIDTH:2]) & WBs_CYC_i & WBs_STB_i & WBs_WE_i   & (~WBs_ACK_o);
assign M2U_FIFO_WDATA_WE = (WBs_ADR_i[ADDRWIDTH-2:0] == FPGA_M2U_FIFO_WDATA[ADDRWIDTH:2]) & WBs_CYC_i & WBs_STB_i & WBs_WE_i   & (~WBs_ACK_o);
assign INTERRUPT_EN_WE = (WBs_ADR_i[ADDRWIDTH-2:0] == FPGA_U2M_FIFO_INT_EN[ADDRWIDTH:2]) & WBs_CYC_i & WBs_STB_i & WBs_WE_i   & (~WBs_ACK_o);
assign CLKCTRL_WE = (WBs_ADR_i[ADDRWIDTH-2:0] == FPGA_CLKCTRL_REG_ADR[ADDRWIDTH:2]) & WBs_CYC_i & WBs_STB_i & WBs_WE_i   & (~WBs_ACK_o);
assign USBPID_WE = (WBs_ADR_i[ADDRWIDTH-2:0] == FPGA_USBPID_REG_ADR[ADDRWIDTH:2]) & WBs_CYC_i & WBs_STB_i & WBs_WE_i   & (~WBs_ACK_o);

// Define the Acknowledge back to the host for registers
//
assign WBs_ACK_o_nxt          =   WBs_CYC_i & WBs_STB_i & (~WBs_ACK_o);


// Define the FPGA's Local Registers
//
always @( posedge WBs_CLK_i or posedge WBs_RST_i)
begin
    if (WBs_RST_i)
    begin
		Scratch_reg <=  16'h0 ; 
        M2U_FIFO_WDATA_reg <= 0;
        M2U_FIFO_WDATA_valid <= 0;
        WBs_ACK_o   <=  1'b0  ;
        Interrupt_en <= 1'b0;
        clk_ctrl_reg <= 0;
        usb_pid_reg <= 16'h6140;
    end  
    else
    begin
	
		if(FB_SCRATCH_REG_Wr_Dcd && WBs_BYTE_STB_i[0])
			Scratch_reg[7:0]   <= WBs_DAT_i[7:0]  ;

        if(FB_SCRATCH_REG_Wr_Dcd && WBs_BYTE_STB_i[1])
			Scratch_reg[15:8]  <= WBs_DAT_i[15:8] ;

		if(CLKCTRL_WE && WBs_BYTE_STB_i[0])
            clk_ctrl_reg <= WBs_DAT_i[0];

		if(USBPID_WE && WBs_BYTE_STB_i[0])
            usb_pid_reg[7:0] <= WBs_DAT_i[7:0];

		if(USBPID_WE && WBs_BYTE_STB_i[1])
            usb_pid_reg[15:8] <= WBs_DAT_i[15:8];

        if (M2U_FIFO_WDATA_WE && WBs_BYTE_STB_i[0]) begin
            M2U_FIFO_WDATA_reg <= WBs_DAT_i[7:0];
            M2U_FIFO_WDATA_valid <= 1;
        end else begin
            M2U_FIFO_WDATA_reg <= M2U_FIFO_WDATA_reg;
            M2U_FIFO_WDATA_valid <= 0;
        end

        if (INTERRUPT_EN_WE && WBs_BYTE_STB_i[0])
            Interrupt_en <= WBs_DAT_i[0];

        WBs_ACK_o  <=  WBs_ACK_o_nxt  ;
    end  
end

assign FIFO_m2u_push = M2U_FIFO_WDATA_valid;
assign FIFO_m2u_din = M2U_FIFO_WDATA_reg;
assign FIFO_u2m_pop = (!FIFO_u2m_empty && (WBs_ADR_i == FPGA_U2M_FIFO_RDATA) && WBs_CYC_i && !WBs_WE_i && WBs_STB_i && WBs_ACK_o);

assign Device_ID_o = 32'h0000A5BD;
assign Rev_Num     = 32'h00000200;

// Define the how to read the local registers and memory
//
always @(*)
 begin
    case(WBs_ADR_i[ADDRWIDTH-2:0])
    FPGA_REG_ID_VALUE_ADR[ADDRWIDTH:2]    : WBs_DAT_o <= Device_ID_o;
    FPGA_REV_NUM_ADR[ADDRWIDTH:2]         : WBs_DAT_o <= Rev_Num;  
    FPGA_SCRATCH_REG_ADR[ADDRWIDTH:2]     : WBs_DAT_o <= { 16'h0, Scratch_reg }; 
    FPGA_CLKCTRL_REG_ADR[ADDRWIDTH:2]     : WBs_DAT_o <= { 31'h0, clk_ctrl_reg }; 
    FPGA_USBPID_REG_ADR[ADDRWIDTH:2]      : WBs_DAT_o <= { 16'h0, usb_pid_reg }; 
    FPGA_U2M_FIFO_FLAGS[ADDRWIDTH:2]      : WBs_DAT_o <= { 28'b0, FIFO_u2m_popflag };
    FPGA_U2M_FIFO_RDATA[ADDRWIDTH:2]      : WBs_DAT_o <= { 24'b0, FIFO_u2m_dout };
    FPGA_M2U_FIFO_FLAGS[ADDRWIDTH:2]      : WBs_DAT_o <= { 28'b0, FIFO_m2u_pushflag };
    FPGA_U2M_FIFO_INT_EN[ADDRWIDTH:2]     : WBs_DAT_o <= { 31'b0, Interrupt_en };
    default                               : WBs_DAT_o <= AL4S3B_DEF_REG_VALUE;
	endcase
end

assign Interrupt_o = (!FIFO_u2m_empty && Interrupt_en);
assign clk_sel_o = clk_ctrl_reg;
assign usb_pid_o = usb_pid_reg;

endmodule

