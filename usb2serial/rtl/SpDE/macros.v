/***************************************************
 Vendor        : QuickLogic Corp.
 SpDE Version  : SpDE 2015.1.2 Release Build				
 File Name     : MACROS.V			
 Creation Date : Tue Sept 14 17:39:38 2015
 Author        : Kishor Kumar 
 Description   : Verilog Netlist File (For Synthesis/Pre-Layout Simulation)									
*****************************************************/

/*-------------------------------------------------------------------------------
 MODULE NAME : ckpad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ckpad
`else
`define ckpad

module ckpad ( P , Q )/* synthesis black_box black_box_pad_pin = "P" */;

input P;
output Q;


clock_cell I1  (.IP(P) , .IC(Q) );


endmodule /* ckpad */
`endif

`ifdef clock_cell
`else
`define clock_cell
module clock_cell( IP , IC );
output IC;
input IP;

//pragma synthesis_off
 assign #1 IC = IP;

//pragma synthesis_on

endmodule // clock_cell
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : GPIO_CELL 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/

`timescale 1 ns /10 ps
`ifdef gpio_cell
`else
`define gpio_cell
module gpio_cell (

		ESEL,
		IE,
		OSEL,
		OQI,
		OQE,
		DS,
		FIXHOLD,
		IZ,
		IQZ,
		IQE,
		IQC,
		IQCS,
		IQR,
		WPD,
		INEN,
		IP
		);
				
input ESEL;
input IE;
input OSEL;
input OQI;
input OQE;
input DS;
input FIXHOLD;
output IZ;
output IQZ;
input IQE;
input IQC;
input IQCS;
input INEN;
input IQR;
input WPD;
inout IP;

//pragma synthesis_off

reg EN_reg, OQ_reg, IQZ;
wire AND_OUT;

assign rstn = ~IQR;
assign IQCP = IQCS ? ~IQC : IQC;

always @(posedge IQCP or negedge rstn)
	if (~rstn)
		EN_reg <= 1'b0;
	else
		EN_reg <= IE;

always @(posedge IQCP or negedge rstn)
	if (~rstn)
		OQ_reg <= 1'b0;
	else
		if (OQE)
			OQ_reg <= OQI;
			
			
always @(posedge IQCP or negedge rstn)		
	if (~rstn)
		IQZ <= 1'b0;
	else
		if (IQE)
		IQZ <= AND_OUT; 
	
assign IZ = AND_OUT;  

assign AND_OUT = INEN ? IP : 1'b0; 

assign EN = ESEL ? IE : EN_reg ;

assign OQ = OSEL ? OQI : OQ_reg ;  

assign IP = EN ? OQ : 1'bz;


assign (highz1,pull0) IP = WPD ? 1'b0 : 1'b1;
//pragma synthesis_on

endmodule

`endif


//Logic cell Behavioral model for Polarpro III
`ifdef logic_cell
`else
`define logic_cell
module logic_cell(QST,QDS,TBS,TAB,TSL,TAS1,TA1,TAS2,TA2,TBS1,TB1,TBS2,TB2,  
		  BAB,BSL,BAS1,BA1,BAS2,BA2,BBS1,BB1,BBS2,BB2,QDI,QEN,
		  QCKS,QCK,QRT,F1,F2,FS,TZ,CZ,QZ,
		  FZ);
input QST,QDS,TBS,TAB,TSL,TAS1,TA1,TAS2,TA2,TBS1,TB1,TBS2,TB2;
input BAB,BSL,BAS1,BA1,BAS2,BA2,BBS1,BB1,BBS2,BB2,QDI,QEN;				  
input QCKS,QCK,QRT,F1,F2,FS;
output TZ,CZ,QZ,FZ;

//pragma synthesis_off

parameter ql_frag =1;

wire TAP1,TAP2,TBP1,TBP2,BAP1,BAP2,BBP1,BBP2,QCKP,TAI,TBI,BAI,BBI,TZI,BZI,CZI,QZI;
reg QZ;

initial
  begin
       QZ  = 1'b0;
end	

assign TAP1 = TAS1 ? ~TA1 : TA1; 
assign TAP2 = TAS2 ? ~TA2 : TA2; 
assign TBP1 = TBS1 ? ~TB1 : TB1; 
assign TBP2 = TBS2 ? ~TB2 : TB2;
assign BAP1 = BAS1 ? ~BA1 : BA1;
assign BAP2 = BAS2 ? ~BA2 : BA2;
assign BBP1 = BBS1 ? ~BB1 : BB1;
assign BBP2 = BBS2 ? ~BB2 : BB2;

assign TAI = TSL ? TAP2 : TAP1;
assign TBI = TSL ? TBP2 : TBP1;
assign BAI = BSL ? BAP2 : BAP1;
assign BBI = BSL ? BBP2 : BBP1;
assign TZI = TAB ? TBI : TAI;
assign BZI = BAB ? BBI : BAI;
assign CZI = TBS ? BZI : TZI;
assign QZI = QDS ? QDI : CZI ;
assign FZ = FS ? F2 : F1;
assign TZ = TZI;
assign CZ = CZI;
assign QCKP = QCKS ? QCK : ~QCK;


/*synopsys translate_off */
always @(posedge QCKP)
	if(~QRT && ~QST)
		if(QEN)
		QZ = QZI;
always @(QRT or QST)
	if(QRT)
		QZ = 1'b0;
	else if (QST)
		QZ = 1'b1;
/*synopsys translate_on */


//pragma synthesis_on
endmodule    
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ram8k_2x1_cell_macro 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ram8k_2x1_cell_macro
`else
`define ram8k_2x1_cell_macro

module ram8k_2x1_cell_macro ( A1_0 , A1_1, A2_0, A2_1, ASYNC_FLUSH_0, ASYNC_FLUSH_1,
                             ASYNC_FLUSH_S0, ASYNC_FLUSH_S1, CLK1_0, CLK1_1,
                             CLK1EN_0, CLK1EN_1, CLK1S_0, CLK1S_1, CLK2_0,
                             CLK2_1, CLK2EN_0, CLK2EN_1, CLK2S_0, CLK2S_1,
                             CONCAT_EN_0, CONCAT_EN_1, CS1_0, CS1_1, CS2_0,
                             CS2_1, DIR_0, DIR_1, FIFO_EN_0, FIFO_EN_1, P1_0,
                             P1_1, P2_0, P2_1, PIPELINE_RD_0, PIPELINE_RD_1,
                             SYNC_FIFO_0,
                             SYNC_FIFO_1, WD_0, WD_1, WEN1_0, WEN1_1,
                             WIDTH_SELECT1_0, WIDTH_SELECT1_1,
                             WIDTH_SELECT2_0, WIDTH_SELECT2_1, Almost_Empty_0,
                             Almost_Empty_1, Almost_Full_0, Almost_Full_1,
                             POP_FLAG_0, POP_FLAG_1, PUSH_FLAG_0, PUSH_FLAG_1,
                             RD_0, RD_1, SD,DS,LS,SD_RB1,LS_RB1,DS_RB1,RMEA,RMEB,RMA,RMB,TEST1A,TEST1B)/* synthesis black_box */;

input [10:0] A1_0;
input [10:0] A1_1;
input [10:0] A2_0;
input [10:0] A2_1;
input CLK1_0 /* synthesis syn_isclock=1 */;
input CLK1_1 /* synthesis syn_isclock=1 */;
output Almost_Empty_0, Almost_Empty_1, Almost_Full_0, Almost_Full_1;
input ASYNC_FLUSH_0, ASYNC_FLUSH_1,CLK2_0, CLK2_1, ASYNC_FLUSH_S0, ASYNC_FLUSH_S1, CLK1EN_0, CLK1EN_1, CLK1S_0, CLK1S_1,CLK2EN_0,CLK2EN_1, CLK2S_0, CLK2S_1, CONCAT_EN_0, CONCAT_EN_1, CS1_0, CS1_1,CS2_0, CS2_1, DIR_0, DIR_1, FIFO_EN_0, FIFO_EN_1, P1_0, P1_1, P2_0,P2_1, PIPELINE_RD_0, PIPELINE_RD_1;
output [3:0] POP_FLAG_0;
output [3:0] POP_FLAG_1;
output [3:0] PUSH_FLAG_0;
output [3:0] PUSH_FLAG_1;
output [17:0] RD_0;
output [17:0] RD_1;
input  SYNC_FIFO_0, SYNC_FIFO_1;
input [17:0] WD_0;
input [17:0] WD_1;
input [1:0] WEN1_0;
input [1:0] WEN1_1;
input [1:0] WIDTH_SELECT1_0;
input [1:0] WIDTH_SELECT1_1;
input [1:0] WIDTH_SELECT2_0;
input [1:0] WIDTH_SELECT2_1;
input SD,DS,LS,SD_RB1,LS_RB1,DS_RB1,RMEA,RMEB,TEST1A,TEST1B;
input [3:0] RMA;
input [3:0] RMB;

ram8k_2x1_cell I1  ( .A1_0({ A1_0[10:0] }) , .A1_1({ A1_1[10:0] }),
                     .A2_0({ A2_0[10:0] }) , .A2_1({ A2_1[10:0] }),
                     .Almost_Empty_0(Almost_Empty_0),
                     .Almost_Empty_1(Almost_Empty_1),
                     .Almost_Full_0(Almost_Full_0),
                     .Almost_Full_1(Almost_Full_1),
                     .ASYNC_FLUSH_0(ASYNC_FLUSH_0),
                     .ASYNC_FLUSH_1(ASYNC_FLUSH_1),
                     .ASYNC_FLUSH_S0(ASYNC_FLUSH_S0),
                     .ASYNC_FLUSH_S1(ASYNC_FLUSH_S1) , .CLK1_0(CLK1_0),
                     .CLK1_1(CLK1_1) , .CLK1EN_0(CLK1EN_0) , .CLK1EN_1(CLK1EN_1),
                     .CLK1S_0(CLK1S_0) , .CLK1S_1(CLK1S_1) , .CLK2_0(CLK2_0),
                     .CLK2_1(CLK2_1) , .CLK2EN_0(CLK2EN_0) , .CLK2EN_1(CLK2EN_1),
                     .CLK2S_0(CLK2S_0) , .CLK2S_1(CLK2S_1),
                     .CONCAT_EN_0(CONCAT_EN_0) , .CONCAT_EN_1(CONCAT_EN_1),
                     .CS1_0(CS1_0) , .CS1_1(CS1_1) , .CS2_0(CS2_0) , .CS2_1(CS2_1),
                     .DIR_0(DIR_0) , .DIR_1(DIR_1) , .FIFO_EN_0(FIFO_EN_0),
                     .FIFO_EN_1(FIFO_EN_1) , .P1_0(P1_0) , .P1_1(P1_1) , .P2_0(P2_0),
                     .P2_1(P2_1) , .PIPELINE_RD_0(PIPELINE_RD_0),
                     .PIPELINE_RD_1(PIPELINE_RD_1),
                     .POP_FLAG_0({ POP_FLAG_0[3:0] }),
                     .POP_FLAG_1({ POP_FLAG_1[3:0] }),
                     .PUSH_FLAG_0({ PUSH_FLAG_0[3:0] }),
                     .PUSH_FLAG_1({ PUSH_FLAG_1[3:0] }) , .RD_0({ RD_0[17:0] }),
                     .RD_1({ RD_1[17:0] }) , .SYNC_FIFO_0(SYNC_FIFO_0),
                     .SYNC_FIFO_1(SYNC_FIFO_1) , .WD_0({ WD_0[17:0] }),
                     .WD_1({ WD_1[17:0] }) , .WEN1_0({ WEN1_0[1:0] }),
                     .WEN1_1({ WEN1_1[1:0] }),
                     .WIDTH_SELECT1_0({ WIDTH_SELECT1_0[1:0] }),
                     .WIDTH_SELECT1_1({ WIDTH_SELECT1_1[1:0] }),
                     .WIDTH_SELECT2_0({ WIDTH_SELECT2_0[1:0] }),
                     .WIDTH_SELECT2_1({ WIDTH_SELECT2_1[1:0] }) );


endmodule /* ram8k_2x1_cell_macro */
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : ram16k_hc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ram16k_hc
`else
`define ram16k_hc

module ram16k_hc ( Async_Flush , ASYNC_FLUSH_S0, CLK1, CLK1EN, CLK2, CLK2EN, CS1, CS2, DIR,
                  FIFO_EN, P1, P2, PIPELINE_RD, RA, SYNC_FIFO, WA,
                  WD, WE, Almost_Empty, Almost_Full, Pop_Flag, Push_Flag, RD )/* synthesis black_box */;

output Almost_Empty, Almost_Full;
input Async_Flush, ASYNC_FLUSH_S0;
input CLK1 /* synthesis syn_isclock=1 */;
input CLK1EN;
input CLK2 /* synthesis syn_isclock=1 */;
input CLK2EN, CS1, CS2, DIR, FIFO_EN, P1, P2, PIPELINE_RD;
output [3:0] Pop_Flag;
output [3:0] Push_Flag;
input [8:0] RA;
output [35:0] RD;
input SYNC_FIFO;
input [8:0] WA;
input [35:0] WD;
input [1:0] WE;supply1 VCC;
supply0 GND;


ram8k_2x1_cell_macro I1  ( .A1_0({ GND,GND,WA[8:0] }),
                           .A1_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .A2_0({ GND,GND,RA[8:0] }),
                           .A2_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .Almost_Empty_0(Almost_Empty),
                           .Almost_Full_0(Almost_Full),
                           .ASYNC_FLUSH_0(Async_Flush) , .ASYNC_FLUSH_1(GND),
                           .ASYNC_FLUSH_S0(ASYNC_FLUSH_S0),
                           .ASYNC_FLUSH_S1(GND) , .CLK1_0(CLK1) , .CLK1_1(CLK1),
                           .CLK1EN_0(CLK1EN) , .CLK1EN_1(CLK1EN) , .CLK1S_0(GND),
                           .CLK1S_1(GND) , .CLK2_0(CLK2) , .CLK2_1(CLK2),
                           .CLK2EN_0(CLK2EN) , .CLK2EN_1(CLK2EN) , .CLK2S_0(GND),
                           .CLK2S_1(GND) , .CONCAT_EN_0(VCC) , .CONCAT_EN_1(GND),
                           .CS1_0(CS1) , .CS1_1(GND) , .CS2_0(CS2) , .CS2_1(GND),
                           .DIR_0(DIR) , .DIR_1(GND) , .FIFO_EN_0(FIFO_EN),
                           .FIFO_EN_1(GND) , .P1_0(P1) , .P1_1(GND) , .P2_0(P2),
                           .P2_1(GND) , .PIPELINE_RD_0(PIPELINE_RD),
                           .PIPELINE_RD_1(PIPELINE_RD),
                           .POP_FLAG_0({ Pop_Flag[3:0] }),
                           .PUSH_FLAG_0({ Push_Flag[3:0] }),
                           .RD_0({ RD[17:0] }) , .RD_1({ RD[35:18] }) ,
                           .SYNC_FIFO_0(SYNC_FIFO) , .SYNC_FIFO_1(GND),
                           .WD_0({ WD[17:0] }) , .WD_1({ WD[35:18] }),
                           .WEN1_0({ WE[1:0] }) , .WEN1_1({ WE[1:0] }),
                           .WIDTH_SELECT1_0({ VCC,GND }),
                           .WIDTH_SELECT1_1({ GND,GND }),
                           .WIDTH_SELECT2_0({ VCC,GND }),
                           .WIDTH_SELECT2_1({ GND,GND }), .Almost_Empty_1(), .Almost_Full_1(), .POP_FLAG_1(), .PUSH_FLAG_1() );


endmodule /* ram16k_hc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ram16k_vc_dp 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ram16k_vc_dp
`else
`define ram16k_vc_dp

module ram16k_vc_dp ( PIPELINE_RD , Port1_A, Port1_CLK, Port1_CLKEN, Port1_CS, Port1_WD,
                     Port1_WDS, Port1_WE, Port2_A, Port2_CLK, Port2_CLKEN,
                     Port2_CS, Port2_WD, Port2_WDS, Port2_WE, 
                     Port1_RD, Port2_RD )/* synthesis black_box */;

input PIPELINE_RD;
input [10:0] Port1_A;
input Port1_CLK /* synthesis syn_isclock=1 */;
input Port1_CLKEN, Port1_CS;
output [17:0] Port1_RD;
input [17:0] Port1_WD;
input [1:0] Port1_WDS;
input [1:0] Port1_WE;
input [10:0] Port2_A;
input Port2_CLK /* synthesis syn_isclock=1 */;
input Port2_CLKEN, Port2_CS;
output [17:0] Port2_RD;
input [17:0] Port2_WD;
input [1:0] Port2_WDS;
input [1:0] Port2_WE;

supply1 VCC;
supply0 GND;


ram8k_2x1_cell_macro I1  ( .A1_0({ Port1_A[10:0] }),
                           .A1_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .A2_0({ Port2_A[10:0] }),
                           .A2_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .ASYNC_FLUSH_0(GND) , .ASYNC_FLUSH_1(GND),
                           .ASYNC_FLUSH_S0(GND) , .ASYNC_FLUSH_S1(GND),
                           .CLK1_0(Port1_CLK) , .CLK1_1(Port1_CLK),
                           .CLK1EN_0(Port1_CLKEN) , .CLK1EN_1(Port1_CLKEN),
                           .CLK1S_0(GND) , .CLK1S_1(GND) , .CLK2_0(Port2_CLK),
                           .CLK2_1(Port2_CLK) , .CLK2EN_0(Port2_CLKEN),
                           .CLK2EN_1(Port2_CLKEN) , .CLK2S_0(GND) , .CLK2S_1(GND),
                           .CONCAT_EN_0(VCC) , .CONCAT_EN_1(GND),
                           .CS1_0(Port1_CS) , .CS1_1(Port1_CS) , .CS2_0(Port2_CS),
                           .CS2_1(Port2_CS) , .DIR_0(GND) , .DIR_1(GND),
                           .FIFO_EN_0(GND) , .FIFO_EN_1(GND) , .P1_0(GND),
                           .P1_1(GND) , .P2_0(GND) , .P2_1(GND),
                           .PIPELINE_RD_0(PIPELINE_RD),
                           .PIPELINE_RD_1(PIPELINE_RD),
                           .RD_0({ Port2_RD[17:0] }) , .RD_1({ Port1_RD[17:0] }),
                           .SYNC_FIFO_0(GND) , .SYNC_FIFO_1(GND),
                           .WD_0({ Port1_WD[17:0] }) , .WD_1({ Port2_WD[17:0] }),
                           .WEN1_0({ Port1_WE[1:0] }),
                           .WEN1_1({ Port2_WE[1:0] }),
                           .WIDTH_SELECT1_0({ Port1_WDS[1:0] }),
                           .WIDTH_SELECT1_1({ GND,GND }),
                           .WIDTH_SELECT2_0({ Port2_WDS[1:0] }),
                           .WIDTH_SELECT2_1({ GND,GND }), .Almost_Empty_0(), .Almost_Empty_1(), .Almost_Full_0(), .Almost_Full_1(), .POP_FLAG_0(), .POP_FLAG_1(), .PUSH_FLAG_0(), .PUSH_FLAG_1() );


endmodule /* ram16k_vc_dp */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ram16k_vc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ram16k_vc
`else
`define ram16k_vc

module ram16k_vc ( Async_Flush , ASYNC_FLUSH_S0, CLK1, CLK1EN, CLK2, CLK2EN, CS1, CS2, DIR,
                  FIFO_EN, P1, P2, PIPELINE_RD, RA, SYNC_FIFO, WA,
                  WD, WDS, WE, Almost_Empty, Almost_Full, Pop_Flag, Push_Flag,
                  RD )/* synthesis black_box */;

output Almost_Empty, Almost_Full;
input Async_Flush, ASYNC_FLUSH_S0;
input CLK1 /* synthesis syn_isclock=1 */;
input CLK1EN;
input CLK2 /* synthesis syn_isclock=1 */;
input CLK2EN, CS1, CS2, DIR, FIFO_EN, P1, P2, PIPELINE_RD;
output [3:0] Pop_Flag;
output [3:0] Push_Flag;
input [10:0] RA;
output [17:0] RD;
input SYNC_FIFO;
input [10:0] WA;
input [17:0] WD;
input [1:0] WDS;
input [1:0] WE;supply1 VCC;
supply0 GND;


ram8k_2x1_cell_macro I1  ( .A1_0({ WA[10:0] }),
                           .A1_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .A2_0({ RA[10:0] }),
                           .A2_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .Almost_Empty_0(Almost_Empty),
                           .Almost_Full_0(Almost_Full),
                           .ASYNC_FLUSH_0(Async_Flush) , .ASYNC_FLUSH_1(GND),
                           .ASYNC_FLUSH_S0(ASYNC_FLUSH_S0),
                           .ASYNC_FLUSH_S1(GND) , .CLK1_0(CLK1) , .CLK1_1(CLK1),
                           .CLK1EN_0(CLK1EN) , .CLK1EN_1(CLK1EN) , .CLK1S_0(GND),
                           .CLK1S_1(GND) , .CLK2_0(CLK2) , .CLK2_1(CLK2),
                           .CLK2EN_0(CLK2EN) , .CLK2EN_1(CLK2EN) , .CLK2S_0(GND),
                           .CLK2S_1(GND) , .CONCAT_EN_0(VCC) , .CONCAT_EN_1(GND),
                           .CS1_0(CS1) , .CS1_1(GND) , .CS2_0(CS2) , .CS2_1(GND),
                           .DIR_0(DIR) , .DIR_1(GND) , .FIFO_EN_0(FIFO_EN),
                           .FIFO_EN_1(GND) , .P1_0(P1) , .P1_1(GND) , .P2_0(P2),
                           .P2_1(GND) , .PIPELINE_RD_0(PIPELINE_RD),
                           .PIPELINE_RD_1(GND) , .POP_FLAG_0({ Pop_Flag[3:0] }),
                           .PUSH_FLAG_0({ Push_Flag[3:0] }),
                           .RD_0({ RD[17:0] }) , .SYNC_FIFO_0(SYNC_FIFO),
                           .SYNC_FIFO_1(GND) , .WD_0({ WD[17:0] }),
                           .WD_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .WEN1_0({ WE[1:0] }) , .WEN1_1({ GND,GND }),
                           .WIDTH_SELECT1_0({ WDS[1:0] }),
                           .WIDTH_SELECT1_1({ GND,GND }),
                           .WIDTH_SELECT2_0({ WDS[1:0] }),
                           .WIDTH_SELECT2_1({ GND,GND }), .Almost_Empty_1(), .Almost_Full_1(), .POP_FLAG_1(), .PUSH_FLAG_1(), .RD_1() );


endmodule /* ram16k_vc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ram8k 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ram8k
`else
`define ram8k

module ram8k ( Async_Flush , ASYNC_FLUSH_S0, CLK1, CLK1EN, CLK2, CLK2EN, CS1, CS2, DIR,
              FIFO_EN, P1, P2, PIPELINE_RD, RA, SYNC_FIFO, WA, WD,
              WDS, WE, Almost_Empty, Almost_Full, Pop_Flag, Push_Flag, RD )/* synthesis black_box */;

output Almost_Empty, Almost_Full;
input Async_Flush, ASYNC_FLUSH_S0;
input CLK1 /* synthesis syn_isclock=1 */;
input CLK1EN;
input CLK2 /* synthesis syn_isclock=1 */;
input CLK2EN, CS1, CS2, DIR, FIFO_EN, P1, P2, PIPELINE_RD;
output [3:0] Pop_Flag;
output [3:0] Push_Flag;
input [9:0] RA;
output [17:0] RD;
input  SYNC_FIFO;
input [9:0] WA;
input [17:0] WD;
input [1:0] WDS;
input [1:0] WE;supply0 GND;


ram8k_2x1_cell_macro I1  ( .A1_0({ GND,WA[9:0] }),
                           .A1_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .A2_0({ GND,RA[9:0] }),
                           .A2_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .Almost_Empty_0(Almost_Empty),
                           .Almost_Full_0(Almost_Full),
                           .ASYNC_FLUSH_0(Async_Flush) , .ASYNC_FLUSH_1(GND),
                           .ASYNC_FLUSH_S0(ASYNC_FLUSH_S0),
                           .ASYNC_FLUSH_S1(GND) , .CLK1_0(CLK1) , .CLK1_1(GND),
                           .CLK1EN_0(CLK1EN) , .CLK1EN_1(GND) , .CLK1S_0(GND),
                           .CLK1S_1(GND) , .CLK2_0(CLK2) , .CLK2_1(GND),
                           .CLK2EN_0(CLK2EN) , .CLK2EN_1(GND) , .CLK2S_0(GND),
                           .CLK2S_1(GND) , .CONCAT_EN_0(GND) , .CONCAT_EN_1(GND),
                           .CS1_0(CS1) , .CS1_1(GND) , .CS2_0(CS2) , .CS2_1(GND),
                           .DIR_0(DIR) , .DIR_1(GND) , .FIFO_EN_0(FIFO_EN),
                           .FIFO_EN_1(GND) , .P1_0(P1) , .P1_1(GND) , .P2_0(P2),
                           .P2_1(GND) , .PIPELINE_RD_0(PIPELINE_RD),
                           .PIPELINE_RD_1(GND) , .POP_FLAG_0({ Pop_Flag[3:0] }),
                           .PUSH_FLAG_0({ Push_Flag[3:0] }),
                           .RD_0({ RD[17:0] }) , .SYNC_FIFO_0(SYNC_FIFO),
                           .SYNC_FIFO_1(GND) , .WD_0({ WD[17:0] }),
                           .WD_1({ GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND }),
                           .WEN1_0({ WE[1:0] }) , .WEN1_1({ GND,GND }),
                           .WIDTH_SELECT1_0({ WDS[1:0] }),
                           .WIDTH_SELECT1_1({ GND,GND }),
                           .WIDTH_SELECT2_0({ WDS[1:0] }),
                           .WIDTH_SELECT2_1({ GND,GND }), .Almost_Empty_1(), .Almost_Full_1(), .POP_FLAG_1(), .PUSH_FLAG_1(), .RD_1() );


endmodule /* ram8k */
`endif



/*-------------------------------------------------------------------------------
 MODULE NAME : gclkbuff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef gclkbuff
`else
`define gclkbuff

module gclkbuff ( A , Z )/* synthesis black_box */;

input A;
output Z;

supply1 VCC;
supply0 GND;


qmux I1  ( .HSCKIN(A) , .IS0(VCC) , .IS1(VCC) , .IZ(Z) , .QCLKIN0(GND) , .QCLKIN1(GND),
           .QCLKIN2(GND) );


endmodule /* gclkbuff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecompai 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecompai
`else
`define ecompai

module ecompai ( A , B, EQ2 )/* synthesis black_box */;

input [1:0] A;
input [1:0] B;
output EQ2;

wire N_14;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(B[1]) , .BA2(B[1]) , .BAB(N_14) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[1]),
                       .CZ(EQ2) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(VCC) , .TAS1(GND),
                       .TAS2(GND) , .TB1(B[0]) , .TB2(B[0]) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(A[0]) , .TZ(N_14), .FZ(), .QZ() );


endmodule /* ecompai */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecompa 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecompa
`else
`define ecompa

module ecompa ( A , B, EQ2 )/* synthesis black_box */;

input [1:0] A;
input [1:0] B;
output EQ2;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(B[0]) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B[1]) , .BB2(B[1]) , .BBS1(VCC) , .BBS2(GND) , .BSL(A[1]),
                       .CZ(EQ2) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B[0]) , .TA2(GND) , .TAB(B[1]) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(B[0]) , .TBS(A[0]) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(A[1]), .FZ(), .QZ(), .TZ() );


endmodule /* ecompa */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecomp16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecomp16
`else
`define ecomp16

module ecomp16 ( A , B, EQ )/* synthesis black_box */;

input [15:0] A;
input [15:0] B;
output EQ;

wire N_77;
wire N_78;
wire N_79;
wire N_80;
supply1 VCC;
supply0 GND;
wire N_70;
wire N_72;
wire N_74;
wire N_76;


ecompa I21  ( .A({ A[1:0] }) , .B({ B[1:0] }) , .EQ2(N_77) );

ecompa I22  ( .A({ A[3:2] }) , .B({ B[3:2] }) , .EQ2(N_79) );

ecompa I23  ( .A({ A[7:6] }) , .B({ B[7:6] }) , .EQ2(N_74) );

ecompa I24  ( .A({ A[15:14] }) , .B({ B[15:14] }) , .EQ2(N_78) );

ecompa I25  ( .A({ A[11:10] }) , .B({ B[11:10] }) , .EQ2(N_70) );

ecompa I26  ( .A({ A[5:4] }) , .B({ B[5:4] }) , .EQ2(N_76) );

ecompa I_22  ( .A({ A[9:8] }) , .B({ B[9:8] }) , .EQ2(N_72) );

ecompa I27  ( .A({ A[13:12] }) , .B({ B[13:12] }) , .EQ2(N_80) );

and16i7 I_18  ( .A(N_77) , .B(N_79) , .C(N_76) , .D(N_74) , .E(N_72) , .F(N_70) , .G(N_80),
                .H(N_78) , .I(VCC) , .J(GND) , .K(GND) , .L(GND) , .M(GND) , .N(GND),
                .O(GND) , .P(GND) , .Q(EQ) );


endmodule /* ecomp16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecomp8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecomp8
`else
`define ecomp8

module ecomp8 ( A , B, EQ )/* synthesis black_box */;

input [7:0] A;
input [7:0] B;
output EQ;

wire N_1;
wire N_2;
wire N_3;
wire N_4;


ecompa I1  ( .A({ A[5:4] }) , .B({ B[5:4] }) , .EQ2(N_3) );

ecompa I2  ( .A({ A[1:0] }) , .B({ B[1:0] }) , .EQ2(N_1) );

ecompa I_9  ( .A({ A[3:2] }) , .B({ B[3:2] }) , .EQ2(N_4) );

ecompa I_7  ( .A({ A[7:6] }) , .B({ B[7:6] }) , .EQ2(N_2) );

and4i0 I_1  ( .A(N_1) , .B(N_4) , .C(N_3) , .D(N_2) , .Q(EQ) );


endmodule /* ecomp8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecomp4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecomp4
`else
`define ecomp4

module ecomp4 ( A , B, EQ )/* synthesis black_box */;

input [3:0] A;
input [3:0] B;
output EQ;

wire N_1;
wire N_2;


ecompa I1  ( .A({ A[1:0] }) , .B({ B[1:0] }) , .EQ2(N_2) );

ecompa I_8  ( .A({ A[3:2] }) , .B({ B[3:2] }) , .EQ2(N_1) );

and2i0 I_7  ( .A(N_2) , .B(N_1) , .Q(EQ) );


endmodule /* ecomp4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecomp32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecomp32
`else
`define ecomp32

module ecomp32 ( A , B, EQ )/* synthesis black_box */;

input [31:0] A;
input [31:0] B;
output EQ;

wire N_18;
wire N_19;
wire N_20;
wire N_2;
wire N_3;
wire N_4;
wire N_6;
wire N_7;
wire N_8;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_15;
wire N_16;
wire N_17;


ecompai I32  ( .A({ A[19:18] }) , .B({ B[19:18] }) , .EQ2(N_7) );

ecompai I33  ( .A({ A[23:22] }) , .B({ B[23:22] }) , .EQ2(N_11) );

ecompai I34  ( .A({ A[27:26] }) , .B({ B[27:26] }) , .EQ2(N_15) );

ecompai I35  ( .A({ A[31:30] }) , .B({ B[31:30] }) , .EQ2(N_17) );

ecompai I_35  ( .A({ A[29:28] }) , .B({ B[29:28] }) , .EQ2(N_16) );

ecompai I_21  ( .A({ A[25:24] }) , .B({ B[25:24] }) , .EQ2(N_13) );

ecompai I_19  ( .A({ A[21:20] }) , .B({ B[21:20] }) , .EQ2(N_20) );

ecompa I36  ( .A({ A[15:14] }) , .B({ B[15:14] }) , .EQ2(N_2) );

ecompa I37  ( .A({ A[11:10] }) , .B({ B[11:10] }) , .EQ2(N_4) );

ecompa I38  ( .A({ A[7:6] }) , .B({ B[7:6] }) , .EQ2(N_8) );

ecompa I39  ( .A({ A[3:2] }) , .B({ B[3:2] }) , .EQ2(N_12) );

ecompa I40  ( .A({ A[1:0] }) , .B({ B[1:0] }) , .EQ2(N_18) );

ecompa I41  ( .A({ A[17:16] }) , .B({ B[17:16] }) , .EQ2(N_19) );

ecompa I_36  ( .A({ A[13:12] }) , .B({ B[13:12] }) , .EQ2(N_3) );

ecompa I_31  ( .A({ A[5:4] }) , .B({ B[5:4] }) , .EQ2(N_10) );

ecompa I_34  ( .A({ A[9:8] }) , .B({ B[9:8] }) , .EQ2(N_6) );

and16i7 I_18  ( .A(N_18) , .B(N_12) , .C(N_10) , .D(N_8) , .E(N_6) , .F(N_4) , .G(N_3),
                .H(N_2) , .I(N_19) , .J(N_7) , .K(N_20) , .L(N_11) , .M(N_13) , .N(N_15),
                .O(N_16) , .P(N_17) , .Q(EQ) );


endmodule /* ecomp32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ecomp2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ecomp2
`else
`define ecomp2

module ecomp2 ( A , B, EQ )/* synthesis black_box */;

input [1:0] A;
input [1:0] B;
output EQ;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(N_11) , .BAS1(GND) , .BAS2(GND),
                       .BB1(A[0]) , .BB2(A[0]) , .BBS1(VCC) , .BBS2(GND) , .BSL(B[0]),
                       .CZ(EQ) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(B[1]) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A[1]) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* ecomp2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and9i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and9i4
`else
`define and9i4

module and9i4 ( A , B, C, D, E, F, G, H, I, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I;
output Q;

wire N_17;
wire N_16;
wire N_13;
wire N_14;
supply0 GND;
supply1 VCC;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_13) , .F2(GND) , .FS(I) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(N_17) , .TA2(GND) , .TAB(H) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(N_13), .CZ(), .QZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_16) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_17) , .F1(N_14) , .F2(GND) , .FS(F) , .FZ(N_16) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_14), .QZ() );


endmodule /* and9i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and8i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and8i1
`else
`define and8i1

module and8i1 ( A , B, C, D, E, F, G, H, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H;
output Q;

wire N_15;
wire N_14;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(N_15) , .TAB(H) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_14) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_15) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and8i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and8i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and8i0
`else
`define and8i0

module and8i0 ( A , B, C, D, E, F, G, H, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H;
output Q;

wire N_15;
wire N_14;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(H) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(N_15) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_14) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_15) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and8i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and7i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and7i1
`else
`define and7i1

module and7i1 ( A , B, C, D, E, F, G, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G;
output Q;

wire N_15;
wire N_14;
wire N_13;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(N_15),
                       .BB1(GND) , .BB2(GND) , .BBS1(N_15) , .BBS2(N_15) , .BSL(GND),
                       .F1(N_13) , .F2(GND) , .FS(G) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(N_15) , .TAS2(N_15),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(N_15) , .TBS2(N_15),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_14) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_13) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and7i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and7i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and7i0
`else
`define and7i0

module and7i0 ( A , B, C, D, E, F, G, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G;
output Q;

wire N_14;
wire N_13;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(N_13) , .FS(G) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_14) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_13) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and7i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i5
`else
`define and6i5

module and6i5 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_13;
wire N_12;
supply0 GND;
supply1 VCC;


logic_cell_macro I3  ( .BA1(N_12) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_13), .QZ() );


endmodule /* and6i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i4
`else
`define and6i4

module and6i4 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_13;
wire N_12;
supply0 GND;
supply1 VCC;


logic_cell_macro I3  ( .BA1(N_12) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(B) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* and6i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i1
`else
`define and6i1

module and6i1 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_12;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(N_12) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and6i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i0
`else
`define and6i0

module and6i0 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_12;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_12) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and6i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and16i7 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and16i7
`else
`define and16i7

module and16i7 ( A , B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P;
output Q;

wire N_17;
wire NET_TN;
wire NET_TE;
wire NET_TS;
supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_13;
wire N_16;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(NET_TN) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(NET_TS) , .BBS1(GND) , .BBS2(GND),
                       .BSL(NET_TE) , .CZ(N_13) , .F1(GND) , .F2(N_13) , .FS(N_12),
                       .FZ(Q) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                       .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(N) , .TA2(GND) , .TAB(M),
                       .TAS1(VCC) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(L) , .TZ(N_12), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(C) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(GND) , .F2(G) , .FS(F) , .FZ(NET_TE) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(D) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(E) , .TZ(NET_TN), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(H) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_16) , .BBS1(GND) , .BBS2(GND) , .BSL(I),
                       .CZ(N_17) , .F1(N_17) , .F2(GND) , .FS(K) , .FZ(NET_TS),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(P) , .TA2(GND) , .TAB(O),
                       .TAS1(VCC) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(J) , .TZ(N_16), .QZ() );


endmodule /* and16i7 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct8
`else
`define upfxct8

module upfxct8 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:7] D;
input EN, LOAD;
output [0:7] Q;wire N_1;
wire N_2;


upfxcar1 QL3  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }) , .ENG(EN),
                .LOAD(LOAD) , .Q({ Q[0:1] }) );

upfxct4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENG(EN) , .ENP(N_1) , .ENT(N_2),
               .LOAD(LOAD) , .Q({ Q[4:7] }) );

upfxct4a I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENG(EN) , .LOAD(LOAD),
               .Q({ Q[0:3] }) , .RCO(N_2) );


endmodule /* upfxct8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct4
`else
`define upfxct4

module upfxct4 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input EN, LOAD;
output [0:3] Q;supply0 GND;


upfxct4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENG(EN) , .ENP(GND) , .ENT(GND),
               .LOAD(LOAD) , .Q({ Q[0:3] }) );


endmodule /* upfxct4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct32
`else
`define upfxct32

module upfxct32 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:31] D;
input EN, LOAD;
output [0:31] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


upfxct4c I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[28:31] }) , .ENG(EN) , .ENP(N_1),
               .ENT(N_4) , .LOAD(LOAD) , .Q({ Q[28:31] }) );

upfxcar3 QL10  ( .ACO1(N_11) , .ACO2(N_10) , .ACO3(N_9) , .CLK(CLK) , .CLR(CLR),
                 .D({ D[0:1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0:1] }) );

upfxcar2 QL9  ( .ACO1(N_2) , .ACO2(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .ENG(EN) , .LOAD(LOAD) );

upfxcar2 QL8  ( .ACO1(N_6) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .ENG(EN) , .LOAD(LOAD) );

upfxct4a I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENG(EN) , .LOAD(LOAD),
               .Q({ Q[0:3] }) , .RCO(N_14) );

upfxct4b QL6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[24:27] }) , .ENG(EN) , .ENP(N_2),
                .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[24:27] }) , .RCO(N_4) );

upfxct4b QL5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20:23] }) , .ENG(EN) , .ENP(N_5),
                .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[20:23] }) , .RCO(N_3) );

upfxct4b QL4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16:19] }) , .ENG(EN) , .ENP(N_6),
                .ENT(N_7) , .LOAD(LOAD) , .Q({ Q[16:19] }) , .RCO(N_8) );

upfxct4b QL3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENG(EN) , .ENP(N_9),
                .ENT(N_13) , .LOAD(LOAD) , .Q({ Q[12:15] }) , .RCO(N_7) );

upfxct4b QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENG(EN) , .ENP(N_10),
                .ENT(N_12) , .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_13) );

upfxct4b QL1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENG(EN) , .ENP(N_11),
                .ENT(N_14) , .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_12) );


endmodule /* upfxct32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct24
`else
`define upfxct24

module upfxct24 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:23] D;
input EN, LOAD;
output [0:23] Q;wire N_11;
wire N_1;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


upfxct4c QL8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20:23] }) , .ENG(EN) , .ENP(N_1),
                .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[20:23] }) );

upfxcar3 QL7  ( .ACO1(N_7) , .ACO2(N_6) , .ACO3(N_5) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0:1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0:1] }) );

upfxcar2 QL6  ( .ACO1(N_11) , .ACO2(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .ENG(EN) , .LOAD(LOAD) );

upfxct4a I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENG(EN) , .LOAD(LOAD),
               .Q({ Q[0:3] }) , .RCO(N_10) );

upfxct4b QL4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16:19] }) , .ENG(EN) , .ENP(N_11),
                .ENT(N_4) , .LOAD(LOAD) , .Q({ Q[16:19] }) , .RCO(N_3) );

upfxct4b QL3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENG(EN) , .ENP(N_5),
                .ENT(N_9) , .LOAD(LOAD) , .Q({ Q[12:15] }) , .RCO(N_4) );

upfxct4b QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENG(EN) , .ENP(N_6),
                .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_9) );

upfxct4b QL1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENG(EN) , .ENP(N_7),
                .ENT(N_10) , .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_8) );


endmodule /* upfxct24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct16
`else
`define upfxct16

module upfxct16 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:15] D;
input EN, LOAD;
output [0:15] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


upfxcar3 QL5  ( .ACO1(N_3) , .ACO2(N_2) , .ACO3(N_1) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0:1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0:1] }) );

upfxct4c QL4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENG(EN) , .ENP(N_1),
                .ENT(N_5) , .LOAD(LOAD) , .Q({ Q[12:15] }) );

upfxct4b QL3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENG(EN) , .ENP(N_2),
                .ENT(N_4) , .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_5) );

upfxct4b QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENG(EN) , .ENP(N_3),
                .ENT(N_6) , .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_4) );

upfxct4a I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENG(EN) , .LOAD(LOAD),
               .Q({ Q[0:3] }) , .RCO(N_6) );


endmodule /* upfxct16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct8
`else
`define upflct8

module upflct8 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:7] D;
input LOAD;
output [0:7] Q;wire N_1;
supply0 GND;


upflcar1 QL3  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .LOAD(LOAD),
                .Q({ Q[0:3] }) );

upflct4c QL1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENP(N_1) , .ENT(GND),
                .LOAD(LOAD) , .Q({ Q[4:7] }) );

upflct4c QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENP(GND) , .ENT(GND),
                .LOAD(LOAD) , .Q({ Q[0:3] }) );


endmodule /* upflct8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct4
`else
`define upflct4

module upflct4 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input LOAD;
output [0:3] Q;supply0 GND;


upflct4c QL1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .ENP(GND) , .ENT(GND),
                .LOAD(LOAD) , .Q({ Q[0:3] }) );


endmodule /* upflct4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct32
`else
`define upflct32

module upflct32 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:31] D;
input LOAD;
output [0:31] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


upflct4a QL11  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .LOAD(LOAD) , .Q({ Q[0:3] }),
                 .RCO(N_14) );

upflct4b I3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[24:27] }) , .ENP(N_4) , .ENT(N_12),
               .LOAD(LOAD) , .Q({ Q[24:27] }) , .RCO(N_13) );

upflct4b QL9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20:23] }) , .ENP(N_7) , .ENT(N_11),
                .LOAD(LOAD) , .Q({ Q[20:23] }) , .RCO(N_12) );

upflct4b I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16:19] }) , .ENP(N_3) , .ENT(N_10),
               .LOAD(LOAD) , .Q({ Q[16:19] }) , .RCO(N_11) );

upflct4b QL8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENP(N_6) , .ENT(N_9),
                .LOAD(LOAD) , .Q({ Q[12:15] }) , .RCO(N_10) );

upflct4b I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENP(N_2) , .ENT(N_8),
               .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_9) );

upflct4b QL6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENP(N_5) , .ENT(N_14),
                .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_8) );

upflct4c I4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[28:31] }) , .ENP(N_1) , .ENT(N_13),
               .LOAD(LOAD) , .Q({ Q[28:31] }) );

upflcar2 QL3  ( .ACO1(N_6) , .ACO2(N_3) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .LOAD(LOAD) );

upflcar2 QL2  ( .ACO1(N_5) , .ACO2(N_2) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .LOAD(LOAD) );

upflcar3 QL1  ( .ACO1(N_7) , .ACO2(N_4) , .ACO3(N_1) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0:1] }) , .LOAD(LOAD) );


endmodule /* upflct32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct24
`else
`define upflct24

module upflct24 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:23] D;
input LOAD;
output [0:23] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


upflct4a QL8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .LOAD(LOAD) , .Q({ Q[0:3] }),
                .RCO(N_10) );

upflct4b I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16:19] }) , .ENP(N_2) , .ENT(N_4),
               .LOAD(LOAD) , .Q({ Q[16:19] }) , .RCO(N_5) );

upflct4b QL7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENP(N_3) , .ENT(N_9),
                .LOAD(LOAD) , .Q({ Q[12:15] }) , .RCO(N_4) );

upflct4b I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENP(N_6) , .ENT(N_8),
               .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_9) );

upflct4b QL5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENP(N_7) , .ENT(N_10),
                .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_8) );

upflct4c I3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20:23] }) , .ENP(N_1) , .ENT(N_5),
               .LOAD(LOAD) , .Q({ Q[20:23] }) );

upflcar2 QL2  ( .ACO1(N_7) , .ACO2(N_6) , .CLK(CLK) , .CLR(CLR) , .D({ D[0:1] }),
                .LOAD(LOAD) );

upflcar3 QL1  ( .ACO1(N_3) , .ACO2(N_2) , .ACO3(N_1) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0:1] }) , .LOAD(LOAD) );


endmodule /* upflct24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct16
`else
`define upflct16

module upflct16 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:15] D;
input LOAD;
output [0:15] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


upflct4a QL5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0:3] }) , .LOAD(LOAD) , .Q({ Q[0:3] }),
                .RCO(N_6) );

upflct4b QL4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8:11] }) , .ENP(N_2) , .ENT(N_4),
                .LOAD(LOAD) , .Q({ Q[8:11] }) , .RCO(N_5) );

upflct4b I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4:7] }) , .ENP(N_3) , .ENT(N_6),
               .LOAD(LOAD) , .Q({ Q[4:7] }) , .RCO(N_4) );

upflct4c I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12:15] }) , .ENP(N_1) , .ENT(N_5),
               .LOAD(LOAD) , .Q({ Q[12:15] }) );

upflcar3 QL1  ( .ACO1(N_3) , .ACO2(N_2) , .ACO3(N_1) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0:1] }) , .LOAD(LOAD) );


endmodule /* upflct16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : udcnt6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef udcnt6
`else
`define udcnt6

module udcnt6 ( CLK , CLR, ENP, ENT, UP, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENP, ENT;
output [5:0] Q;
output RCO;
input UP;

wire N_1;
wire N_2;


udcnt3b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENP(N_2) , .ENT(ENP) , .Q({ Q[3],Q[4],Q[5] }),
               .RCO(N_1) , .UP(UP) );

udcnt3a I_3  ( .CLK(CLK) , .CLR(CLR) , .ENP(ENP) , .ENT(ENT) , .Q({ Q[0],Q[1],Q[2] }),
               .RCO(N_2) , .UP(UP) );

nand2i1 I_1  ( .A(N_2) , .B(N_1) , .Q(RCO) );


endmodule /* udcnt6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : udcnt3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef udcnt3
`else
`define udcnt3

module udcnt3 ( CLK , CLR, ENP, ENT, UP, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENP, ENT;
output [2:0] Q;
output RCO;
input UP;



udcnt3a I_1  ( .CLK(CLK) , .CLR(CLR) , .ENP(ENP) , .ENT(ENT) , .Q({ Q[0],Q[1],Q[2] }),
               .RCO(RCO) , .UP(UP) );


endmodule /* udcnt3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : udcnt12 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef udcnt12
`else
`define udcnt12

module udcnt12 ( CLK , CLR, ENP, ENT, UP, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENP, ENT;
output [11:0] Q;
output RCO;
input UP;

wire N_1;
wire N_2;
wire N_3;
wire N_4;


udcnt3b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENP(N_4) , .ENT(N_2) , .Q({ Q[9],Q[10],Q[11] }),
               .RCO(N_1) , .UP(UP) );

udcnt3b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENP(N_4) , .ENT(N_3) , .Q({ Q[6],Q[7],Q[8] }),
               .RCO(N_2) , .UP(UP) );

udcnt3b I_4  ( .CLK(CLK) , .CLR(CLR) , .ENP(N_4) , .ENT(ENP) , .Q({ Q[3],Q[4],Q[5] }),
               .RCO(N_3) , .UP(UP) );

udcnt3a I_5  ( .CLK(CLK) , .CLR(CLR) , .ENP(ENP) , .ENT(ENT) , .Q({ Q[0],Q[1],Q[2] }),
               .RCO(N_4) , .UP(UP) );

nand2i1 I_1  ( .A(N_4) , .B(N_1) , .Q(RCO) );


endmodule /* udcnt12 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctx16p2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctx16p2
`else
`define uctx16p2

module uctx16p2 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input EN, LOAD;
output [15:0] Q;wire UCTXCO;
wire Q8BUFFN1;
wire Q3Q4Q5EN1;
wire Q3EN;
wire Q13BUFFN1;
wire Q12BUFFN1;
wire Q4BUFF1;
wire Q0BUFF1;
wire D0D1D2;
wire Q1Q2Q0N;
wire LDBUFFN3;
wire Q3Q4Q5EN2;
wire Q6Q7Q8;
wire Q9Q10Q11;
wire Q7BUFFN1;
wire Q6BUFF1;
wire LDBUFFN2;
wire ENBUFF1;
wire LDBUFFN1;
wire CO3;
wire CO2;
supply1 VCC;
supply0 GND;
wire CO1;


ucxco UCXCO1  ( .CLK(CLK) , .CO(UCTXCO) , .D_DEC(D0D1D2) , .EN(ENBUFF1),
                .LDBUF(LDBUFFN1) , .LOAD(LOAD) , .PRE(CLR) , .Q_DEC(Q1Q2Q0N) );

and4i1 I_94  ( .A(Q[7]) , .B(Q[6]) , .C(Q[8]) , .D(EN) , .Q(Q3Q4Q5EN2) );

and4i1 I_90  ( .A(Q[3]) , .B(Q[4]) , .C(Q[5]) , .D(EN) , .Q(Q3Q4Q5EN1) );

ucxbit2b UCTX13  ( .CLK(CLK) , .CLR(CLR) , .D(D[13]) , .ENH1(Q3Q4Q5EN2),
                   .ENH2(Q6Q7Q8) , .ENH3(Q9Q10Q11) , .ENH4(VCC) , .ENL1(CO3),
                   .ENL2(Q12BUFFN1) , .ENL3(GND) , .LOAD(LDBUFFN3) , .Q(Q[13]),
                   .QFB(Q13BUFFN1) );

ucxbit2b UCTX12  ( .CLK(CLK) , .CLR(CLR) , .D(D[12]) , .ENH1(Q3Q4Q5EN2),
                   .ENH2(Q6Q7Q8) , .ENH3(Q9Q10Q11) , .ENH4(VCC) , .ENL1(CO3),
                   .ENL2(GND) , .ENL3(GND) , .LOAD(LDBUFFN3) , .Q(Q[12]),
                   .QFB(Q12BUFFN1) );

ucxbit2b UCTX8  ( .CLK(CLK) , .CLR(CLR) , .D(D[8]) , .ENH1(Q3Q4Q5EN1) , .ENH2(Q6BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO2) , .ENL2(Q7BUFFN1) , .ENL3(GND),
                  .LOAD(LDBUFFN2) , .Q(Q[8]) , .QFB(Q8BUFFN1) );

ucxbit2b UCTX7  ( .CLK(CLK) , .CLR(CLR) , .D(D[7]) , .ENH1(Q3EN) , .ENH2(Q4BUFF1),
                  .ENH3(Q[5]) , .ENH4(Q6BUFF1) , .ENL1(CO1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN2) , .Q(Q[7]) , .QFB(Q7BUFFN1) );

ucxbit2a UCTX15  ( .CLK(CLK) , .CLR(CLR) , .D(D[15]) , .ENH1(Q3Q4Q5EN2),
                   .ENH2(Q6Q7Q8) , .ENH3(Q9Q10Q11) , .ENH4(Q[14]) , .ENL1(CO3),
                   .ENL2(Q12BUFFN1) , .ENL3(Q13BUFFN1) , .LOAD(LDBUFFN3) , .Q(Q[15]),
                   .QFB(Q[15]) );

ucxbit2a UCTX14  ( .CLK(CLK) , .CLR(CLR) , .D(D[14]) , .ENH1(Q3Q4Q5EN2),
                   .ENH2(Q6Q7Q8) , .ENH3(Q9Q10Q11) , .ENH4(VCC) , .ENL1(CO3),
                   .ENL2(Q12BUFFN1) , .ENL3(Q13BUFFN1) , .LOAD(LDBUFFN3) , .Q(Q[14]),
                   .QFB(Q[14]) );

ucxbit2a UCTX11  ( .CLK(CLK) , .CLR(CLR) , .D(D[11]) , .ENH1(Q3Q4Q5EN1),
                   .ENH2(Q6BUFF1) , .ENH3(Q[9]) , .ENH4(Q[10]) , .ENL1(CO2),
                   .ENL2(Q7BUFFN1) , .ENL3(Q8BUFFN1) , .LOAD(LDBUFFN3) , .Q(Q[11]),
                   .QFB(Q[11]) );

ucxbit2a UCTX10  ( .CLK(CLK) , .CLR(CLR) , .D(D[10]) , .ENH1(Q3Q4Q5EN1),
                   .ENH2(Q6BUFF1) , .ENH3(Q[9]) , .ENH4(VCC) , .ENL1(CO2),
                   .ENL2(Q7BUFFN1) , .ENL3(Q8BUFFN1) , .LOAD(LDBUFFN3) , .Q(Q[10]),
                   .QFB(Q[10]) );

ucxbit2a UCTX9  ( .CLK(CLK) , .CLR(CLR) , .D(D[9]) , .ENH1(Q3Q4Q5EN1) , .ENH2(Q6BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO2) , .ENL2(Q7BUFFN1),
                  .ENL3(Q8BUFFN1) , .LOAD(LDBUFFN2) , .Q(Q[9]) , .QFB(Q[9]) );

ucxbit2a UCTX6  ( .CLK(CLK) , .CLR(CLR) , .D(D[6]) , .ENH1(Q3EN) , .ENH2(Q4BUFF1),
                  .ENH3(Q[5]) , .ENH4(VCC) , .ENL1(CO1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN2) , .Q(Q[6]) , .QFB(Q6BUFF1) );

ucxbit2a UCTX5  ( .CLK(CLK) , .CLR(CLR) , .D(D[5]) , .ENH1(Q3EN) , .ENH2(Q4BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN2) , .Q(Q[5]) , .QFB(Q[5]) );

ucxbit2a UCTX4  ( .CLK(CLK) , .CLR(CLR) , .D(D[4]) , .ENH1(Q3EN) , .ENH2(VCC),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN2) , .Q(Q[4]) , .QFB(Q4BUFF1) );

ucxbit2a UCTX3  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENH1(Q0BUFF1) , .ENH2(Q[1]),
                  .ENH3(Q[2]) , .ENH4(VCC) , .ENL1(ENBUFF1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN1) , .Q(Q[3]) , .QFB(Q[3]) );

ucxbit2a UCTX2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENH1(Q0BUFF1) , .ENH2(Q[1]),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(ENBUFF1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN1) , .Q(Q[2]) , .QFB(Q[2]) );

ucxbit2a UCTX1  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENH1(Q0BUFF1) , .ENH2(VCC),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(ENBUFF1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN1) , .Q(Q[1]) , .QFB(Q[1]) );

ucxbit2a UCTX0  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENH1(VCC) , .ENH2(VCC),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(ENBUFF1) , .ENL2(GND) , .ENL3(GND),
                  .LOAD(LDBUFFN1) , .Q(Q[0]) , .QFB(Q0BUFF1) );

and3i0 I_95  ( .A(Q[9]) , .B(Q[10]) , .C(Q[11]) , .Q(Q9Q10Q11) );

and3i0 I_96  ( .A(Q[3]) , .B(Q[4]) , .C(Q[5]) , .Q(Q6Q7Q8) );

and3i0 I_104  ( .A(D[0]) , .B(D[1]) , .C(D[2]) , .Q(D0D1D2) );

inv I_111  ( .A(LOAD) , .Q(LDBUFFN3) );

inv I_99  ( .A(Q[13]) , .Q(Q13BUFFN1) );

inv I_100  ( .A(Q[12]) , .Q(Q12BUFFN1) );

inv I_34  ( .A(Q[7]) , .Q(Q7BUFFN1) );

inv I_92  ( .A(Q[8]) , .Q(Q8BUFFN1) );

inv I_107  ( .A(LOAD) , .Q(LDBUFFN2) );

and3i1 I_105  ( .A(Q[1]) , .B(Q[2]) , .C(Q[0]) , .Q(Q1Q2Q0N) );

and2i1 I_72  ( .A(Q[3]) , .B(EN) , .Q(Q3EN) );

buff I_93  ( .A(Q[6]) , .Q(Q6BUFF1) );

buff I_42  ( .A(Q[4]) , .Q(Q4BUFF1) );

buff I_32  ( .A(Q[0]) , .Q(Q0BUFF1) );

buff I_108  ( .A(EN) , .Q(ENBUFF1) );

buff I_114  ( .A(UCTXCO) , .Q(CO3) );

buff I_112  ( .A(UCTXCO) , .Q(CO1) );

buff I_113  ( .A(UCTXCO) , .Q(CO2) );


endmodule /* uctx16p2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucte16p2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucte16p2
`else
`define ucte16p2

module ucte16p2 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [15:0] Q;wire Q1Q2Q3;
wire UCTECO;
wire Q11BUFFN1;
wire Q10Q13;
wire Q12BUFFN1;
wire Q7Q8Q9;
wire Q4Q5Q6EN1;
wire Q4Q5Q6EN2;
wire Q8BUFFN1;
wire Q10BUFF1;
wire Q7BUFF1;
wire ENBUFFN2;
wire Q5BUFF1;
wire Q4BUFF1;
wire Q0BUFF1;
supply0 GND;
wire ENBUFFN1;
wire CO1A;
supply1 VCC;
wire CO1B;
wire CO1C;
wire N_13;


and2i0 I_62  ( .A(Q[10]) , .B(Q[13]) , .Q(Q10Q13) );

ucebit2b UCTE12  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN2) , .ENH2(Q7Q8Q9),
                   .ENH3(Q10BUFF1) , .ENH4(VCC) , .ENL1(CO1C) , .ENL2(GND),
                   .ENL3(Q11BUFFN1) , .Q(Q[12]) , .QFB(Q12BUFFN1) );

ucebit2b UCTE8  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN1) , .ENH2(Q7BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO1B) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[8]) , .QFB(Q8BUFFN1) );

mux4x2 I_34  ( .A(VCC) , .B(Q[0]) , .C(VCC) , .D(Q[0]) , .Q(N_13) , .S0(Q1Q2Q3),
               .S1(ENBUFFN1) );

inv I_57  ( .A(Q[8]) , .Q(Q8BUFFN1) );

inv I_56  ( .A(EN) , .Q(ENBUFFN2) );

inv I_35  ( .A(EN) , .Q(ENBUFFN1) );

inv I_44  ( .A(Q[11]) , .Q(Q11BUFFN1) );

inv I_58  ( .A(Q[12]) , .Q(Q12BUFFN1) );

and4i1 I_59  ( .A(Q[4]) , .B(Q[5]) , .C(Q[6]) , .D(EN) , .Q(Q4Q5Q6EN1) );

and4i1 I_45  ( .A(Q[4]) , .B(Q[5]) , .C(Q[6]) , .D(EN) , .Q(Q4Q5Q6EN2) );

buff I_60  ( .A(Q[7]) , .Q(Q7BUFF1) );

buff I_51  ( .A(Q[4]) , .Q(Q4BUFF1) );

buff I_47  ( .A(UCTECO) , .Q(CO1C) );

buff I_33  ( .A(UCTECO) , .Q(CO1A) );

buff I_32  ( .A(UCTECO) , .Q(CO1B) );

buff I_49  ( .A(Q[0]) , .Q(Q0BUFF1) );

buff I_63  ( .A(Q[10]) , .Q(Q10BUFF1) );

buff I_50  ( .A(Q[5]) , .Q(Q5BUFF1) );

and3i0 I_17  ( .A(Q[1]) , .B(Q[2]) , .C(Q[3]) , .Q(Q1Q2Q3) );

and3i0 I_61  ( .A(Q[7]) , .B(Q[8]) , .C(Q[9]) , .Q(Q7Q8Q9) );

dffp I_18  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(UCTECO) );

ucebit2a UCTE15  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN2) , .ENH2(Q7Q8Q9),
                   .ENH3(Q10Q13) , .ENH4(Q[14]) , .ENL1(CO1C) , .ENL2(Q11BUFFN1),
                   .ENL3(Q12BUFFN1) , .Q(Q[15]) , .QFB(Q[15]) );

ucebit2a UCTE14  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN2) , .ENH2(Q7Q8Q9),
                   .ENH3(Q10Q13) , .ENH4(VCC) , .ENL1(CO1C) , .ENL2(Q11BUFFN1),
                   .ENL3(Q12BUFFN1) , .Q(Q[14]) , .QFB(Q[14]) );

ucebit2a UCTE13  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN2) , .ENH2(Q7Q8Q9),
                   .ENH3(Q10BUFF1) , .ENH4(VCC) , .ENL1(CO1C) , .ENL2(Q11BUFFN1),
                   .ENL3(Q12BUFFN1) , .Q(Q[13]) , .QFB(Q[13]) );

ucebit2a UCTE11  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN1) , .ENH2(Q7BUFF1),
                   .ENH3(Q[9]) , .ENH4(Q10BUFF1) , .ENL1(CO1B) , .ENL2(Q8BUFFN1),
                   .ENL3(GND) , .Q(Q[11]) , .QFB(Q[11]) );

ucebit2a UCTE10  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN1) , .ENH2(Q7BUFF1),
                   .ENH3(Q[9]) , .ENH4(VCC) , .ENL1(CO1B) , .ENL2(Q8BUFFN1),
                   .ENL3(GND) , .Q(Q[10]) , .QFB(Q10BUFF1) );

ucebit2a UCTE9  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q4Q5Q6EN1) , .ENH2(Q7BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO1B) , .ENL2(Q8BUFFN1) , .ENL3(GND),
                  .Q(Q[9]) , .QFB(Q[9]) );

ucebit2a UCTE7  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN2) , .ENH2(Q4BUFF1),
                  .ENH3(Q5BUFF1) , .ENH4(Q[6]) , .ENL1(CO1A) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[7]) , .QFB(Q[7]) );

ucebit2a UCTE6  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN2) , .ENH2(Q4BUFF1),
                  .ENH3(Q5BUFF1) , .ENH4(VCC) , .ENL1(CO1A) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[6]) , .QFB(Q[6]) );

ucebit2a UCTE5  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN2) , .ENH2(Q4BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(CO1A) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[5]) , .QFB(Q5BUFF1) );

ucebit2a UCTE4  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN2) , .ENH2(VCC) , .ENH3(VCC),
                  .ENH4(VCC) , .ENL1(CO1A) , .ENL2(GND) , .ENL3(GND) , .Q(Q[4]),
                  .QFB(Q4BUFF1) );

ucebit2a UCTE3  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN1) , .ENH2(Q0BUFF1),
                  .ENH3(Q[1]) , .ENH4(Q[2]) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[3]) , .QFB(Q[3]) );

ucebit2a UCTE2  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN1) , .ENH2(Q0BUFF1),
                  .ENH3(Q[1]) , .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[2]) , .QFB(Q[2]) );

ucebit2a UCTE1  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN1) , .ENH2(Q0BUFF1),
                  .ENH3(VCC) , .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND),
                  .Q(Q[1]) , .QFB(Q[1]) );

ucebit2a UCTE0  ( .CLK(CLK) , .CLR(CLR) , .ENH1(ENBUFFN1) , .ENH2(VCC) , .ENH3(VCC),
                  .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[0]),
                  .QFB(Q0BUFF1) );


endmodule /* ucte16p2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uct8p2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uct8p2
`else
`define uct8p2

module uct8p2 ( CLK , CLR, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
output [7:0] Q;wire Q1Q2Q3;
wire N_1;
supply0 GND;
wire UCTCO;
supply1 VCC;


mux2x2 I_60  ( .A(GND) , .B(Q[0]) , .Q(N_1) , .S(Q1Q2Q3) );

dffc I_61  ( .CLK(CLK) , .CLR(CLR) , .D(N_1) , .Q(UCTCO) );

and3i0 I_17  ( .A(Q[1]) , .B(Q[2]) , .C(Q[3]) , .Q(Q1Q2Q3) );

ucebit2a UCT7  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[4]) , .ENH2(Q[5]) , .ENH3(Q[6]),
                 .ENH4(UCTCO) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[7]),
                 .QFB(Q[7]) );

ucebit2a UCT6  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[4]) , .ENH2(Q[5]) , .ENH3(UCTCO),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[6]),
                 .QFB(Q[6]) );

ucebit2a UCT5  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[4]) , .ENH2(UCTCO) , .ENH3(VCC),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[5]),
                 .QFB(Q[5]) );

ucebit2a UCT4  ( .CLK(CLK) , .CLR(CLR) , .ENH1(UCTCO) , .ENH2(VCC) , .ENH3(VCC),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[4]),
                 .QFB(Q[4]) );

ucebit2a UCT3  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[0]) , .ENH2(Q[1]) , .ENH3(Q[2]),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[3]),
                 .QFB(Q[3]) );

ucebit2a UCT2  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[0]) , .ENH2(Q[1]) , .ENH3(VCC),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[2]),
                 .QFB(Q[2]) );

ucebit2a UCT1  ( .CLK(CLK) , .CLR(CLR) , .ENH1(Q[0]) , .ENH2(VCC) , .ENH3(VCC),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[1]),
                 .QFB(Q[1]) );

ucebit2a UCT0  ( .CLK(CLK) , .CLR(CLR) , .ENH1(VCC) , .ENH2(VCC) , .ENH3(VCC),
                 .ENH4(VCC) , .ENL1(GND) , .ENL2(GND) , .ENL3(GND) , .Q(Q[0]),
                 .QFB(Q[0]) );


endmodule /* uct8p2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx8
`else
`define ucntx8

module ucntx8 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input EN, LOAD;
output [7:0] Q;wire N_1;
wire N_2;


uctxcar1 I_1  ( .ACO1(N_2) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }) , .ENG(EN),
                .LOAD(LOAD) , .Q({ Q[0],Q[1] }) );

ucntx4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENG(EN) , .ENP(N_2) , .ENT(N_1),
              .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) );

ucntx4a I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_1) );


endmodule /* ucntx8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx4
`else
`define ucntx4

module ucntx4 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input EN, LOAD;
output [3:0] Q;supply0 GND;


ucntx4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENG(EN) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );


endmodule /* ucntx4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx32
`else
`define ucntx32

module ucntx32 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [31:0] D;
input EN, LOAD;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


ucntx4c I14  ( .CLK(CLK) , .CLR(CLR) , .D({ D[28],D[29],D[30],D[31] }) , .ENG(EN) , .ENP(N_14),
               .ENT(N_11) , .LOAD(LOAD) , .Q({ Q[28],Q[29],Q[30],Q[31] }) );

ucntx4a I7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_1) );

ucntx4b I10  ( .CLK(CLK) , .CLR(CLR) , .D({ D[24],D[25],D[26],D[27] }) , .ENG(EN) , .ENP(N_13),
               .ENT(N_12) , .LOAD(LOAD) , .Q({ Q[24],Q[25],Q[26],Q[27] }) , .RCO(N_11) );

ucntx4b I8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20],D[21],D[22],D[23] }) , .ENG(EN) , .ENP(N_10),
              .ENT(N_7) , .LOAD(LOAD) , .Q({ Q[20],Q[21],Q[22],Q[23] }) , .RCO(N_12) );

ucntx4b I9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16],D[17],D[18],D[19] }) , .ENG(EN) , .ENP(N_9),
              .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_7) );

ucntx4b I11  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENG(EN) , .ENP(N_6),
               .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_8) );

ucntx4b I12  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENG(EN) , .ENP(N_5),
               .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucntx4b I13  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENG(EN) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_3) );

uctxcar2 I_9  ( .ACO1(N_13) , .ACO2(N_14) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                .ENG(EN) , .LOAD(LOAD) );

uctxcar2 I_10  ( .ACO1(N_9) , .ACO2(N_10) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                 .ENG(EN) , .LOAD(LOAD) );

uctxcar3 I_11  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                 .D({ D[0],D[1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0],Q[1] }) );


endmodule /* ucntx32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx24
`else
`define ucntx24

module ucntx24 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [23:0] D;
input EN, LOAD;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


uctxcar3 I_1  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0],D[1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0],Q[1] }) );

uctxcar2 I_2  ( .ACO1(N_9) , .ACO2(N_10) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                .ENG(EN) , .LOAD(LOAD) );

ucntx4c I3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20],D[21],D[22],D[23] }) , .ENG(EN) , .ENP(N_10),
              .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[20],Q[21],Q[22],Q[23] }) );

ucntx4b I5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16],D[17],D[18],D[19] }) , .ENG(EN) , .ENP(N_9),
              .ENT(N_7) , .LOAD(LOAD) , .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_8) );

ucntx4b I4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENG(EN) , .ENP(N_6),
              .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_7) );

ucntx4b I6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENG(EN) , .ENP(N_5) , .ENT(N_3),
              .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucntx4b I7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENG(EN) , .ENP(N_4) , .ENT(N_1),
              .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_3) );

ucntx4a I8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_1) );


endmodule /* ucntx24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx16
`else
`define ucntx16

module ucntx16 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input EN, LOAD;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


ucntx4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENG(EN) , .ENP(N_6),
              .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) );

uctxcar3 I_2  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0],D[1] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[0],Q[1] }) );

ucntx4b I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENG(EN) , .ENP(N_5) , .ENT(N_3),
              .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucntx4b I3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENG(EN) , .ENP(N_4) , .ENT(N_1),
              .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_3) );

ucntx4a I4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_1) );


endmodule /* ucntx16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl8
`else
`define ucntl8

module ucntl8 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input LOAD;
output [7:0] Q;wire N_1;
supply0 GND;


uctlcar1 I_1  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .LOAD(LOAD),
                .Q({ Q[0],Q[1],Q[2],Q[3] }) );

ucntl4c I_2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENP(N_1) , .ENT(GND),
               .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) );

ucntl4c I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENP(GND) , .ENT(GND),
               .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );


endmodule /* ucntl8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl4
`else
`define ucntl4

module ucntl4 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input LOAD;
output [3:0] Q;supply0 GND;


ucntl4c I_1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .ENP(GND) , .ENT(GND),
               .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );


endmodule /* ucntl4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl32
`else
`define ucntl32

module ucntl32 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [31:0] D;
input LOAD;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


uctlcar3 I_1  ( .ACO1(N_8) , .ACO2(N_11) , .ACO3(N_14) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0],D[1] }) , .LOAD(LOAD) );

uctlcar2 I_2  ( .ACO1(N_9) , .ACO2(N_12) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                .LOAD(LOAD) );

uctlcar2 I_3  ( .ACO1(N_10) , .ACO2(N_13) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                .LOAD(LOAD) );

ucntl4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[24],D[25],D[26],D[27] }) , .ENP(N_11) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[24],Q[25],Q[26],Q[27] }) , .RCO(N_2) );

ucntl4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20],D[21],D[22],D[23] }) , .ENP(N_8) , .ENT(N_4),
               .LOAD(LOAD) , .Q({ Q[20],Q[21],Q[22],Q[23] }) , .RCO(N_3) );

ucntl4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16],D[17],D[18],D[19] }) , .ENP(N_12) , .ENT(N_5),
               .LOAD(LOAD) , .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_4) );

ucntl4b I_7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENP(N_9) , .ENT(N_6),
               .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_5) );

ucntl4b I_8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENP(N_13) , .ENT(N_7),
               .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_6) );

ucntl4b I_9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENP(N_10) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_7) );

ucntl4a I_10  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }),
                .RCO(N_1) );

ucntl4c I_11  ( .CLK(CLK) , .CLR(CLR) , .D({ D[28],D[29],D[30],D[31] }) , .ENP(N_14) , .ENT(N_2),
                .LOAD(LOAD) , .Q({ Q[28],Q[29],Q[30],Q[31] }) );


endmodule /* ucntl32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl24
`else
`define ucntl24

module ucntl24 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [23:0] D;
input LOAD;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


uctlcar2 I_1  ( .ACO1(N_4) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1] }),
                .LOAD(LOAD) );

uctlcar3 I_2  ( .ACO1(N_8) , .ACO2(N_9) , .ACO3(N_10) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0],D[1] }) , .LOAD(LOAD) );

ucntl4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[16],D[17],D[18],D[19] }) , .ENP(N_9) , .ENT(N_7),
               .LOAD(LOAD) , .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_6) );

ucntl4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENP(N_8) , .ENT(N_2),
               .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_7) );

ucntl4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENP(N_5) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucntl4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_3) );

ucntl4a I_7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }),
               .RCO(N_1) );

ucntl4c I_8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[20],D[21],D[22],D[23] }) , .ENP(N_10) , .ENT(N_6),
               .LOAD(LOAD) , .Q({ Q[20],Q[21],Q[22],Q[23] }) );


endmodule /* ucntl24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl16
`else
`define ucntl16

module ucntl16 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input LOAD;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


ucntl4c I_1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[12],D[13],D[14],D[15] }) , .ENP(N_6) , .ENT(N_2),
               .LOAD(LOAD) , .Q({ Q[12],Q[13],Q[14],Q[15] }) );

uctlcar3 I_2  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[0],D[1] }) , .LOAD(LOAD) );

ucntl4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[8],D[9],D[10],D[11] }) , .ENP(N_5) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucntl4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[4],D[5],D[6],D[7] }) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_3) );

ucntl4a I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[0],D[1],D[2],D[3] }) , .LOAD(LOAD) , .Q({ Q[0],Q[1],Q[2],Q[3] }),
               .RCO(N_1) );


endmodule /* ucntl16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte8
`else
`define ucnte8

module ucnte8 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [7:0] Q;wire N_1;
supply0 GND;


uctecar1 I_1  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );

ucnte4c I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_1) , .ENT(GND) , .Q({ Q[4],Q[5],Q[6],Q[7] }) );

ucnte4c I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(EN) , .ENT(GND) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );


endmodule /* ucnte8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte4
`else
`define ucnte4

module ucnte4 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [3:0] Q;supply0 GND;


ucnte4c I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(GND) , .ENT(GND) , .Q({ Q[0],Q[1],Q[2],Q[3] }) );


endmodule /* ucnte4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte32
`else
`define ucnte32

module ucnte32 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


ucnte4b I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_3) , .ENT(N_13),
               .Q({ Q[24],Q[25],Q[26],Q[27] }) , .RCO(N_14) );

ucnte4b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_2) , .ENT(N_1),
               .Q({ Q[20],Q[21],Q[22],Q[23] }) , .RCO(N_13) );

ucnte4b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_6),
               .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_1) );

ucnte4b I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_10) , .ENT(N_7),
               .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_6) );

ucnte4b I_5  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_12) , .ENT(N_8),
               .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_7) );

ucnte4b I_6  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_11) , .ENT(N_9),
               .Q({ Q[4],Q[5],Q[6],Q[7] }) , .RCO(N_8) );

ucnte4a I_7  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_9) );

ucnte4c I_8  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_14),
               .Q({ Q[28],Q[29],Q[30],Q[31] }) );

upfecar2 QL9  ( .ACO1(N_10) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

upfecar2 QL10  ( .ACO1(N_11) , .ACO2(N_12) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

upfecar3 QL11  ( .ACO1(N_2) , .ACO2(N_3) , .ACO3(N_4) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* ucnte32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte24
`else
`define ucnte24

module ucnte24 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


ucnte4c I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_6) , .ENT(N_9),
               .Q({ Q[20],Q[21],Q[22],Q[23] }) );

ucnte4b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_7) , .ENT(N_10),
               .Q({ Q[16],Q[17],Q[18],Q[19] }) , .RCO(N_9) );

ucnte4b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_8) , .ENT(N_1),
               .Q({ Q[12],Q[13],Q[14],Q[15] }) , .RCO(N_10) );

ucnte4b I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_2),
               .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_1) );

ucnte4b I_5  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_3) , .Q({ Q[4],Q[5],Q[6],Q[7] }),
               .RCO(N_2) );

ucnte4a I_6  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_3) );

upfecar2 QL7  ( .ACO1(N_4) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

upfecar3 QL8  ( .ACO1(N_8) , .ACO2(N_7) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* ucnte24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte16
`else
`define ucnte16

module ucnte16 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


ucnte4c I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_2),
               .Q({ Q[12],Q[13],Q[14],Q[15] }) );

ucnte4b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_3),
               .Q({ Q[8],Q[9],Q[10],Q[11] }) , .RCO(N_2) );

ucnte4b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_6) , .ENT(N_1) , .Q({ Q[4],Q[5],Q[6],Q[7] }),
               .RCO(N_3) );

ucnte4a I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[0],Q[1],Q[2],Q[3] }) , .RCO(N_1) );

upfecar3 QL5  ( .ACO1(N_6) , .ACO2(N_5) , .ACO3(N_4) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* ucnte16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rcnt4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rcnt4
`else
`define rcnt4

module rcnt4 ( CI , CLK, CLR, D, LOAD, CO, Q )/* synthesis black_box */;

input CI;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output CO;
input [3:0] D;
input LOAD;
output [3:0] Q;wire N_1;
supply1 VCC;
wire N_2;
wire N_3;
wire N_4;


and2i0 I_1  ( .A(N_1) , .B(Q[3]) , .Q(CO) );

ripbit QL1  ( .CI(N_3) , .CLK(CLK) , .CLR(CLR) , .CO(N_1) , .CX(Q[2]) , .D(D[3]),
              .LOAD(LOAD) , .Q(Q[3]) );

ripbit QL2  ( .CI(N_2) , .CLK(CLK) , .CLR(CLR) , .CO(N_3) , .CX(Q[1]) , .D(D[2]),
              .LOAD(LOAD) , .Q(Q[2]) );

ripbit QL3  ( .CI(N_4) , .CLK(CLK) , .CLR(CLR) , .CO(N_2) , .CX(Q[0]) , .D(D[1]),
              .LOAD(LOAD) , .Q(Q[1]) );

ripbit QL4  ( .CI(CI) , .CLK(CLK) , .CLR(CLR) , .CO(N_4) , .CX(VCC) , .D(D[0]),
              .LOAD(LOAD) , .Q(Q[0]) );


endmodule /* rcnt4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rcnt8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rcnt8
`else
`define rcnt8

module rcnt8 ( CI , CLK, CLR, D, LOAD, CO, Q )/* synthesis black_box */;

input CI;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output CO;
input [7:0] D;
input LOAD;
output [7:0] Q;wire N_1;


rcnt4 QL3  ( .CI(N_1) , .CLK(CLK) , .CLR(CLR) , .CO(CO) , .D({ D[7:4] }) , .LOAD(LOAD),
             .Q({ Q[7:4] }) );

rcnt4 QL4  ( .CI(CI) , .CLK(CLK) , .CLR(CLR) , .CO(N_1) , .D({ D[3:0] }) , .LOAD(LOAD),
             .Q({ Q[3:0] }) );


endmodule /* rcnt8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rcnt16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rcnt16
`else
`define rcnt16

module rcnt16 ( CI , CLK, CLR, D, LOAD, CO, Q )/* synthesis black_box */;

input CI;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output CO;
input [15:0] D;
input LOAD;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;


rcnt4 QL5  ( .CI(N_1) , .CLK(CLK) , .CLR(CLR) , .CO(CO) , .D({ D[15:12] }) , .LOAD(LOAD),
             .Q({ Q[15:12] }) );

rcnt4 QL6  ( .CI(N_2) , .CLK(CLK) , .CLR(CLR) , .CO(N_1) , .D({ D[11:8] }) , .LOAD(LOAD),
             .Q({ Q[11:8] }) );

rcnt4 QL7  ( .CI(N_3) , .CLK(CLK) , .CLR(CLR) , .CO(N_2) , .D({ D[7:4] }) , .LOAD(LOAD),
             .Q({ Q[7:4] }) );

rcnt4 QL8  ( .CI(CI) , .CLK(CLK) , .CLR(CLR) , .CO(N_3) , .D({ D[3:0] }) , .LOAD(LOAD),
             .Q({ Q[3:0] }) );


endmodule /* rcnt16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx8
`else
`define dcntx8

module dcntx8 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input EN, LOAD;
output [7:0] Q;wire N_1;
wire N_2;


dctxcar1 I_1  ( .ACO1(N_2) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }) , .ENG(EN),
                .LOAD(LOAD) , .Q({ Q[1:0] }) );

dcntx4a I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[3:0] }) , .RCO(N_1) );

dcntx4c I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENG(EN) , .ENP(N_2) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) );


endmodule /* dcntx8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx4
`else
`define dcntx4

module dcntx4 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input EN, LOAD;
output [3:0] Q;supply1 VCC;


dcntx4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENG(EN) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q({ Q[3:0] }) );


endmodule /* dcntx4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx32
`else
`define dcntx32

module dcntx32 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [31:0] D;
input EN, LOAD;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


dcntx4c I9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[31:28] }) , .ENG(EN) , .ENP(N_14),
              .ENT(N_11) , .LOAD(LOAD) , .Q({ Q[31:28] }) );

dctxcar2 I_1  ( .ACO1(N_13) , .ACO2(N_14) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .ENG(EN) , .LOAD(LOAD) );

dctxcar2 I_2  ( .ACO1(N_9) , .ACO2(N_10) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .ENG(EN) , .LOAD(LOAD) );

dctxcar3 I_3  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[1:0] }) );

dcntx4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[27:24] }) , .ENG(EN) , .ENP(N_13),
               .ENT(N_12) , .LOAD(LOAD) , .Q({ Q[27:24] }) , .RCO(N_11) );

dcntx4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[23:20] }) , .ENG(EN) , .ENP(N_10),
               .ENT(N_7) , .LOAD(LOAD) , .Q({ Q[23:20] }) , .RCO(N_12) );

dcntx4b I_7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[19:16] }) , .ENG(EN) , .ENP(N_9),
               .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[19:16] }) , .RCO(N_7) );

dcntx4b I_8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENG(EN) , .ENP(N_6),
               .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[15:12] }) , .RCO(N_8) );

dcntx4b I_9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENG(EN) , .ENP(N_5),
               .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_2) );

dcntx4b I_10  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENG(EN) , .ENP(N_4),
                .ENT(N_1) , .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_3) );

dcntx4a I8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[3:0] }) , .RCO(N_1) );


endmodule /* dcntx32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx24
`else
`define dcntx24

module dcntx24 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [23:0] D;
input EN, LOAD;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


dctxcar3 I_1  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[1:0] }) );

dcntx4c I4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[23:20] }) , .ENG(EN) , .ENP(N_10),
              .ENT(N_8) , .LOAD(LOAD) , .Q({ Q[23:20] }) );

dcntx4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[19:16] }) , .ENG(EN) , .ENP(N_9),
               .ENT(N_7) , .LOAD(LOAD) , .Q({ Q[19:16] }) , .RCO(N_8) );

dcntx4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENG(EN) , .ENP(N_6),
               .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[15:12] }) , .RCO(N_7) );

dcntx4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENG(EN) , .ENP(N_5),
               .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_2) );

dcntx4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENG(EN) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_3) );

dcntx4a I5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[3:0] }) , .RCO(N_1) );

dctxcar2 I_8  ( .ACO1(N_9) , .ACO2(N_10) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .ENG(EN) , .LOAD(LOAD) );


endmodule /* dcntx24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx16
`else
`define dcntx16

module dcntx16 ( CLK , CLR, D, EN, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input EN, LOAD;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


dcntx4c I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENG(EN) , .ENP(N_6),
              .ENT(N_2) , .LOAD(LOAD) , .Q({ Q[15:12] }) );

dcntx4b I_2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENG(EN) , .ENP(N_5),
               .ENT(N_3) , .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_2) );

dcntx4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENG(EN) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_3) );

dcntx4a I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENG(EN) , .LOAD(LOAD),
              .Q({ Q[3:0] }) , .RCO(N_1) );

dctxcar3 I_5  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .ENG(EN) , .LOAD(LOAD) , .Q({ Q[1:0] }) );


endmodule /* dcntx16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl8
`else
`define dcntl8

module dcntl8 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input LOAD;
output [7:0] Q;supply1 VCC;
wire N_1;


dctlcar1 I_1  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LOAD(LOAD),
                .Q({ Q[3:0] }) );

dcntl4c I_2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENP(N_1) , .ENT(VCC),
               .LOAD(LOAD) , .Q({ Q[7:4] }) );

dcntl4c I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENP(VCC) , .ENT(VCC),
               .LOAD(LOAD) , .Q({ Q[3:0] }) );


endmodule /* dcntl8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl4
`else
`define dcntl4

module dcntl4 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input LOAD;
output [3:0] Q;supply1 VCC;


dcntl4c I_1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .ENP(VCC) , .ENT(VCC),
               .LOAD(LOAD) , .Q({ Q[3:0] }) );


endmodule /* dcntl4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl32
`else
`define dcntl32

module dcntl32 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [31:0] D;
input LOAD;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


dctlcar3 I_1  ( .ACO1(N_8) , .ACO2(N_11) , .ACO3(N_14) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .LOAD(LOAD) );

dctlcar2 I_3  ( .ACO1(N_9) , .ACO2(N_12) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .LOAD(LOAD) );

dctlcar2 I_2  ( .ACO1(N_10) , .ACO2(N_13) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .LOAD(LOAD) );

dcntl4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[27:24] }) , .ENP(N_11) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[27:24] }) , .RCO(N_2) );

dcntl4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[23:20] }) , .ENP(N_8) , .ENT(N_4),
               .LOAD(LOAD) , .Q({ Q[23:20] }) , .RCO(N_3) );

dcntl4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[19:16] }) , .ENP(N_12) , .ENT(N_5),
               .LOAD(LOAD) , .Q({ Q[19:16] }) , .RCO(N_4) );

dcntl4b I_7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENP(N_9) , .ENT(N_6),
               .LOAD(LOAD) , .Q({ Q[15:12] }) , .RCO(N_5) );

dcntl4b I_8  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENP(N_13) , .ENT(N_7),
               .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_6) );

dcntl4b I_9  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENP(N_10) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_7) );

dcntl4a I_10  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LOAD(LOAD) , .Q({ Q[3:0] }),
                .RCO(N_1) );

dcntl4c I_11  ( .CLK(CLK) , .CLR(CLR) , .D({ D[31:28] }) , .ENP(N_14) , .ENT(N_2),
                .LOAD(LOAD) , .Q({ Q[31:28] }) );


endmodule /* dcntl32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl24
`else
`define dcntl24

module dcntl24 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [23:0] D;
input LOAD;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


dcntl4c I_1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[23:20] }) , .ENP(N_10) , .ENT(N_6),
               .LOAD(LOAD) , .Q({ Q[23:20] }) );

dctlcar3 I_2  ( .ACO1(N_8) , .ACO2(N_9) , .ACO3(N_10) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .LOAD(LOAD) );

dcntl4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[19:16] }) , .ENP(N_9) , .ENT(N_7),
               .LOAD(LOAD) , .Q({ Q[19:16] }) , .RCO(N_6) );

dcntl4b I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENP(N_8) , .ENT(N_2),
               .LOAD(LOAD) , .Q({ Q[15:12] }) , .RCO(N_7) );

dcntl4b I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENP(N_5) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_2) );

dcntl4b I_6  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_3) );

dcntl4a I_7  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LOAD(LOAD) , .Q({ Q[3:0] }),
               .RCO(N_1) );

dctlcar2 I_8  ( .ACO1(N_4) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .D({ D[1:0] }),
                .LOAD(LOAD) );


endmodule /* dcntl24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl16
`else
`define dcntl16

module dcntl16 ( CLK , CLR, D, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input LOAD;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


dctlcar3 I_1  ( .ACO1(N_4) , .ACO2(N_5) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR),
                .D({ D[1:0] }) , .LOAD(LOAD) );

dcntl4b I_2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .ENP(N_5) , .ENT(N_3),
               .LOAD(LOAD) , .Q({ Q[11:8] }) , .RCO(N_2) );

dcntl4b I_3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .ENP(N_4) , .ENT(N_1),
               .LOAD(LOAD) , .Q({ Q[7:4] }) , .RCO(N_3) );

dcntl4a I_4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LOAD(LOAD) , .Q({ Q[3:0] }),
               .RCO(N_1) );

dcntl4c I_5  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .ENP(N_6) , .ENT(N_2),
               .LOAD(LOAD) , .Q({ Q[15:12] }) );


endmodule /* dcntl16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte8
`else
`define dcnte8

module dcnte8 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [7:0] Q;wire N_1;
supply1 VCC;


dctecar1 I_1  ( .ACO1(N_1) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[3:0] }) );

dcnte4c I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_1) , .ENT(VCC) , .Q({ Q[7:4] }) );

dcnte4c I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(EN) , .ENT(VCC) , .Q({ Q[3:0] }) );


endmodule /* dcnte8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte4
`else
`define dcnte4

module dcnte4 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [3:0] Q;supply1 VCC;


dcnte4c I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(VCC) , .ENT(VCC) , .Q({ Q[3:0] }) );


endmodule /* dcnte4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte32
`else
`define dcnte32

module dcnte32 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [31:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;


dcnte4c I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_14),
               .Q({ Q[31:28] }) );

dcnte4b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_3) , .ENT(N_13),
               .Q({ Q[27:24] }) , .RCO(N_14) );

dcnte4b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_2) , .ENT(N_1),
               .Q({ Q[23:20] }) , .RCO(N_13) );

dcnte4b I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_6),
               .Q({ Q[19:16] }) , .RCO(N_1) );

dcnte4b I_5  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_10) , .ENT(N_7),
               .Q({ Q[15:12] }) , .RCO(N_6) );

dcnte4b I_6  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_12) , .ENT(N_8),
               .Q({ Q[11:8] }) , .RCO(N_7) );

dcnte4b I_7  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_11) , .ENT(N_9),
               .Q({ Q[7:4] }) , .RCO(N_8) );

dcnte4a I_8  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[3:0] }) , .RCO(N_9) );

dnfecar3 QL9  ( .ACO1(N_2) , .ACO2(N_3) , .ACO3(N_4) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

dnfecar2 QL10  ( .ACO1(N_10) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

dnfecar2 QL11  ( .ACO1(N_11) , .ACO2(N_12) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* dcnte32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte24 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte24
`else
`define dcnte24

module dcnte24 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [23:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;


dcnte4b I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_7) , .ENT(N_10),
               .Q({ Q[19:16] }) , .RCO(N_9) );

dcnte4b I_5  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_8) , .ENT(N_1),
               .Q({ Q[15:12] }) , .RCO(N_10) );

dcnte4b I_6  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_2),
               .Q({ Q[11:8] }) , .RCO(N_1) );

dcnte4b I_7  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_3) , .Q({ Q[7:4] }),
               .RCO(N_2) );

dcnte4a I_8  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[3:0] }) , .RCO(N_3) );

dcnte4c I_9  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_6) , .ENT(N_9),
               .Q({ Q[23:20] }) );

dnfecar2 QL2  ( .ACO1(N_4) , .ACO2(N_5) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );

dnfecar3 QL7  ( .ACO1(N_8) , .ACO2(N_7) , .ACO3(N_6) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* dcnte24 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgec8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgec8
`else
`define rgec8

module rgec8 ( CLK , CLR, D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input EN;
output [7:0] Q;supply0 GND;


dffepc I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[7]) , .EN(EN) , .PRE(GND) , .Q(Q[7]) );

dffepc QL8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .EN(EN) , .PRE(GND) , .Q(Q[0]) );

dffepc QL7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .EN(EN) , .PRE(GND) , .Q(Q[1]) );

dffepc QL6  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .EN(EN) , .PRE(GND) , .Q(Q[2]) );

dffepc QL5  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .EN(EN) , .PRE(GND) , .Q(Q[3]) );

dffepc I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[6]) , .EN(EN) , .PRE(GND) , .Q(Q[6]) );

dffepc I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[5]) , .EN(EN) , .PRE(GND) , .Q(Q[5]) );

dffepc I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[4]) , .EN(EN) , .PRE(GND) , .Q(Q[4]) );


endmodule /* rgec8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgec4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgec4
`else
`define rgec4

module rgec4 ( CLK , CLR, D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input EN;
output [3:0] Q;supply0 GND;


dffepc I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .EN(EN) , .PRE(GND) , .Q(Q[3]) );

dffepc I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .EN(EN) , .PRE(GND) , .Q(Q[2]) );

dffepc I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .EN(EN) , .PRE(GND) , .Q(Q[1]) );

dffepc I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .EN(EN) , .PRE(GND) , .Q(Q[0]) );


endmodule /* rgec4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgec16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgec16
`else
`define rgec16

module rgec16 ( CLK , CLR, D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input EN;
output [15:0] Q;supply0 GND;


dffepc I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[12]) , .EN(EN) , .PRE(GND) , .Q(Q[12]) );

dffepc I6  ( .CLK(CLK) , .CLR(CLR) , .D(D[13]) , .EN(EN) , .PRE(GND) , .Q(Q[13]) );

dffepc I7  ( .CLK(CLK) , .CLR(CLR) , .D(D[14]) , .EN(EN) , .PRE(GND) , .Q(Q[14]) );

dffepc I8  ( .CLK(CLK) , .CLR(CLR) , .D(D[15]) , .EN(EN) , .PRE(GND) , .Q(Q[15]) );

dffepc QL9  ( .CLK(CLK) , .CLR(CLR) , .D(D[11]) , .EN(EN) , .PRE(GND) , .Q(Q[11]) );

dffepc QL10  ( .CLK(CLK) , .CLR(CLR) , .D(D[10]) , .EN(EN) , .PRE(GND) , .Q(Q[10]) );

dffepc QL11  ( .CLK(CLK) , .CLR(CLR) , .D(D[9]) , .EN(EN) , .PRE(GND) , .Q(Q[9]) );

dffepc QL12  ( .CLK(CLK) , .CLR(CLR) , .D(D[8]) , .EN(EN) , .PRE(GND) , .Q(Q[8]) );

dffepc I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[7]) , .EN(EN) , .PRE(GND) , .Q(Q[7]) );

dffepc I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[6]) , .EN(EN) , .PRE(GND) , .Q(Q[6]) );

dffepc I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[5]) , .EN(EN) , .PRE(GND) , .Q(Q[5]) );

dffepc I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[4]) , .EN(EN) , .PRE(GND) , .Q(Q[4]) );

dffepc QL5  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .EN(EN) , .PRE(GND) , .Q(Q[3]) );

dffepc QL6  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .EN(EN) , .PRE(GND) , .Q(Q[2]) );

dffepc QL7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .EN(EN) , .PRE(GND) , .Q(Q[1]) );

dffepc QL8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .EN(EN) , .PRE(GND) , .Q(Q[0]) );


endmodule /* rgec16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rge8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rge8
`else
`define rge8

module rge8 ( CLK , D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [7:0] D;
input EN;
output [7:0] Q;

dffe I4  ( .CLK(CLK) , .D(D[0]) , .EN(EN) , .Q(Q[0]) );

dffe I3  ( .CLK(CLK) , .D(D[1]) , .EN(EN) , .Q(Q[1]) );

dffe I2  ( .CLK(CLK) , .D(D[2]) , .EN(EN) , .Q(Q[2]) );

dffe I1  ( .CLK(CLK) , .D(D[3]) , .EN(EN) , .Q(Q[3]) );

dffe QL1  ( .CLK(CLK) , .D(D[7]) , .EN(EN) , .Q(Q[7]) );

dffe QL2  ( .CLK(CLK) , .D(D[6]) , .EN(EN) , .Q(Q[6]) );

dffe QL3  ( .CLK(CLK) , .D(D[5]) , .EN(EN) , .Q(Q[5]) );

dffe QL4  ( .CLK(CLK) , .D(D[4]) , .EN(EN) , .Q(Q[4]) );


endmodule /* rge8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rge4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rge4
`else
`define rge4

module rge4 ( CLK , D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [3:0] D;
input EN;
output [3:0] Q;

dffe I1  ( .CLK(CLK) , .D(D[3]) , .EN(EN) , .Q(Q[3]) );

dffe I2  ( .CLK(CLK) , .D(D[2]) , .EN(EN) , .Q(Q[2]) );

dffe I3  ( .CLK(CLK) , .D(D[1]) , .EN(EN) , .Q(Q[1]) );

dffe I4  ( .CLK(CLK) , .D(D[0]) , .EN(EN) , .Q(Q[0]) );


endmodule /* rge4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rge16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rge16
`else
`define rge16

module rge16 ( CLK , D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [15:0] D;
input EN;
output [15:0] Q;

dffe I5  ( .CLK(CLK) , .D(D[15]) , .EN(EN) , .Q(Q[15]) );

dffe I6  ( .CLK(CLK) , .D(D[14]) , .EN(EN) , .Q(Q[14]) );

dffe I7  ( .CLK(CLK) , .D(D[13]) , .EN(EN) , .Q(Q[13]) );

dffe I8  ( .CLK(CLK) , .D(D[12]) , .EN(EN) , .Q(Q[12]) );

dffe QL5  ( .CLK(CLK) , .D(D[11]) , .EN(EN) , .Q(Q[11]) );

dffe QL6  ( .CLK(CLK) , .D(D[10]) , .EN(EN) , .Q(Q[10]) );

dffe QL7  ( .CLK(CLK) , .D(D[9]) , .EN(EN) , .Q(Q[9]) );

dffe QL8  ( .CLK(CLK) , .D(D[8]) , .EN(EN) , .Q(Q[8]) );

dffe I1  ( .CLK(CLK) , .D(D[7]) , .EN(EN) , .Q(Q[7]) );

dffe I2  ( .CLK(CLK) , .D(D[6]) , .EN(EN) , .Q(Q[6]) );

dffe I3  ( .CLK(CLK) , .D(D[5]) , .EN(EN) , .Q(Q[5]) );

dffe I4  ( .CLK(CLK) , .D(D[4]) , .EN(EN) , .Q(Q[4]) );

dffe QL9  ( .CLK(CLK) , .D(D[3]) , .EN(EN) , .Q(Q[3]) );

dffe QL10  ( .CLK(CLK) , .D(D[2]) , .EN(EN) , .Q(Q[2]) );

dffe QL11  ( .CLK(CLK) , .D(D[1]) , .EN(EN) , .Q(Q[1]) );

dffe QL12  ( .CLK(CLK) , .D(D[0]) , .EN(EN) , .Q(Q[0]) );


endmodule /* rge16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgc8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgc8
`else
`define rgc8

module rgc8 ( CLK , CLR, D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
output [7:0] Q;

dffc QL1  ( .CLK(CLK) , .CLR(CLR) , .D(D[7]) , .Q(Q[7]) );

dffc QL2  ( .CLK(CLK) , .CLR(CLR) , .D(D[6]) , .Q(Q[6]) );

dffc QL3  ( .CLK(CLK) , .CLR(CLR) , .D(D[5]) , .Q(Q[5]) );

dffc QL4  ( .CLK(CLK) , .CLR(CLR) , .D(D[4]) , .Q(Q[4]) );

dffc QL5  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .Q(Q[3]) );

dffc QL6  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .Q(Q[2]) );

dffc QL7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .Q(Q[1]) );

dffc QL8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .Q(Q[0]) );


endmodule /* rgc8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgc4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgc4
`else
`define rgc4

module rgc4 ( CLK , CLR, D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
output [3:0] Q;

dffc QL1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .Q(Q[3]) );

dffc QL2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .Q(Q[2]) );

dffc QL3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .Q(Q[1]) );

dffc QL4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .Q(Q[0]) );


endmodule /* rgc4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rgc16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rgc16
`else
`define rgc16

module rgc16 ( CLK , CLR, D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
output [15:0] Q;

dffc I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[15]) , .Q(Q[15]) );

dffc I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[14]) , .Q(Q[14]) );

dffc I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[13]) , .Q(Q[13]) );

dffc I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[12]) , .Q(Q[12]) );

dffc QL9  ( .CLK(CLK) , .CLR(CLR) , .D(D[8]) , .Q(Q[8]) );

dffc QL12  ( .CLK(CLK) , .CLR(CLR) , .D(D[11]) , .Q(Q[11]) );

dffc QL11  ( .CLK(CLK) , .CLR(CLR) , .D(D[10]) , .Q(Q[10]) );

dffc QL10  ( .CLK(CLK) , .CLR(CLR) , .D(D[9]) , .Q(Q[9]) );

dffc QL8  ( .CLK(CLK) , .CLR(CLR) , .D(D[7]) , .Q(Q[7]) );

dffc QL7  ( .CLK(CLK) , .CLR(CLR) , .D(D[6]) , .Q(Q[6]) );

dffc QL6  ( .CLK(CLK) , .CLR(CLR) , .D(D[5]) , .Q(Q[5]) );

dffc QL5  ( .CLK(CLK) , .CLR(CLR) , .D(D[4]) , .Q(Q[4]) );

dffc QL4  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .Q(Q[3]) );

dffc QL3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .Q(Q[2]) );

dffc QL2  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .Q(Q[1]) );

dffc QL1  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .Q(Q[0]) );


endmodule /* rgc16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rg8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rg8
`else
`define rg8

module rg8 ( CLK , D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [7:0] D;
output [7:0] Q;

dff QL8  ( .CLK(CLK) , .D(D[7]) , .Q(Q[7]) );

dff QL4  ( .CLK(CLK) , .D(D[3]) , .Q(Q[3]) );

dff QL5  ( .CLK(CLK) , .D(D[2]) , .Q(Q[2]) );

dff QL1  ( .CLK(CLK) , .D(D[6]) , .Q(Q[6]) );

dff QL2  ( .CLK(CLK) , .D(D[5]) , .Q(Q[5]) );

dff QL6  ( .CLK(CLK) , .D(D[1]) , .Q(Q[1]) );

dff QL7  ( .CLK(CLK) , .D(D[0]) , .Q(Q[0]) );

dff QL3  ( .CLK(CLK) , .D(D[4]) , .Q(Q[4]) );


endmodule /* rg8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rg4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rg4
`else
`define rg4

module rg4 ( CLK , D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [3:0] D;
output [3:0] Q;

dff QL1  ( .CLK(CLK) , .D(D[3]) , .Q(Q[3]) );

dff QL2  ( .CLK(CLK) , .D(D[2]) , .Q(Q[2]) );

dff QL3  ( .CLK(CLK) , .D(D[1]) , .Q(Q[1]) );

dff QL4  ( .CLK(CLK) , .D(D[0]) , .Q(Q[0]) );


endmodule /* rg4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rg16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rg16
`else
`define rg16

module rg16 ( CLK , D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input [15:0] D;
output [15:0] Q;

dff I1  ( .CLK(CLK) , .D(D[15]) , .Q(Q[15]) );

dff I2  ( .CLK(CLK) , .D(D[14]) , .Q(Q[14]) );

dff I3  ( .CLK(CLK) , .D(D[13]) , .Q(Q[13]) );

dff I4  ( .CLK(CLK) , .D(D[12]) , .Q(Q[12]) );

dff QL5  ( .CLK(CLK) , .D(D[11]) , .Q(Q[11]) );

dff QL6  ( .CLK(CLK) , .D(D[10]) , .Q(Q[10]) );

dff QL7  ( .CLK(CLK) , .D(D[9]) , .Q(Q[9]) );

dff QL8  ( .CLK(CLK) , .D(D[8]) , .Q(Q[8]) );

dff QL9  ( .CLK(CLK) , .D(D[7]) , .Q(Q[7]) );

dff QL10  ( .CLK(CLK) , .D(D[6]) , .Q(Q[6]) );

dff QL11  ( .CLK(CLK) , .D(D[5]) , .Q(Q[5]) );

dff QL12  ( .CLK(CLK) , .D(D[4]) , .Q(Q[4]) );

dff QL13  ( .CLK(CLK) , .D(D[3]) , .Q(Q[3]) );

dff QL14  ( .CLK(CLK) , .D(D[2]) , .Q(Q[2]) );

dff QL15  ( .CLK(CLK) , .D(D[1]) , .Q(Q[1]) );

dff QL16  ( .CLK(CLK) , .D(D[0]) , .Q(Q[0]) );


endmodule /* rg16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : shft8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef shft8
`else
`define shft8

module shft8 ( CLK , CLR, D, EN, LOAD, SI, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input EN, LOAD;
output [7:0] Q;
input SI;



shft4 QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .EN(EN) , .LOAD(LOAD),
             .Q({ Q[7:4] }) , .SI(Q[3]) );

shft4 QL1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .EN(EN) , .LOAD(LOAD),
             .Q({ Q[3:0] }) , .SI(SI) );


endmodule /* shft8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : shft4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef shft4
`else
`define shft4

module shft4 ( CLK , CLR, D, EN, LOAD, SI, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input EN, LOAD;
output [3:0] Q;
input SI;



shiftbit QL4  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .EN(EN) , .LOAD(LOAD) , .Q(Q[3]),
                .SI(Q[2]) );

shiftbit QL3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .EN(EN) , .LOAD(LOAD) , .Q(Q[2]),
                .SI(Q[1]) );

shiftbit QL2  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .EN(EN) , .LOAD(LOAD) , .Q(Q[1]),
                .SI(Q[0]) );

shiftbit QL1  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .EN(EN) , .LOAD(LOAD) , .Q(Q[0]),
                .SI(SI) );


endmodule /* shft4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : shft16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef shft16
`else
`define shft16

module shft16 ( CLK , CLR, D, EN, LOAD, SI, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input EN, LOAD;
output [15:0] Q;
input SI;



shft4 I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .EN(EN) , .LOAD(LOAD),
            .Q({ Q[15:12] }) , .SI(Q[11]) );

shft4 I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .EN(EN) , .LOAD(LOAD),
            .Q({ Q[11:8] }) , .SI(Q[7]) );

shft4 I3  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .EN(EN) , .LOAD(LOAD),
            .Q({ Q[7:4] }) , .SI(Q[3]) );

shft4 QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .EN(EN) , .LOAD(LOAD),
             .Q({ Q[3:0] }) , .SI(SI) );


endmodule /* shft16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bshft8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bshft8
`else
`define bshft8

module bshft8 ( CLK , CLR, D, LSI, RSI, S0, S1, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [7:0] D;
input LSI;
output [7:0] Q;
input RSI, S0, S1;



bshft4 I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LSI(LSI) , .Q({ Q[3:0] }),
             .RSI(Q[4]) , .S0(S0) , .S1(S1) );

bshft4 QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .LSI(Q[3]) , .Q({ Q[7:4] }),
              .RSI(RSI) , .S0(S0) , .S1(S1) );


endmodule /* bshft8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bshft4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bshft4
`else
`define bshft4

module bshft4 ( CLK , CLR, D, LSI, RSI, S0, S1, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input LSI;
output [3:0] Q;
input RSI, S0, S1;



bishbit QL4  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .LSI(Q[2]) , .Q(Q[3]) , .RSI(RSI),
               .S0(S0) , .S1(S1) );

bishbit QL2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .LSI(Q[1]) , .Q(Q[2]) , .RSI(Q[3]),
               .S0(S0) , .S1(S1) );

bishbit QL3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .LSI(Q[0]) , .Q(Q[1]) , .RSI(Q[2]),
               .S0(S0) , .S1(S1) );

bishbit QL1  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .LSI(LSI) , .Q(Q[0]) , .RSI(Q[1]),
               .S0(S0) , .S1(S1) );


endmodule /* bshft4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bshft16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bshft16
`else
`define bshft16

module bshft16 ( CLK , CLR, D, LSI, RSI, S0, S1, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [15:0] D;
input LSI;
output [15:0] Q;
input RSI, S0, S1;



bshft4 I1  ( .CLK(CLK) , .CLR(CLR) , .D({ D[11:8] }) , .LSI(Q[7]) , .Q({ Q[11:8] }),
             .RSI(Q[12]) , .S0(S0) , .S1(S1) );

bshft4 I2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[3:0] }) , .LSI(LSI) , .Q({ Q[3:0] }),
             .RSI(Q[4]) , .S0(S0) , .S1(S1) );

bshft4 QL2  ( .CLK(CLK) , .CLR(CLR) , .D({ D[7:4] }) , .LSI(Q[3]) , .Q({ Q[7:4] }),
              .RSI(Q[8]) , .S0(S0) , .S1(S1) );

bshft4 QL4  ( .CLK(CLK) , .CLR(CLR) , .D({ D[15:12] }) , .LSI(Q[11]),
              .Q({ Q[15:12] }) , .RSI(RSI) , .S0(S0) , .S1(S1) );


endmodule /* bshft16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte16
`else
`define dcnte16

module dcnte16 ( CLK , CLR, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN;
output [15:0] Q;wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;


dcnte4c I_1  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_4) , .ENT(N_2),
               .Q({ Q[15:12] }) );

dcnte4b I_2  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_5) , .ENT(N_3),
               .Q({ Q[11:8] }) , .RCO(N_2) );

dcnte4b I_3  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .ENP(N_6) , .ENT(N_1) , .Q({ Q[7:4] }),
               .RCO(N_3) );

dcnte4a I_4  ( .CLK(CLK) , .CLR(CLR) , .ENG(EN) , .Q({ Q[3:0] }) , .RCO(N_1) );

dnfecar3 QL5  ( .ACO1(N_6) , .ACO2(N_5) , .ACO3(N_4) , .CLK(CLK) , .CLR(CLR) , .ENG(EN) );


endmodule /* dcnte16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sub4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sub4
`else
`define sub4

module sub4 ( A , B, Q )/* synthesis black_box */;

input [3:0] A;
input [3:0] B;
output [3:0] Q;wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;


csamuxd QL1  ( .A(N_14) , .Q(Q[3]) , .S00(N_17) , .S01(N_16) , .S1(N_18) );

mux4x6 QL2  ( .A(N_15) , .B(N_15) , .C(N_15) , .D(N_15) , .Q(Q[1]) , .S0(N_12) , .S1(B[1]) );

xor2p QL3  ( .A(N_18) , .B(N_13) , .Q(Q[2]) );

and2i1 I1  ( .A(A[0]) , .B(B[0]) , .Q(N_11) );

csblow QL5  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_12) , .B0(B[0]) , .B1(B[1]) , .C0_n(N_15),
              .C1(N_18) );

csbbitb QL6  ( .A(A[2]) , .B(B[2]) , .C0(N_17) , .C1(N_16) , .S0(N_13) );

csbbitb QL7  ( .A(A[3]) , .B(B[3]) , .S0(N_14), .C0(), .C1() );

nand2i2 QL8  ( .A(N_15) , .B(N_11) , .Q(Q[0]) );


endmodule /* sub4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sub8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sub8
`else
`define sub8

module sub8 ( A , B, Q )/* synthesis black_box */;

input [7:0] A;
input [7:0] B;
output [7:0] Q;supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;


mux2x1 I1  ( .A(N_25) , .B(N_25) , .Q(N_34) , .S(N_18) );

mux2x2 I2  ( .A(N_25) , .B(N_25) , .Q(N_33) , .S(N_20) );

csamuxb I3  ( .A(N_33) , .B(N_34) , .Q(Q[7]) , .S00(N_37) , .S01(N_35) , .S1(N_36) );

csamuxa I4  ( .A(N_32) , .Q(Q[6]) , .S00(N_37) , .S01(N_35) , .S1(N_36) );

muxc2dx2 I5  ( .A(N_24) , .B(N_21) , .C(GND) , .D(GND) , .Q(N_35) , .S(N_19) , .T(N_31), .R() );

muxb2dx2 I6  ( .A(N_24) , .B(N_21) , .C(GND) , .D(GND) , .Q(N_37) , .S(N_23) , .T(N_15), .R() );

csamuxc I7  ( .A(N_27) , .B(N_26) , .Q(N_36) , .S00(N_29) , .S01(N_28) , .S1(N_30) );

csamuxd I8  ( .A(N_17) , .Q(Q[5]) , .S00(N_15) , .S01(N_31) , .S1(N_36) );

csamuxd I9  ( .A(N_16) , .Q(Q[3]) , .S00(N_29) , .S01(N_28) , .S1(N_38) );

xor2p I10  ( .A(N_36) , .B(N_14) , .Q(Q[4]) );

xor2p I11  ( .A(N_38) , .B(N_13) , .Q(Q[2]) );

buff I12  ( .A(N_30) , .Q(N_38) );

mux4x6 I13  ( .A(N_22) , .B(N_22) , .C(N_22) , .D(N_22) , .Q(Q[1]) , .S0(N_12) , .S1(B[1]) );

csbbita I14  ( .A(A[7]) , .B(B[7]) , .S0(N_25), .C0(), .C1() );

csbbita I15  ( .A(A[6]) , .B(B[6]) , .C0(N_20) , .C1(N_18) , .S0(N_32) );

csbbita I16  ( .A(A[5]) , .B(B[5]) , .C0(N_24) , .C1(N_21) , .S0(N_17) );

csbbita I17  ( .A(A[4]) , .B(B[4]) , .C0(N_23) , .C1(N_19) , .S0(N_14) );

csbbitb I23  ( .A(A[3]) , .B(B[3]) , .C0(N_27) , .C1(N_26) , .S0(N_16) );

csbbitb I24  ( .A(A[2]) , .B(B[2]) , .C0(N_29) , .C1(N_28) , .S0(N_13) );

csblow I20  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_12) , .B0(B[0]) , .B1(B[1]) , .C0_n(N_22),
              .C1(N_30) );

nand2i2 I21  ( .A(N_22) , .B(N_11) , .Q(Q[0]) );

and2i1 I22  ( .A(A[0]) , .B(B[0]) , .Q(N_11) );


endmodule /* sub8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sub16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sub16
`else
`define sub16

module sub16 ( A , B, Q )/* synthesis black_box */;

input [15:0] A;
input [15:0] B;
output [15:0] Q;wire N_84;
wire N_85;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_36;
wire N_37;
wire N_38;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_70;
wire N_72;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;


muxc2dx2 I52  ( .A(N_58) , .B(N_57) , .C(N_58) , .D(N_57) , .Q(N_63) , .R(N_64) , .S(N_85),
                .T(N_56) );

muxb2dx2 I53  ( .A(N_58) , .B(N_57) , .C(N_58) , .D(N_57) , .Q(N_70) , .R(N_62) , .S(N_55),
                .T(N_84) );

muxi2dx2 I48  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_44) , .R(N_29) , .S(N_25) );

muxi2dx2 I49  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_5) , .R(N_7) , .S(N_26) );

muxi2dx2 I50  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_34) , .R(N_8) , .S(N_27) );

muxi2dx2 I51  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_61) , .R(N_66) , .S(N_28) );

csblow I47  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_52) , .B0(B[0]) , .B1(B[1]) , .C0_n(N_83),
              .C1(N_53) );

xnor2p I1  ( .A(A[15]) , .B(B[15]) , .Q(N_77) );

mux2dx0 I2  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_40) , .R(N_41) , .S(N_8) );

mux2dx0 I3  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_36) , .R(N_37) , .S(N_4) );

mux2dx2 I56  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_3) , .R(N_6) , .S(N_20) );

mux2dx2 I4  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_43) , .R(N_2) , .S(N_18) );

mux2dx2 I6  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_33) , .R(N_4) , .S(N_22) );

mux2dx2 I7  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_60) , .R(N_65) , .S(N_24) );

mux2dxx I9  ( .A(N_1) , .B(N_1) , .C(N_79) , .D(N_78) , .Q(N_47) , .R(N_48) , .S(N_29) );

mux2dxx I10  ( .A(N_1) , .B(N_1) , .C(N_79) , .D(N_78) , .Q(N_45) , .R(N_46) , .S(N_2) );

mux2x0 I11  ( .A(N_33) , .B(N_34) , .Q(Q[9]) , .S(N_31) );

mux2x0 I12  ( .A(N_36) , .B(N_40) , .Q(Q[11]) , .S(N_31) );

csamuxa I57  ( .A(N_67) , .Q(Q[6]) , .S00(N_70) , .S01(N_63) , .S1(N_82) );

csamuxa I55  ( .A(N_42) , .Q(Q[12]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxa I14  ( .A(N_38) , .Q(Q[10]) , .S00(N_4) , .S01(N_8) , .S1(N_31) );

csamuxb I16  ( .A(N_46) , .B(N_48) , .Q(Q[15]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I17  ( .A(N_45) , .B(N_47) , .Q(Q[14]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I18  ( .A(N_43) , .B(N_44) , .Q(Q[13]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I19  ( .A(N_65) , .B(N_66) , .Q(N_30) , .S00(N_62) , .S01(N_64) , .S1(N_68) );

csamuxb I20  ( .A(N_65) , .B(N_66) , .Q(N_31) , .S00(N_62) , .S01(N_64) , .S1(N_68) );

csamuxb I21  ( .A(N_60) , .B(N_61) , .Q(Q[7]) , .S00(N_70) , .S01(N_63) , .S1(N_82) );

csamuxc I22  ( .A(N_80) , .B(N_81) , .Q(N_68) , .S00(N_50) , .S01(N_51) , .S1(N_53) );

csamuxd I23  ( .A(N_49) , .Q(Q[3]) , .S00(N_50) , .S01(N_51) , .S1(N_73) );

csamuxd I24  ( .A(N_59) , .Q(Q[5]) , .S00(N_84) , .S01(N_56) , .S1(N_82) );

mux4x6 I25  ( .A(N_83) , .B(N_83) , .C(N_83) , .D(N_83) , .Q(Q[1]) , .S0(N_52) , .S1(B[1]) );

buff I54  ( .A(N_53) , .Q(N_73) );

buff I26  ( .A(N_68) , .Q(N_82) );

xor2p I28  ( .A(N_31) , .B(N_32) , .Q(Q[8]) );

xor2p I29  ( .A(N_82) , .B(N_72) , .Q(Q[4]) );

xor2p I30  ( .A(N_73) , .B(N_74) , .Q(Q[2]) );

mux2dxy I31  ( .A(N_75) , .B(N_75) , .C(N_76) , .D(N_76) , .Q(N_79) , .R(N_78) , .S(N_77) );

and2i1 I32  ( .A(A[0]) , .B(B[0]) , .Q(N_54) );

csbbitb I33  ( .A(A[3]) , .B(B[3]) , .C0(N_80) , .C1(N_81) , .S0(N_49) );

csbbitb I34  ( .A(A[2]) , .B(B[2]) , .C0(N_50) , .C1(N_51) , .S0(N_74) );

csbbita I35  ( .A(A[14]) , .B(B[14]) , .C0(N_75) , .C1(N_76) , .S0(N_1) );

csbbita I36  ( .A(A[13]) , .B(B[13]) , .C0(N_13) , .C1(N_17) , .S0(N_9) );

csbbita I37  ( .A(A[12]) , .B(B[12]) , .C0(N_18) , .C1(N_25) , .S0(N_42) );

csbbita I38  ( .A(A[11]) , .B(B[11]) , .C0(N_14) , .C1(N_19) , .S0(N_10) );

csbbita I39  ( .A(A[10]) , .B(B[10]) , .C0(N_20) , .C1(N_26) , .S0(N_38) );

csbbita I40  ( .A(A[9]) , .B(B[9]) , .C0(N_15) , .C1(N_21) , .S0(N_11) );

csbbita I41  ( .A(A[8]) , .B(B[8]) , .C0(N_22) , .C1(N_27) , .S0(N_32) );

csbbita I42  ( .A(A[7]) , .B(B[7]) , .C0(N_16) , .C1(N_23) , .S0(N_12) );

csbbita I43  ( .A(A[6]) , .B(B[6]) , .C0(N_24) , .C1(N_28) , .S0(N_67) );

csbbita I44  ( .A(A[5]) , .B(B[5]) , .C0(N_58) , .C1(N_57) , .S0(N_59) );

csbbita I45  ( .A(A[4]) , .B(B[4]) , .C0(N_55) , .C1(N_85) , .S0(N_72) );

nand2i2 I46  ( .A(N_83) , .B(N_54) , .Q(Q[0]) );


endmodule /* sub16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sub32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sub32
`else
`define sub32

module sub32 ( A , B, Q )/* synthesis black_box */;

input [31:0] A;
input [31:0] B;
output [31:0] Q;wire N_204;
wire N_205;
wire N_202;
wire N_203;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;
wire N_39;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_70;
wire N_71;
wire N_72;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;
wire N_84;
wire N_85;
wire N_86;
wire N_87;
wire N_88;
wire N_89;
wire N_90;
wire N_91;
wire N_92;
wire N_93;
wire N_94;
wire N_95;
wire N_96;
wire N_97;
wire N_98;
wire N_99;
wire N_100;
wire N_101;
wire N_102;
wire N_103;
wire N_104;
wire N_105;
wire N_106;
wire N_107;
wire N_108;
wire N_109;
wire N_110;
wire N_111;
wire N_112;
wire N_113;
wire N_114;
wire N_115;
wire N_116;
wire N_118;
wire N_120;
wire N_121;
wire N_122;
wire N_123;
wire N_124;
wire N_125;
wire N_126;
wire N_127;
wire N_128;
wire N_129;
wire N_130;
wire N_131;
wire N_132;
wire N_133;
wire N_134;
wire N_135;
wire N_136;
wire N_137;
wire N_138;
wire N_139;
wire N_140;
wire N_141;
wire N_142;
wire N_143;
wire N_144;
wire N_145;
wire N_146;
wire N_147;
wire N_148;
wire N_149;
wire N_150;
wire N_151;
wire N_152;
wire N_153;
wire N_154;
wire N_155;
wire N_156;
wire N_157;
wire N_158;
wire N_159;
wire N_160;
wire N_161;
wire N_162;
wire N_163;
wire N_164;
wire N_165;
wire N_166;
wire N_167;
wire N_168;
wire N_169;
wire N_170;
wire N_171;
wire N_172;
wire N_173;
wire N_174;
wire N_175;
wire N_176;
wire N_177;
wire N_178;
wire N_179;
wire N_180;
wire N_181;
wire N_183;
wire N_184;
wire N_185;
wire N_186;
wire N_187;
wire N_188;
wire N_189;
wire C15A;
wire C15B;
wire N_191;
wire N_192;
wire N_193;
wire N_194;
wire N_195;
wire N_196;
wire N_197;
wire C15C;
wire C15D;
wire N_198;
wire N_199;
wire N_200;
wire N_201;


muxb2dx0 I63  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_62) , .R(N_63) , .S(N_20),
                .T(N_61) );

muxb2dx0 I64  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_58) , .R(N_59) , .S(N_16),
                .T(N_57) );

muxb2dx0 I65  ( .A(N_74) , .B(N_75) , .C(N_74) , .D(N_75) , .Q(N_78) , .R(N_3) , .S(N_76),
                .T(N_82) );

muxb2dx0 I66  ( .A(N_74) , .B(N_75) , .C(N_74) , .D(N_75) , .Q(N_77) , .R(N_2) , .S(N_4),
                .T(N_83) );

muxb2dx0 I61  ( .A(N_175) , .B(N_185) , .C(N_175) , .D(N_185) , .Q(N_187) , .R(N_186),
                .S(N_205) , .T(N_177) );

muxb2dx0 I62  ( .A(N_175) , .B(N_185) , .C(N_175) , .D(N_185) , .Q(N_183) , .R(N_184),
                .S(N_204) , .T(N_176) );

muxb2dx2 I59  ( .A(N_128) , .B(N_129) , .C(N_128) , .D(N_129) , .Q(N_189) , .R(N_118),
                .S(N_131) , .T(N_202) );

muxc2dx2 I60  ( .A(N_128) , .B(N_129) , .C(N_128) , .D(N_129) , .Q(N_188) , .R(N_124),
                .S(N_203) , .T(N_130) );

muxi2dx2 I67  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_79) , .R(N_76) , .S(N_14) );

muxi2dx2 I68  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_84) , .R(N_75) , .S(N_13) );

muxi2dx2 I69  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_96) , .R(N_87) , .S(N_47) );

muxi2dx2 I70  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_91) , .R(N_98) , .S(N_46) );

muxi2dx2 I71  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_56) , .R(N_20) , .S(N_30) );

muxi2dx2 I72  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_17) , .R(N_19) , .S(N_29) );

muxi2dx2 I73  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_66) , .R(N_32) , .S(N_37) );

muxi2dx2 I54  ( .A(N_164) , .B(N_164) , .C(N_166) , .D(N_168) , .Q(N_158) , .R(N_160),
                .S(N_172) );

muxi2dx2 I55  ( .A(N_165) , .B(N_165) , .C(N_167) , .D(N_170) , .Q(N_193) , .R(N_163),
                .S(N_173) );

muxi2dx2 I56  ( .A(N_148) , .B(N_148) , .C(N_150) , .D(N_152) , .Q(N_178) , .R(N_185),
                .S(N_156) );

muxi2dx2 I57  ( .A(N_149) , .B(N_149) , .C(N_151) , .D(N_154) , .Q(N_147) , .R(N_205),
                .S(N_157) );

muxi2dx2 I58  ( .A(N_144) , .B(N_144) , .C(N_143) , .D(N_142) , .Q(N_125) , .R(N_122),
                .S(N_140) );

mux2dxy QL1  ( .A(N_52) , .B(N_52) , .C(N_53) , .D(N_53) , .Q(N_50) , .R(N_49) , .S(N_51) );

xnor2p QL2  ( .A(A[31]) , .B(B[31]) , .Q(N_51) );

xor2p QL3  ( .A(C15A) , .B(N_73) , .Q(Q[16]) );

xor2p I1  ( .A(N_115) , .B(N_114) , .Q(Q[2]) );

xor2p I2  ( .A(N_111) , .B(N_116) , .Q(Q[4]) );

xor2p I3  ( .A(N_138) , .B(N_145) , .Q(Q[8]) );

buff I76  ( .A(N_133) , .Q(N_115) );

buff I5  ( .A(N_120) , .Q(N_111) );

mux4x6 I6  ( .A(N_201) , .B(N_201) , .C(N_201) , .D(N_201) , .Q(Q[1]) , .S0(N_134),
             .S1(B[1]) );

csamuxd I7  ( .A(N_137) , .Q(Q[3]) , .S00(N_136) , .S01(N_135) , .S1(N_115) );

csamuxd I8  ( .A(N_127) , .Q(Q[5]) , .S00(N_202) , .S01(N_130) , .S1(N_111) );

csamuxc I9  ( .A(N_113) , .B(N_112) , .Q(N_120) , .S00(N_136) , .S01(N_135) , .S1(N_133) );

csamuxb I88  ( .A(N_100) , .B(N_98) , .Q(N_88) , .S00(N_1) , .S01(N_87) , .S1(N_3) );

csamuxb I89  ( .A(N_100) , .B(N_98) , .Q(N_110) , .S00(N_1) , .S01(N_87) , .S1(N_2) );

csamuxb I81  ( .A(N_72) , .B(N_71) , .Q(Q[26]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb I82  ( .A(N_94) , .B(N_80) , .Q(Q[22]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb I78  ( .A(N_199) , .B(N_200) , .Q(C15C) , .S00(N_184) , .S01(N_186) , .S1(N_139) );

csamuxb I79  ( .A(N_197) , .B(N_180) , .Q(C15A) , .S00(N_184) , .S01(N_186) , .S1(N_139) );

csamuxb I80  ( .A(N_194) , .B(N_195) , .Q(Q[14]) , .S00(N_183) , .S01(N_187),
               .S1(N_138) );

csamuxb I77  ( .A(N_123) , .B(N_122) , .Q(N_138) , .S00(N_189) , .S01(N_188),
               .S1(N_120) );

csamuxb QL25  ( .A(N_86) , .B(N_84) , .Q(Q[19]) , .S00(N_83) , .S01(N_82) , .S1(C15A) );

csamuxb QL17  ( .A(N_95) , .B(N_96) , .Q(Q[21]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb QL15  ( .A(N_93) , .B(N_81) , .Q(Q[23]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb QL27  ( .A(N_100) , .B(N_98) , .Q(N_99) , .S00(N_1) , .S01(N_87) , .S1(N_2) );

csamuxb QL29  ( .A(N_100) , .B(N_98) , .Q(N_109) , .S00(N_1) , .S01(N_87) , .S1(N_3) );

csamuxb QL18  ( .A(N_55) , .B(N_56) , .Q(Q[25]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb QL20  ( .A(N_58) , .B(N_62) , .Q(Q[27]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb QL21  ( .A(N_101) , .B(N_103) , .Q(Q[28]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL22  ( .A(N_102) , .B(N_104) , .Q(Q[29]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL23  ( .A(N_105) , .B(N_107) , .Q(Q[30]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL24  ( .A(N_106) , .B(N_108) , .Q(Q[31]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb I10  ( .A(N_126) , .B(N_125) , .Q(Q[7]) , .S00(N_189) , .S01(N_188) , .S1(N_111) );

csamuxb I12  ( .A(N_123) , .B(N_122) , .Q(N_139) , .S00(N_118) , .S01(N_124),
               .S1(N_120) );

csamuxb I13  ( .A(N_179) , .B(N_178) , .Q(Q[11]) , .S00(N_176) , .S01(N_177),
               .S1(N_138) );

csamuxb I14  ( .A(N_192) , .B(N_193) , .Q(Q[13]) , .S00(N_183) , .S01(N_187),
               .S1(N_138) );

csamuxb I16  ( .A(N_196) , .B(N_181) , .Q(Q[15]) , .S00(N_183) , .S01(N_187),
               .S1(N_138) );

csamuxb I18  ( .A(N_197) , .B(N_180) , .Q(C15B) , .S00(N_184) , .S01(N_186) , .S1(N_139) );

csamuxb I20  ( .A(N_199) , .B(N_200) , .Q(C15D) , .S00(N_184) , .S01(N_186) , .S1(N_139) );

csamuxa I74  ( .A(N_85) , .Q(Q[18]) , .S00(N_83) , .S01(N_82) , .S1(C15A) );

csamuxa I75  ( .A(N_97) , .Q(Q[20]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxa QL43  ( .A(N_89) , .Q(Q[24]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxa I21  ( .A(N_174) , .Q(Q[10]) , .S00(N_176) , .S01(N_177) , .S1(N_138) );

csamuxa I22  ( .A(N_121) , .Q(Q[6]) , .S00(N_189) , .S01(N_188) , .S1(N_111) );

csamuxa I23  ( .A(N_191) , .Q(Q[12]) , .S00(N_183) , .S01(N_187) , .S1(N_138) );

mux2x0 QL53  ( .A(N_54) , .B(N_79) , .Q(Q[17]) , .S(C15A) );

mux2x0 I24  ( .A(N_146) , .B(N_147) , .Q(Q[9]) , .S(N_138) );

mux2dxx I91  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_101) , .R(N_102),
               .S(N_59) );

mux2dxx I90  ( .A(N_92) , .B(N_92) , .C(N_90) , .D(N_91) , .Q(N_80) , .R(N_81) , .S(N_87) );

mux2dxx I83  ( .A(N_198) , .B(N_198) , .C(N_159) , .D(N_158) , .Q(N_195) , .R(N_181),
               .S(N_163) );

mux2dxx I84  ( .A(N_198) , .B(N_198) , .C(N_159) , .D(N_158) , .Q(N_194) , .R(N_196),
               .S(N_162) );

mux2dxx QL60  ( .A(N_92) , .B(N_92) , .C(N_90) , .D(N_91) , .Q(N_94) , .R(N_93) , .S(N_1) );

mux2dxx QL59  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_103) , .R(N_104),
                .S(N_63) );

mux2dxx QL56  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_67) , .R(N_68) , .S(N_31) );

mux2dxx QL57  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_69) , .R(N_70) , .S(N_32) );

mux2dx2 I92  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_15) , .R(N_18) , .S(N_26) );

mux2dx2 I86  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_95) , .R(N_1) , .S(N_45) );

mux2dx2 I87  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_90) , .R(N_100) , .S(N_43) );

mux2dx2 I85  ( .A(N_164) , .B(N_164) , .C(N_166) , .D(N_168) , .Q(N_159) , .R(N_161),
               .S(N_169) );

mux2dx2 QL78  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_55) , .R(N_16) , .S(N_28) );

mux2dx2 QL75  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_86) , .R(N_74) , .S(N_10) );

mux2dx2 QL76  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_54) , .R(N_4) , .S(N_12) );

mux2dx2 QL82  ( .A(N_57) , .B(N_57) , .C(N_61) , .D(N_61) , .Q(N_72) , .R(N_71) , .S(N_60) );

mux2dx2 QL79  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_65) , .R(N_31) , .S(N_36) );

mux2dx2 I28  ( .A(N_165) , .B(N_165) , .C(N_167) , .D(N_170) , .Q(N_192) , .R(N_162),
               .S(N_171) );

mux2dx2 I29  ( .A(N_148) , .B(N_148) , .C(N_150) , .D(N_152) , .Q(N_179) , .R(N_175),
               .S(N_153) );

mux2dx2 I30  ( .A(N_149) , .B(N_149) , .C(N_151) , .D(N_154) , .Q(N_146) , .R(N_204),
               .S(N_155) );

mux2dx2 I31  ( .A(N_144) , .B(N_144) , .C(N_143) , .D(N_142) , .Q(N_126) , .R(N_123),
               .S(N_141) );

mux2dx0 QL89  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_107) , .R(N_108),
                .S(N_63) );

mux2dx0 QL88  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_105) , .R(N_106),
                .S(N_59) );

mux2dx0 I35  ( .A(N_161) , .B(N_160) , .C(N_161) , .D(N_160) , .Q(N_197) , .R(N_199),
               .S(N_162) );

mux2dx0 I36  ( .A(N_161) , .B(N_160) , .C(N_161) , .D(N_160) , .Q(N_180) , .R(N_200),
               .S(N_163) );

csblow I37  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_134) , .B0(B[0]) , .B1(B[1]) , .C0_n(N_201),
              .C1(N_133) );

and2i1 I38  ( .A(A[0]) , .B(B[0]) , .Q(N_132) );

csbbitb I39  ( .A(A[3]) , .B(B[3]) , .C0(N_113) , .C1(N_112) , .S0(N_137) );

csbbitb I40  ( .A(A[2]) , .B(B[2]) , .C0(N_136) , .C1(N_135) , .S0(N_114) );

csbbita QL111  ( .A(A[30]) , .B(B[30]) , .C0(N_52) , .C1(N_53) , .S0(N_48) );

csbbita QL110  ( .A(A[29]) , .B(B[29]) , .C0(N_34) , .C1(N_35) , .S0(N_33) );

csbbita QL109  ( .A(A[28]) , .B(B[28]) , .C0(N_36) , .C1(N_37) , .S0(N_64) );

csbbita QL108  ( .A(A[27]) , .B(B[27]) , .C0(N_23) , .C1(N_25) , .S0(N_21) );

csbbita QL107  ( .A(A[26]) , .B(B[26]) , .C0(N_26) , .C1(N_29) , .S0(N_60) );

csbbita QL106  ( .A(A[25]) , .B(B[25]) , .C0(N_24) , .C1(N_27) , .S0(N_22) );

csbbita QL105  ( .A(A[24]) , .B(B[24]) , .C0(N_28) , .C1(N_30) , .S0(N_89) );

csbbita QL104  ( .A(A[23]) , .B(B[23]) , .C0(N_40) , .C1(N_42) , .S0(N_38) );

csbbita QL103  ( .A(A[22]) , .B(B[22]) , .C0(N_43) , .C1(N_46) , .S0(N_92) );

csbbita QL102  ( .A(A[21]) , .B(B[21]) , .C0(N_41) , .C1(N_44) , .S0(N_39) );

csbbita QL101  ( .A(A[20]) , .B(B[20]) , .C0(N_45) , .C1(N_47) , .S0(N_97) );

csbbita QL99  ( .A(A[19]) , .B(B[19]) , .C0(N_7) , .C1(N_9) , .S0(N_5) );

csbbita QL98  ( .A(A[18]) , .B(B[18]) , .C0(N_10) , .C1(N_13) , .S0(N_85) );

csbbita QL97  ( .A(A[17]) , .B(B[17]) , .C0(N_8) , .C1(N_11) , .S0(N_6) );

csbbita QL96  ( .A(A[16]) , .B(B[16]) , .C0(N_12) , .C1(N_14) , .S0(N_73) );

csbbita I41  ( .A(A[15]) , .B(B[15]) , .C0(N_166) , .C1(N_168) , .S0(N_164) );

csbbita I42  ( .A(A[14]) , .B(B[14]) , .C0(N_169) , .C1(N_172) , .S0(N_198) );

csbbita I43  ( .A(A[13]) , .B(B[13]) , .C0(N_167) , .C1(N_170) , .S0(N_165) );

csbbita I44  ( .A(A[12]) , .B(B[12]) , .C0(N_171) , .C1(N_173) , .S0(N_191) );

csbbita I45  ( .A(A[11]) , .B(B[11]) , .C0(N_150) , .C1(N_152) , .S0(N_148) );

csbbita I46  ( .A(A[10]) , .B(B[10]) , .C0(N_153) , .C1(N_156) , .S0(N_174) );

csbbita I47  ( .A(A[9]) , .B(B[9]) , .C0(N_151) , .C1(N_154) , .S0(N_149) );

csbbita I48  ( .A(A[8]) , .B(B[8]) , .C0(N_155) , .C1(N_157) , .S0(N_145) );

csbbita I49  ( .A(A[7]) , .B(B[7]) , .C0(N_143) , .C1(N_142) , .S0(N_144) );

csbbita I50  ( .A(A[6]) , .B(B[6]) , .C0(N_141) , .C1(N_140) , .S0(N_121) );

csbbita I51  ( .A(A[5]) , .B(B[5]) , .C0(N_128) , .C1(N_129) , .S0(N_127) );

csbbita I52  ( .A(A[4]) , .B(B[4]) , .C0(N_131) , .C1(N_203) , .S0(N_116) );

nand2i2 I53  ( .A(N_201) , .B(N_132) , .Q(Q[0]) );


endmodule /* sub32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mult4x4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mult4x4
`else
`define mult4x4

module mult4x4 ( X , Y, P )/* synthesis black_box */;

output [7:0] P;
input [3:0] X;
input [3:0] Y;supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;


and2i0 I1  ( .A(Y[0]) , .B(X[0]) , .Q(P[0]) );

xor2i0 I2  ( .A(N_24) , .B(N_26) , .Q(P[4]) );

mbitb I3  ( .A0(Y[3]) , .A1(X[3]) , .B(N_25) , .CI(N_13) , .CO(P[7]) , .S(P[6]) );

mbitc I4  ( .A(N_23) , .B0(N_24) , .B1(N_26) , .CI(N_16) , .CO(N_25) , .S(P[5]) );

mbitc I5  ( .A(N_21) , .B0(Y[1]) , .B1(X[3]) , .CI(N_15) , .CO(N_16) , .S(N_24) );

mbitc I6  ( .A(N_22) , .B0(Y[0]) , .B1(X[3]) , .CI(N_18) , .CO(N_26) , .S(P[3]) );

mbitc I7  ( .A(N_20) , .B0(Y[0]) , .B1(X[2]) , .CI(N_17) , .CO(N_18) , .S(P[2]) );

mbitc I8  ( .A(N_19) , .B0(Y[1]) , .B1(X[2]) , .CI(N_14) , .CO(N_15) , .S(N_22) );

mbita I9  ( .A0(Y[1]) , .A1(X[0]) , .B0(Y[0]) , .B1(X[1]) , .CI(GND) , .CO(N_17),
            .S(P[1]) );

mbita I10  ( .A0(Y[2]) , .A1(X[0]) , .B0(Y[1]) , .B1(X[1]) , .CI(GND) , .CO(N_14),
             .S(N_20) );

mbita I11  ( .A0(Y[3]) , .A1(X[2]) , .B0(Y[2]) , .B1(X[3]) , .CI(N_12) , .CO(N_13),
             .S(N_23) );

mbita I12  ( .A0(Y[3]) , .A1(X[1]) , .B0(Y[2]) , .B1(X[2]) , .CI(N_11) , .CO(N_12),
             .S(N_21) );

mbita I13  ( .A0(Y[3]) , .A1(X[0]) , .B0(Y[2]) , .B1(X[1]) , .CI(GND) , .CO(N_11),
             .S(N_19) );


endmodule /* mult4x4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : radd4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef radd4
`else
`define radd4

module radd4 ( A , B, CI, CO, S )/* synthesis black_box */;

input [3:0] A;
input [3:0] B;
input CI;
output CO;
output [3:0] S;wire N_11;
wire N_12;
wire N_13;


fadd1 I4  ( .A(A[3]) , .B(B[3]) , .CI(N_11) , .CO(CO) , .S(S[3]) );

fadd1 I5  ( .A(A[2]) , .B(B[2]) , .CI(N_12) , .CO(N_11) , .S(S[2]) );

fadd1 I6  ( .A(A[1]) , .B(B[1]) , .CI(N_13) , .CO(N_12) , .S(S[1]) );

fadd1 I7  ( .A(A[0]) , .B(B[0]) , .CI(CI) , .CO(N_13) , .S(S[0]) );


endmodule /* radd4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : radd8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef radd8
`else
`define radd8

module radd8 ( A , B, CI, CO, S )/* synthesis black_box */;

input [7:0] A;
input [7:0] B;
input CI;
output CO;
output [7:0] S;wire N_11;


radd4 I1  ( .A({ A[7:4] }) , .B({ B[7:4] }) , .CI(N_11) , .CO(CO) , .S({ S[7:4] }) );

radd4 I2  ( .A({ A[3:0] }) , .B({ B[3:0] }) , .CI(CI) , .CO(N_11) , .S({ S[3:0] }) );


endmodule /* radd8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : radd16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef radd16
`else
`define radd16

module radd16 ( A , B, CI, CO, S )/* synthesis black_box */;

input [15:0] A;
input [15:0] B;
input CI;
output CO;
output [15:0] S;wire N_11;
wire N_12;
wire N_13;


radd4 I1  ( .A({ A[15:12] }) , .B({ B[15:12] }) , .CI(N_13) , .CO(CO),
            .S({ S[15:12] }) );

radd4 I2  ( .A({ A[11:8] }) , .B({ B[11:8] }) , .CI(N_12) , .CO(N_13),
            .S({ S[11:8] }) );

radd4 I3  ( .A({ A[7:4] }) , .B({ B[7:4] }) , .CI(N_11) , .CO(N_12) , .S({ S[7:4] }) );

radd4 I4  ( .A({ A[3:0] }) , .B({ B[3:0] }) , .CI(CI) , .CO(N_11) , .S({ S[3:0] }) );


endmodule /* radd16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : fadd1_p2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef fadd1_p2
`else
`define fadd1_p2

module fadd1_p2 ( A , B, CI, CO, S )/* synthesis black_box */;

input A, B, CI;
output CO, S;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(A) , .BAB(CI) , .BAS1(GND) , .BAS2(GND),
                       .BB1(A) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B) , .CZ(CO),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(A) , .TAB(CI) , .TAS1(GND) , .TAS2(GND) , .TB1(A),
                       .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(B) , .TZ(S), .FZ(), .QZ() );


endmodule /* fadd1_p2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : fadd1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef fadd1
`else
`define fadd1

module fadd1 ( A , B, CI, CO, S )/* synthesis black_box */;

input A, B, CI;
output CO, S;



maj3i0 I6  ( .A(CI) , .B(B) , .C(A) , .Q(CO) );

xor3i0 I5  ( .A(A) , .B(B) , .C(CI) , .Q(S) );


endmodule /* fadd1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : comp4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef comp4
`else
`define comp4

module comp4 ( A , B, EQ )/* synthesis black_box ql_pack = 1 */;
//pragma attribute comp4 hierarchy preserve

input [3:0] A;
input [3:0] B;
output EQ;

wire N_11;
wire N_12;
wire N_13;
wire N_14;


and4i2 I1  ( .A(N_14) , .B(N_13) , .C(N_12) , .D(N_11) , .Q(EQ) );

eqcombit I2  ( .A1(A[2]) , .A2(A[3]) , .B1(B[2]) , .B2(B[3]) , .EQ1(N_11) , .EQ2(N_13) );

eqcombit I3  ( .A1(A[0]) , .A2(A[1]) , .B1(B[0]) , .B2(B[1]) , .EQ1(N_12) , .EQ2(N_14) );


endmodule /* comp4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : comp8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef comp8
`else
`define comp8

module comp8 ( A , B, EQ )/* synthesis black_box ql_pack = 1 */;
//pragma attribute comp8 hierarchy preserve

input [7:0] A;
input [7:0] B;
output EQ;

supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;


and14i7 I5  ( .A(N_18) , .B(N_17) , .C(N_16) , .D(N_11) , .E(VCC) , .F(VCC) , .G(VCC),
              .H(GND) , .I(N_15) , .J(N_14) , .K(N_13) , .L(N_12) , .M(GND) , .N(GND),
              .Q(EQ) );

eqcombit I1  ( .A1(A[6]) , .A2(A[7]) , .B1(B[6]) , .B2(B[7]) , .EQ1(N_12) , .EQ2(N_11) );

eqcombit I2  ( .A1(A[4]) , .A2(A[5]) , .B1(B[4]) , .B2(B[5]) , .EQ1(N_13) , .EQ2(N_16) );

eqcombit I3  ( .A1(A[2]) , .A2(A[3]) , .B1(B[2]) , .B2(B[3]) , .EQ1(N_14) , .EQ2(N_17) );

eqcombit I4  ( .A1(A[0]) , .A2(A[1]) , .B1(B[0]) , .B2(B[1]) , .EQ1(N_15) , .EQ2(N_18) );


endmodule /* comp8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : comp12 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef comp12
`else
`define comp12

module comp12 ( A , B, EQ )/* synthesis black_box ql_pack = 1 */;
//pragma attribute comp12 hierarchy preserve

input [11:0] A;
input [11:0] B;
output EQ;

supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;


and14i7 I7  ( .A(N_21) , .B(N_19) , .C(N_17) , .D(N_11) , .E(N_20) , .F(N_22) , .G(VCC),
              .H(GND) , .I(N_15) , .J(N_14) , .K(N_13) , .L(N_12) , .M(N_16) , .N(N_18),
              .Q(EQ) );

eqcombit I1  ( .A1(A[10]) , .A2(A[11]) , .B1(B[10]) , .B2(B[11]) , .EQ1(N_18),
               .EQ2(N_22) );

eqcombit I2  ( .A1(A[8]) , .A2(A[9]) , .B1(B[8]) , .B2(B[9]) , .EQ1(N_16) , .EQ2(N_20) );

eqcombit I3  ( .A1(A[6]) , .A2(A[7]) , .B1(B[6]) , .B2(B[7]) , .EQ1(N_12) , .EQ2(N_11) );

eqcombit I4  ( .A1(A[4]) , .A2(A[5]) , .B1(B[4]) , .B2(B[5]) , .EQ1(N_13) , .EQ2(N_17) );

eqcombit I5  ( .A1(A[2]) , .A2(A[3]) , .B1(B[2]) , .B2(B[3]) , .EQ1(N_14) , .EQ2(N_19) );

eqcombit I6  ( .A1(A[0]) , .A2(A[1]) , .B1(B[0]) , .B2(B[1]) , .EQ1(N_15) , .EQ2(N_21) );


endmodule /* comp12 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_4invar_8bit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_4invar_8bit
`else
`define adder_4invar_8bit

module adder_4invar_8bit ( A , B, C, CI, D, CO, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_4invar_8bit hierarchy preserve

input [7:0] A;
input [7:0] B;
input [7:0] C;
input CI;
output CO;
input [7:0] D;
output [7:0] S;wire N_11;


adder_4invar_4bit I15  ( .A({ A[7:4] }) , .B({ B[7:4] }) , .C({ C[7:4] }),
                         .Cin(N_11) , .Co(CO) , .D({ D[7:4] }) , .S({ S[7:4] }) );

adder_4invar_4bit I16  ( .A({ A[3:0] }) , .B({ B[3:0] }) , .C({ C[3:0] }) , .Cin(CI),
                         .Co(N_11) , .D({ D[3:0] }) , .S({ S[3:0] }) );


endmodule /* adder_4invar_8bit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_4invar_4bit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_4invar_4bit
`else
`define adder_4invar_4bit

module adder_4invar_4bit ( A , B, C, Cin, D, Co, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_4invar_4bit hierarchy preserve

input [3:0] A;
input [3:0] B;
input [3:0] C;
input Cin;
output Co;
input [3:0] D;
output [3:0] S;wire N_33;
wire N_34;
wire N_35;


adder_4invar I12  ( .A(A[3]) , .B(B[3]) , .C(C[3]) , .Cin(N_33) , .Co(Co) , .D(D[3]),
                    .S(S[3]) );

adder_4invar I13  ( .A(A[2]) , .B(B[2]) , .C(C[2]) , .Cin(N_34) , .Co(N_33) , .D(D[2]),
                    .S(S[2]) );

adder_4invar I14  ( .A(A[1]) , .B(B[1]) , .C(C[1]) , .Cin(N_35) , .Co(N_34) , .D(D[1]),
                    .S(S[1]) );

adder_4invar I15  ( .A(A[0]) , .B(B[0]) , .C(C[0]) , .Cin(Cin) , .Co(N_35) , .D(D[0]),
                    .S(S[0]) );


endmodule /* adder_4invar_4bit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_4invar_32bit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_4invar_32bit
`else
`define adder_4invar_32bit

module adder_4invar_32bit ( A , B, C, CI, D, CO, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_4invar_32bit hierarchy preserve

input [31:0] A;
input [31:0] B;
input [31:0] C;
input CI;
output CO;
input [31:0] D;
output [31:0] S;wire N_11;


adder_4invar_16bit I17  ( .A({ A[31:16] }) , .B({ B[31:16] }) , .C({ C[31:16] }),
                          .CI(N_11) , .CO(CO) , .D({ D[31:16] }) , .S({ S[31:16] }) );

adder_4invar_16bit I18  ( .A({ A[15:0] }) , .B({ B[15:0] }) , .C({ C[15:0] }),
                          .CI(CI) , .CO(N_11) , .D({ D[15:0] }) , .S({ S[15:0] }) );


endmodule /* adder_4invar_32bit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_4invar_16bit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_4invar_16bit
`else
`define adder_4invar_16bit

module adder_4invar_16bit ( A , B, C, CI, D, CO, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_4invar_16bit hierarchy preserve

input [15:0] A;
input [15:0] B;
input [15:0] C;
input CI;
output CO;
input [15:0] D;
output [15:0] S;wire N_11;


adder_4invar_8bit I16  ( .A({ A[15:8] }) , .B({ B[15:8] }) , .C({ C[15:8] }),
                         .CI(N_11) , .CO(CO) , .D({ D[15:8] }) , .S({ S[15:8] }) );

adder_4invar_8bit I17  ( .A({ A[7:0] }) , .B({ B[7:0] }) , .C({ C[7:0] }) , .CI(CI),
                         .CO(N_11) , .D({ D[7:0] }) , .S({ S[7:0] }) );


endmodule /* adder_4invar_16bit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_4invar 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_4invar
`else
`define adder_4invar

module adder_4invar ( A , B, C, Cin, D, Co, S )/* synthesis black_box ql_pack = 1 */;
//pragma attribute adder_4invar hierarchy preserve

input A, B, C, Cin;
output Co;
input D;
output S;

wire N_16;
wire N_15;
supply1 VCC;
supply0 GND;
wire N_13;


logic_cell_macro I4  ( .BA1(N_15) , .BA2(VCC) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(C),
                       .CZ(Co) , .F1(Cin) , .F2(VCC) , .FS(D) , .FZ(N_15) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(N_16) , .TA2(N_15) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(N_15) , .TB2(VCC) , .TBS(B) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C), .QZ(), .TZ() );

logic_cell_macro I3  ( .BA1(N_13) , .BA2(N_13) , .BAB(D) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(N_13) , .BB2(N_13) , .BBS1(VCC) , .BBS2(GND) , .BSL(Cin),
                       .CZ(S) , .F1(GND) , .F2(Cin) , .FS(D) , .FZ(N_16) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(C) , .TA2(C) , .TAB(A) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(C) , .TB2(C) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(B),
                       .TZ(N_13), .QZ() );


endmodule /* adder_4invar */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_32bit_2var 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_32bit_2var
`else
`define adder_32bit_2var

module adder_32bit_2var ( A , B, cin, cout, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_32bit_2var hierarchy preserve

input [31:0] A;
input [31:0] B;
input cin;
output cout;
output [31:0] S;wire N_13;


adder_16bit_2var I35  ( .A({ A[31:16] }) , .B({ B[31:16] }) , .CI(N_13) , .CO(cout),
                        .S({ S[31:16] }) );

adder_16bit_2var I36  ( .A({ A[15:0] }) , .B({ B[15:0] }) , .CI(cin) , .CO(N_13),
                        .S({ S[15:0] }) );


endmodule /* adder_32bit_2var */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : adder_16bit_2var 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef adder_16bit_2var
`else
`define adder_16bit_2var

module adder_16bit_2var ( A , B, CI, CO, S )/* synthesis ql_pack = 1 */;
//pragma attribute adder_16bit_2var hierarchy preserve

input [15:0] A;
input [15:0] B;
input CI;
output CO;
output [15:0] S;wire N_60;
wire N_58;
wire N_59;
wire N_55;
wire N_56;
wire N_57;
wire N_53;
wire N_54;
wire N_37;
wire N_40;
wire N_41;
wire N_42;
wire carry14;
wire carry13;
wire carry12;
wire carry8;
wire carry4;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire carry2;
wire carry3;
supply1 VCC;
supply0 GND;


logic_cell_macro I15  ( .BA1(carry14) , .BA2(carry14) , .BAB(A[15]) , .BAS1(GND),
                        .BAS2(VCC) , .BB1(carry14) , .BB2(carry14) , .BBS1(VCC),
                        .BBS2(GND) , .BSL(B[15]) , .CZ(S[15]) , .F1(N_40) , .F2(N_37),
                        .FS(A[15]) , .FZ(CO) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                        .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(carry13),
                        .TA2(carry13) , .TAB(A[14]) , .TAS1(GND) , .TAS2(VCC),
                        .TB1(carry13) , .TB2(carry13) , .TBS(VCC) , .TBS1(VCC),
                        .TBS2(GND) , .TSL(B[14]) , .TZ(S[14]), .QZ() );

logic_cell_macro I17  ( .BA1(GND) , .BA2(carry12) , .BAB(B[13]) , .BAS1(GND),
                        .BAS2(GND) , .BB1(carry12) , .BB2(VCC) , .BBS1(GND),
                        .BBS2(GND) , .BSL(A[13]) , .CZ(carry13) , .F1(carry14),
                        .F2(VCC) , .FS(B[15]) , .FZ(N_37) , .QCK(GND) , .QCKS(VCC),
                        .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                        .TA1(carry12) , .TA2(carry12) , .TAB(A[13]) , .TAS1(GND),
                        .TAS2(VCC) , .TB1(carry12) , .TB2(carry12) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[13]) , .TZ(S[13]), .QZ() );

logic_cell_macro I16  ( .BA1(GND) , .BA2(N_60) , .BAB(B[12]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_60) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[12]),
                        .CZ(carry12) , .F1(GND) , .F2(carry14) , .FS(B[15]),
                        .FZ(N_40) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                        .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(N_60) , .TA2(N_60),
                        .TAB(A[12]) , .TAS1(GND) , .TAS2(VCC) , .TB1(N_60),
                        .TB2(N_60) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(B[12]),
                        .TZ(S[12]), .QZ() );

logic_cell_macro I24  ( .BA1(GND) , .BA2(N_58) , .BAB(B[11]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_58) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[11]),
                        .CZ(N_60) , .F1(N_41) , .F2(N_42) , .FS(A[14]) , .FZ(carry14),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_58) , .TA2(N_58) , .TAB(A[11]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_58) , .TB2(N_58) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[11]) , .TZ(S[11]), .QZ() );

logic_cell_macro I18  ( .BA1(GND) , .BA2(N_59) , .BAB(B[10]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_59) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[10]),
                        .CZ(N_58) , .F1(carry13) , .F2(VCC) , .FS(B[14]) , .FZ(N_42),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_59) , .TA2(N_59) , .TAB(A[10]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_59) , .TB2(N_59) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[10]) , .TZ(S[10]), .QZ() );

logic_cell_macro I19  ( .BA1(GND) , .BA2(carry8) , .BAB(B[9]) , .BAS1(GND),
                        .BAS2(GND) , .BB1(carry8) , .BB2(VCC) , .BBS1(GND),
                        .BBS2(GND) , .BSL(A[9]) , .CZ(N_59) , .F1(GND) , .F2(carry13),
                        .FS(B[14]) , .FZ(N_41) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                        .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(carry8),
                        .TA2(carry8) , .TAB(A[9]) , .TAS1(GND) , .TAS2(VCC),
                        .TB1(carry8) , .TB2(carry8) , .TBS(VCC) , .TBS1(VCC),
                        .TBS2(GND) , .TSL(B[9]) , .TZ(S[9]), .QZ() );

logic_cell_macro I20  ( .BA1(GND) , .BA2(N_55) , .BAB(B[8]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_55) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[8]),
                        .CZ(carry8) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                        .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                        .QST(GND) , .TA1(N_55) , .TA2(N_55) , .TAB(A[8]) , .TAS1(GND),
                        .TAS2(VCC) , .TB1(N_55) , .TB2(N_55) , .TBS(VCC) , .TBS1(VCC),
                        .TBS2(GND) , .TSL(B[8]) , .TZ(S[8]), .FZ(), .QZ() );

logic_cell_macro I14  ( .BA1(carry3) , .BA2(carry3) , .BAB(A[4]) , .BAS1(GND),
                        .BAS2(VCC) , .BB1(carry3) , .BB2(carry3) , .BBS1(VCC),
                        .BBS2(GND) , .BSL(B[4]) , .CZ(S[4]) , .F1(GND) , .F2(GND),
                        .FS(GND) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                        .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(carry2),
                        .TA2(carry2) , .TAB(A[3]) , .TAS1(GND) , .TAS2(VCC),
                        .TB1(carry2) , .TB2(carry2) , .TBS(VCC) , .TBS1(VCC),
                        .TBS2(GND) , .TSL(B[3]) , .TZ(S[3]), .FZ(), .QZ() );

logic_cell_macro I22  ( .BA1(GND) , .BA2(N_57) , .BAB(B[6]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_57) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[6]),
                        .CZ(N_56) , .F1(carry3) , .F2(VCC) , .FS(B[4]) , .FZ(N_47),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_57) , .TA2(N_57) , .TAB(A[6]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_57) , .TB2(N_57) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[6]) , .TZ(S[6]), .QZ() );

logic_cell_macro I21  ( .BA1(GND) , .BA2(N_56) , .BAB(B[7]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_56) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[7]),
                        .CZ(N_55) , .F1(N_46) , .F2(N_47) , .FS(A[4]) , .FZ(carry4),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_56) , .TA2(N_56) , .TAB(A[7]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_56) , .TB2(N_56) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[7]) , .TZ(S[7]), .QZ() );

logic_cell_macro I25  ( .BA1(GND) , .BA2(N_53) , .BAB(B[2]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_53) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[2]),
                        .CZ(carry2) , .F1(N_49) , .F2(N_48) , .FS(A[3]) , .FZ(carry3),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_53) , .TA2(N_53) , .TAB(A[2]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_53) , .TB2(N_53) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[2]) , .TZ(S[2]), .QZ() );

logic_cell_macro I26  ( .BA1(GND) , .BA2(N_54) , .BAB(B[1]) , .BAS1(GND) , .BAS2(GND),
                        .BB1(N_54) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[1]),
                        .CZ(N_53) , .F1(carry2) , .F2(VCC) , .FS(B[3]) , .FZ(N_48),
                        .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                        .QRT(GND) , .QST(GND) , .TA1(N_54) , .TA2(N_54) , .TAB(A[1]),
                        .TAS1(GND) , .TAS2(VCC) , .TB1(N_54) , .TB2(N_54) , .TBS(VCC),
                        .TBS1(VCC) , .TBS2(GND) , .TSL(B[1]) , .TZ(S[1]), .QZ() );

logic_cell_macro I23  ( .BA1(GND) , .BA2(carry4) , .BAB(B[5]) , .BAS1(GND),
                        .BAS2(GND) , .BB1(carry4) , .BB2(VCC) , .BBS1(GND),
                        .BBS2(GND) , .BSL(A[5]) , .CZ(N_57) , .F1(GND) , .F2(carry3),
                        .FS(B[4]) , .FZ(N_46) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                        .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(carry4),
                        .TA2(carry4) , .TAB(A[5]) , .TAS1(GND) , .TAS2(VCC),
                        .TB1(carry4) , .TB2(carry4) , .TBS(VCC) , .TBS1(VCC),
                        .TBS2(GND) , .TSL(B[5]) , .TZ(S[5]), .QZ() );

logic_cell_macro I1  ( .BA1(GND) , .BA2(CI) , .BAB(B[0]) , .BAS1(GND) , .BAS2(GND),
                       .BB1(CI) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A[0]),
                       .CZ(N_54) , .F1(GND) , .F2(carry2) , .FS(B[3]) , .FZ(N_49),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(CI) , .TA2(CI) , .TAB(A[0]),
                       .TAS1(GND) , .TAS2(VCC) , .TB1(CI) , .TB2(CI) , .TBS(VCC),
                       .TBS1(VCC) , .TBS2(GND) , .TSL(B[0]) , .TZ(S[0]), .QZ() );


endmodule /* adder_16bit_2var */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : add4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef add4
`else
`define add4

module add4 ( A , B, Q )/* synthesis black_box */;

input [3:0] A;
input [3:0] B;
output [3:0] Q;wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;


nor2i0 I13  ( .A(B[0]) , .B(A[0]) , .Q(N_11) );

xor2p I12  ( .A(N_18) , .B(N_13) , .Q(Q[2]) );

csabitb I10  ( .A(A[2]) , .B(B[2]) , .C0(N_17) , .C1(N_16) , .S0(N_13) );

csabitb I11  ( .A(A[3]) , .B(B[3]) , .S0(N_14), .C0(), .C1() );

csalow I6  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_12) , .B0(B[0]) , .B1(B[1]) , .C0(N_15),
             .C1(N_18) );

csamuxd I7  ( .A(N_14) , .Q(Q[3]) , .S00(N_17) , .S01(N_16) , .S1(N_18) );

mux4x6 I4  ( .A(N_15) , .B(N_15) , .C(N_15) , .D(N_15) , .Q(Q[1]) , .S0(N_12) , .S1(B[1]) );

and2i2 I5  ( .A(N_11) , .B(N_15) , .Q(Q[0]) );


endmodule /* add4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : add8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef add8
`else
`define add8

module add8 ( A , B, Q )/* synthesis black_box */;

input [7:0] A;
input [7:0] B;
output [7:0] Q;wire N_38;
wire N_39;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;


buff I39  ( .A(N_29) , .Q(N_37) );

muxc2dx2 I37  ( .A(N_23) , .B(N_20) , .C(GND) , .D(GND) , .Q(N_34) , .S(N_38) , .T(N_18), .R() );

muxb2dx2 I38  ( .A(N_23) , .B(N_20) , .C(GND) , .D(GND) , .Q(N_36) , .S(N_39) , .T(N_22), .R() );

xor2p I33  ( .A(N_35) , .B(N_14) , .Q(Q[4]) );

xor2p I32  ( .A(N_37) , .B(N_13) , .Q(Q[2]) );

csabita I40  ( .A(A[6]) , .B(B[6]) , .C0(N_19) , .C1(N_17) , .S0(N_31) );

csabita I28  ( .A(A[4]) , .B(B[4]) , .C0(N_39) , .C1(N_38) , .S0(N_14) );

csabita I29  ( .A(A[7]) , .B(B[7]) , .S0(N_24), .C0(), .C1() );

csabita I31  ( .A(A[5]) , .B(B[5]) , .C0(N_23) , .C1(N_20) , .S0(N_16) );

csabitb I26  ( .A(A[3]) , .B(B[3]) , .C0(N_26) , .C1(N_25) , .S0(N_15) );

csabitb I27  ( .A(A[2]) , .B(B[2]) , .C0(N_28) , .C1(N_27) , .S0(N_13) );

and2i2 I1  ( .A(N_11) , .B(N_21) , .Q(Q[0]) );

nor2i0 I2  ( .A(B[0]) , .B(A[0]) , .Q(N_11) );

mux4x6 I4  ( .A(N_21) , .B(N_21) , .C(N_21) , .D(N_21) , .Q(Q[1]) , .S0(N_12) , .S1(B[1]) );

mux2x1 I7  ( .A(N_24) , .B(N_24) , .Q(N_33) , .S(N_17) );

mux2x2 I8  ( .A(N_24) , .B(N_24) , .Q(N_32) , .S(N_19) );

csalow I16  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_12) , .B0(B[0]) , .B1(B[1]) , .C0(N_21),
              .C1(N_29) );

csamuxc I35  ( .A(N_26) , .B(N_25) , .Q(N_35) , .S00(N_28) , .S01(N_27) , .S1(N_29) );

csamuxb I36  ( .A(N_32) , .B(N_33) , .Q(Q[7]) , .S00(N_36) , .S01(N_34) , .S1(N_35) );

csamuxa I19  ( .A(N_31) , .Q(Q[6]) , .S00(N_36) , .S01(N_34) , .S1(N_35) );

csamuxd I20  ( .A(N_16) , .Q(Q[5]) , .S00(N_22) , .S01(N_18) , .S1(N_35) );

csamuxd I21  ( .A(N_15) , .Q(Q[3]) , .S00(N_28) , .S01(N_27) , .S1(N_37) );


endmodule /* add8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : add16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef add16
`else
`define add16

module add16 ( A , B, Q )/* synthesis black_box */;

input [15:0] A;
input [15:0] B;
output [15:0] Q;wire N_84;
wire N_85;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_36;
wire N_37;
wire N_38;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_71;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;


muxc2dx2 I52  ( .A(N_59) , .B(N_58) , .C(N_59) , .D(N_58) , .Q(N_64) , .R(N_65) , .S(N_85),
                .T(N_57) );

muxb2dx2 I53  ( .A(N_59) , .B(N_58) , .C(N_59) , .D(N_58) , .Q(N_71) , .R(N_63) , .S(N_56),
                .T(N_84) );

muxi2dx2 I48  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_44) , .R(N_29) , .S(N_25) );

muxi2dx2 I49  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_5) , .R(N_7) , .S(N_26) );

muxi2dx2 I50  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_34) , .R(N_8) , .S(N_27) );

muxi2dx2 I51  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_62) , .R(N_67) , .S(N_28) );

mux2dx0 I1  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_40) , .R(N_41) , .S(N_8) );

mux2dx0 I2  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_36) , .R(N_37) , .S(N_4) );

mux2dx2 I57  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_3) , .R(N_6) , .S(N_20) );

mux2dx2 I3  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_43) , .R(N_2) , .S(N_18) );

mux2dx2 I5  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_33) , .R(N_4) , .S(N_22) );

mux2dx2 I6  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_61) , .R(N_66) , .S(N_24) );

mux2dxx I8  ( .A(N_1) , .B(N_1) , .C(N_80) , .D(N_79) , .Q(N_45) , .R(N_46) , .S(N_2) );

mux2dxx I9  ( .A(N_1) , .B(N_1) , .C(N_80) , .D(N_79) , .Q(N_47) , .R(N_48) , .S(N_29) );

mux2x0 I10  ( .A(N_36) , .B(N_40) , .Q(Q[11]) , .S(N_31) );

mux2x0 I11  ( .A(N_33) , .B(N_34) , .Q(Q[9]) , .S(N_31) );

csamuxa I55  ( .A(N_42) , .Q(Q[12]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxa I56  ( .A(N_68) , .Q(Q[6]) , .S00(N_71) , .S01(N_64) , .S1(N_83) );

csamuxa I13  ( .A(N_38) , .Q(Q[10]) , .S00(N_4) , .S01(N_8) , .S1(N_31) );

csamuxb I15  ( .A(N_46) , .B(N_48) , .Q(Q[15]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I16  ( .A(N_45) , .B(N_47) , .Q(Q[14]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I17  ( .A(N_43) , .B(N_44) , .Q(Q[13]) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I18  ( .A(N_66) , .B(N_67) , .Q(N_30) , .S00(N_63) , .S01(N_65) , .S1(N_69) );

csamuxb I19  ( .A(N_66) , .B(N_67) , .Q(N_31) , .S00(N_63) , .S01(N_65) , .S1(N_69) );

csamuxb I20  ( .A(N_61) , .B(N_62) , .Q(Q[7]) , .S00(N_71) , .S01(N_64) , .S1(N_83) );

csamuxc I21  ( .A(N_81) , .B(N_82) , .Q(N_69) , .S00(N_50) , .S01(N_51) , .S1(N_53) );

csamuxd I22  ( .A(N_60) , .Q(Q[5]) , .S00(N_84) , .S01(N_57) , .S1(N_83) );

csamuxd I23  ( .A(N_49) , .Q(Q[3]) , .S00(N_50) , .S01(N_51) , .S1(N_74) );

mux4x6 I24  ( .A(N_55) , .B(N_55) , .C(N_55) , .D(N_55) , .Q(Q[1]) , .S0(N_52) , .S1(B[1]) );

csalow I25  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_52) , .B0(B[0]) , .B1(B[1]) , .C0(N_55),
              .C1(N_53) );

and2i2 I26  ( .A(N_54) , .B(N_55) , .Q(Q[0]) );

nor2i0 I27  ( .A(B[0]) , .B(A[0]) , .Q(N_54) );

buff I54  ( .A(N_53) , .Q(N_74) );

buff I28  ( .A(N_69) , .Q(N_83) );

csabita I30  ( .A(A[14]) , .B(B[14]) , .C0(N_76) , .C1(N_77) , .S0(N_1) );

csabita I31  ( .A(A[13]) , .B(B[13]) , .C0(N_13) , .C1(N_17) , .S0(N_9) );

csabita I32  ( .A(A[12]) , .B(B[12]) , .C0(N_18) , .C1(N_25) , .S0(N_42) );

csabita I33  ( .A(A[11]) , .B(B[11]) , .C0(N_14) , .C1(N_19) , .S0(N_10) );

csabita I34  ( .A(A[10]) , .B(B[10]) , .C0(N_20) , .C1(N_26) , .S0(N_38) );

csabita I35  ( .A(A[9]) , .B(B[9]) , .C0(N_15) , .C1(N_21) , .S0(N_11) );

csabita I36  ( .A(A[8]) , .B(B[8]) , .C0(N_22) , .C1(N_27) , .S0(N_32) );

csabita I37  ( .A(A[7]) , .B(B[7]) , .C0(N_16) , .C1(N_23) , .S0(N_12) );

csabita I38  ( .A(A[6]) , .B(B[6]) , .C0(N_24) , .C1(N_28) , .S0(N_68) );

csabita I39  ( .A(A[5]) , .B(B[5]) , .C0(N_59) , .C1(N_58) , .S0(N_60) );

csabita I40  ( .A(A[4]) , .B(B[4]) , .C0(N_56) , .C1(N_85) , .S0(N_73) );

csabitb I41  ( .A(A[3]) , .B(B[3]) , .C0(N_81) , .C1(N_82) , .S0(N_49) );

csabitb I42  ( .A(A[2]) , .B(B[2]) , .C0(N_50) , .C1(N_51) , .S0(N_75) );

xor2p I43  ( .A(A[15]) , .B(B[15]) , .Q(N_78) );

xor2p I44  ( .A(N_31) , .B(N_32) , .Q(Q[8]) );

xor2p I45  ( .A(N_83) , .B(N_73) , .Q(Q[4]) );

xor2p I46  ( .A(N_74) , .B(N_75) , .Q(Q[2]) );

mux2dxy I47  ( .A(N_76) , .B(N_76) , .C(N_77) , .D(N_77) , .Q(N_80) , .R(N_79) , .S(N_78) );


endmodule /* add16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : add32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef add32
`else
`define add32

module add32 ( A , B, Q )/* synthesis black_box */;

input [31:0] A;
input [31:0] B;
output [31:0] Q;wire N_204;
wire N_205;
wire N_202;
wire N_203;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;
wire N_39;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_70;
wire N_71;
wire N_72;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;
wire N_84;
wire N_85;
wire N_86;
wire N_87;
wire N_88;
wire N_89;
wire N_90;
wire N_91;
wire N_92;
wire N_93;
wire N_94;
wire N_95;
wire N_96;
wire N_97;
wire N_98;
wire N_99;
wire N_100;
wire N_101;
wire N_102;
wire N_103;
wire N_104;
wire N_105;
wire N_106;
wire N_107;
wire N_108;
wire N_109;
wire N_110;
wire N_111;
wire N_112;
wire N_113;
wire N_114;
wire N_115;
wire N_116;
wire N_118;
wire N_120;
wire N_121;
wire N_122;
wire N_123;
wire N_124;
wire N_125;
wire N_126;
wire N_127;
wire N_128;
wire N_129;
wire N_130;
wire N_131;
wire N_132;
wire N_133;
wire N_134;
wire N_135;
wire N_136;
wire N_137;
wire N_138;
wire N_139;
wire N_140;
wire N_141;
wire N_142;
wire N_143;
wire N_144;
wire N_145;
wire N_146;
wire N_147;
wire N_148;
wire N_149;
wire N_150;
wire N_151;
wire N_152;
wire N_153;
wire N_154;
wire N_155;
wire N_156;
wire N_157;
wire N_158;
wire N_159;
wire N_160;
wire N_161;
wire N_162;
wire N_163;
wire N_164;
wire N_165;
wire N_166;
wire N_167;
wire N_168;
wire N_169;
wire N_170;
wire N_171;
wire N_172;
wire N_173;
wire N_174;
wire N_175;
wire N_176;
wire N_177;
wire N_178;
wire N_179;
wire N_180;
wire N_181;
wire N_182;
wire N_184;
wire N_185;
wire N_186;
wire N_187;
wire N_188;
wire N_189;
wire N_190;
wire C15A;
wire C15B;
wire N_192;
wire N_193;
wire N_194;
wire N_195;
wire N_196;
wire N_197;
wire N_198;
wire C15C;
wire C15D;
wire N_199;
wire N_200;
wire N_201;


nor2i0 I77  ( .A(B[0]) , .B(A[0]) , .Q(N_133) );

muxb2dx0 I63  ( .A(N_74) , .B(N_75) , .C(N_74) , .D(N_75) , .Q(N_78) , .R(N_3) , .S(N_76),
                .T(N_82) );

muxb2dx0 I64  ( .A(N_74) , .B(N_75) , .C(N_74) , .D(N_75) , .Q(N_77) , .R(N_2) , .S(N_4),
                .T(N_83) );

muxb2dx0 I65  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_58) , .R(N_59) , .S(N_16),
                .T(N_57) );

muxb2dx0 I66  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_62) , .R(N_63) , .S(N_20),
                .T(N_61) );

muxb2dx0 I61  ( .A(N_176) , .B(N_186) , .C(N_176) , .D(N_186) , .Q(N_188) , .R(N_187),
                .S(N_204) , .T(N_178) );

muxb2dx0 I62  ( .A(N_176) , .B(N_186) , .C(N_176) , .D(N_186) , .Q(N_184) , .R(N_185),
                .S(N_205) , .T(N_177) );

muxc2dx2 I59  ( .A(N_128) , .B(N_129) , .C(N_128) , .D(N_129) , .Q(N_189) , .R(N_124),
                .S(N_203) , .T(N_130) );

muxb2dx2 I60  ( .A(N_128) , .B(N_129) , .C(N_128) , .D(N_129) , .Q(N_190) , .R(N_118),
                .S(N_131) , .T(N_202) );

muxi2dx2 I67  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_66) , .R(N_32) , .S(N_37) );

muxi2dx2 I68  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_17) , .R(N_19) , .S(N_29) );

muxi2dx2 I69  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_56) , .R(N_20) , .S(N_30) );

muxi2dx2 I70  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_91) , .R(N_98) , .S(N_46) );

muxi2dx2 I71  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_96) , .R(N_87) , .S(N_47) );

muxi2dx2 I72  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_84) , .R(N_75) , .S(N_13) );

muxi2dx2 I73  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_79) , .R(N_76) , .S(N_14) );

muxi2dx2 I54  ( .A(N_165) , .B(N_165) , .C(N_167) , .D(N_169) , .Q(N_159) , .R(N_161),
                .S(N_173) );

muxi2dx2 I55  ( .A(N_166) , .B(N_166) , .C(N_168) , .D(N_171) , .Q(N_194) , .R(N_164),
                .S(N_174) );

muxi2dx2 I56  ( .A(N_149) , .B(N_149) , .C(N_151) , .D(N_153) , .Q(N_179) , .R(N_186),
                .S(N_157) );

muxi2dx2 I57  ( .A(N_150) , .B(N_150) , .C(N_152) , .D(N_155) , .Q(N_148) , .R(N_204),
                .S(N_158) );

muxi2dx2 I58  ( .A(N_145) , .B(N_145) , .C(N_144) , .D(N_143) , .Q(N_125) , .R(N_122),
                .S(N_141) );

mux2dxy QL1  ( .A(N_52) , .B(N_52) , .C(N_53) , .D(N_53) , .Q(N_50) , .R(N_49) , .S(N_51) );

xor2p QL2  ( .A(A[31]) , .B(B[31]) , .Q(N_51) );

xor2p QL3  ( .A(C15A) , .B(N_73) , .Q(Q[16]) );

xor2p I1  ( .A(N_139) , .B(N_146) , .Q(Q[8]) );

xor2p I2  ( .A(N_111) , .B(N_116) , .Q(Q[4]) );

xor2p I3  ( .A(N_115) , .B(N_114) , .Q(Q[2]) );

csabitb I4  ( .A(A[3]) , .B(B[3]) , .C0(N_113) , .C1(N_112) , .S0(N_138) );

csabitb I5  ( .A(A[2]) , .B(B[2]) , .C0(N_137) , .C1(N_136) , .S0(N_114) );

csabita I86  ( .A(A[28]) , .B(B[28]) , .C0(N_36) , .C1(N_37) , .S0(N_64) );

csabita I87  ( .A(A[26]) , .B(B[26]) , .C0(N_26) , .C1(N_29) , .S0(N_60) );

csabita I88  ( .A(A[24]) , .B(B[24]) , .C0(N_28) , .C1(N_30) , .S0(N_89) );

csabita I89  ( .A(A[22]) , .B(B[22]) , .C0(N_43) , .C1(N_46) , .S0(N_92) );

csabita I90  ( .A(A[20]) , .B(B[20]) , .C0(N_45) , .C1(N_47) , .S0(N_97) );

csabita I91  ( .A(A[18]) , .B(B[18]) , .C0(N_10) , .C1(N_13) , .S0(N_85) );

csabita I92  ( .A(A[16]) , .B(B[16]) , .C0(N_12) , .C1(N_14) , .S0(N_73) );

csabita I82  ( .A(A[6]) , .B(B[6]) , .C0(N_142) , .C1(N_141) , .S0(N_121) );

csabita I78  ( .A(A[8]) , .B(B[8]) , .C0(N_156) , .C1(N_158) , .S0(N_146) );

csabita I79  ( .A(A[10]) , .B(B[10]) , .C0(N_154) , .C1(N_157) , .S0(N_175) );

csabita I80  ( .A(A[12]) , .B(B[12]) , .C0(N_172) , .C1(N_174) , .S0(N_192) );

csabita I81  ( .A(A[14]) , .B(B[14]) , .C0(N_170) , .C1(N_173) , .S0(N_199) );

csabita QL16  ( .A(A[25]) , .B(B[25]) , .C0(N_24) , .C1(N_27) , .S0(N_22) );

csabita QL10  ( .A(A[19]) , .B(B[19]) , .C0(N_7) , .C1(N_9) , .S0(N_5) );

csabita QL12  ( .A(A[21]) , .B(B[21]) , .C0(N_41) , .C1(N_44) , .S0(N_39) );

csabita QL14  ( .A(A[23]) , .B(B[23]) , .C0(N_40) , .C1(N_42) , .S0(N_38) );

csabita QL18  ( .A(A[27]) , .B(B[27]) , .C0(N_23) , .C1(N_25) , .S0(N_21) );

csabita QL20  ( .A(A[29]) , .B(B[29]) , .C0(N_34) , .C1(N_35) , .S0(N_33) );

csabita QL21  ( .A(A[30]) , .B(B[30]) , .C0(N_52) , .C1(N_53) , .S0(N_48) );

csabita QL22  ( .A(A[17]) , .B(B[17]) , .C0(N_8) , .C1(N_11) , .S0(N_6) );

csabita I6  ( .A(A[15]) , .B(B[15]) , .C0(N_167) , .C1(N_169) , .S0(N_165) );

csabita I8  ( .A(A[13]) , .B(B[13]) , .C0(N_168) , .C1(N_171) , .S0(N_166) );

csabita I10  ( .A(A[11]) , .B(B[11]) , .C0(N_151) , .C1(N_153) , .S0(N_149) );

csabita I12  ( .A(A[9]) , .B(B[9]) , .C0(N_152) , .C1(N_155) , .S0(N_150) );

csabita I14  ( .A(A[7]) , .B(B[7]) , .C0(N_144) , .C1(N_143) , .S0(N_145) );

csabita I16  ( .A(A[5]) , .B(B[5]) , .C0(N_128) , .C1(N_129) , .S0(N_127) );

csabita I17  ( .A(A[4]) , .B(B[4]) , .C0(N_131) , .C1(N_203) , .S0(N_116) );

buff I76  ( .A(N_134) , .Q(N_115) );

buff I18  ( .A(N_120) , .Q(N_111) );

and2i2 I21  ( .A(N_133) , .B(N_132) , .Q(Q[0]) );

csalow I22  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_135) , .B0(B[0]) , .B1(B[1]) , .C0(N_132),
              .C1(N_134) );

mux4x6 I23  ( .A(N_132) , .B(N_132) , .C(N_132) , .D(N_132) , .Q(Q[1]) , .S0(N_135),
              .S1(B[1]) );

csamuxd I24  ( .A(N_127) , .Q(Q[5]) , .S00(N_202) , .S01(N_130) , .S1(N_111) );

csamuxd I25  ( .A(N_138) , .Q(Q[3]) , .S00(N_137) , .S01(N_136) , .S1(N_115) );

csamuxc I26  ( .A(N_113) , .B(N_112) , .Q(N_120) , .S00(N_137) , .S01(N_136),
               .S1(N_134) );

csamuxb I99  ( .A(N_100) , .B(N_98) , .Q(N_88) , .S00(N_1) , .S01(N_87) , .S1(N_3) );

csamuxb I100  ( .A(N_100) , .B(N_98) , .Q(N_110) , .S00(N_1) , .S01(N_87) , .S1(N_2) );

csamuxb I96  ( .A(N_72) , .B(N_71) , .Q(Q[26]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb I97  ( .A(N_94) , .B(N_80) , .Q(Q[22]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb QL57  ( .A(N_86) , .B(N_84) , .Q(Q[19]) , .S00(N_83) , .S01(N_82) , .S1(C15A) );

csamuxb QL59  ( .A(N_100) , .B(N_98) , .Q(N_99) , .S00(N_1) , .S01(N_87) , .S1(N_2) );

csamuxb QL61  ( .A(N_100) , .B(N_98) , .Q(N_109) , .S00(N_1) , .S01(N_87) , .S1(N_3) );

csamuxb QL49  ( .A(N_95) , .B(N_96) , .Q(Q[21]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb QL47  ( .A(N_93) , .B(N_81) , .Q(Q[23]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxb QL50  ( .A(N_55) , .B(N_56) , .Q(Q[25]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb QL52  ( .A(N_58) , .B(N_62) , .Q(Q[27]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxb QL53  ( .A(N_101) , .B(N_103) , .Q(Q[28]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL54  ( .A(N_102) , .B(N_104) , .Q(Q[29]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL55  ( .A(N_105) , .B(N_107) , .Q(Q[30]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb QL56  ( .A(N_106) , .B(N_108) , .Q(Q[31]) , .S00(N_110) , .S01(N_109),
                .S1(C15D) );

csamuxb I27  ( .A(N_200) , .B(N_201) , .Q(C15D) , .S00(N_185) , .S01(N_187) , .S1(N_140) );

csamuxb I28  ( .A(N_200) , .B(N_201) , .Q(C15C) , .S00(N_185) , .S01(N_187) , .S1(N_140) );

csamuxb I29  ( .A(N_198) , .B(N_181) , .Q(C15B) , .S00(N_185) , .S01(N_187) , .S1(N_140) );

csamuxb I30  ( .A(N_198) , .B(N_181) , .Q(C15A) , .S00(N_185) , .S01(N_187) , .S1(N_140) );

csamuxb I31  ( .A(N_197) , .B(N_182) , .Q(Q[15]) , .S00(N_184) , .S01(N_188),
               .S1(N_139) );

csamuxb I32  ( .A(N_195) , .B(N_196) , .Q(Q[14]) , .S00(N_184) , .S01(N_188),
               .S1(N_139) );

csamuxb I33  ( .A(N_193) , .B(N_194) , .Q(Q[13]) , .S00(N_184) , .S01(N_188),
               .S1(N_139) );

csamuxb I34  ( .A(N_180) , .B(N_179) , .Q(Q[11]) , .S00(N_177) , .S01(N_178),
               .S1(N_139) );

csamuxb I35  ( .A(N_123) , .B(N_122) , .Q(N_140) , .S00(N_118) , .S01(N_124),
               .S1(N_120) );

csamuxb I36  ( .A(N_123) , .B(N_122) , .Q(N_139) , .S00(N_190) , .S01(N_189),
               .S1(N_120) );

csamuxb I37  ( .A(N_126) , .B(N_125) , .Q(Q[7]) , .S00(N_190) , .S01(N_189) , .S1(N_111) );

csamuxa I74  ( .A(N_97) , .Q(Q[20]) , .S00(N_77) , .S01(N_78) , .S1(C15B) );

csamuxa I75  ( .A(N_85) , .Q(Q[18]) , .S00(N_83) , .S01(N_82) , .S1(C15A) );

csamuxa QL75  ( .A(N_89) , .Q(Q[24]) , .S00(N_99) , .S01(N_88) , .S1(C15C) );

csamuxa I38  ( .A(N_175) , .Q(Q[10]) , .S00(N_177) , .S01(N_178) , .S1(N_139) );

csamuxa I39  ( .A(N_192) , .Q(Q[12]) , .S00(N_184) , .S01(N_188) , .S1(N_139) );

csamuxa I40  ( .A(N_121) , .Q(Q[6]) , .S00(N_190) , .S01(N_189) , .S1(N_111) );

mux2x0 QL85  ( .A(N_54) , .B(N_79) , .Q(Q[17]) , .S(C15A) );

mux2x0 I41  ( .A(N_147) , .B(N_148) , .Q(Q[9]) , .S(N_139) );

mux2dxx I101  ( .A(N_92) , .B(N_92) , .C(N_90) , .D(N_91) , .Q(N_80) , .R(N_81) , .S(N_87) );

mux2dxx I98  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_101) , .R(N_102),
               .S(N_59) );

mux2dxx I83  ( .A(N_199) , .B(N_199) , .C(N_160) , .D(N_159) , .Q(N_196) , .R(N_182),
               .S(N_164) );

mux2dxx I84  ( .A(N_199) , .B(N_199) , .C(N_160) , .D(N_159) , .Q(N_195) , .R(N_197),
               .S(N_163) );

mux2dxx QL91  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_103) , .R(N_104),
                .S(N_63) );

mux2dxx QL92  ( .A(N_92) , .B(N_92) , .C(N_90) , .D(N_91) , .Q(N_94) , .R(N_93) , .S(N_1) );

mux2dxx QL88  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_67) , .R(N_68) , .S(N_31) );

mux2dxx QL89  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_69) , .R(N_70) , .S(N_32) );

mux2dx2 I94  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_15) , .R(N_18) , .S(N_26) );

mux2dx2 I95  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_90) , .R(N_100) , .S(N_43) );

mux2dx2 I93  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_95) , .R(N_1) , .S(N_45) );

mux2dx2 I85  ( .A(N_165) , .B(N_165) , .C(N_167) , .D(N_169) , .Q(N_160) , .R(N_162),
               .S(N_170) );

mux2dx2 QL114  ( .A(N_57) , .B(N_57) , .C(N_61) , .D(N_61) , .Q(N_72) , .R(N_71),
                 .S(N_60) );

mux2dx2 QL110  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_55) , .R(N_16),
                 .S(N_28) );

mux2dx2 QL108  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_54) , .R(N_4) , .S(N_12) );

mux2dx2 QL107  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_86) , .R(N_74) , .S(N_10) );

mux2dx2 QL111  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_65) , .R(N_31),
                 .S(N_36) );

mux2dx2 I45  ( .A(N_166) , .B(N_166) , .C(N_168) , .D(N_171) , .Q(N_193) , .R(N_163),
               .S(N_172) );

mux2dx2 I46  ( .A(N_149) , .B(N_149) , .C(N_151) , .D(N_153) , .Q(N_180) , .R(N_176),
               .S(N_154) );

mux2dx2 I47  ( .A(N_150) , .B(N_150) , .C(N_152) , .D(N_155) , .Q(N_147) , .R(N_205),
               .S(N_156) );

mux2dx2 I48  ( .A(N_145) , .B(N_145) , .C(N_144) , .D(N_143) , .Q(N_126) , .R(N_123),
               .S(N_142) );

mux2dx0 QL121  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_107) , .R(N_108),
                 .S(N_63) );

mux2dx0 QL120  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_105) , .R(N_106),
                 .S(N_59) );

mux2dx0 I50  ( .A(N_162) , .B(N_161) , .C(N_162) , .D(N_161) , .Q(N_181) , .R(N_201),
               .S(N_164) );

mux2dx0 I51  ( .A(N_162) , .B(N_161) , .C(N_162) , .D(N_161) , .Q(N_198) , .R(N_200),
               .S(N_163) );


endmodule /* add32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : accum8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef accum8
`else
`define accum8

module accum8 ( A , CLK, CLR, Q )/* synthesis black_box */;

input [7:0] A;
input CLK, CLR;
output [7:0] Q;wire N_48;
wire N_49;
wire N_47;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;


muxb2dx2 I34  ( .A(N_32) , .B(N_29) , .C(GND) , .D(GND) , .Q(N_45) , .S(N_47) , .T(N_48), .R() );

muxc2dx2 I35  ( .A(N_32) , .B(N_29) , .C(GND) , .D(GND) , .Q(N_43) , .S(N_49) , .T(N_27), .R() );

mux2x1 I1  ( .A(N_33) , .B(N_33) , .Q(N_42) , .S(N_26) );

mux2x2 I2  ( .A(N_33) , .B(N_33) , .Q(N_41) , .S(N_28) );

csamuxb I3  ( .A(N_41) , .B(N_42) , .Q(N_23) , .S00(N_45) , .S01(N_43) , .S1(N_44) );

csamuxa I4  ( .A(N_40) , .Q(N_22) , .S00(N_45) , .S01(N_43) , .S1(N_44) );

csamuxc I5  ( .A(N_35) , .B(N_34) , .Q(N_44) , .S00(N_37) , .S01(N_36) , .S1(N_38) );

csamuxd I6  ( .A(N_25) , .Q(N_21) , .S00(N_48) , .S01(N_27) , .S1(N_44) );

csamuxd I7  ( .A(N_24) , .Q(N_17) , .S00(N_37) , .S01(N_36) , .S1(N_46) );

xor2p I8  ( .A(N_44) , .B(N_19) , .Q(N_18) );

xor2p I9  ( .A(N_46) , .B(N_16) , .Q(N_15) );

buff I10  ( .A(N_38) , .Q(N_46) );

mux4x6 I11  ( .A(N_30) , .B(N_30) , .C(N_30) , .D(N_30) , .Q(N_14) , .S0(N_13) , .S1(Q[1]) );

dffc I12  ( .CLK(CLK) , .CLR(CLR) , .D(N_23) , .Q(Q[7]) );

dffc I13  ( .CLK(CLK) , .CLR(CLR) , .D(N_22) , .Q(Q[6]) );

dffc I14  ( .CLK(CLK) , .CLR(CLR) , .D(N_21) , .Q(Q[5]) );

dffc I15  ( .CLK(CLK) , .CLR(CLR) , .D(N_18) , .Q(Q[4]) );

dffc I16  ( .CLK(CLK) , .CLR(CLR) , .D(N_17) , .Q(Q[3]) );

dffc I17  ( .CLK(CLK) , .CLR(CLR) , .D(N_15) , .Q(Q[2]) );

dffc I18  ( .CLK(CLK) , .CLR(CLR) , .D(N_14) , .Q(Q[1]) );

dffc I19  ( .CLK(CLK) , .CLR(CLR) , .D(N_12) , .Q(Q[0]) );

csabita I30  ( .A(A[7]) , .B(Q[7]) , .S0(N_33), .C0(), .C1() );

csabita I31  ( .A(A[6]) , .B(Q[6]) , .C0(N_28) , .C1(N_26) , .S0(N_40) );

csabita I32  ( .A(A[5]) , .B(Q[5]) , .C0(N_32) , .C1(N_29) , .S0(N_25) );

csabita I33  ( .A(A[4]) , .B(Q[4]) , .C0(N_47) , .C1(N_49) , .S0(N_19) );

csabitb I24  ( .A(A[3]) , .B(Q[3]) , .C0(N_35) , .C1(N_34) , .S0(N_24) );

csabitb I25  ( .A(A[2]) , .B(Q[2]) , .C0(N_37) , .C1(N_36) , .S0(N_16) );

csalow I26  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_13) , .B0(Q[0]) , .B1(Q[1]) , .C0(N_30),
              .C1(N_38) );

and2i2 I27  ( .A(N_11) , .B(N_30) , .Q(N_12) );

nor2i0 I28  ( .A(Q[0]) , .B(A[0]) , .Q(N_11) );


endmodule /* accum8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : accum32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef accum32
`else
`define accum32

module accum32 ( A , CLK, CLR, Q )/* synthesis black_box */;

input [31:0] A;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output [31:0] Q;wire N_234;
wire N_235;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;
wire N_39;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_70;
wire N_71;
wire N_72;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;
wire N_84;
wire N_85;
wire N_86;
wire N_87;
wire N_88;
wire N_89;
wire N_90;
wire N_91;
wire N_92;
wire N_93;
wire N_94;
wire N_95;
wire N_96;
wire N_97;
wire N_98;
wire N_99;
wire N_100;
wire N_101;
wire N_102;
wire N_103;
wire N_104;
wire N_105;
wire N_106;
wire N_107;
wire N_108;
wire N_109;
wire N_110;
wire N_111;
wire N_112;
wire N_113;
wire N_114;
wire N_115;
wire N_116;
wire N_117;
wire N_118;
wire N_119;
wire N_120;
wire N_121;
wire N_122;
wire N_123;
wire N_124;
wire N_125;
wire N_126;
wire N_127;
wire N_128;
wire N_129;
wire N_130;
wire N_131;
wire N_132;
wire N_133;
wire N_134;
wire N_135;
wire N_136;
wire N_137;
wire N_138;
wire N_139;
wire N_140;
wire N_141;
wire N_143;
wire N_145;
wire N_146;
wire N_147;
wire N_148;
wire N_149;
wire N_150;
wire N_151;
wire N_152;
wire N_153;
wire N_154;
wire N_155;
wire N_156;
wire N_157;
wire N_158;
wire N_159;
wire N_160;
wire N_161;
wire N_162;
wire N_163;
wire N_164;
wire N_165;
wire N_166;
wire N_167;
wire N_168;
wire N_169;
wire N_170;
wire N_171;
wire N_172;
wire N_173;
wire N_174;
wire N_175;
wire N_176;
wire N_177;
wire N_178;
wire N_179;
wire N_180;
wire N_181;
wire N_182;
wire N_183;
wire N_184;
wire N_185;
wire N_186;
wire N_187;
wire N_188;
wire N_189;
wire N_190;
wire N_191;
wire N_192;
wire N_193;
wire N_194;
wire N_195;
wire N_196;
wire N_197;
wire N_198;
wire N_199;
wire N_200;
wire N_201;
wire N_202;
wire N_203;
wire N_204;
wire N_205;
wire N_206;
wire N_207;
wire N_208;
wire N_209;
wire N_210;
wire N_211;
wire N_212;
wire N_213;
wire N_214;
wire N_216;
wire N_217;
wire N_218;
wire N_219;
wire N_220;
wire N_221;
wire N_222;
wire C15A;
wire C15B;
wire N_224;
wire N_225;
wire N_226;
wire N_227;
wire N_228;
wire N_229;
wire N_230;
wire C15C;
wire C15D;
wire N_231;
wire N_232;
wire N_233;


nor2i0 I90  ( .A(Q[0]) , .B(A[0]) , .Q(N_158) );

muxb2dx0 I77  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_62) , .R(N_63) , .S(N_20),
                .T(N_61) );

muxb2dx0 I78  ( .A(N_15) , .B(N_17) , .C(N_18) , .D(N_19) , .Q(N_58) , .R(N_59) , .S(N_16),
                .T(N_57) );

muxb2dx0 I79  ( .A(N_88) , .B(N_89) , .C(N_88) , .D(N_89) , .Q(N_92) , .R(N_3) , .S(N_90),
                .T(N_96) );

muxb2dx0 I80  ( .A(N_88) , .B(N_89) , .C(N_88) , .D(N_89) , .Q(N_91) , .R(N_2) , .S(N_4),
                .T(N_97) );

muxc2dx2 I75  ( .A(N_153) , .B(N_154) , .C(N_153) , .D(N_154) , .Q(N_221) , .R(N_149),
                .S(N_235) , .T(N_155) );

muxb2dx2 I76  ( .A(N_153) , .B(N_154) , .C(N_153) , .D(N_154) , .Q(N_222) , .R(N_143),
                .S(N_156) , .T(N_234) );

muxi2dx2 I81  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_93) , .R(N_90) , .S(N_14) );

muxi2dx2 I82  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_98) , .R(N_89) , .S(N_13) );

muxi2dx2 I83  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_112) , .R(N_102),
                .S(N_47) );

muxi2dx2 I84  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_107) , .R(N_114),
                .S(N_46) );

muxi2dx2 I85  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_56) , .R(N_20) , .S(N_30) );

muxi2dx2 I86  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_17) , .R(N_19) , .S(N_29) );

muxi2dx2 I87  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_66) , .R(N_32) , .S(N_37) );

muxi2dx2 I70  ( .A(N_192) , .B(N_192) , .C(N_194) , .D(N_196) , .Q(N_186) , .R(N_188),
                .S(N_200) );

muxi2dx2 I71  ( .A(N_193) , .B(N_193) , .C(N_195) , .D(N_198) , .Q(N_226) , .R(N_191),
                .S(N_201) );

muxi2dx2 I72  ( .A(N_174) , .B(N_174) , .C(N_176) , .D(N_178) , .Q(N_211) , .R(N_218),
                .S(N_182) );

muxi2dx2 I73  ( .A(N_175) , .B(N_175) , .C(N_177) , .D(N_180) , .Q(N_173) , .R(N_210),
                .S(N_183) );

muxi2dx2 I74  ( .A(N_170) , .B(N_170) , .C(N_169) , .D(N_168) , .Q(N_150) , .R(N_147),
                .S(N_166) );

mux2dxy QL1  ( .A(N_52) , .B(N_52) , .C(N_53) , .D(N_53) , .Q(N_50) , .R(N_49) , .S(N_51) );

dffc QL15  ( .CLK(CLK) , .CLR(CLR) , .D(N_73) , .Q(Q[31]) );

dffc QL14  ( .CLK(CLK) , .CLR(CLR) , .D(N_74) , .Q(Q[30]) );

dffc QL13  ( .CLK(CLK) , .CLR(CLR) , .D(N_75) , .Q(Q[29]) );

dffc QL12  ( .CLK(CLK) , .CLR(CLR) , .D(N_76) , .Q(Q[28]) );

dffc QL11  ( .CLK(CLK) , .CLR(CLR) , .D(N_77) , .Q(Q[27]) );

dffc QL10  ( .CLK(CLK) , .CLR(CLR) , .D(N_78) , .Q(Q[26]) );

dffc QL9  ( .CLK(CLK) , .CLR(CLR) , .D(N_79) , .Q(Q[25]) );

dffc QL17  ( .CLK(CLK) , .CLR(CLR) , .D(N_103) , .Q(Q[24]) );

dffc QL5  ( .CLK(CLK) , .CLR(CLR) , .D(N_80) , .Q(Q[23]) );

dffc QL6  ( .CLK(CLK) , .CLR(CLR) , .D(N_81) , .Q(Q[22]) );

dffc QL7  ( .CLK(CLK) , .CLR(CLR) , .D(N_82) , .Q(Q[21]) );

dffc QL8  ( .CLK(CLK) , .CLR(CLR) , .D(N_83) , .Q(Q[20]) );

dffc QL16  ( .CLK(CLK) , .CLR(CLR) , .D(N_99) , .Q(Q[19]) );

dffc QL4  ( .CLK(CLK) , .CLR(CLR) , .D(N_84) , .Q(Q[18]) );

dffc QL2  ( .CLK(CLK) , .CLR(CLR) , .D(N_85) , .Q(Q[17]) );

dffc QL3  ( .CLK(CLK) , .CLR(CLR) , .D(N_86) , .Q(Q[16]) );

dffc I1  ( .CLK(CLK) , .CLR(CLR) , .D(N_202) , .Q(Q[15]) );

dffc I2  ( .CLK(CLK) , .CLR(CLR) , .D(N_203) , .Q(Q[14]) );

dffc I3  ( .CLK(CLK) , .CLR(CLR) , .D(N_204) , .Q(Q[13]) );

dffc I4  ( .CLK(CLK) , .CLR(CLR) , .D(N_205) , .Q(Q[12]) );

dffc I5  ( .CLK(CLK) , .CLR(CLR) , .D(N_206) , .Q(Q[11]) );

dffc I6  ( .CLK(CLK) , .CLR(CLR) , .D(N_127) , .Q(Q[10]) );

dffc I7  ( .CLK(CLK) , .CLR(CLR) , .D(N_184) , .Q(Q[9]) );

dffc I8  ( .CLK(CLK) , .CLR(CLR) , .D(N_185) , .Q(Q[8]) );

dffc I9  ( .CLK(CLK) , .CLR(CLR) , .D(N_128) , .Q(Q[7]) );

dffc I10  ( .CLK(CLK) , .CLR(CLR) , .D(N_129) , .Q(Q[6]) );

dffc I11  ( .CLK(CLK) , .CLR(CLR) , .D(N_130) , .Q(Q[5]) );

dffc I12  ( .CLK(CLK) , .CLR(CLR) , .D(N_131) , .Q(Q[4]) );

dffc I13  ( .CLK(CLK) , .CLR(CLR) , .D(N_132) , .Q(Q[3]) );

dffc I14  ( .CLK(CLK) , .CLR(CLR) , .D(N_133) , .Q(Q[2]) );

dffc I15  ( .CLK(CLK) , .CLR(CLR) , .D(N_134) , .Q(Q[1]) );

dffc I16  ( .CLK(CLK) , .CLR(CLR) , .D(N_135) , .Q(Q[0]) );

xor2p QL34  ( .A(A[31]) , .B(Q[31]) , .Q(N_51) );

xor2p QL35  ( .A(C15A) , .B(N_87) , .Q(N_86) );

xor2p I17  ( .A(N_164) , .B(N_171) , .Q(N_185) );

xor2p I18  ( .A(N_136) , .B(N_141) , .Q(N_131) );

xor2p I19  ( .A(N_140) , .B(N_139) , .Q(N_133) );

csabitb I20  ( .A(A[3]) , .B(Q[3]) , .C0(N_138) , .C1(N_137) , .S0(N_163) );

csabitb I21  ( .A(A[2]) , .B(Q[2]) , .C0(N_162) , .C1(N_161) , .S0(N_139) );

csabita I110  ( .A(A[24]) , .B(Q[24]) , .C0(N_28) , .C1(N_30) , .S0(N_105) );

csabita I111  ( .A(A[22]) , .B(Q[22]) , .C0(N_43) , .C1(N_46) , .S0(N_108) );

csabita I107  ( .A(A[28]) , .B(Q[28]) , .C0(N_36) , .C1(N_37) , .S0(N_64) );

csabita I108  ( .A(A[26]) , .B(Q[26]) , .C0(N_26) , .C1(N_29) , .S0(N_60) );

csabita I109  ( .A(A[20]) , .B(Q[20]) , .C0(N_45) , .C1(N_47) , .S0(N_113) );

csabita I105  ( .A(A[18]) , .B(Q[18]) , .C0(N_10) , .C1(N_13) , .S0(N_100) );

csabita I106  ( .A(A[16]) , .B(Q[16]) , .C0(N_12) , .C1(N_14) , .S0(N_87) );

csabita I98  ( .A(A[8]) , .B(Q[8]) , .C0(N_181) , .C1(N_183) , .S0(N_171) );

csabita I96  ( .A(A[14]) , .B(Q[14]) , .C0(N_197) , .C1(N_200) , .S0(N_231) );

csabita I97  ( .A(A[12]) , .B(Q[12]) , .C0(N_199) , .C1(N_201) , .S0(N_224) );

csabita I94  ( .A(A[10]) , .B(Q[10]) , .C0(N_179) , .C1(N_182) , .S0(N_207) );

csabita I92  ( .A(A[6]) , .B(Q[6]) , .C0(N_167) , .C1(N_166) , .S0(N_146) );

csabita QL53  ( .A(A[30]) , .B(Q[30]) , .C0(N_52) , .C1(N_53) , .S0(N_48) );

csabita QL52  ( .A(A[29]) , .B(Q[29]) , .C0(N_34) , .C1(N_35) , .S0(N_33) );

csabita QL50  ( .A(A[27]) , .B(Q[27]) , .C0(N_23) , .C1(N_25) , .S0(N_21) );

csabita QL48  ( .A(A[25]) , .B(Q[25]) , .C0(N_24) , .C1(N_27) , .S0(N_22) );

csabita QL46  ( .A(A[23]) , .B(Q[23]) , .C0(N_40) , .C1(N_42) , .S0(N_38) );

csabita QL44  ( .A(A[21]) , .B(Q[21]) , .C0(N_41) , .C1(N_44) , .S0(N_39) );

csabita QL42  ( .A(A[19]) , .B(Q[19]) , .C0(N_7) , .C1(N_9) , .S0(N_5) );

csabita QL54  ( .A(A[17]) , .B(Q[17]) , .C0(N_8) , .C1(N_11) , .S0(N_6) );

csabita I22  ( .A(A[15]) , .B(Q[15]) , .C0(N_194) , .C1(N_196) , .S0(N_192) );

csabita I24  ( .A(A[13]) , .B(Q[13]) , .C0(N_195) , .C1(N_198) , .S0(N_193) );

csabita I26  ( .A(A[11]) , .B(Q[11]) , .C0(N_176) , .C1(N_178) , .S0(N_174) );

csabita I28  ( .A(A[9]) , .B(Q[9]) , .C0(N_177) , .C1(N_180) , .S0(N_175) );

csabita I30  ( .A(A[7]) , .B(Q[7]) , .C0(N_169) , .C1(N_168) , .S0(N_170) );

csabita I32  ( .A(A[5]) , .B(Q[5]) , .C0(N_153) , .C1(N_154) , .S0(N_152) );

csabita I33  ( .A(A[4]) , .B(Q[4]) , .C0(N_156) , .C1(N_235) , .S0(N_141) );

buff I91  ( .A(N_159) , .Q(N_140) );

buff I34  ( .A(N_145) , .Q(N_136) );

and2i2 I37  ( .A(N_158) , .B(N_157) , .Q(N_135) );

csalow I38  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_160) , .B0(Q[0]) , .B1(Q[1]) , .C0(N_157),
              .C1(N_159) );

mux4x6 I39  ( .A(N_157) , .B(N_157) , .C(N_157) , .D(N_157) , .Q(N_134) , .S0(N_160),
              .S1(Q[1]) );

csamuxd I40  ( .A(N_152) , .Q(N_130) , .S00(N_234) , .S01(N_155) , .S1(N_136) );

csamuxd I41  ( .A(N_163) , .Q(N_132) , .S00(N_162) , .S01(N_161) , .S1(N_140) );

csamuxc I42  ( .A(N_138) , .B(N_137) , .Q(N_145) , .S00(N_162) , .S01(N_161),
               .S1(N_159) );

csamuxb I117  ( .A(N_116) , .B(N_114) , .Q(N_104) , .S00(N_1) , .S01(N_102) , .S1(N_3) );

csamuxb I118  ( .A(N_116) , .B(N_114) , .Q(N_126) , .S00(N_1) , .S01(N_102) , .S1(N_2) );

csamuxb I112  ( .A(N_72) , .B(N_71) , .Q(N_78) , .S00(N_115) , .S01(N_104) , .S1(C15C) );

csamuxb I113  ( .A(N_110) , .B(N_94) , .Q(N_81) , .S00(N_91) , .S01(N_92) , .S1(C15B) );

csamuxb I101  ( .A(N_232) , .B(N_233) , .Q(C15C) , .S00(N_217) , .S01(N_219),
                .S1(N_165) );

csamuxb I102  ( .A(N_230) , .B(N_213) , .Q(C15A) , .S00(N_217) , .S01(N_219),
                .S1(N_165) );

csamuxb I100  ( .A(N_227) , .B(N_228) , .Q(N_203) , .S00(N_216) , .S01(N_220),
                .S1(N_164) );

csamuxb I93  ( .A(N_148) , .B(N_147) , .Q(N_164) , .S00(N_222) , .S01(N_221),
               .S1(N_145) );

csamuxb QL88  ( .A(N_122) , .B(N_124) , .Q(N_73) , .S00(N_126) , .S01(N_125) , .S1(C15D) );

csamuxb QL86  ( .A(N_118) , .B(N_120) , .Q(N_75) , .S00(N_126) , .S01(N_125) , .S1(C15D) );

csamuxb QL87  ( .A(N_121) , .B(N_123) , .Q(N_74) , .S00(N_126) , .S01(N_125) , .S1(C15D) );

csamuxb QL85  ( .A(N_117) , .B(N_119) , .Q(N_76) , .S00(N_126) , .S01(N_125) , .S1(C15D) );

csamuxb QL82  ( .A(N_55) , .B(N_56) , .Q(N_79) , .S00(N_115) , .S01(N_104) , .S1(C15C) );

csamuxb QL84  ( .A(N_58) , .B(N_62) , .Q(N_77) , .S00(N_115) , .S01(N_104) , .S1(C15C) );

csamuxb QL93  ( .A(N_116) , .B(N_114) , .Q(N_125) , .S00(N_1) , .S01(N_102) , .S1(N_3) );

csamuxb QL91  ( .A(N_116) , .B(N_114) , .Q(N_115) , .S00(N_1) , .S01(N_102) , .S1(N_2) );

csamuxb QL79  ( .A(N_109) , .B(N_95) , .Q(N_80) , .S00(N_91) , .S01(N_92) , .S1(C15B) );

csamuxb QL81  ( .A(N_111) , .B(N_112) , .Q(N_82) , .S00(N_91) , .S01(N_92) , .S1(C15B) );

csamuxb QL89  ( .A(N_101) , .B(N_98) , .Q(N_99) , .S00(N_97) , .S01(N_96) , .S1(C15A) );

csamuxb I43  ( .A(N_151) , .B(N_150) , .Q(N_128) , .S00(N_222) , .S01(N_221),
               .S1(N_136) );

csamuxb I45  ( .A(N_148) , .B(N_147) , .Q(N_165) , .S00(N_143) , .S01(N_149),
               .S1(N_145) );

csamuxb I46  ( .A(N_212) , .B(N_211) , .Q(N_206) , .S00(N_209) , .S01(N_210),
               .S1(N_164) );

csamuxb I47  ( .A(N_225) , .B(N_226) , .Q(N_204) , .S00(N_216) , .S01(N_220),
               .S1(N_164) );

csamuxb I49  ( .A(N_229) , .B(N_214) , .Q(N_202) , .S00(N_216) , .S01(N_220),
               .S1(N_164) );

csamuxb I51  ( .A(N_230) , .B(N_213) , .Q(C15B) , .S00(N_217) , .S01(N_219) , .S1(N_165) );

csamuxb I53  ( .A(N_232) , .B(N_233) , .Q(C15D) , .S00(N_217) , .S01(N_219) , .S1(N_165) );

csamuxa I88  ( .A(N_100) , .Q(N_84) , .S00(N_97) , .S01(N_96) , .S1(C15A) );

csamuxa I89  ( .A(N_113) , .Q(N_83) , .S00(N_91) , .S01(N_92) , .S1(C15B) );

csamuxa QL107  ( .A(N_105) , .Q(N_103) , .S00(N_115) , .S01(N_104) , .S1(C15C) );

csamuxa I54  ( .A(N_224) , .Q(N_205) , .S00(N_216) , .S01(N_220) , .S1(N_164) );

csamuxa I55  ( .A(N_207) , .Q(N_127) , .S00(N_209) , .S01(N_210) , .S1(N_164) );

csamuxa I56  ( .A(N_146) , .Q(N_129) , .S00(N_222) , .S01(N_221) , .S1(N_136) );

mux2x0 QL117  ( .A(N_54) , .B(N_93) , .Q(N_85) , .S(C15A) );

mux2x0 I57  ( .A(N_172) , .B(N_173) , .Q(N_184) , .S(N_164) );

mux2dxx I120  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_117) , .R(N_118),
                .S(N_59) );

mux2dxx I119  ( .A(N_108) , .B(N_108) , .C(N_106) , .D(N_107) , .Q(N_94) , .R(N_95),
                .S(N_102) );

mux2dxx I103  ( .A(N_231) , .B(N_231) , .C(N_187) , .D(N_186) , .Q(N_227) , .R(N_229),
                .S(N_190) );

mux2dxx I104  ( .A(N_231) , .B(N_231) , .C(N_187) , .D(N_186) , .Q(N_228) , .R(N_214),
                .S(N_191) );

mux2dxx QL120  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_67) , .R(N_68),
                 .S(N_31) );

mux2dxx QL121  ( .A(N_48) , .B(N_48) , .C(N_50) , .D(N_49) , .Q(N_69) , .R(N_70),
                 .S(N_32) );

mux2dxx QL122  ( .A(N_64) , .B(N_64) , .C(N_65) , .D(N_66) , .Q(N_119) , .R(N_120),
                 .S(N_63) );

mux2dxx QL124  ( .A(N_108) , .B(N_108) , .C(N_106) , .D(N_107) , .Q(N_110) , .R(N_109),
                 .S(N_1) );

mux2dx2 I114  ( .A(N_21) , .B(N_21) , .C(N_23) , .D(N_25) , .Q(N_15) , .R(N_18) , .S(N_26) );

mux2dx2 I115  ( .A(N_38) , .B(N_38) , .C(N_40) , .D(N_42) , .Q(N_106) , .R(N_116),
                .S(N_43) );

mux2dx2 I116  ( .A(N_39) , .B(N_39) , .C(N_41) , .D(N_44) , .Q(N_111) , .R(N_1) , .S(N_45) );

mux2dx2 I99  ( .A(N_192) , .B(N_192) , .C(N_194) , .D(N_196) , .Q(N_187) , .R(N_189),
               .S(N_197) );

mux2dx2 I95  ( .A(N_174) , .B(N_174) , .C(N_176) , .D(N_178) , .Q(N_212) , .R(N_208),
               .S(N_179) );

mux2dx2 QL143  ( .A(N_33) , .B(N_33) , .C(N_34) , .D(N_35) , .Q(N_65) , .R(N_31),
                 .S(N_36) );

mux2dx2 QL146  ( .A(N_57) , .B(N_57) , .C(N_61) , .D(N_61) , .Q(N_72) , .R(N_71),
                 .S(N_60) );

mux2dx2 QL142  ( .A(N_22) , .B(N_22) , .C(N_24) , .D(N_27) , .Q(N_55) , .R(N_16),
                 .S(N_28) );

mux2dx2 QL139  ( .A(N_5) , .B(N_5) , .C(N_7) , .D(N_9) , .Q(N_101) , .R(N_88) , .S(N_10) );

mux2dx2 QL140  ( .A(N_6) , .B(N_6) , .C(N_8) , .D(N_11) , .Q(N_54) , .R(N_4) , .S(N_12) );

mux2dx2 I61  ( .A(N_193) , .B(N_193) , .C(N_195) , .D(N_198) , .Q(N_225) , .R(N_190),
               .S(N_199) );

mux2dx2 I63  ( .A(N_175) , .B(N_175) , .C(N_177) , .D(N_180) , .Q(N_172) , .R(N_209),
               .S(N_181) );

mux2dx2 I64  ( .A(N_170) , .B(N_170) , .C(N_169) , .D(N_168) , .Q(N_151) , .R(N_148),
               .S(N_167) );

mux2dx0 QL152  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_121) , .R(N_122),
                 .S(N_59) );

mux2dx0 QL153  ( .A(N_67) , .B(N_69) , .C(N_68) , .D(N_70) , .Q(N_123) , .R(N_124),
                 .S(N_63) );

mux2dx0 I66  ( .A(N_208) , .B(N_218) , .C(N_208) , .D(N_218) , .Q(N_216) , .R(N_217),
               .S(N_209) );

mux2dx0 I67  ( .A(N_208) , .B(N_218) , .C(N_208) , .D(N_218) , .Q(N_220) , .R(N_219),
               .S(N_210) );

mux2dx0 I68  ( .A(N_189) , .B(N_188) , .C(N_189) , .D(N_188) , .Q(N_230) , .R(N_232),
               .S(N_190) );

mux2dx0 I69  ( .A(N_189) , .B(N_188) , .C(N_189) , .D(N_188) , .Q(N_213) , .R(N_233),
               .S(N_191) );


endmodule /* accum32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sop14i7 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sop14i7
`else
`define sop14i7

module sop14i7 ( A , B, C, D, E, F, G, H, I, J, K, L, M, N, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M, N;
output Q;

wire NET_TS;
wire NET_EE;
wire NET_TE;
wire N_16;
wire N_17;
wire N_12;
supply1 VCC;
supply0 GND;
wire N_13;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(C) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(NET_EE) , .F1(NET_TS) , .F2(VCC) , .FS(NET_TE) , .FZ(Q),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(N_12),
                       .TAS1(GND) , .TAS2(GND) , .TB1(F) , .TB2(GND) , .TBS(VCC),
                       .TBS1(VCC) , .TBS2(GND) , .TSL(E) , .TZ(NET_TE), .QZ() );

logic_cell_macro I5  ( .BA1(GND) , .BA2(GND) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(M) , .BB2(GND) , .BBS1(VCC) , .BBS2(GND) , .BSL(N),
                       .CZ(N_16) , .F1(NET_EE) , .F2(GND) , .FS(D) , .FZ(N_12),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(G) , .TA2(VCC) , .TAB(H),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(VCC) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(N_16) , .TZ(NET_TS), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_17) , .F2(GND) , .FS(L) , .FZ(N_13) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(I) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(K) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(J) , .TZ(N_17), .CZ(), .QZ() );


endmodule /* sop14i7 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dec2t4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dec2t4
`else
`define dec2t4

module dec2t4 ( S0 , S1, Q0, Q1, Q2, Q3 )/* synthesis black_box */;

output Q0, Q1, Q2, Q3;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(S1) , .TA2(Q2) , .TAB(S0) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(Q0) , .TZ(Q1), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(S0) , .BAS1(GND) , .BAS2(GND),
                       .BB1(S1) , .BB2(GND) , .BBS1(VCC) , .BBS2(GND) , .BSL(Q3),
                       .CZ(Q2) , .F1(GND) , .F2(S0) , .FS(S1) , .FZ(Q3) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(GND) , .TAB(S1) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(S0) , .TZ(Q0), .QZ() );


endmodule /* dec2t4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor14i7 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor14i7
`else
`define nor14i7

module nor14i7 ( A , B, C, D, E, F, G, H, I, J, K, L, M, N, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M, N;
output Q;

wire NET_TN;
wire NET_TE;
wire NET_TS;
supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_13;
wire N_16;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(NET_TN) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(NET_TS) , .BBS1(GND) , .BBS2(GND),
                       .BSL(NET_TE) , .CZ(N_13) , .F1(GND) , .F2(N_13) , .FS(N_12),
                       .FZ(Q) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                       .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(G) , .TA2(GND) , .TAB(F),
                       .TAS1(VCC) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(E) , .TZ(N_12), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(H) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(J) , .BBS1(GND) , .BBS2(GND) , .BSL(I),
                       .CZ(N_11) , .F1(GND) , .F2(N) , .FS(M) , .FZ(NET_TE) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(K) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(L) , .TZ(NET_TN), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_16) , .F2(GND) , .FS(D) , .FZ(NET_TS) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(A) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C) , .TZ(N_16), .CZ(), .QZ() );


endmodule /* nor14i7 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or13i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or13i6
`else
`define or13i6

module or13i6 ( A , B, C, D, E, F, G, H, I, J, K, L, M, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M;
output Q;

wire NET_TF;
wire N_11;
wire NET_EE;
wire N_13;
wire N_14;
wire N_15;
supply1 VCC;
supply0 GND;


logic_cell_macro I4  ( .BA1(VCC) , .BA2(VCC) , .BAB(NET_EE) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(K) , .BBS1(GND) , .BBS2(VCC) , .BSL(J),
                       .CZ(N_13) , .F1(GND) , .F2(H) , .FS(I) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(NET_TF) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_13) , .TZ(Q), .QZ() );

logic_cell_macro I5  ( .BA1(E) , .BA2(VCC) , .BAB(B) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_14) , .F1(N_15) , .F2(VCC) , .FS(N_14) , .FZ(NET_TF),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(M),
                       .TAS1(GND) , .TAS2(GND) , .TB1(L) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(A) , .TZ(NET_EE), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(G) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(F) , .TZ(N_15), .CZ(), .FZ(), .QZ() );


endmodule /* or13i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor2xor3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor2xor3
`else
`define xor2xor3

module xor2xor3 ( A0 , A1, B0, B1, C0, Q0, Q1 )/* synthesis black_box */;

input A0, A1, B0, B1, C0;
output Q0, Q1;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(C0) , .BA2(C0) , .BAB(A0) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(C0) , .BB2(C0) , .BBS1(VCC) , .BBS2(GND) , .BSL(B0),
                       .CZ(Q0) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(VCC) , .TAB(A1) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B1) , .TZ(Q1), .FZ(), .QZ() );


endmodule /* xor2xor3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and5i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and5i4
`else
`define and5i4

module and5i4 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I3  ( .BA1(N_11) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* and5i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and14i7 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and14i7
`else
`define and14i7

module and14i7 ( A , B, C, D, E, F, G, H, I, J, K, L, M, N, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M, N;
output Q;

wire NET_TN;
wire NET_TE;
wire NET_TS;
supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_13;
wire N_16;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(C) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(GND) , .F2(G) , .FS(F) , .FZ(NET_TE) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(D) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(E) , .TZ(NET_TN), .QZ() );

logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(NET_TN) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(NET_TS) , .BBS1(GND) , .BBS2(GND),
                       .BSL(NET_TE) , .CZ(N_13) , .F1(GND) , .F2(N_13) , .FS(N_12),
                       .FZ(Q) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                       .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(N) , .TA2(GND) , .TAB(M),
                       .TAS1(VCC) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(L) , .TZ(N_12), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_16) , .F2(GND) , .FS(K) , .FZ(NET_TS) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(I) , .TA2(GND) , .TAB(H) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(J) , .TZ(N_16), .CZ(), .QZ() );


endmodule /* and14i7 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : accum16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef accum16
`else
`define accum16

module accum16 ( A , CLK, CLR, Q )/* synthesis black_box */;

input [15:0] A;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output [15:0] Q;wire N_101;
wire N_102;
wire N_103;
wire N_100;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_36;
wire N_37;
wire N_38;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_71;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire N_78;
wire N_79;
wire N_80;
wire N_81;
wire N_82;
wire N_83;
wire N_84;
wire N_85;
wire N_86;
wire N_87;
wire N_88;
wire N_89;
wire N_90;
wire N_91;
wire N_92;
wire N_93;
wire N_94;
wire N_95;
wire N_96;
wire N_97;
wire N_98;
wire N_99;


muxc2dx2 I68  ( .A(N_59) , .B(N_58) , .C(N_59) , .D(N_58) , .Q(N_64) , .R(N_65),
                .S(N_103) , .T(N_100) );

muxb2dx2 I69  ( .A(N_59) , .B(N_58) , .C(N_59) , .D(N_58) , .Q(N_71) , .R(N_63),
                .S(N_102) , .T(N_101) );

muxi2dx2 I64  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_44) , .R(N_29) , .S(N_25) );

muxi2dx2 I65  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_5) , .R(N_7) , .S(N_26) );

muxi2dx2 I66  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_34) , .R(N_8) , .S(N_27) );

muxi2dx2 I67  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_62) , .R(N_67) , .S(N_28) );

mux2dxy I59  ( .A(N_76) , .B(N_76) , .C(N_77) , .D(N_77) , .Q(N_80) , .R(N_79) , .S(N_78) );

mux2dxx I60  ( .A(N_1) , .B(N_1) , .C(N_80) , .D(N_79) , .Q(N_47) , .R(N_48) , .S(N_29) );

mux2dxx I61  ( .A(N_1) , .B(N_1) , .C(N_80) , .D(N_79) , .Q(N_45) , .R(N_46) , .S(N_2) );

mux2dx0 I62  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_40) , .R(N_41) , .S(N_8) );

mux2dx0 I63  ( .A(N_3) , .B(N_5) , .C(N_6) , .D(N_7) , .Q(N_36) , .R(N_37) , .S(N_4) );

mux2dx2 I72  ( .A(N_10) , .B(N_10) , .C(N_14) , .D(N_19) , .Q(N_3) , .R(N_6) , .S(N_20) );

mux2dx2 I1  ( .A(N_9) , .B(N_9) , .C(N_13) , .D(N_17) , .Q(N_43) , .R(N_2) , .S(N_18) );

mux2dx2 I3  ( .A(N_11) , .B(N_11) , .C(N_15) , .D(N_21) , .Q(N_33) , .R(N_4) , .S(N_22) );

mux2dx2 I4  ( .A(N_12) , .B(N_12) , .C(N_16) , .D(N_23) , .Q(N_61) , .R(N_66) , .S(N_24) );

mux2x0 I6  ( .A(N_36) , .B(N_40) , .Q(N_94) , .S(N_31) );

mux2x0 I7  ( .A(N_33) , .B(N_34) , .Q(N_93) , .S(N_31) );

csamuxa I73  ( .A(N_42) , .Q(N_95) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxa I70  ( .A(N_68) , .Q(N_90) , .S00(N_71) , .S01(N_64) , .S1(N_83) );

csamuxa I9  ( .A(N_38) , .Q(N_99) , .S00(N_4) , .S01(N_8) , .S1(N_31) );

csamuxb I74  ( .A(N_45) , .B(N_47) , .Q(N_97) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I11  ( .A(N_43) , .B(N_44) , .Q(N_96) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I13  ( .A(N_46) , .B(N_48) , .Q(N_98) , .S00(N_37) , .S01(N_41) , .S1(N_30) );

csamuxb I14  ( .A(N_66) , .B(N_67) , .Q(N_30) , .S00(N_63) , .S01(N_65) , .S1(N_69) );

csamuxb I15  ( .A(N_66) , .B(N_67) , .Q(N_31) , .S00(N_63) , .S01(N_65) , .S1(N_69) );

csamuxb I16  ( .A(N_61) , .B(N_62) , .Q(N_91) , .S00(N_71) , .S01(N_64) , .S1(N_83) );

csamuxc I17  ( .A(N_81) , .B(N_82) , .Q(N_69) , .S00(N_50) , .S01(N_51) , .S1(N_53) );

csamuxd I18  ( .A(N_60) , .Q(N_89) , .S00(N_101) , .S01(N_100) , .S1(N_83) );

csamuxd I19  ( .A(N_49) , .Q(N_87) , .S00(N_50) , .S01(N_51) , .S1(N_74) );

mux4x6 I20  ( .A(N_55) , .B(N_55) , .C(N_55) , .D(N_55) , .Q(N_85) , .S0(N_52) , .S1(Q[1]) );

csalow I21  ( .A0(A[0]) , .A1(A[1]) , .A1T(N_52) , .B0(Q[0]) , .B1(Q[1]) , .C0(N_55),
              .C1(N_53) );

and2i2 I22  ( .A(N_54) , .B(N_55) , .Q(N_84) );

nor2i0 I23  ( .A(Q[0]) , .B(A[0]) , .Q(N_54) );

buff I71  ( .A(N_53) , .Q(N_74) );

buff I24  ( .A(N_69) , .Q(N_83) );

csabita I26  ( .A(A[14]) , .B(Q[14]) , .C0(N_76) , .C1(N_77) , .S0(N_1) );

csabita I27  ( .A(A[13]) , .B(Q[13]) , .C0(N_13) , .C1(N_17) , .S0(N_9) );

csabita I28  ( .A(A[12]) , .B(Q[12]) , .C0(N_18) , .C1(N_25) , .S0(N_42) );

csabita I29  ( .A(A[11]) , .B(Q[11]) , .C0(N_14) , .C1(N_19) , .S0(N_10) );

csabita I30  ( .A(A[10]) , .B(Q[10]) , .C0(N_20) , .C1(N_26) , .S0(N_38) );

csabita I31  ( .A(A[9]) , .B(Q[9]) , .C0(N_15) , .C1(N_21) , .S0(N_11) );

csabita I32  ( .A(A[8]) , .B(Q[8]) , .C0(N_22) , .C1(N_27) , .S0(N_32) );

csabita I33  ( .A(A[7]) , .B(Q[7]) , .C0(N_16) , .C1(N_23) , .S0(N_12) );

csabita I34  ( .A(A[6]) , .B(Q[6]) , .C0(N_24) , .C1(N_28) , .S0(N_68) );

csabita I35  ( .A(A[5]) , .B(Q[5]) , .C0(N_59) , .C1(N_58) , .S0(N_60) );

csabita I36  ( .A(A[4]) , .B(Q[4]) , .C0(N_102) , .C1(N_103) , .S0(N_73) );

csabitb I37  ( .A(A[3]) , .B(Q[3]) , .C0(N_81) , .C1(N_82) , .S0(N_49) );

csabitb I38  ( .A(A[2]) , .B(Q[2]) , .C0(N_50) , .C1(N_51) , .S0(N_75) );

xor2p I39  ( .A(N_74) , .B(N_75) , .Q(N_86) );

xor2p I40  ( .A(N_31) , .B(N_32) , .Q(N_92) );

xor2p I41  ( .A(N_83) , .B(N_73) , .Q(N_88) );

xor2p I42  ( .A(A[15]) , .B(Q[15]) , .Q(N_78) );

dffc I43  ( .CLK(CLK) , .CLR(CLR) , .D(N_98) , .Q(Q[15]) );

dffc I44  ( .CLK(CLK) , .CLR(CLR) , .D(N_97) , .Q(Q[14]) );

dffc I45  ( .CLK(CLK) , .CLR(CLR) , .D(N_96) , .Q(Q[13]) );

dffc I46  ( .CLK(CLK) , .CLR(CLR) , .D(N_95) , .Q(Q[12]) );

dffc I47  ( .CLK(CLK) , .CLR(CLR) , .D(N_94) , .Q(Q[11]) );

dffc I48  ( .CLK(CLK) , .CLR(CLR) , .D(N_99) , .Q(Q[10]) );

dffc I49  ( .CLK(CLK) , .CLR(CLR) , .D(N_93) , .Q(Q[9]) );

dffc I50  ( .CLK(CLK) , .CLR(CLR) , .D(N_92) , .Q(Q[8]) );

dffc I51  ( .CLK(CLK) , .CLR(CLR) , .D(N_91) , .Q(Q[7]) );

dffc I52  ( .CLK(CLK) , .CLR(CLR) , .D(N_90) , .Q(Q[6]) );

dffc I53  ( .CLK(CLK) , .CLR(CLR) , .D(N_89) , .Q(Q[5]) );

dffc I54  ( .CLK(CLK) , .CLR(CLR) , .D(N_88) , .Q(Q[4]) );

dffc I55  ( .CLK(CLK) , .CLR(CLR) , .D(N_87) , .Q(Q[3]) );

dffc I56  ( .CLK(CLK) , .CLR(CLR) , .D(N_86) , .Q(Q[2]) );

dffc I57  ( .CLK(CLK) , .CLR(CLR) , .D(N_85) , .Q(Q[1]) );

dffc I58  ( .CLK(CLK) , .CLR(CLR) , .D(N_84) , .Q(Q[0]) );


endmodule /* accum16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand13i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand13i6
`else
`define nand13i6

module nand13i6 ( A , B, C, D, E, F, G, H, I, J, K, L, M, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H, I, J, K, L, M;
output Q;

wire NET_TF;
wire N_11;
wire NET_EE;
wire N_13;
wire N_14;
wire N_15;
supply1 VCC;
supply0 GND;


logic_cell_macro I4  ( .BA1(VCC) , .BA2(VCC) , .BAB(NET_EE) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(D) , .BBS1(GND) , .BBS2(VCC) , .BSL(C),
                       .CZ(N_13) , .F1(GND) , .F2(A) , .FS(B) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(NET_TF) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_13) , .TZ(Q), .QZ() );

logic_cell_macro I5  ( .BA1(K) , .BA2(VCC) , .BAB(H) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(J),
                       .CZ(N_14) , .F1(N_15) , .F2(VCC) , .FS(N_14) , .FZ(NET_TF),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(F),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(E) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(G) , .TZ(NET_EE), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(M) , .TA2(VCC) , .TAB(I) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(L) , .TZ(N_15), .CZ(), .FZ(), .QZ() );


endmodule /* nand13i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i6
`else
`define nor6i6

module nor6i6 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_12;
supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_11) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(GND) , .F2(N_12) , .FS(A) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_12), .QZ() );


endmodule /* nor6i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i5
`else
`define nor6i5

module nor6i5 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_13;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_11) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(A) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_13), .QZ() );


endmodule /* nor6i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i4
`else
`define nor6i4

module nor6i4 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_13;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_11) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(A) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(D) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_13), .QZ() );


endmodule /* nor6i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i3
`else
`define nor6i3

module nor6i3 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_13;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_11) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(A) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(D) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_13), .QZ() );


endmodule /* nor6i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i2
`else
`define nor6i2

module nor6i2 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_14;
supply0 GND;
supply1 VCC;
wire N_13;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_14) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(C) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* nor6i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i1
`else
`define nor6i1

module nor6i1 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_14;
supply0 GND;
supply1 VCC;
wire N_13;


logic_cell_macro I3  ( .BA1(GND) , .BA2(N_14) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(C) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* nor6i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor6i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor6i0
`else
`define nor6i0

module nor6i0 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_14;
supply0 GND;
supply1 VCC;
wire N_13;


logic_cell_macro I3  ( .BA1(N_14) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_14) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(C) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* nor6i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i5
`else
`define nor5i5

module nor5i5 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(VCC) , .BSL(B),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(E) , .TAB(N_12) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i4
`else
`define nor5i4

module nor5i4 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(E) , .TAB(N_12) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i3
`else
`define nor5i3

module nor5i3 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(E) , .TAB(N_12) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i2
`else
`define nor5i2

module nor5i2 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(B) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(E) , .TAB(N_12) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i1
`else
`define nor5i1

module nor5i1 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(B) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(E) , .TA2(GND) , .TAB(N_12) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor5i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor5i0
`else
`define nor5i0

module nor5i0 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I1  ( .BA1(E) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_12) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(N_12) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nor5i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i6
`else
`define or6i6

module or6i6 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(B) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(N_11), .QZ() );


endmodule /* or6i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i5
`else
`define or6i5

module or6i5 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(B) , .BBS1(GND) , .BBS2(VCC) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(N_11), .QZ() );


endmodule /* or6i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i4
`else
`define or6i4

module or6i4 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(B) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(N_11), .QZ() );


endmodule /* or6i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i3
`else
`define or6i3

module or6i3 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(B) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(A) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(N_11), .QZ() );


endmodule /* or6i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i2
`else
`define or6i2

module or6i2 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(C) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_11), .QZ() );


endmodule /* or6i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i1
`else
`define or6i1

module or6i1 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(E) , .BAB(D) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(C) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_11), .QZ() );


endmodule /* or6i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or6i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or6i0
`else
`define or6i0

module or6i0 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(F) , .BA2(VCC) , .BAB(D) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(E),
                       .CZ(N_12) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(C) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_11), .QZ() );


endmodule /* or6i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i5
`else
`define or5i5

module or5i5 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(E) , .BBS1(GND) , .BBS2(VCC) , .BSL(D),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i4
`else
`define or5i4

module or5i4 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(E) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i3
`else
`define or5i3

module or5i3 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(E) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i2
`else
`define or5i2

module or5i2 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(C) , .BA2(VCC) , .BAB(B) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(E) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(N_11) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i1
`else
`define or5i1

module or5i1 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(C) , .BA2(VCC) , .BAB(B) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(E) , .TAS1(GND),
                       .TAS2(GND) , .TB1(A) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_11) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or5i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or5i0
`else
`define or5i0

module or5i0 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(C) , .BA2(VCC) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(A) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(Q), .FZ(), .QZ() );


endmodule /* or5i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i6
`else
`define nand6i6

module nand6i6 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(E) , .BA2(VCC) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(D) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i5
`else
`define nand6i5

module nand6i5 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(E) , .BA2(VCC) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(D) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i4
`else
`define nand6i4

module nand6i4 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(E) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(D) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i3
`else
`define nand6i3

module nand6i3 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(E) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i2
`else
`define nand6i2

module nand6i2 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(E) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i1
`else
`define nand6i1

module nand6i1 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(E) , .BAB(F) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand6i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand6i0
`else
`define nand6i0

module nand6i0 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(F) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(E) , .BBS1(GND) , .BBS2(VCC) , .BSL(B),
                       .CZ(N_11) , .F1(N_12) , .F2(VCC) , .FS(N_11) , .FZ(Q) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(D) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(C) , .TZ(N_12), .QZ() );


endmodule /* nand6i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i5
`else
`define nand5i5

module nand5i5 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(A) , .BA2(GND) , .BAB(B) , .BAS1(VCC) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(C),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(E) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i4
`else
`define nand5i4

module nand5i4 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(A) , .BA2(GND) , .BAB(B) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(C),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(E) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i3
`else
`define nand5i3

module nand5i3 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(C),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(E) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i2
`else
`define nand5i2

module nand5i2 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(B) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(E) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(D) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i1
`else
`define nand5i1

module nand5i1 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(B) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(E) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand5i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand5i0
`else
`define nand5i0

module nand5i0 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(E) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(N_11) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(VCC) , .TAB(N_11) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(A) , .TZ(Q), .FZ(), .QZ() );


endmodule /* nand5i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and5i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and5i0
`else
`define and5i0

module and5i0 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(N_11) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* and5i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i6
`else
`define and6i6

module and6i6 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_13;
wire N_12;
supply0 GND;
supply1 VCC;


logic_cell_macro I3  ( .BA1(N_12) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(B) , .TA2(GND) , .TAB(C) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* and6i6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i3
`else
`define and6i3

module and6i3 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_13;
wire N_12;
supply0 GND;
supply1 VCC;


logic_cell_macro I3  ( .BA1(N_12) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(N_13) , .F2(GND) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_13), .QZ() );


endmodule /* and6i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and6i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and6i2
`else
`define and6i2

module and6i2 ( A , B, C, D, E, F, Q );

input A, B, C, D, E, F;
output Q;

wire N_12;
supply0 GND;
wire N_11;
supply1 VCC;


logic_cell_macro I3  ( .BA1(N_12) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(F),
                       .CZ(Q) , .F1(GND) , .F2(N_11) , .FS(D) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(N_11), .QZ() );


endmodule /* and6i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor5i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor5i0
`else
`define xor5i0

module xor5i0 ( A , B, C, D, E, Q )/* synthesis black_box */;

input A, B, C, D, E;
output Q;

supply1 VCC;
supply0 GND;
wire N_13;


logic_cell_macro I1  ( .BA1(N_13) , .BA2(N_13) , .BAB(D) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(N_13) , .BB2(N_13) , .BBS1(VCC) , .BBS2(GND) , .BSL(E),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(C) , .TA2(C) , .TAB(A) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(C) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(B),
                       .TZ(N_13), .FZ(), .QZ() );


endmodule /* xor5i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor4i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor4i0
`else
`define xor4i0

module xor4i0 ( A , B, C, D, Q )/* synthesis black_box */;

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(D) , .BA2(D) , .BAB(B) , .BAS1(VCC) , .BAS2(GND) , .BB1(D),
                       .BB2(D) , .BBS1(GND) , .BBS2(VCC) , .BSL(C) , .CZ(Q) , .F1(GND),
                       .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                       .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(D) , .TA2(D),
                       .TAB(B) , .TAS1(GND) , .TAS2(VCC) , .TB1(D) , .TB2(D) , .TBS(A),
                       .TBS1(VCC) , .TBS2(GND) , .TSL(C), .FZ(), .QZ(), .TZ() );


endmodule /* xor4i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and5i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and5i3
`else
`define and5i3

module and5i3 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I3  ( .BA1(N_11) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(A) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* and5i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and5i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and5i2
`else
`define and5i2

module and5i2 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I3  ( .BA1(N_11) , .BA2(GND) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* and5i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and5i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and5i1
`else
`define and5i1

module and5i1 ( A , B, C, D, E, Q );

input A, B, C, D, E;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I3  ( .BA1(GND) , .BA2(N_11) , .BAB(E) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(B) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* and5i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor3i0
`else
`define xor3i0

module xor3i0 ( A , B, C, Q )/* synthesis black_box */;

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(C) , .TA2(C) , .TAB(A) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(C) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* xor3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor2i0
`else
`define xor2i0

module xor2i0 ( A , B, Q )/* synthesis black_box */;

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(A) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* xor2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xnor3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xnor3i0
`else
`define xnor3i0

module xnor3i0 ( A , B, C, Q )/* synthesis black_box */;

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(C) , .TA2(C) , .TAB(A) , .TAS1(VCC) , .TAS2(GND) , .TB1(C),
                       .TB2(C) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC) , .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* xnor3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xnor2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xnor2i0
`else
`define xnor2i0

module xnor2i0 ( A , B, Q )/* synthesis black_box */;

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(A) , .TAB(GND) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* xnor2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or4i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or4i4
`else
`define or4i4

module or4i4 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(VCC) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* or4i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or4i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or4i2
`else
`define or4i2

module or4i2 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(A) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* or4i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or4i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or4i3
`else
`define or4i3

module or4i3 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(GND) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* or4i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or4i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or4i1
`else
`define or4i1

module or4i1 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(A) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* or4i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or4i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or4i0
`else
`define or4i0

module or4i0 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(D) , .TA2(VCC) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(A) , .TBS1(GND) , .TBS2(GND),
                       .TSL(C), .FZ(), .QZ(), .TZ() );


endmodule /* or4i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or3i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or3i3
`else
`define or3i3

module or3i3 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* or3i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or3i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or3i2
`else
`define or3i2

module or3i2 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* or3i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or3i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or3i1
`else
`define or3i1

module or3i1 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(A) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* or3i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or3i0
`else
`define or3i0

module or3i0 ( A , B, C, Q );

input A, B, C;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* or3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or2i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or2i2
`else
`define or2i2

module or2i2 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(A) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* or2i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or2i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or2i1
`else
`define or2i1

module or2i1 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(A) , .FS(B) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* or2i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : or2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef or2i0
`else
`define or2i0

module or2i0 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(A) , .F2(VCC) , .FS(B) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* or2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor4i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor4i4
`else
`define nor4i4

module nor4i4 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(A) , .BBS1(GND) , .BBS2(GND) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* nor4i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor4i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor4i3
`else
`define nor4i3

module nor4i3 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(A) , .BBS1(GND) , .BBS2(VCC) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* nor4i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor4i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor4i2
`else
`define nor4i2

module nor4i2 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(D) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(A) , .TBS(B) , .TBS1(GND) , .TBS2(VCC) , .TSL(C), .FZ(), .QZ(), .TZ() );


endmodule /* nor4i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor4i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor4i1
`else
`define nor4i1

module nor4i1 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(D) , .TA2(GND) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(C) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A), .FZ(), .QZ(), .TZ() );


endmodule /* nor4i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor4i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor4i0
`else
`define nor4i0

module nor4i0 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* nor4i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor3i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor3i3
`else
`define nor3i3

module nor3i3 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor3i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor3i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor3i2
`else
`define nor3i2

module nor3i2 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(B) , .TAB(A) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(C) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor3i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor3i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor3i1
`else
`define nor3i1

module nor3i1 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(C) , .TA2(GND) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor3i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor3i0
`else
`define nor3i0

module nor3i0 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(C) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A), .FZ(), .QZ(), .TZ() );


endmodule /* nor3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor2i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor2i1
`else
`define nor2i1

module nor2i1 ( A , B, Q );

input A, B;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(B) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor2i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor2i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor2i2
`else
`define nor2i2

module nor2i2 ( A , B, Q );

input A, B;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(A) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor2i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nor2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nor2i0
`else
`define nor2i0

module nor2i0 ( A , B, Q );

input A, B;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nor2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand4i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand4i4
`else
`define nand4i4

module nand4i4 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(D) , .TA2(VCC) , .TAB(B) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(A) , .TBS1(GND) , .TBS2(GND),
                       .TSL(C), .FZ(), .QZ(), .TZ() );


endmodule /* nand4i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand4i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand4i3
`else
`define nand4i3

module nand4i3 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(VCC) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(B) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A), .FZ(), .QZ(), .TZ() );


endmodule /* nand4i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand4i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand4i2
`else
`define nand4i2

module nand4i2 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(VCC) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(A) , .TAB(C) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(VCC) , .TB2(VCC) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* nand4i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand4i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand4i1
`else
`define nand4i1

module nand4i1 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(B) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(A) , .CZ(Q),
                       .F1(VCC) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(VCC) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(C) , .TBS1(GND) , .TBS2(GND),
                       .TSL(VCC), .FZ(), .QZ(), .TZ() );


endmodule /* nand4i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand4i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand4i0
`else
`define nand4i0

module nand4i0 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(VCC) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(A) , .BBS1(GND) , .BBS2(VCC) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* nand4i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand3i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand3i3
`else
`define nand3i3

module nand3i3 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand3i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand3i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand3i2
`else
`define nand3i2

module nand3i2 ( A , B, C, Q )/* synthesis black_box */;

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(VCC) , .TAB(C) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand3i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand3i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand3i1
`else
`define nand3i1

module nand3i1 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(A) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(C) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand3i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand3i0
`else
`define nand3i0

module nand3i0 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(VCC) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand2i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand2i2
`else
`define nand2i2

module nand2i2 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(B) , .TA2(VCC) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand2i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand2i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand2i1
`else
`define nand2i1

module nand2i1 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(VCC) , .TAB(GND) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand2i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : nand2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef nand2i0
`else
`define nand2i0

module nand2i0 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(A) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* nand2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and4i4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and4i4
`else
`define and4i4

module and4i4 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* and4i4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and4i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and4i3
`else
`define and4i3

module and4i3 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* and4i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and4i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and4i2
`else
`define and4i2

module and4i2 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(A) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* and4i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and4i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and4i1
`else
`define and4i1

module and4i1 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(A) , .TBS(D) , .TBS1(GND) , .TBS2(GND) , .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* and4i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and4i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and4i0
`else
`define and4i0

module and4i0 ( A , B, C, D, Q );

input A, B, C, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(C) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(A) , .BBS1(GND) , .BBS2(GND) , .BSL(B) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(D) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* and4i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and3i3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and3i3
`else
`define and3i3

module and3i3 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* and3i3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and3i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and3i2
`else
`define and3i2

module and3i2 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* and3i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and3i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and3i1
`else
`define and3i1

module and3i1 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(A) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* and3i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and3i0
`else
`define and3i0

module and3i0 ( A , B, C, Q );

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* and3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and2i2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and2i2
`else
`define and2i2

module and2i2 ( A , B, Q )/* synthesis black_box */;

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(GND) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* and2i2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and2i1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and2i1
`else
`define and2i1

module and2i1 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(A) , .F2(GND) , .FS(B) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* and2i1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : and2i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef and2i0
`else
`define and2i0

module and2i0 ( A , B, Q );

input A, B;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(A) , .FS(B) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* and2i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : hadd1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef hadd1
`else
`define hadd1

module hadd1 ( A , B, CO, S )/* synthesis black_box */;

input A, B;
output CO, S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(B) , .BA2(B) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(S) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(CO), .FZ(), .QZ() );


endmodule /* hadd1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xnor2p 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xnor2p
`else
`define xnor2p

module xnor2p ( A , B, Q )/* synthesis black_box */;

input A, B;
output Q;

supply0 GND;
supply1 VCC;


mux4x0 I1  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(Q) , .S0(B) , .S1(A) );


endmodule /* xnor2p */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uplsbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uplsbit
`else
`define uplsbit

module uplsbit ( CLK , CLR, D, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire TE_NET;
wire NET_LR;
supply0 GND;
supply1 VCC;


logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(Q1) , .TZ(TE_NET), .CZ(), .FZ(), .QZ() );

logic_cell_macro I3  ( .BA1(CLR) , .BA2(GND) , .BAB(Q) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(CLR) , .BBS1(GND) , .BBS2(VCC) , .BSL(ENP),
                       .CZ(NET_LR) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(Q) , .TAS1(GND),
                       .TAS2(GND) , .TB1(CLR) , .TB2(CLR) , .TBS(TE_NET) , .TBS1(VCC),
                       .TBS2(VCC) , .TSL(ENP), .FZ(), .QZ(), .TZ() );

logic_cell_macro I4  ( .BA1(NET_LR) , .BA2(Q) , .BAB(CLR) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_LR) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(ENT),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(GND) , .QST(GND),
                       .QZ(Q) , .TA1(D) , .TA2(GND) , .TAB(NET_LR) , .TAS1(GND),
                       .TAS2(GND) , .TB1(D) , .TB2(ENT) , .TBS(LOAD) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(CLR), .CZ(), .FZ(), .TZ() );


endmodule /* uplsbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uplabit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uplabit
`else
`define uplabit

module uplabit ( CLK , CLR, D, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire N_18;
wire N_16;
wire N_17;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(N_18) , .BA2(N_18) , .BAB(N_16) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(D) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(Q) , .F1(GND),
                       .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(GND),
                       .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(N_17) , .TAS1(GND) , .TAS2(GND),
                       .TB1(ENP) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND),
                       .TSL(ENT) , .TZ(N_18), .CZ(), .FZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(LOAD) , .FZ(N_16) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_17), .CZ(), .QZ() );


endmodule /* uplabit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct4c
`else
`define upfxct4c

module upfxct4c ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, ENP, ENT, LOAD;
output [0:3] Q;supply1 VCC;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* upfxct4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct4b
`else
`define upfxct4b

module upfxct4b ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, ENP, ENT, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand5i1 I5  ( .A(Q[0]) , .B(Q[1]) , .C(Q[2]) , .D(Q[3]) , .E(ENT) , .Q(RCO) );


endmodule /* upfxct4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxct4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxct4a
`else
`define upfxct4a

module upfxct4a ( CLK , CLR, D, ENG, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;
supply0 GND;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand2i0 I5  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );


endmodule /* upfxct4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxcar3
`else
`define upfxcar3

module upfxcar3 ( CLK , CLR, D, ENG, LOAD, Q, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;
input [0:1] Q;wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;


and2i1 I8  ( .A(Q[1]) , .B(Q[0]) , .Q(N_14) );

dffp I1  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO3) );

dffp I2  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I3  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I4  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO3) , .Q(N_13) , .S0(ENG) , .S1(LOAD) );

mux4x7 I5  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO2) , .Q(N_12) , .S0(ENG) , .S1(LOAD) );

mux4x7 I6  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

and2i0 I9  ( .A(D[0]) , .B(D[1]) , .Q(N_15) );


endmodule /* upfxcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxcar2
`else
`define upfxcar2

module upfxcar2 ( CLK , CLR, D, ENG, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;

wire N_19;
wire N_17;
wire N_18;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_15;


and2i1 I9  ( .A(N_17) , .B(N_18) , .Q(N_15) );

and2i0 I10  ( .A(D[0]) , .B(D[1]) , .Q(N_19) );

dffp I3  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I4  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I5  ( .A(N_19) , .B(N_19) , .C(N_15) , .D(ACO2) , .Q(N_12) , .S0(ENG) , .S1(LOAD) );

mux4x7 I6  ( .A(N_19) , .B(N_19) , .C(N_15) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

upfxbit I7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(N_17) , .Q0(N_18) , .Q1(VCC) , .Q2(VCC) );

upfxbit I8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(N_18) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* upfxcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxcar1
`else
`define upfxcar1

module upfxcar1 ( CLK , CLR, D, ENG, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;
input [0:1] Q;wire N_11;
wire N_12;
wire N_13;


and2i1 I5  ( .A(Q[1]) , .B(Q[0]) , .Q(N_12) );

dffp I1  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I2  ( .A(N_13) , .B(N_13) , .C(N_12) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

and2i0 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_13) );


endmodule /* upfxcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct4c
`else
`define upflct4c

module upflct4c ( CLK , CLR, D, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENP, ENT, LOAD;
output [0:3] Q;supply1 VCC;


upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* upflct4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfxbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfxbit
`else
`define upfxbit

module upfxbit ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENG, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire N_19;
wire N_18;
wire N_16;
wire N_17;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(N_19) , .BA2(N_19) , .BAB(N_18) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(D) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(Q) , .F1(N_17),
                       .F2(GND) , .FS(ENP) , .FZ(N_16) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(N_16) , .TAS1(GND),
                       .TAS2(GND) , .TB1(ENG) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(ENT) , .TZ(N_19), .CZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(LOAD) , .FZ(N_18) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_17), .CZ(), .QZ() );


endmodule /* upfxbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct4b
`else
`define upflct4b

module upflct4b ( CLK , CLR, D, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENP, ENT, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;


upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand5i1 I5  ( .A(Q[0]) , .B(Q[1]) , .C(Q[2]) , .D(Q[3]) , .E(ENT) , .Q(RCO) );


endmodule /* upflct4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflct4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflct4a
`else
`define upflct4a

module upflct4a ( CLK , CLR, D, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;
supply0 GND;


upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand2i0 I5  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );


endmodule /* upflct4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflcar3
`else
`define upflcar3

module upflcar3 ( CLK , CLR, D, LOAD, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input LOAD;

wire N_22;
wire N_23;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;


and3i1 I16  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_19) );

and3i1 I17  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_18) );

and3i1 I18  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_21) );

and3i1 I19  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_17) );

and3i1 I20  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_20) );

and3i1 I21  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_16) );

upflbit I15  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
               .Q(N_22) , .Q0(N_23) , .Q1(VCC) , .Q2(VCC) );

upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_23) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

dffp I9  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO3) );

dffp I10  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I11  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I12  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_13) , .S0(N_18) , .S1(N_21) );

mux4x0 I13  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_12) , .S0(N_17) , .S1(N_20) );

mux4x0 I14  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_11) , .S0(N_16) , .S1(N_19) );


endmodule /* upflcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflcar2
`else
`define upflcar2

module upflcar2 ( CLK , CLR, D, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input LOAD;

wire N_21;
wire N_22;
supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_16;
wire N_17;
wire N_19;
wire N_20;


and3i1 I16  ( .A(LOAD) , .B(N_21) , .C(N_22) , .Q(N_17) );

and3i1 I17  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_20) );

and3i1 I18  ( .A(LOAD) , .B(N_21) , .C(N_22) , .Q(N_16) );

and3i1 I19  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_19) );

upflbit I15  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
               .Q(N_21) , .Q0(N_22) , .Q1(VCC) , .Q2(VCC) );

upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_22) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

dffp I11  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

dffp I10  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

mux4x0 I13  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_12) , .S0(N_17) , .S1(N_20) );

mux4x0 I14  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_11) , .S0(N_16) , .S1(N_19) );


endmodule /* upflcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflcar1
`else
`define upflcar1

module upflcar1 ( CLK , CLR, D, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input LOAD;
input [0:3] Q;wire N_16;
wire N_17;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_14;
wire N_15;


and4i1 I2  ( .A(D[0]) , .B(D[1]) , .C(D[2]) , .D(LOAD) , .Q(N_15) );

and4i1 I1  ( .A(LOAD) , .B(N_16) , .C(Q[2]) , .D(N_17) , .Q(N_14) );

dffp I3  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x6 I4  ( .A(VCC) , .B(Q[3]) , .C(D[3]) , .D(VCC) , .Q(N_11) , .S0(N_14) , .S1(N_15) );

upflbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_16) , .Q0(N_17) , .Q1(VCC) , .Q2(VCC) );

upflbit I6  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_17) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* upflcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upflbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upflbit
`else
`define upflbit

module upflbit ( CLK , CLR, D, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire N_15;
wire N_11;
supply0 GND;
supply1 VCC;
wire N_14;


logic_cell_macro I1  ( .BA1(Q) , .BA2(D) , .BAB(N_11) , .BAS1(GND) , .BAS2(GND),
                       .BB1(Q) , .BB2(D) , .BBS1(VCC) , .BBS2(GND) , .BSL(N_15),
                       .F1(VCC) , .F2(GND) , .FS(LOAD) , .FZ(N_15) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(N_14),
                       .TAS1(GND) , .TAS2(GND) , .TB1(ENT) , .TB2(GND) , .TBS(VCC),
                       .TBS1(VCC) , .TBS2(GND) , .TSL(ENP) , .TZ(N_11), .CZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(Q1) , .TZ(N_14), .CZ(), .FZ(), .QZ() );


endmodule /* upflbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfecar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfecar3
`else
`define upfecar3

module upfecar3 ( CLK , CLR, ENG, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;

wire N_14;
wire N_15;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;


upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_14),
              .Q0(N_15) , .Q1(VCC) , .Q2(VCC) );

upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_15),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

mux4x8 I3  ( .A(VCC) , .B(N_15) , .C(VCC) , .D(N_15) , .Q(N_13) , .S0(N_14) , .S1(ENG) );

mux4x8 I4  ( .A(VCC) , .B(N_15) , .C(VCC) , .D(N_15) , .Q(N_12) , .S0(N_14) , .S1(ENG) );

mux4x8 I5  ( .A(VCC) , .B(N_15) , .C(VCC) , .D(N_15) , .Q(N_11) , .S0(N_14) , .S1(ENG) );

dffp I6  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO3) );

dffp I7  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I8  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );


endmodule /* upfecar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfecar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfecar2
`else
`define upfecar2

module upfecar2 ( CLK , CLR, ENG, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;

wire N_13;
wire N_14;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;


upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_13),
              .Q0(N_14) , .Q1(VCC) , .Q2(VCC) );

upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_14),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

mux4x8 I3  ( .A(VCC) , .B(N_14) , .C(VCC) , .D(N_14) , .Q(N_12) , .S0(N_13) , .S1(ENG) );

mux4x8 I4  ( .A(VCC) , .B(N_14) , .C(VCC) , .D(N_14) , .Q(N_11) , .S0(N_13) , .S1(ENG) );

dffp I5  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I6  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );


endmodule /* upfecar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : upfebit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef upfebit
`else
`define upfebit

module upfebit ( CLK , CLR, ENG, ENP, ENT, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output Q;
input Q0, Q1, Q2;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(Q1) , .TZ(N_11), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(Q) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(ENP),
                       .F1(N_11) , .F2(GND) , .FS(ENG) , .FZ(N_12) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(VCC) , .TAB(N_12),
                       .TAS1(GND) , .TAS2(GND) , .TB1(ENP) , .TB2(ENP) , .TBS(ENT),
                       .TBS2(GND) , .TSL(Q), .CZ(), .TBS1(VCC), .TZ() );


endmodule /* upfebit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : updncarb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef updncarb
`else
`define updncarb

module updncarb ( ENT , Q0, Q1, Q2, UP, CO )/* synthesis black_box */;

output CO;
input ENT, Q0, Q1, Q2, UP;

wire N_11;
wire NET_EE;
supply0 GND;
supply1 VCC;
wire N_12;
wire N_13;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_11) , .F2(GND) , .FS(UP) , .FZ(NET_EE) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_11), .CZ(), .QZ() );

logic_cell_macro I2  ( .BA1(VCC) , .BA2(ENT) , .BAB(NET_EE) , .BAS1(GND) , .BAS2(GND),
                       .BB1(ENT) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(N_12),
                       .CZ(CO) , .F1(N_13) , .F2(GND) , .FS(Q0) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(UP) , .TAS1(GND),
                       .TAS2(GND) , .TB1(Q2) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_13), .QZ() );


endmodule /* updncarb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : updncara 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef updncara
`else
`define updncara

module updncara ( ENT , Q0, Q1, Q2, UP, CO )/* synthesis black_box */;

output CO;
input ENT, Q0, Q1, Q2, UP;

wire N_11;
wire NET_EE;
supply0 GND;
supply1 VCC;
wire N_12;
wire N_13;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(N_11) , .F2(GND) , .FS(UP) , .FZ(NET_EE) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(Q0) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(Q2) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_11), .CZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(ENT) , .BAB(NET_EE) , .BAS1(GND) , .BAS2(GND),
                       .BB1(ENT) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(N_12),
                       .CZ(CO) , .F1(N_13) , .F2(GND) , .FS(Q0) , .FZ(N_12) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(UP) , .TAS1(GND),
                       .TAS2(GND) , .TB1(Q2) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_13), .QZ() );


endmodule /* updncara */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : updnbitb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef updnbitb
`else
`define updnbitb

module updnbitb ( CLK , CLR, D0, D1, ENP, ENT, U0, U1, UP, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D0, D1, ENP, ENT;
output Q;
input U0, U1, UP;

wire N_11;
wire OF_NET;
wire OS_NET;
wire TF_NET;
wire SE_NET;
supply0 GND;
supply1 VCC;


logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(UP) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(ENT) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(ENP) , .TZ(OF_NET), .CZ(), .FZ(), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(OF_NET) , .BAS1(GND) , .BAS2(GND),
                       .BB1(D1) , .BB2(GND) , .BBS1(VCC) , .BBS2(GND) , .BSL(D0),
                       .CZ(OS_NET) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(ENP) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(U1) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(U0) , .TZ(SE_NET), .FZ(), .QZ() );

logic_cell_macro I4  ( .BA1(OS_NET) , .BA2(OS_NET) , .BAB(TF_NET) , .BAS1(N_11),
                       .BAS2(VCC) , .BB1(VCC) , .BB2(OS_NET) , .BBS1(N_11),
                       .BBS2(N_11) , .BSL(Q) , .F1(GND) , .F2(GND) , .FS(GND),
                       .QCK(CLK) , .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC),
                       .QRT(CLR) , .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND),
                       .TAB(SE_NET) , .TAS1(N_11) , .TAS2(N_11) , .TB1(UP) , .TB2(GND),
                       .TBS(VCC) , .TBS1(VCC) , .TBS2(N_11) , .TSL(ENT) , .TZ(TF_NET), .CZ(), .FZ() );


endmodule /* updnbitb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : updnbita 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef updnbita
`else
`define updnbita

module updnbita ( CLK , CLR, D0, D1, ENP, ENT, U0, U1, UP, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D0, D1, ENP, ENT;
output Q;
input U0, U1, UP;

wire OF_NET;
wire OS_NET;
wire TF_NET;
wire SE_NET;
supply0 GND;
supply1 VCC;


logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(UP) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(ENP) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(ENT) , .TZ(OF_NET), .CZ(), .FZ(), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(OF_NET) , .BAS1(GND) , .BAS2(GND),
                       .BB1(D1) , .BB2(GND) , .BBS1(VCC) , .BBS2(GND) , .BSL(D0),
                       .CZ(OS_NET) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(ENT) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(U1) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(U0) , .TZ(SE_NET), .FZ(), .QZ() );

logic_cell_macro I4  ( .BA1(OS_NET) , .BA2(OS_NET) , .BAB(TF_NET) , .BAS1(GND),
                       .BAS2(VCC) , .BB1(VCC) , .BB2(OS_NET) , .BBS1(GND) , .BBS2(GND),
                       .BSL(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(SE_NET) , .TAS1(GND),
                       .TAS2(GND) , .TB1(UP) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(ENP) , .TZ(TF_NET), .CZ(), .FZ() );


endmodule /* updnbita */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : udcnt3b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef udcnt3b
`else
`define udcnt3b

module udcnt3b ( CLK , CLR, ENP, ENT, UP, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENP, ENT;
output [0:2] Q;
output RCO;
input UP;

supply1 VCC;
supply0 GND;


updncarb I1  ( .CO(RCO) , .ENT(ENT) , .Q0(Q[2]) , .Q1(Q[1]) , .Q2(Q[0]) , .UP(UP) );

updnbitb I2  ( .CLK(CLK) , .CLR(CLR) , .D0(Q[0]) , .D1(Q[1]) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[2]) , .U0(Q[0]) , .U1(Q[1]) , .UP(UP) );

updnbitb I3  ( .CLK(CLK) , .CLR(CLR) , .D0(Q[0]) , .D1(GND) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[1]) , .U0(Q[0]) , .U1(VCC) , .UP(UP) );

updnbitb I4  ( .CLK(CLK) , .CLR(CLR) , .D0(GND) , .D1(GND) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[0]) , .U0(VCC) , .U1(VCC) , .UP(UP) );


endmodule /* udcnt3b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : udcnt3a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef udcnt3a
`else
`define udcnt3a

module udcnt3a ( CLK , CLR, ENP, ENT, UP, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENP, ENT;
output [0:2] Q;
output RCO;
input UP;

supply1 VCC;
supply0 GND;


updncara I4  ( .CO(RCO) , .ENT(ENT) , .Q0(Q[2]) , .Q1(Q[1]) , .Q2(Q[0]) , .UP(UP) );

updnbita I5  ( .CLK(CLK) , .CLR(CLR) , .D0(Q[0]) , .D1(Q[1]) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[2]) , .U0(Q[0]) , .U1(Q[1]) , .UP(UP) );

updnbita I6  ( .CLK(CLK) , .CLR(CLR) , .D0(Q[0]) , .D1(GND) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[1]) , .U0(Q[0]) , .U1(VCC) , .UP(UP) );

updnbita I7  ( .CLK(CLK) , .CLR(CLR) , .D0(GND) , .D1(GND) , .ENP(ENP) , .ENT(ENT),
               .Q(Q[0]) , .U0(VCC) , .U1(VCC) , .UP(UP) );


endmodule /* udcnt3a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucxco 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucxco
`else
`define ucxco

module ucxco ( CLK , D_DEC, EN, LOAD, PRE, Q_DEC, CO, LDBUF )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
output CO;
input D_DEC, EN;
output LDBUF;
input LOAD, PRE, Q_DEC;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(Q_DEC) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D_DEC),
                       .F1(VCC) , .F2(GND) , .FS(LOAD) , .FZ(LDBUF) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(GND),
                       .QST(PRE) , .QZ(CO) , .TA1(Q_DEC) , .TA2(GND) , .TAB(CO),
                       .TAS1(VCC) , .TAS2(GND) , .TB1(Q_DEC) , .TB2(VCC) , .TBS(LDBUF),
                       .TBS1(GND) , .TBS2(GND) , .TSL(EN), .CZ(), .TZ() );


endmodule /* ucxco */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucxbit2b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucxbit2b
`else
`define ucxbit2b

module ucxbit2b ( CLK , CLR, D, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, LOAD,
                 QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, LOAD;
output Q;
input QFB;

wire N_14;
supply0 GND;
supply1 VCC;
wire NET_LR;
wire N_11;
wire N_13;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(ENH1) , .BAS1(N_14) , .BAS2(N_14),
                       .BB1(GND) , .BB2(ENH3) , .BBS1(N_14) , .BBS2(N_14) , .BSL(ENH2),
                       .CZ(NET_LR) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC),
                       .TAS2(N_14) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(N_14),
                       .TBS2(N_14) , .TSL(ENL2) , .TZ(N_13), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(N_11) , .BA2(D) , .BAB(QFB) , .BAS1(VCC) , .BAS2(GND),
                       .BB1(N_11) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(LOAD),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(ENH4) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(NET_LR) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_13) , .TZ(N_11), .CZ(), .FZ() );


endmodule /* ucxbit2b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucxbit2a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucxbit2a
`else
`define ucxbit2a

module ucxbit2a ( CLK , CLR, D, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, LOAD,
                 QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, LOAD;
output Q;
input QFB;

wire N_14;
supply0 GND;
supply1 VCC;
wire NET_LR;
wire N_13;


logic_cell_macro I2  ( .BA1(N_14) , .BA2(D) , .BAB(QFB) , .BAS1(GND) , .BAS2(GND),
                       .BB1(N_14) , .BB2(D) , .BBS1(VCC) , .BBS2(GND) , .BSL(LOAD),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(ENH4) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(NET_LR) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_13) , .TZ(N_14), .CZ(), .FZ() );

logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(ENH1) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(ENH3) , .BBS1(GND) , .BBS2(GND) , .BSL(ENH2),
                       .CZ(NET_LR) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(ENL2) , .TZ(N_13), .FZ(), .QZ() );


endmodule /* ucxbit2a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctxcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctxcar3
`else
`define uctxcar3

module uctxcar3 ( CLK , CLR, D, ENG, LOAD, Q, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;
input [0:1] Q;wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;


and2i1 I9  ( .A(Q[1]) , .B(Q[0]) , .Q(N_14) );

dffp I1  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO3) );

dffp I2  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I3  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I4  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO3) , .Q(N_13) , .S0(ENG) , .S1(LOAD) );

mux4x7 I5  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO2) , .Q(N_12) , .S0(ENG) , .S1(LOAD) );

mux4x7 I6  ( .A(N_15) , .B(N_15) , .C(N_14) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

and2i0 I8  ( .A(D[0]) , .B(D[1]) , .Q(N_15) );


endmodule /* uctxcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctxcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctxcar2
`else
`define uctxcar2

module uctxcar2 ( CLK , CLR, D, ENG, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;

wire N_19;
wire N_17;
wire N_18;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_15;


and2i1 I9  ( .A(N_17) , .B(N_18) , .Q(N_15) );

upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(N_17) , .Q0(N_18) , .Q1(VCC) , .Q2(VCC) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(N_18) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

and2i0 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_19) );

dffp I5  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I6  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I7  ( .A(N_19) , .B(N_19) , .C(N_15) , .D(ACO2) , .Q(N_12) , .S0(ENG) , .S1(LOAD) );

mux4x7 I8  ( .A(N_19) , .B(N_19) , .C(N_15) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );


endmodule /* uctxcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctxcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctxcar1
`else
`define uctxcar1

module uctxcar1 ( CLK , CLR, D, ENG, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input ENG, LOAD;
input [0:1] Q;wire N_13;
wire N_11;
wire N_12;


and2i1 I5  ( .A(Q[1]) , .B(Q[0]) , .Q(N_12) );

dffp I1  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x7 I2  ( .A(N_13) , .B(N_13) , .C(N_12) , .D(ACO1) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

and2i0 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_13) );


endmodule /* uctxcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctlcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctlcar3
`else
`define uctlcar3

module uctlcar3 ( CLK , CLR, D, LOAD, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input LOAD;

wire N_22;
wire N_23;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;


and3i1 I16  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_21) );

and3i1 I17  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_18) );

and3i1 I18  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_17) );

and3i1 I19  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_20) );

and3i1 I20  ( .A(LOAD) , .B(N_22) , .C(N_23) , .Q(N_16) );

and3i1 I21  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_19) );

mux4x0 I1  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_13) , .S0(N_18) , .S1(N_21) );

mux4x0 I2  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_12) , .S0(N_17) , .S1(N_20) );

mux4x0 I3  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_11) , .S0(N_16) , .S1(N_19) );

dffp I4  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO3) );

dffp I5  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I6  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

upflbit I15  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
               .Q(N_22) , .Q0(N_23) , .Q1(VCC) , .Q2(VCC) );

upflbit I14  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
               .Q(N_23) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* uctlcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctlcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctlcar2
`else
`define uctlcar2

module uctlcar2 ( CLK , CLR, D, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:1] D;
input LOAD;

wire N_19;
wire N_20;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;
wire N_15;
wire N_16;
wire N_17;
wire N_18;


and3i1 I11  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_17) );

and3i1 I12  ( .A(LOAD) , .B(N_19) , .C(N_20) , .Q(N_16) );

and3i1 I13  ( .A(D[0]) , .B(D[1]) , .C(LOAD) , .Q(N_18) );

and3i1 I14  ( .A(LOAD) , .B(N_19) , .C(N_20) , .Q(N_15) );

upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_19) , .Q0(N_20) , .Q1(VCC) , .Q2(VCC) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_20) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

dffp I3  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I4  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I9  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_12) , .S0(N_16) , .S1(N_18) );

mux4x0 I10  ( .A(VCC) , .B(GND) , .C(GND) , .D(VCC) , .Q(N_11) , .S0(N_15) , .S1(N_17) );


endmodule /* uctlcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctlcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctlcar1
`else
`define uctlcar1

module uctlcar1 ( CLK , CLR, D, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input LOAD;
input [0:3] Q;wire N_16;
wire N_17;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_14;
wire N_15;


dffp I1  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_16) , .Q0(N_17) , .Q1(VCC) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(N_17) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

mux4x6 I4  ( .A(VCC) , .B(Q[3]) , .C(D[3]) , .D(VCC) , .Q(N_11) , .S0(N_14) , .S1(N_15) );

and4i1 I5  ( .A(LOAD) , .B(N_16) , .C(Q[2]) , .D(N_17) , .Q(N_14) );

and4i1 I6  ( .A(D[0]) , .B(D[1]) , .C(D[2]) , .D(LOAD) , .Q(N_15) );


endmodule /* uctlcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : uctecar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef uctecar1
`else
`define uctecar1

module uctecar1 ( CLK , CLR, ENG, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;
input [0:3] Q;wire N_15;
wire N_16;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_14;


upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_15),
              .Q0(N_16) , .Q1(VCC) , .Q2(VCC) );

upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(GND) , .ENP(ENG) , .ENT(GND) , .Q(N_16),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

dffp I3  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x8 I4  ( .A(VCC) , .B(N_16) , .C(VCC) , .D(N_16) , .Q(N_11) , .S0(N_14) , .S1(ENG) );

and3i0 I5  ( .A(N_15) , .B(Q[2]) , .C(Q[3]) , .Q(N_14) );


endmodule /* uctecar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx4c
`else
`define ucntx4c

module ucntx4c ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, ENP, ENT, LOAD;
output [0:3] Q;supply1 VCC;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* ucntx4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx4b
`else
`define ucntx4b

module ucntx4b ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, ENP, ENT, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand5i1 I5  ( .A(Q[0]) , .B(Q[1]) , .C(Q[2]) , .D(Q[3]) , .E(ENT) , .Q(RCO) );


endmodule /* ucntx4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntx4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntx4a
`else
`define ucntx4a

module ucntx4a ( CLK , CLR, D, ENG, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENG, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;
supply0 GND;


upfxbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(GND) , .ENT(GND),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand2i0 I5  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );


endmodule /* ucntx4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl4c
`else
`define ucntl4c

module ucntl4c ( CLK , CLR, D, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENP, ENT, LOAD;
output [0:3] Q;supply1 VCC;


upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* ucntl4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl4b
`else
`define ucntl4b

module ucntl4b ( CLK , CLR, D, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input ENP, ENT, LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;


upflbit I1  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand5i1 I5  ( .A(Q[0]) , .B(Q[1]) , .C(Q[2]) , .D(Q[3]) , .E(ENT) , .Q(RCO) );


endmodule /* ucntl4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucntl4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucntl4a
`else
`define ucntl4a

module ucntl4a ( CLK , CLR, D, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [0:3] D;
input LOAD;
output [0:3] Q;
output RCO;

supply1 VCC;
supply0 GND;


nand2i0 I1  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );

upflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upflbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(GND) , .ENT(GND) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* ucntl4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte4c
`else
`define ucnte4c

module ucnte4c ( CLK , CLR, ENG, ENP, ENT, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output [0:3] Q;supply1 VCC;


upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[0]),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );


endmodule /* ucnte4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte4b
`else
`define ucnte4b

module ucnte4b ( CLK , CLR, ENG, ENP, ENT, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output [0:3] Q;
output RCO;

supply1 VCC;


upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[0]),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand5i1 I5  ( .A(Q[0]) , .B(Q[1]) , .C(Q[2]) , .D(Q[3]) , .E(ENT) , .Q(RCO) );


endmodule /* ucnte4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucnte4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucnte4a
`else
`define ucnte4a

module ucnte4a ( CLK , CLR, ENG, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;
output [0:3] Q;
output RCO;

supply1 VCC;
supply0 GND;


upfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(GND) , .ENT(GND) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

upfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(GND) , .ENT(GND) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(VCC) );

upfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(GND) , .ENT(GND) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(VCC) , .Q2(VCC) );

upfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(GND) , .ENT(GND) , .Q(Q[0]),
              .Q0(VCC) , .Q1(VCC) , .Q2(VCC) );

nand2i0 I5  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );


endmodule /* ucnte4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucebitb0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucebitb0
`else
`define ucebitb0

module ucebitb0 ( CLK , CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3;
output Q;
input QFB;

wire NET_QF;
wire NET_N;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(QFB) , .FZ(NET_QF) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(ENL2) , .TZ(NET_N), .CZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(VCC) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_N) , .BB2(NET_N) , .BBS1(GND) , .BBS2(VCC),
                       .BSL(NET_QF) , .F1(GND) , .F2(N_14) , .FS(ENH4) , .FZ(N_13),
                       .QCK(CLK) , .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC),
                       .QRT(CLR) , .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND),
                       .TAB(ENH2) , .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(ENH1),
                       .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(ENH3) , .TZ(N_14), .CZ() );


endmodule /* ucebitb0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucebita1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucebita1
`else
`define ucebita1

module ucebita1 ( CLK , ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, PRE, QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, PRE;
output Q;
input QFB;

wire NET_N;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(ENL2) , .TZ(NET_N), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(VCC) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_N) , .BB2(NET_N) , .BBS1(GND) , .BBS2(VCC) , .BSL(QFB),
                       .F1(GND) , .F2(N_14) , .FS(ENH4) , .FZ(N_13) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(GND),
                       .QST(PRE) , .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(ENH2),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(ENH1) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(ENH3) , .TZ(N_14), .CZ() );


endmodule /* ucebita1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucebita0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucebita0
`else
`define ucebita0

module ucebita0 ( CLK , CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3;
output Q;
input QFB;

wire NET_N;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(ENL2) , .TZ(NET_N), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(VCC) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_N) , .BB2(NET_N) , .BBS1(GND) , .BBS2(VCC) , .BSL(QFB),
                       .F1(GND) , .F2(N_14) , .FS(ENH4) , .FZ(N_13) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(ENH2),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(ENH1) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(ENH3) , .TZ(N_14), .CZ() );


endmodule /* ucebita0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucebit2b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucebit2b
`else
`define ucebit2b

module ucebit2b ( CLK , CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3;
output Q;
input QFB;

wire NET_QF;
wire NET_N;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(QFB) , .FZ(NET_QF) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(ENL2) , .TZ(NET_N), .CZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(VCC) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_N) , .BB2(NET_N) , .BBS1(GND) , .BBS2(VCC),
                       .BSL(NET_QF) , .F1(GND) , .F2(N_14) , .FS(ENH4) , .FZ(N_13),
                       .QCK(CLK) , .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC),
                       .QRT(CLR) , .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND),
                       .TAB(ENH2) , .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(ENH1),
                       .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(ENH3) , .TZ(N_14), .CZ() );


endmodule /* ucebit2b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ucebit2a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ucebit2a
`else
`define ucebit2a

module ucebit2a ( CLK , CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3, QFB, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENH1, ENH2, ENH3, ENH4, ENL1, ENL2, ENL3;
output Q;
input QFB;

wire NET_N;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(ENL3) , .TA2(GND) , .TAB(ENL1) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(ENL2) , .TZ(NET_N), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(VCC) , .BAB(N_13) , .BAS1(GND) , .BAS2(GND),
                       .BB1(NET_N) , .BB2(NET_N) , .BBS1(GND) , .BBS2(VCC) , .BSL(QFB),
                       .F1(GND) , .F2(N_14) , .FS(ENH4) , .FZ(N_13) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(ENH2),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(ENH1) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(ENH3) , .TZ(N_14), .CZ() );


endmodule /* ucebit2a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tri_inv 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tri_inv
`else
`define tri_inv

module tri_inv ( IN1 , IN2, IN3, OUT1, OUT2, OUT3 )/* synthesis black_box */;

input IN1, IN2, IN3;
output OUT1, OUT2, OUT3;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(IN2),
                       .CZ(OUT2) , .F1(VCC) , .F2(GND) , .FS(IN3) , .FZ(OUT3),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(IN1) , .TZ(OUT1), .QZ(), .TA1(VCC) );


endmodule /* tri_inv */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t148ao 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t148ao
`else
`define t148ao

module t148ao ( EI , P1, P2, P3, P4, P5, P6, P7, A0 )/* synthesis black_box */;

output A0;
input EI, P1, P2, P3, P4, P5, P6, P7;

wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;


xor2i0 I1  ( .A(N_12) , .B(N_11) , .Q(A0) );

or3i0 I2  ( .A(N_14) , .B(N_15) , .C(N_13) , .Q(N_11) );

or2i0 I3  ( .A(EI) , .B(P7) , .Q(N_12) );

and4i2 I4  ( .A(N_12) , .B(P6) , .C(P5) , .D(EI) , .Q(N_13) );

and5i2 I5  ( .A(N_12) , .B(P4) , .C(P6) , .D(P3) , .E(EI) , .Q(N_15) );

and6i2 I6  ( .A(N_12) , .B(P2) , .C(P4) , .D(P6) , .E(P1) , .F(EI) , .Q(N_14) );


endmodule /* t148ao */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t148a2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t148a2
`else
`define t148a2

module t148a2 ( EI , P4, P5, P6, P7, A2 )/* synthesis black_box */;

output A2;
input EI, P4, P5, P6, P7;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(P6) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(P4) , .BBS1(GND) , .BBS2(GND) , .BSL(P5),
                       .CZ(N_11) , .F1(N_11) , .F2(VCC) , .FS(EI) , .FZ(A2) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(P7) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .QZ(), .TZ() );


endmodule /* t148a2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t148a1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t148a1
`else
`define t148a1

module t148a1 ( EI , P2, P3, P4, P5, P6, P7, A1 )/* synthesis black_box */;

output A1;
input EI, P2, P3, P4, P5, P6, P7;

wire N_11;
wire N_12;
wire N_13;


or4i0 I1  ( .A(EI) , .B(N_13) , .C(N_12) , .D(N_11) , .Q(A1) );

and3i1 I2  ( .A(P6) , .B(P7) , .C(P5) , .Q(N_11) );

and3i1 I3  ( .A(P7) , .B(P6) , .C(P4) , .Q(N_12) );

and4i0 I4  ( .A(P2) , .B(P3) , .C(P7) , .D(P6) , .Q(N_13) );


endmodule /* t148a1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t138f3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t138f3
`else
`define t138f3

module t138f3 ( A , B, C, EN, ENOUT, Y1, Y5 )/* synthesis black_box */;

input A, B, C, EN;
output ENOUT, Y1, Y5;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I4  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(EN) , .FZ(ENOUT) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .QZ(), .TZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(C) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(N_11),
                       .CZ(Y5) , .F1(N_11) , .F2(GND) , .FS(C) , .FZ(Y1) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(A) , .TA2(GND) , .TAB(EN) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B) , .TZ(N_11), .QZ() );


endmodule /* t138f3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t138f2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t138f2
`else
`define t138f2

module t138f2 ( A , B, C, EN, Y0, Y3, Y6 )/* synthesis black_box */;

input A, B, C, EN;
output Y0, Y3, Y6;

wire N_11;
supply0 GND;
supply1 VCC;
wire N_12;


logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(N_12) , .BAS1(GND) , .BAS2(GND),
                       .BB1(A) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(C) , .CZ(Y3),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(VCC) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(EN) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(N_11) , .TZ(Y0), .FZ(), .QZ() );

logic_cell_macro I3  ( .BA1(GND) , .BA2(GND) , .BAB(N_12) , .BAS1(GND) , .BAS2(GND),
                       .BB1(C) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(A) , .CZ(Y6),
                       .F1(GND) , .F2(B) , .FS(EN) , .FZ(N_12) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(GND) , .TAB(C) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(N_11), .QZ() );


endmodule /* t138f2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : t138f1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef t138f1
`else
`define t138f1

module t138f1 ( A , B, C, EN, Y2, Y4, Y7 )/* synthesis black_box */;

input A, B, C, EN;
output Y2, Y4, Y7;

supply1 VCC;
supply0 GND;
wire N_11;
wire N_13;
wire N_14;


logic_cell_macro I1  ( .BA1(N_13) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(EN),
                       .CZ(Y7) , .F1(A) , .F2(VCC) , .FS(EN) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(B) , .TAS1(GND),
                       .TAS2(GND) , .TB1(C) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(N_11) , .TZ(Y2), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(C) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(N_13) , .F1(N_14) , .F2(Y2) , .FS(Y7) , .FZ(Y4) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(GND) , .TAB(C) , .TAS1(GND),
                       .TAS2(GND) , .TB1(B) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(N_11) , .TZ(N_14), .QZ() );


endmodule /* t138f1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum2_gen 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum2_gen
`else
`define sum2_gen

module sum2_gen ( C_i , Cj_i0, Cj_i1, Ck_j0, Ck_j1, Sk_0, Sk_1, Sk_i )/* synthesis black_box */;

input C_i, Cj_i0, Cj_i1, Ck_j0, Ck_j1, Sk_0, Sk_1;
output Sk_i;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(Sk_0) , .BA2(Sk_1) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Ck_j1),
                       .CZ(Sk_i) , .F1(Cj_i0) , .F2(Cj_i1) , .FS(C_i) , .FZ(N_11),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(Sk_0) , .TA2(Sk_1) , .TAB(GND),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(N_11),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Ck_j0), .QZ(), .TZ() );


endmodule /* sum2_gen */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum16
`else
`define sum16

module sum16 ( a , b, C11_C70, C11_C71, C7_C30, C7_C31, Cin, Co0_Ci0, Co0_Ci1,
              Co10_C90, Co10_C91, Co12_C110, Co12_C111, Co13_C120, Co13_C121,
              Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10, Co2_C11,
              Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50,
              Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81, S, Carry3, Sumi );

input [0:0] a;
input [0:0] b;
input C11_C70, C11_C71, C7_C30, C7_C31;
output Carry3;
input Cin, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111,Co13_C120, Co13_C121, Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10,Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50,Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
input [15:0] S;
output [15:0] Sumi;wire Carry_0;
wire Carry3a;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;


carry0 I32  ( .A(a[0]) , .B(b[0]) , .Cin(Cin) , .Cout(Carry_0) );

sum2_gen I3  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Carry3) , .Ck_j1(GND),
               .Sk_0(N_15) , .Sk_1(N_16) , .Sk_i(Sumi[7]) );

sum2_gen I4  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_22) , .Sk_1(N_14) , .Sk_i(Sumi[15]) );

sum2_gen I5  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_21) , .Sk_1(N_13) , .Sk_i(Sumi[14]) );

sum2_gen I6  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_20) , .Sk_1(N_12) , .Sk_i(Sumi[13]) );

sum2_gen I2  ( .C_i(GND) , .Cj_i0(Carry3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_0(N_19) , .Sk_1(N_11) , .Sk_i(Sumi[11]) );

sum2_gen I1  ( .C_i(GND) , .Cj_i0(Carry3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_0(N_17) , .Sk_1(N_18) , .Sk_i(Sumi[10]) );

sum_gen I18  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Carry3) , .Ck_j1(GND),
               .Sk_01(S[4]) , .Sk_i(Sumi[4]) );

sum_gen I17  ( .C_i(GND) , .Cj_i0(Carry3) , .Cj_i1(GND) , .Ck_j0(Co4_C30),
               .Ck_j1(Co4_C31) , .Sk_01(S[5]) , .Sk_i(Sumi[5]) );

sum_gen I16  ( .C_i(Carry3) , .Cj_i0(Co4_C30) , .Cj_i1(Co4_C31) , .Ck_j0(Co5_C40),
               .Ck_j1(Co5_C41) , .Sk_01(S[6]) , .Sk_i(Sumi[6]) );

sum_gen I14  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Sk_01(S[7]) , .Sk_i(N_16) );

sum_gen I15  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Sk_01(S[7]) , .Sk_i(N_15) );

sum_gen I13  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Sk_01(S[15]) , .Sk_i(N_14) );

sum_gen I12  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Sk_01(S[15]) , .Sk_i(N_22) );

sum_gen I11  ( .C_i(GND) , .Cj_i0(Co12_C111) , .Cj_i1(GND) , .Ck_j0(Co13_C120),
               .Ck_j1(Co13_C121) , .Sk_01(S[14]) , .Sk_i(N_13) );

sum_gen I10  ( .C_i(GND) , .Cj_i0(Co12_C110) , .Cj_i1(GND) , .Ck_j0(Co13_C120),
               .Ck_j1(Co13_C121) , .Sk_01(S[14]) , .Sk_i(N_21) );

sum_gen I9  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Co12_C111) , .Ck_j1(GND),
              .Sk_01(S[13]) , .Sk_i(N_12) );

sum_gen I8  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Co12_C110) , .Ck_j1(GND),
              .Sk_01(S[13]) , .Sk_i(N_20) );

sum_gen I7  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
              .Ck_j1(C11_C71) , .Sk_01(S[12]) , .Sk_i(Sumi[12]) );

sum_gen I19  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Sk_01(S[11]) , .Sk_i(N_11) );

sum_gen I20  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Sk_01(S[11]) , .Sk_i(N_19) );

sum_gen I21  ( .C_i(GND) , .Cj_i0(Co8_C71) , .Cj_i1(GND) , .Ck_j0(Co9_C80),
               .Ck_j1(Co9_C81) , .Sk_01(S[10]) , .Sk_i(N_18) );

sum_gen I22  ( .C_i(GND) , .Cj_i0(Co8_C70) , .Cj_i1(GND) , .Ck_j0(Co9_C80),
               .Ck_j1(Co9_C81) , .Sk_01(S[10]) , .Sk_i(N_17) );

sum_gen I23  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(Co8_C70),
               .Ck_j1(Co8_C71) , .Sk_01(S[9]) , .Sk_i(Sumi[9]) );

sum_gen I24  ( .C_i(GND) , .Cj_i0(Carry3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_01(S[8]) , .Sk_i(Sumi[8]) );

sum_gen I25  ( .C_i(Carry_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
               .Ck_j1(Co2_C11) , .Sk_01(S[3]) , .Sk_i(Sumi[3]) );

sum_gen I26  ( .C_i(Cin) , .Cj_i0(Co0_Ci0) , .Cj_i1(Co0_Ci1) , .Ck_j0(Co1_C00),
               .Ck_j1(Co1_C01) , .Sk_01(S[2]) , .Sk_i(Sumi[2]) );

sum_gen I27  ( .C_i(GND) , .Cj_i0(Cin) , .Cj_i1(GND) , .Ck_j0(Co0_Ci0),
               .Ck_j1(Co0_Ci1) , .Sk_01(S[1]) , .Sk_i(Sumi[1]) );

cary_gen I29  ( .C_i(Carry_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
                .Ck_j1(Co2_C11) , .Cm_i(Carry3a) , .Cm_k0(Co3_C20) , .Cm_k1(Co3_C21) );

cary_gen I30  ( .C_i(Carry_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
                .Ck_j1(Co2_C11) , .Cm_i(Carry3) , .Cm_k0(Co3_C20) , .Cm_k1(Co3_C21) );

sum0 I31  ( .A(a[0]) , .B(b[0]) , .Cin(Cin) , .s0(Sumi[0]) );


endmodule /* sum16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum0
`else
`define sum0

module sum0 ( A , B, Cin, s0 )/* synthesis black_box */;

input A, B, Cin;
output s0;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(A) , .TAB(Cin) , .TAS1(GND) , .TAS2(VCC) , .TB1(A),
                       .TB2(A) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(B) , .TZ(s0), .CZ(), .FZ(), .QZ() );


endmodule /* sum0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum_gen 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum_gen
`else
`define sum_gen

module sum_gen ( C_i , Cj_i0, Cj_i1, Ck_j0, Ck_j1, Sk_01, Sk_i )/* synthesis black_box */;

input C_i, Cj_i0, Cj_i1, Ck_j0, Ck_j1, Sk_01;
output Sk_i;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(VCC) , .BAB(Ck_j1) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(GND) , .BBS1(GND) , .BBS2(VCC) , .BSL(Sk_01),
                       .CZ(Sk_i) , .F1(Cj_i0) , .F2(Cj_i1) , .FS(C_i) , .FZ(N_11),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(VCC) , .TAB(Ck_j0),
                       .TAS1(GND) , .TAS2(GND) , .TB1(VCC) , .TB2(GND) , .TBS(N_11),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Sk_01), .QZ(), .TZ() );


endmodule /* sum_gen */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum_c0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum_c0
`else
`define sum_c0

module sum_c0 ( Ax , Bx, Co_Ci0, Co_Ci1 )/* synthesis black_box */;

input Ax, Bx;
output Co_Ci0, Co_Ci1;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(Bx) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Ax),
                       .CZ(Co_Ci0) , .F1(Bx) , .F2(VCC) , .FS(Ax) , .FZ(Co_Ci1),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(VCC) , .TAB(GND),
                       .TAS1(GND) , .TAS2(GND) , .TB1(VCC) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(GND), .QZ(), .TZ() );


endmodule /* sum_c0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : sum_c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef sum_c
`else
`define sum_c

module sum_c ( Ax , Bx, Co_Ci0, Co_Ci1, Sub_Sum )/* synthesis black_box */;

input Ax, Bx;
output Co_Ci0, Co_Ci1, Sub_Sum;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(Bx) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Ax),
                       .CZ(Co_Ci0) , .F1(Bx) , .F2(VCC) , .FS(Ax) , .FZ(Co_Ci1),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(GND) , .TA2(VCC) , .TAB(Ax),
                       .TAS1(GND) , .TAS2(GND) , .TB1(VCC) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Bx) , .TZ(Sub_Sum), .QZ() );


endmodule /* sum_c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ripbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ripbit
`else
`define ripbit

module ripbit ( CI , CLK, CLR, CX, D, LOAD, CO, Q )/* synthesis black_box */;

input CI;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
output CO;
input CX, D, LOAD;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(LOAD) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(D) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(CO) , .F1(GND),
                       .F2(CI) , .FS(CX) , .FZ(CO) , .QCK(CLK) , .QCKS(VCC) , .QDI(GND),
                       .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .TZ() );


endmodule /* ripbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : reg169 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef reg169
`else
`define reg169

module reg169 ( CLK , D_IN, DATA, EN, FDBK, LDNN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D_IN, DATA, EN, FDBK, LDNN;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(DATA) , .BA2(DATA) , .BAB(LDNN) , .BAS1(GND) , .BAS2(GND),
                       .BB1(FDBK) , .BB2(FDBK) , .BBS1(GND) , .BBS2(VCC) , .BSL(N_11),
                       .F1(EN) , .F2(GND) , .FS(D_IN) , .FZ(N_11) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(GND),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* reg169 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : rco169 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef rco169
`else
`define rco169

module rco169 ( A , ANN, ENT, QC, QD, RCO )/* synthesis black_box */;

input A, ANN, ENT, QC, QD;
output RCO;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(A) , .BAB(ENT) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(QD),
                       .CZ(RCO) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(QD) , .TAB(ENT) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(VCC) , .TBS(QC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(ANN), .FZ(), .QZ(), .TZ() );


endmodule /* rco169 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : muxi2dx2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef muxi2dx2
`else
`define muxi2dx2

module muxi2dx2 ( A , B, C, D, S, Q, R )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;



mux2dx1 I1  ( .A(B) , .B(A) , .C(D) , .D(C) , .Q(Q) , .R(R) , .S(S) );


endmodule /* muxi2dx2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : muxde2x0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef muxde2x0
`else
`define muxde2x0

module muxde2x0 ( A1 , A2, B1, B2, GNN, SEL, Y1, Y2 )/* synthesis black_box */;

input A1, A2, B1, B2, GNN, SEL;
output Y1, Y2;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(A2) , .BA2(GND) , .BAB(SEL) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B2) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GNN),
                       .CZ(Y2) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A1) , .TA2(GND) , .TAB(SEL) , .TAS1(GND) , .TAS2(GND),
                       .TB1(B1) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GNN) , .TZ(Y1), .FZ(), .QZ() );


endmodule /* muxde2x0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : muxc2dx2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef muxc2dx2
`else
`define muxc2dx2

module muxc2dx2 ( A , B, C, D, S, Q, R, T )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;
output T;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(T) , .BAS1(GND) , .BAS2(GND),
                       .BB1(C) , .BB2(C) , .BBS1(GND) , .BBS2(GND) , .BSL(D) , .CZ(R),
                       .F1(GND) , .F2(VCC) , .FS(S) , .FZ(T) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(T) , .TAS1(GND) , .TAS2(GND),
                       .TB1(A) , .TB2(A) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(B),
                       .TZ(Q), .QZ() );


endmodule /* muxc2dx2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : muxb2dx2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef muxb2dx2
`else
`define muxb2dx2

module muxb2dx2 ( A , B, C, D, S, Q, R, T )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;
output T;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(C) , .BA2(C) , .BAB(T) , .BAS1(GND) , .BAS2(GND) , .BB1(VCC),
                       .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(D) , .CZ(R) , .F1(GND),
                       .F2(VCC) , .FS(S) , .FZ(T) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                       .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(A) , .TA2(A),
                       .TAB(T) , .TAS1(GND) , .TAS2(GND) , .TB1(VCC) , .TB2(GND),
                       .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(B) , .TZ(Q), .QZ() );


endmodule /* muxb2dx2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dxy 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dxy
`else
`define mux2dxy

module mux2dxy ( A , B, C, D, S, Q, R )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(C) , .BA2(D) , .BAB(GND) , .BAS1(VCC) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(S),
                       .CZ(R) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .FZ(), .QZ() );


endmodule /* mux2dxy */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dxx 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dxx
`else
`define mux2dxx

module mux2dxx ( A , B, C, D, S, Q, R )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(C) , .F2(D) , .FS(S) , .FZ(R) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .CZ(), .QZ() );


endmodule /* mux2dxx */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mbitc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mbitc
`else
`define mbitc

module mbitc ( A , B0, B1, CI, CO, S )/* synthesis black_box */;

input A, B0, B1, CI;
output CO, S;

wire N_11;
wire N_12;


maj3i0 I8  ( .A(A) , .B(N_12) , .C(CI) , .Q(CO) );

xor3i0 I5  ( .A(A) , .B(N_11) , .C(CI) , .Q(S) );

and2i0 I6  ( .A(B0) , .B(B1) , .Q(N_12) );

and2i0 I7  ( .A(B0) , .B(B1) , .Q(N_11) );


endmodule /* mbitc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mbitb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mbitb
`else
`define mbitb

module mbitb ( A0 , A1, B, CI, CO, S )/* synthesis black_box */;

input A0, A1, B, CI;
output CO, S;

wire N_11;
wire N_12;


maj3i0 I6  ( .A(N_11) , .B(B) , .C(CI) , .Q(CO) );

xor3i0 I5  ( .A(N_12) , .B(B) , .C(CI) , .Q(S) );

and2i0 I3  ( .A(A0) , .B(A1) , .Q(N_11) );

and2i0 I4  ( .A(A0) , .B(A1) , .Q(N_12) );


endmodule /* mbitb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mbita 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mbita
`else
`define mbita

module mbita ( A0 , A1, B0, B1, CI, CO, S )/* synthesis black_box */;

input A0, A1, B0, B1, CI;
output CO, S;

wire N_11;
wire N_12;
wire N_13;
wire N_14;


maj3i0 I8  ( .A(N_12) , .B(N_11) , .C(CI) , .Q(CO) );

xor3i0 I7  ( .A(N_14) , .B(N_13) , .C(CI) , .Q(S) );

and2i0 I3  ( .A(B0) , .B(B1) , .Q(N_11) );

and2i0 I4  ( .A(A0) , .B(A1) , .Q(N_12) );

and2i0 I5  ( .A(B0) , .B(B1) , .Q(N_13) );

and2i0 I6  ( .A(A0) , .B(A1) , .Q(N_14) );


endmodule /* mbita */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ltch259 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ltch259
`else
`define ltch259

module ltch259 ( CLRNN , DATA, DECIN, GNN, Q )/* synthesis black_box */;

input CLRNN, DATA, DECIN, GNN;
output Q;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(GND) , .BA2(DECIN) , .BAB(CLRNN) , .BAS1(GND) , .BAS2(GND),
                       .BB1(Q) , .BB2(DATA) , .BBS1(GND) , .BBS2(GND) , .BSL(N_11),
                       .CZ(Q) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(DECIN) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GNN) , .TZ(N_11), .FZ(), .QZ() );


endmodule /* ltch259 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : eqcombit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef eqcombit
`else
`define eqcombit

module eqcombit ( A1 , A2, B1, B2, EQ1, EQ2 )/* synthesis black_box */;

input A1, A2, B1, B2;
output EQ1, EQ2;

wire N_11;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(B1) , .BA2(GND) , .BAB(N_11) , .BAS1(GND) , .BAS2(GND),
                       .BB1(EQ2) , .BB2(EQ2) , .BBS1(GND) , .BBS2(GND) , .BSL(A1),
                       .CZ(EQ1) , .F1(A1) , .F2(GND) , .FS(B1) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(GND) , .TAB(A2) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(B2) , .TZ(EQ2), .QZ() );


endmodule /* eqcombit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : muxb2dx0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef muxb2dx0
`else
`define muxb2dx0

module muxb2dx0 ( A , B, C, D, S, Q, R, T )/* synthesis black_box */;

input A, B, C, D;
output Q, R;
input S;
output T;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(C) , .BA2(D) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(T),
                       .CZ(R) , .F1(GND) , .F2(VCC) , .FS(S) , .FZ(T) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(T) , .TZ(Q), .QZ() );


endmodule /* muxb2dx0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnfxbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnfxbit
`else
`define dnfxbit

module dnfxbit ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENG, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire N_18;
wire N_16;
wire N_17;
supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(N_18) , .BA2(N_18) , .BAB(LOAD) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(D) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(Q) , .F1(N_17),
                       .F2(GND) , .FS(Q0) , .FZ(N_16) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(N_16) , .TAS1(GND),
                       .TAS2(GND) , .TB1(Q2) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_18), .CZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(ENP) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(ENG) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(ENT) , .TZ(N_17), .CZ(), .FZ(), .QZ() );


endmodule /* dnfxbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnflbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnflbit
`else
`define dnflbit

module dnflbit ( CLK , CLR, D, ENP, ENT, LOAD, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, ENP, ENT, LOAD;
output Q;
input Q0, Q1, Q2;

wire N_11;
supply0 GND;
supply1 VCC;
wire N_14;


logic_cell_macro I1  ( .BA1(Q) , .BA2(D) , .BAB(N_11) , .BAS1(GND) , .BAS2(GND),
                       .BB1(Q) , .BB2(D) , .BBS1(VCC) , .BBS2(GND) , .BSL(LOAD),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(N_14) , .TAS1(GND),
                       .TAS2(GND) , .TB1(Q2) , .TB2(GND) , .TBS(VCC) , .TBS1(VCC),
                       .TBS2(GND) , .TSL(Q1) , .TZ(N_11), .CZ(), .FZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(ENP) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q0) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(ENT) , .TZ(N_14), .CZ(), .FZ(), .QZ() );


endmodule /* dnflbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnfecar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnfecar3
`else
`define dnfecar3

module dnfecar3 ( CLK , CLR, ENG, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;

wire N_16;
wire N_17;
supply1 VCC;
supply0 GND;
wire N_13;
wire N_14;
wire N_15;


dffp I1  ( .CLK(CLK) , .D(N_15) , .PRE(CLR) , .Q(ACO3) );

dffp I2  ( .CLK(CLK) , .D(N_14) , .PRE(CLR) , .Q(ACO2) );

dffp I3  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO1) );

mux4x1 I4  ( .A(N_17) , .B(GND) , .C(N_17) , .D(GND) , .Q(N_15) , .S0(N_16) , .S1(ENG) );

mux4x1 I5  ( .A(N_17) , .B(GND) , .C(N_17) , .D(GND) , .Q(N_14) , .S0(N_16) , .S1(ENG) );

mux4x1 I6  ( .A(N_17) , .B(GND) , .C(N_17) , .D(GND) , .Q(N_13) , .S0(N_16) , .S1(ENG) );

dnfebit I7  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_16),
              .Q0(N_17) , .Q1(GND) , .Q2(GND) );

dnfebit I8  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_17),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dnfecar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnfecar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnfecar2
`else
`define dnfecar2

module dnfecar2 ( CLK , CLR, ENG, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;

wire N_13;
wire N_14;
supply1 VCC;
supply0 GND;
wire N_11;
wire N_12;


dnfebit I1  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_13),
              .Q0(N_14) , .Q1(GND) , .Q2(GND) );

dnfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_14),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );

dffp I3  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I4  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x1 I5  ( .A(N_14) , .B(GND) , .C(N_14) , .D(GND) , .Q(N_12) , .S0(N_13) , .S1(ENG) );

mux4x1 I6  ( .A(N_14) , .B(GND) , .C(N_14) , .D(GND) , .Q(N_11) , .S0(N_13) , .S1(ENG) );


endmodule /* dnfecar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnfecar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnfecar1
`else
`define dnfecar1

module dnfecar1 ( CLK , CLR, ENG, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;
input [0:3] Q;wire N_15;
wire N_16;
supply1 VCC;
supply0 GND;
wire N_13;
wire N_14;


and3i3 I1  ( .A(N_15) , .B(Q[2]) , .C(Q[3]) , .Q(N_14) );

dffp I2  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO1) );

mux4x2 I3  ( .A(GND) , .B(N_16) , .C(GND) , .D(N_16) , .Q(N_13) , .S0(N_14) , .S1(ENG) );

dnfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_15),
              .Q0(N_16) , .Q1(GND) , .Q2(GND) );

dnfebit I5  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_16),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dnfecar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dnfebit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dnfebit
`else
`define dnfebit

module dnfebit ( CLK , CLR, ENG, ENP, ENT, Q0, Q1, Q2, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output Q;
input Q0, Q1, Q2;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(ENP) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(ENG) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(ENT) , .TZ(N_11), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(Q) , .BAS1(GND) , .BAS2(GND),
                       .BB1(VCC) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(Q0),
                       .F1(N_11) , .F2(GND) , .FS(Q2) , .FZ(N_12) , .QCK(CLK),
                       .QCKS(VCC) , .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR),
                       .QST(GND) , .QZ(Q) , .TA1(GND) , .TA2(VCC) , .TAB(N_12),
                       .TAS1(GND) , .TAS2(GND) , .TB1(Q0) , .TB2(Q0) , .TBS(Q1),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Q), .CZ(), .TZ() );


endmodule /* dnfebit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dif16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dif16
`else
`define dif16

module dif16 ( a , b, Bin, C11_C70, C11_C71, C7_C30, C7_C31, Co0_Ci0, Co0_Ci1,
              Co10_C90, Co10_C91, Co12_C110, Co12_C111, Co13_C120, Co13_C121,
              Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10, Co2_C11,
              Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50,
              Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81, D, Borrow3, Diffi );

input [0:0] a;
input [0:0] b;
input Bin;
output Borrow3;
input C11_C70, C11_C71, C7_C30, C7_C31, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91,Co12_C110, Co12_C111, Co13_C120, Co13_C121, Co14_C130, Co14_C131,Co1_C00, Co1_C01, Co2_C10, Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31,Co5_C40, Co5_C41, Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
input [15:0] D;
output [15:0] Diffi;wire Borrow_0;
wire Borrow3a;
supply0 GND;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;


borrow0 I32  ( .A(a[0]) , .B(b[0]) , .Bin(Bin) , .Bout(Borrow_0) );

cary_gen I1  ( .C_i(Borrow_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
               .Ck_j1(Co2_C11) , .Cm_i(Borrow3a) , .Cm_k0(Co3_C20) , .Cm_k1(Co3_C21) );

cary_gen I2  ( .C_i(Borrow_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
               .Ck_j1(Co2_C11) , .Cm_i(Borrow3) , .Cm_k0(Co3_C20) , .Cm_k1(Co3_C21) );

sum2_gen I4  ( .C_i(GND) , .Cj_i0(Borrow3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_0(N_17) , .Sk_1(N_18) , .Sk_i(Diffi[10]) );

sum2_gen I3  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Borrow3) , .Ck_j1(GND),
               .Sk_0(N_15) , .Sk_1(N_16) , .Sk_i(Diffi[7]) );

sum2_gen I5  ( .C_i(GND) , .Cj_i0(Borrow3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_0(N_19) , .Sk_1(N_11) , .Sk_i(Diffi[11]) );

sum2_gen I8  ( .C_i(Borrow3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_22) , .Sk_1(N_14) , .Sk_i(Diffi[15]) );

sum2_gen I7  ( .C_i(Borrow3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_20) , .Sk_1(N_13) , .Sk_i(Diffi[14]) );

sum2_gen I6  ( .C_i(Borrow3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_0(N_21) , .Sk_1(N_12) , .Sk_i(Diffi[13]) );

sum_gen I16  ( .C_i(GND) , .Cj_i0(Co8_C71) , .Cj_i1(GND) , .Ck_j0(Co9_C80),
               .Ck_j1(Co9_C81) , .Sk_01(D[10]) , .Sk_i(N_18) );

sum_gen I17  ( .C_i(GND) , .Cj_i0(Co8_C70) , .Cj_i1(GND) , .Ck_j0(Co9_C80),
               .Ck_j1(Co9_C81) , .Sk_01(D[10]) , .Sk_i(N_17) );

sum_gen I18  ( .C_i(Borrow3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(Co8_C70),
               .Ck_j1(Co8_C71) , .Sk_01(D[9]) , .Sk_i(Diffi[9]) );

sum_gen I19  ( .C_i(GND) , .Cj_i0(Borrow3a) , .Cj_i1(GND) , .Ck_j0(C7_C30),
               .Ck_j1(C7_C31) , .Sk_01(D[8]) , .Sk_i(Diffi[8]) );

sum_gen I27  ( .C_i(Borrow_0) , .Cj_i0(Co1_C00) , .Cj_i1(Co1_C01) , .Ck_j0(Co2_C10),
               .Ck_j1(Co2_C11) , .Sk_01(D[3]) , .Sk_i(Diffi[3]) );

sum_gen I28  ( .C_i(Bin) , .Cj_i0(Co0_Ci1) , .Cj_i1(Co0_Ci0) , .Ck_j0(Co1_C00),
               .Ck_j1(Co1_C01) , .Sk_01(D[2]) , .Sk_i(Diffi[2]) );

sum_gen I29  ( .C_i(GND) , .Cj_i0(Bin) , .Cj_i1(GND) , .Ck_j0(Co0_Ci1),
               .Ck_j1(Co0_Ci0) , .Sk_01(D[1]) , .Sk_i(Diffi[1]) );

sum_gen I26  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Borrow3) , .Ck_j1(GND),
               .Sk_01(D[4]) , .Sk_i(Diffi[4]) );

sum_gen I25  ( .C_i(GND) , .Cj_i0(Borrow3) , .Cj_i1(GND) , .Ck_j0(Co4_C30),
               .Ck_j1(Co4_C31) , .Sk_01(D[5]) , .Sk_i(Diffi[5]) );

sum_gen I24  ( .C_i(Borrow3) , .Cj_i0(Co4_C30) , .Cj_i1(Co4_C31) , .Ck_j0(Co5_C40),
               .Ck_j1(Co5_C41) , .Sk_01(D[6]) , .Sk_i(Diffi[6]) );

sum_gen I22  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Sk_01(D[7]) , .Sk_i(N_16) );

sum_gen I23  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Sk_01(D[7]) , .Sk_i(N_15) );

sum_gen I20  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Sk_01(D[11]) , .Sk_i(N_19) );

sum_gen I21  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Sk_01(D[11]) , .Sk_i(N_11) );

sum_gen I9  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
              .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Sk_01(D[15]) , .Sk_i(N_14) );

sum_gen I10  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Sk_01(D[15]) , .Sk_i(N_22) );

sum_gen I11  ( .C_i(GND) , .Cj_i0(Co12_C111) , .Cj_i1(GND) , .Ck_j0(Co13_C120),
               .Ck_j1(Co13_C121) , .Sk_01(D[14]) , .Sk_i(N_13) );

sum_gen I12  ( .C_i(GND) , .Cj_i0(Co12_C110) , .Cj_i1(GND) , .Ck_j0(Co13_C120),
               .Ck_j1(Co13_C121) , .Sk_01(D[14]) , .Sk_i(N_20) );

sum_gen I13  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Co12_C111) , .Ck_j1(GND),
               .Sk_01(D[13]) , .Sk_i(N_12) );

sum_gen I14  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Co12_C110) , .Ck_j1(GND),
               .Sk_01(D[13]) , .Sk_i(N_21) );

sum_gen I15  ( .C_i(Borrow3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Sk_01(D[12]) , .Sk_i(Diffi[12]) );

dif0 I31  ( .A(a[0]) , .B(b[0]) , .Bin(Bin) , .d0(Diffi[0]) );


endmodule /* dif16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dif0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dif0
`else
`define dif0

module dif0 ( A , B, Bin, d0 )/* synthesis black_box */;

input A, B, Bin;
output d0;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(A) , .BA2(A) , .BAB(GND) , .BAS1(VCC) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(d0) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(A) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(Bin) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B), .FZ(), .QZ(), .TZ() );


endmodule /* dif0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dif_b0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dif_b0
`else
`define dif_b0

module dif_b0 ( Ax , Bx, Bo_Bi0, Bo_Bi1 )/* synthesis black_box */;

input Ax;
output Bo_Bi0, Bo_Bi1;
input Bx;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Ax) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Bx),
                       .CZ(Bo_Bi0) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(Ax) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(Bx) , .TZ(Bo_Bi1), .FZ(), .QZ() );


endmodule /* dif_b0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dif_b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dif_b
`else
`define dif_b

module dif_b ( Ax , Bx, Bo_Bi0, Bo_Bi1, Sub_Dif )/* synthesis black_box */;

input Ax;
output Bo_Bi0, Bo_Bi1;
input Bx;
output Sub_Dif;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Bx) , .BA2(Bx) , .BAB(GND) , .BAS1(VCC) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Ax),
                       .CZ(Sub_Dif) , .F1(Ax) , .F2(GND) , .FS(Bx) , .FZ(Bo_Bi0),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(VCC) , .TA2(Ax) , .TAB(GND),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Bx) , .TZ(Bo_Bi1), .QZ() );


endmodule /* dif_b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctxcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctxcar3
`else
`define dctxcar3

module dctxcar3 ( CLK , CLR, D, ENG, LOAD, Q, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [1:0] D;
input ENG, LOAD;
input [1:0] Q;wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;


and2i1 I1  ( .A(Q[0]) , .B(Q[1]) , .Q(N_14) );

dffp I5  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO3) );

dffp I6  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO2) );

dffp I2  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I7  ( .A(ACO3) , .B(N_14) , .C(N_15) , .D(N_15) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

mux4x0 I8  ( .A(ACO2) , .B(N_14) , .C(N_15) , .D(N_15) , .Q(N_12) , .S0(ENG) , .S1(LOAD) );

mux4x0 I3  ( .A(ACO1) , .B(N_14) , .C(N_15) , .D(N_15) , .Q(N_13) , .S0(ENG) , .S1(LOAD) );

and2i2 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_15) );


endmodule /* dctxcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctxcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctxcar2
`else
`define dctxcar2

module dctxcar2 ( CLK , CLR, D, ENG, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [1:0] D;
input ENG, LOAD;

wire N_17;
wire N_18;
supply0 GND;
supply1 VCC;
wire N_13;
wire N_14;
wire N_15;
wire N_16;


dnfxbit I6  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(N_17) , .Q0(N_18) , .Q1(GND) , .Q2(GND) );

dnfxbit I9  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(N_18) , .Q0(GND) , .Q1(GND) , .Q2(GND) );

and2i1 I1  ( .A(N_18) , .B(N_17) , .Q(N_15) );

dffp I7  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO2) );

dffp I2  ( .CLK(CLK) , .D(N_14) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I8  ( .A(ACO2) , .B(N_15) , .C(N_16) , .D(N_16) , .Q(N_13) , .S0(ENG) , .S1(LOAD) );

mux4x0 I3  ( .A(ACO1) , .B(N_15) , .C(N_16) , .D(N_16) , .Q(N_14) , .S0(ENG) , .S1(LOAD) );

and2i2 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_16) );


endmodule /* dctxcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctxcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctxcar1
`else
`define dctxcar1

module dctxcar1 ( CLK , CLR, D, ENG, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [1:0] D;
input ENG, LOAD;
input [1:0] Q;wire N_11;
wire N_12;
wire N_13;


and2i1 I1  ( .A(Q[0]) , .B(Q[1]) , .Q(N_13) );

dffp I2  ( .CLK(CLK) , .D(N_11) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I3  ( .A(ACO1) , .B(N_13) , .C(N_12) , .D(N_12) , .Q(N_11) , .S0(ENG) , .S1(LOAD) );

and2i2 I4  ( .A(D[0]) , .B(D[1]) , .Q(N_12) );


endmodule /* dctxcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctlcar3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctlcar3
`else
`define dctlcar3

module dctlcar3 ( CLK , CLR, D, LOAD, ACO1, ACO2, ACO3 )/* synthesis black_box */;

output ACO1, ACO2, ACO3;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [1:0] D;
input LOAD;

wire N_23;
wire N_24;
supply1 VCC;
supply0 GND;
wire N_12;
wire N_13;
wire N_14;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;


and3i2 I16  ( .A(N_24) , .B(N_23) , .C(LOAD) , .Q(N_18) );

and3i2 I17  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .Q(N_21) );

and3i2 I9  ( .A(N_24) , .B(N_23) , .C(LOAD) , .Q(N_17) );

and3i2 I10  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .Q(N_20) );

and3i2 I11  ( .A(N_24) , .B(N_23) , .C(LOAD) , .Q(N_16) );

and3i2 I12  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .Q(N_19) );

dnflbit I20  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
               .Q(N_23) , .Q0(N_24) , .Q1(GND) , .Q2(GND) );

dnflbit I7  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(N_24) , .Q0(GND) , .Q1(GND) , .Q2(GND) );

dffp I18  ( .CLK(CLK) , .D(N_14) , .PRE(CLR) , .Q(ACO3) );

dffp I13  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO2) );

dffp I2  ( .CLK(CLK) , .D(N_12) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I19  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(N_14) , .S0(N_18) , .S1(N_21) );

mux4x0 I14  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(N_13) , .S0(N_17) , .S1(N_20) );

mux4x0 I15  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(N_12) , .S0(N_16) , .S1(N_19) );


endmodule /* dctlcar3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctlcar2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctlcar2
`else
`define dctlcar2

module dctlcar2 ( CLK , CLR, D, LOAD, ACO1, ACO2 )/* synthesis black_box */;

output ACO1, ACO2;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [1:0] D;
input LOAD;

wire N_21;
wire N_22;
supply0 GND;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
supply1 VCC;


and3i2 I9  ( .A(N_22) , .B(N_21) , .C(LOAD) , .Q(N_16) );

and3i2 I10  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .Q(N_17) );

and3i2 I11  ( .A(N_22) , .B(N_21) , .C(LOAD) , .Q(N_19) );

and3i2 I12  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .Q(N_20) );

dnflbit I7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(N_21) , .Q0(N_22) , .Q1(GND) , .Q2(GND) );

dnflbit I8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(N_22) , .Q0(GND) , .Q1(GND) , .Q2(GND) );

dffp I13  ( .CLK(CLK) , .D(N_15) , .PRE(CLR) , .Q(ACO2) );

dffp I2  ( .CLK(CLK) , .D(N_18) , .PRE(CLR) , .Q(ACO1) );

mux4x0 I14  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(N_15) , .S0(N_16) , .S1(N_17) );

mux4x0 I15  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(N_18) , .S0(N_19) , .S1(N_20) );


endmodule /* dctlcar2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctlcar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctlcar1
`else
`define dctlcar1

module dctlcar1 ( CLK , CLR, D, LOAD, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input LOAD;
input [3:0] Q;wire N_14;
wire N_15;
supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_13;


mux4x6 I4  ( .A(GND) , .B(Q[3]) , .C(D[3]) , .D(GND) , .Q(N_13) , .S0(N_12) , .S1(N_11) );

and4i3 I5  ( .A(N_15) , .B(LOAD) , .C(Q[2]) , .D(N_14) , .Q(N_12) );

and4i3 I6  ( .A(LOAD) , .B(D[0]) , .C(D[1]) , .D(D[2]) , .Q(N_11) );

dnflbit I7  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(N_14) , .Q0(N_15) , .Q1(GND) , .Q2(GND) );

dnflbit I8  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(N_15) , .Q0(GND) , .Q1(GND) , .Q2(GND) );

dffp I2  ( .CLK(CLK) , .D(N_13) , .PRE(CLR) , .Q(ACO1) );


endmodule /* dctlcar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dctecar1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dctecar1
`else
`define dctecar1

module dctecar1 ( CLK , CLR, ENG, Q, ACO1 )/* synthesis black_box */;

output ACO1;
input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;
input [3:0] Q;wire N_29;
wire N_30;
supply1 VCC;
supply0 GND;
wire N_17;
wire N_28;


and3i3 I1  ( .A(N_29) , .B(Q[2]) , .C(Q[3]) , .Q(N_17) );

mux4x2 I2  ( .A(GND) , .B(N_30) , .C(GND) , .D(N_30) , .Q(N_28) , .S0(N_17) , .S1(ENG) );

dffp I3  ( .CLK(CLK) , .D(N_28) , .PRE(CLR) , .Q(ACO1) );

dnfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_29),
              .Q0(N_30) , .Q1(GND) , .Q2(GND) );

dnfebit I5  ( .CLK(CLK) , .CLR(CLR) , .ENG(VCC) , .ENP(ENG) , .ENT(VCC) , .Q(N_30),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dctecar1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx4c
`else
`define dcntx4c

module dcntx4c ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input ENG, ENP, ENT, LOAD;
output [3:0] Q;supply0 GND;


dnfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfxbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntx4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx4b
`else
`define dcntx4b

module dcntx4b ( CLK , CLR, D, ENG, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input ENG, ENP, ENT, LOAD;
output [3:0] Q;
output RCO;

supply0 GND;


and5i4 I6  ( .A(ENT) , .B(Q[0]) , .C(Q[1]) , .D(Q[2]) , .E(Q[3]) , .Q(RCO) );

dnfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfxbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntx4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntx4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntx4a
`else
`define dcntx4a

module dcntx4a ( CLK , CLR, D, ENG, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input ENG, LOAD;
output [3:0] Q;
output RCO;

supply0 GND;
supply1 VCC;


and2i2 I1  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );

dnfxbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfxbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfxbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfxbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC),
              .LOAD(LOAD) , .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntx4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl4c
`else
`define dcntl4c

module dcntl4c ( CLK , CLR, D, ENP, ENT, LOAD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input ENP, ENT, LOAD;
output [3:0] Q;supply0 GND;


dnflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnflbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntl4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl4b
`else
`define dcntl4b

module dcntl4b ( CLK , CLR, D, ENP, ENT, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input ENP, ENT, LOAD;
output [3:0] Q;
output RCO;

supply0 GND;


and5i4 I6  ( .A(ENT) , .B(Q[0]) , .C(Q[1]) , .D(Q[2]) , .E(Q[3]) , .Q(RCO) );

dnflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnflbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(ENP) , .ENT(ENT) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntl4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcntl4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcntl4a
`else
`define dcntl4a

module dcntl4a ( CLK , CLR, D, LOAD, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR;
input [3:0] D;
input LOAD;
output [3:0] Q;
output RCO;

supply0 GND;
supply1 VCC;


and2i2 I1  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );

dnflbit I2  ( .CLK(CLK) , .CLR(CLR) , .D(D[3]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(Q[3]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnflbit I3  ( .CLK(CLK) , .CLR(CLR) , .D(D[2]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(Q[2]) , .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnflbit I4  ( .CLK(CLK) , .CLR(CLR) , .D(D[1]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(Q[1]) , .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnflbit I5  ( .CLK(CLK) , .CLR(CLR) , .D(D[0]) , .ENP(VCC) , .ENT(VCC) , .LOAD(LOAD),
              .Q(Q[0]) , .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcntl4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte4c 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte4c
`else
`define dcnte4c

module dcnte4c ( CLK , CLR, ENG, ENP, ENT, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output [3:0] Q;supply0 GND;


dnfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfebit I5  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[0]),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcnte4c */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte4b 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte4b
`else
`define dcnte4b

module dcnte4b ( CLK , CLR, ENG, ENP, ENT, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG, ENP, ENT;
output [3:0] Q;
output RCO;

supply0 GND;


and5i4 I6  ( .A(ENT) , .B(Q[0]) , .C(Q[1]) , .D(Q[2]) , .E(Q[3]) , .Q(RCO) );

dnfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfebit I5  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(ENP) , .ENT(ENT) , .Q(Q[0]),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcnte4b */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dcnte4a 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dcnte4a
`else
`define dcnte4a

module dcnte4a ( CLK , CLR, ENG, Q, RCO )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, ENG;
output [3:0] Q;
output RCO;

supply0 GND;
supply1 VCC;


and2i2 I1  ( .A(Q[2]) , .B(Q[3]) , .Q(RCO) );

dnfebit I2  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC) , .Q(Q[3]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(Q[2]) );

dnfebit I3  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC) , .Q(Q[2]),
              .Q0(Q[0]) , .Q1(Q[1]) , .Q2(GND) );

dnfebit I4  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC) , .Q(Q[1]),
              .Q0(Q[0]) , .Q1(GND) , .Q2(GND) );

dnfebit I5  ( .CLK(CLK) , .CLR(CLR) , .ENG(ENG) , .ENP(VCC) , .ENT(VCC) , .Q(Q[0]),
              .Q0(GND) , .Q1(GND) , .Q2(GND) );


endmodule /* dcnte4a */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csbbita 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csbbita
`else
`define csbbita

module csbbita ( A , B, C0, C1, S0 )/* synthesis black_box */;

input A, B;
output C0, C1, S0;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(B) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(A),
                       .CZ(C1) , .F1(A) , .F2(GND) , .FS(B) , .FZ(C0) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(GND) , .TAB(B) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(S0), .QZ() );


endmodule /* csbbita */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csamuxc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csamuxc
`else
`define csamuxc

module csamuxc ( A , B, S00, S01, S1, Q )/* synthesis black_box */;

input A, B;
output Q;
input S00, S01, S1;

wire N_11;


and2i1 I1  ( .A(S1) , .B(S01) , .Q(N_11) );

mux4xe I2  ( .A(A) , .B(B) , .C(B) , .D(B) , .Q(Q) , .S0(N_11) , .S1(S00) );


endmodule /* csamuxc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csamuxb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csamuxb
`else
`define csamuxb

module csamuxb ( A , B, S00, S01, S1, Q )/* synthesis black_box */;

input A, B;
output Q;
input S00, S01, S1;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(S01) , .FS(S1) , .FZ(N_11) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(A) , .TA2(B) , .TAB(S00) , .TAS1(GND),
                       .TAS2(GND) , .TB1(B) , .TB2(B) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_11) , .TZ(Q), .CZ(), .QZ() );


endmodule /* csamuxb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csamuxa 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csamuxa
`else
`define csamuxa

module csamuxa ( A , S00, S01, S1, Q )/* synthesis black_box */;

input A;
output Q;
input S00, S01, S1;



mux4xa I1  ( .A(S00) , .B(S00) , .C(S01) , .D(S01) , .Q(Q) , .S0(A) , .S1(S1) );


endmodule /* csamuxa */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csalow 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csalow
`else
`define csalow

module csalow ( A0 , A1, B0, B1, A1T, C0, C1 )/* synthesis black_box */;

input A0, A1;
output A1T;
input B0, B1;
output C0, C1;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(B1) , .BAB(C0) , .BAS1(GND) , .BAS2(GND),
                       .BB1(B1) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(A1),
                       .CZ(C1) , .F1(GND) , .F2(VCC) , .FS(A1) , .FZ(A1T) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(B0) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A0) , .TZ(C0), .QZ() );


endmodule /* csalow */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csabitb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csabitb
`else
`define csabitb

module csabitb ( A , B, C0, C1, S0 )/* synthesis black_box */;

input A, B;
output C0, C1, S0;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(C1) , .F1(GND) , .F2(B) , .FS(A) , .FZ(C0) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(VCC) , .TA2(GND) , .TAB(C0) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(C1) , .TZ(S0), .QZ() );


endmodule /* csabitb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csabita 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csabita
`else
`define csabita

module csabita ( A , B, C0, C1, S0 )/* synthesis black_box */;

input A, B;
output C0, C1, S0;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(VCC) , .BA2(GND) , .BAB(A) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(B),
                       .CZ(C1) , .F1(GND) , .F2(B) , .FS(A) , .FZ(C0) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(GND) , .TA2(VCC) , .TAB(B) , .TAS1(GND),
                       .TAS2(GND) , .TB1(VCC) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(A) , .TZ(S0), .QZ() );


endmodule /* csabita */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : cary_gen 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef cary_gen
`else
`define cary_gen

module cary_gen ( C_i , Cj_i0, Cj_i1, Ck_j0, Ck_j1, Cm_k0, Cm_k1, Cm_i )/* synthesis black_box */;

input C_i, Cj_i0, Cj_i1, Ck_j0, Ck_j1;
output Cm_i;
input Cm_k0, Cm_k1;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(Cm_k0) , .BA2(Cm_k1) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(Ck_j1),
                       .CZ(Cm_i) , .F1(Cj_i0) , .F2(Cj_i1) , .FS(C_i) , .FZ(N_11),
                       .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND),
                       .QRT(GND) , .QST(GND) , .TA1(Cm_k0) , .TA2(Cm_k1) , .TAB(GND),
                       .TAS1(GND) , .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(N_11),
                       .TBS1(GND) , .TBS2(GND) , .TSL(Ck_j0), .QZ(), .TZ() );


endmodule /* cary_gen */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : carry32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef carry32
`else
`define carry32

module carry32 ( a , b, Carry3, Carry3a, C11_C70, C11_C71, C19_C150, C19_C151,
                C23_C190, C23_C191, C27_C230, C27_C231, C7_C30, C7_C31,
                Carry15, Carry15a, Carry15b, Co, Co0_Ci0, Co0_Ci1, Co10_C90,
                Co10_C91, Co12_C110, Co12_C111, Co13_C120, Co13_C121,
                Co14_C130, Co14_C131, Co16_C150, Co16_C151, Co17_C160,
                Co17_C161, Co18_C170, Co18_C171, Co1_C00, Co1_C01, Co20_C190,
                Co20_C191, Co21_C200, Co21_C201, Co22_C210, Co22_C211,
                Co24_C230, Co24_C231, Co25_C240, Co25_C241, Co26_C250,
                Co26_C251, Co28_C270, Co28_C271, Co29_C280, Co29_C281,
                Co2_C10, Co2_C11, Co30_C290, Co30_C291, Co3_C20, Co3_C21,
                Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50, Co6_C51, Co8_C70,
                Co8_C71, Co9_C80, Co9_C81, S );

input [31:0] a;
input [31:0] b;
output C11_C70, C11_C71, C19_C150, C19_C151, C23_C190, C23_C191, C27_C230,C27_C231, C7_C30, C7_C31, Carry15, Carry15a, Carry15b;
input Carry3, Carry3a;
output Co, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111,Co13_C120, Co13_C121, Co14_C130, Co14_C131, Co16_C150, Co16_C151,Co17_C160, Co17_C161, Co18_C170, Co18_C171, Co1_C00, Co1_C01,Co20_C190, Co20_C191, Co21_C200, Co21_C201, Co22_C210, Co22_C211,Co24_C230, Co24_C231, Co25_C240, Co25_C241, Co26_C250, Co26_C251,Co28_C270, Co28_C271, Co29_C280, Co29_C281, Co2_C10, Co2_C11,Co30_C290, Co30_C291, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40,Co5_C41, Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
output [31:0] S;wire Co19_C180;
wire Co19_C181;
wire Co7_C60;
wire Co23_C220;
wire Co7_C61;
wire Co23_C221;
wire Co11_C100;
wire Co27_C260;
wire Co11_C101;
wire Co27_C261;
wire C15_C110;
wire C31_C160;
supply0 GND;
wire C15_C111;
wire C31_C161;
wire Co15_C140;
wire Co31_C300;
wire C31_C270;
wire Co15_C141;
wire Co31_C301;
wire C31_C271;


cary_gen I2  ( .C_i(C19_C151) , .Cj_i0(C23_C190) , .Cj_i1(C23_C191),
               .Ck_j0(C27_C230) , .Ck_j1(C27_C231) , .Cm_i(C31_C161),
               .Cm_k0(C31_C270) , .Cm_k1(C31_C271) );

cary_gen I1  ( .C_i(GND) , .Cj_i0(GND) , .Cj_i1(GND) , .Ck_j0(Carry15) , .Ck_j1(GND),
               .Cm_i(Co) , .Cm_k0(C31_C160) , .Cm_k1(C31_C161) );

cary_gen I3  ( .C_i(C19_C150) , .Cj_i0(C23_C190) , .Cj_i1(C23_C191),
               .Ck_j0(C27_C230) , .Ck_j1(C27_C231) , .Cm_i(C31_C160),
               .Cm_k0(C31_C270) , .Cm_k1(C31_C271) );

cary_gen I4  ( .C_i(Carry3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15b) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I5  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15a) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I6  ( .C_i(Carry3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I9  ( .C_i(Co28_C271) , .Cj_i0(Co29_C280) , .Cj_i1(Co29_C281),
               .Ck_j0(Co30_C290) , .Ck_j1(Co30_C291) , .Cm_i(C31_C271),
               .Cm_k0(Co31_C300) , .Cm_k1(Co31_C301) );

cary_gen I10  ( .C_i(Co28_C270) , .Cj_i0(Co29_C280) , .Cj_i1(Co29_C281),
                .Ck_j0(Co30_C290) , .Ck_j1(Co30_C291) , .Cm_i(C31_C270),
                .Cm_k0(Co31_C300) , .Cm_k1(Co31_C301) );

cary_gen I13  ( .C_i(Co24_C231) , .Cj_i0(Co25_C240) , .Cj_i1(Co25_C241),
                .Ck_j0(Co26_C250) , .Ck_j1(Co26_C251) , .Cm_i(C27_C231),
                .Cm_k0(Co27_C260) , .Cm_k1(Co27_C261) );

cary_gen I14  ( .C_i(Co24_C230) , .Cj_i0(Co25_C240) , .Cj_i1(Co25_C241),
                .Ck_j0(Co26_C250) , .Ck_j1(Co26_C251) , .Cm_i(C27_C230),
                .Cm_k0(Co27_C260) , .Cm_k1(Co27_C261) );

cary_gen I11  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
                .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C111),
                .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I12  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
                .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C110),
                .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I17  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
                .Ck_j1(Co10_C91) , .Cm_i(C11_C71) , .Cm_k0(Co11_C100),
                .Cm_k1(Co11_C101) );

cary_gen I18  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
                .Ck_j1(Co10_C91) , .Cm_i(C11_C70) , .Cm_k0(Co11_C100),
                .Cm_k1(Co11_C101) );

cary_gen I15  ( .C_i(Co20_C191) , .Cj_i0(Co21_C200) , .Cj_i1(Co21_C201),
                .Ck_j0(Co22_C210) , .Ck_j1(Co22_C211) , .Cm_i(C23_C191),
                .Cm_k0(Co23_C220) , .Cm_k1(Co23_C221) );

cary_gen I16  ( .C_i(Co20_C190) , .Cj_i0(Co21_C200) , .Cj_i1(Co21_C201),
                .Ck_j0(Co22_C210) , .Ck_j1(Co22_C211) , .Cm_i(C23_C190),
                .Cm_k0(Co23_C220) , .Cm_k1(Co23_C221) );

cary_gen I7  ( .C_i(Co16_C151) , .Cj_i0(Co17_C160) , .Cj_i1(Co17_C161),
               .Ck_j0(Co18_C170) , .Ck_j1(Co18_C171) , .Cm_i(C19_C151),
               .Cm_k0(Co19_C180) , .Cm_k1(Co19_C181) );

cary_gen I8  ( .C_i(Co16_C150) , .Cj_i0(Co17_C160) , .Cj_i1(Co17_C161),
               .Ck_j0(Co18_C170) , .Ck_j1(Co18_C171) , .Cm_i(C19_C150),
               .Cm_k0(Co19_C180) , .Cm_k1(Co19_C181) );

cary_gen I19  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
                .Ck_j1(Co6_C51) , .Cm_i(C7_C31) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

cary_gen I20  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
                .Ck_j1(Co6_C51) , .Cm_i(C7_C30) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

sum_c I36  ( .Ax(a[31]) , .Bx(b[31]) , .Co_Ci0(Co31_C300) , .Co_Ci1(Co31_C301),
             .Sub_Sum(S[31]) );

sum_c I35  ( .Ax(a[30]) , .Bx(b[30]) , .Co_Ci0(Co30_C290) , .Co_Ci1(Co30_C291),
             .Sub_Sum(S[30]) );

sum_c I34  ( .Ax(a[29]) , .Bx(b[29]) , .Co_Ci0(Co29_C280) , .Co_Ci1(Co29_C281),
             .Sub_Sum(S[29]) );

sum_c I33  ( .Ax(a[28]) , .Bx(b[28]) , .Co_Ci0(Co28_C270) , .Co_Ci1(Co28_C271),
             .Sub_Sum(S[28]) );

sum_c I32  ( .Ax(a[27]) , .Bx(b[27]) , .Co_Ci0(Co27_C260) , .Co_Ci1(Co27_C261),
             .Sub_Sum(S[27]) );

sum_c I31  ( .Ax(a[26]) , .Bx(b[26]) , .Co_Ci0(Co26_C250) , .Co_Ci1(Co26_C251),
             .Sub_Sum(S[26]) );

sum_c I30  ( .Ax(a[25]) , .Bx(b[25]) , .Co_Ci0(Co25_C240) , .Co_Ci1(Co25_C241),
             .Sub_Sum(S[25]) );

sum_c I29  ( .Ax(a[24]) , .Bx(b[24]) , .Co_Ci0(Co24_C230) , .Co_Ci1(Co24_C231),
             .Sub_Sum(S[24]) );

sum_c I37  ( .Ax(a[15]) , .Bx(b[15]) , .Co_Ci0(Co15_C140) , .Co_Ci1(Co15_C141),
             .Sub_Sum(S[15]) );

sum_c I38  ( .Ax(a[14]) , .Bx(b[14]) , .Co_Ci0(Co14_C130) , .Co_Ci1(Co14_C131),
             .Sub_Sum(S[14]) );

sum_c I39  ( .Ax(a[13]) , .Bx(b[13]) , .Co_Ci0(Co13_C120) , .Co_Ci1(Co13_C121),
             .Sub_Sum(S[13]) );

sum_c I40  ( .Ax(a[12]) , .Bx(b[12]) , .Co_Ci0(Co12_C110) , .Co_Ci1(Co12_C111),
             .Sub_Sum(S[12]) );

sum_c I41  ( .Ax(a[11]) , .Bx(b[11]) , .Co_Ci0(Co11_C100) , .Co_Ci1(Co11_C101),
             .Sub_Sum(S[11]) );

sum_c I42  ( .Ax(a[10]) , .Bx(b[10]) , .Co_Ci0(Co10_C90) , .Co_Ci1(Co10_C91),
             .Sub_Sum(S[10]) );

sum_c I43  ( .Ax(a[9]) , .Bx(b[9]) , .Co_Ci0(Co9_C80) , .Co_Ci1(Co9_C81),
             .Sub_Sum(S[9]) );

sum_c I44  ( .Ax(a[8]) , .Bx(b[8]) , .Co_Ci0(Co8_C70) , .Co_Ci1(Co8_C71),
             .Sub_Sum(S[8]) );

sum_c I25  ( .Ax(a[23]) , .Bx(b[23]) , .Co_Ci0(Co23_C220) , .Co_Ci1(Co23_C221),
             .Sub_Sum(S[23]) );

sum_c I26  ( .Ax(a[22]) , .Bx(b[22]) , .Co_Ci0(Co22_C210) , .Co_Ci1(Co22_C211),
             .Sub_Sum(S[22]) );

sum_c I27  ( .Ax(a[21]) , .Bx(b[21]) , .Co_Ci0(Co21_C200) , .Co_Ci1(Co21_C201),
             .Sub_Sum(S[21]) );

sum_c I28  ( .Ax(a[20]) , .Bx(b[20]) , .Co_Ci0(Co20_C190) , .Co_Ci1(Co20_C191),
             .Sub_Sum(S[20]) );

sum_c I21  ( .Ax(a[19]) , .Bx(b[19]) , .Co_Ci0(Co19_C180) , .Co_Ci1(Co19_C181),
             .Sub_Sum(S[19]) );

sum_c I22  ( .Ax(a[18]) , .Bx(b[18]) , .Co_Ci0(Co18_C170) , .Co_Ci1(Co18_C171),
             .Sub_Sum(S[18]) );

sum_c I23  ( .Ax(a[17]) , .Bx(b[17]) , .Co_Ci0(Co17_C160) , .Co_Ci1(Co17_C161),
             .Sub_Sum(S[17]) );

sum_c I24  ( .Ax(a[16]) , .Bx(b[16]) , .Co_Ci0(Co16_C150) , .Co_Ci1(Co16_C151),
             .Sub_Sum(S[16]) );

sum_c I45  ( .Ax(a[7]) , .Bx(b[7]) , .Co_Ci0(Co7_C60) , .Co_Ci1(Co7_C61),
             .Sub_Sum(S[7]) );

sum_c I46  ( .Ax(a[6]) , .Bx(b[6]) , .Co_Ci0(Co6_C50) , .Co_Ci1(Co6_C51),
             .Sub_Sum(S[6]) );

sum_c I47  ( .Ax(a[5]) , .Bx(b[5]) , .Co_Ci0(Co5_C40) , .Co_Ci1(Co5_C41),
             .Sub_Sum(S[5]) );

sum_c I48  ( .Ax(a[4]) , .Bx(b[4]) , .Co_Ci0(Co4_C30) , .Co_Ci1(Co4_C31),
             .Sub_Sum(S[4]) );

sum_c I49  ( .Ax(a[3]) , .Bx(b[3]) , .Co_Ci0(Co3_C20) , .Co_Ci1(Co3_C21),
             .Sub_Sum(S[3]) );

sum_c I50  ( .Ax(a[2]) , .Bx(b[2]) , .Co_Ci0(Co2_C10) , .Co_Ci1(Co2_C11),
             .Sub_Sum(S[2]) );

sum_c I51  ( .Ax(a[1]) , .Bx(b[1]) , .Co_Ci0(Co1_C00) , .Co_Ci1(Co1_C01),
             .Sub_Sum(S[1]) );

sum_c0 I52  ( .Ax(a[0]) , .Bx(b[0]) , .Co_Ci0(Co0_Ci0) , .Co_Ci1(Co0_Ci1) );


endmodule /* carry32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : carry16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef carry16
`else
`define carry16

module carry16 ( a , b, Carry3, C11_C70, C11_C71, C7_C30, C7_C31, Co, Co0_Ci0,
                Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111, Co13_C120,
                Co13_C121, Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10,
                Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40, Co5_C41,
                Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81, S );

input [15:0] a;
input [15:0] b;
output C11_C70, C11_C71, C7_C30, C7_C31;
input Carry3;
output Co, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111,Co13_C120, Co13_C121, Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10,Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50,Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
output [15:0] S;wire Co7_C60;
wire Co7_C61;
wire Co11_C100;
wire Co11_C101;
wire C15_C110;
wire C15_C111;
wire Co15_C140;
wire Co15_C141;


sum_c0 I23  ( .Ax(a[0]) , .Bx(b[0]) , .Co_Ci0(Co0_Ci0) , .Co_Ci1(Co0_Ci1) );

cary_gen I7  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C111),
               .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I6  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C110),
               .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I5  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Cm_i(C11_C71) , .Cm_k0(Co11_C100),
               .Cm_k1(Co11_C101) );

cary_gen I4  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Cm_i(C11_C70) , .Cm_k0(Co11_C100),
               .Cm_k1(Co11_C101) );

cary_gen I3  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Cm_i(C7_C31) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

cary_gen I2  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Cm_i(C7_C30) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

cary_gen I1  ( .C_i(Carry3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Co) , .Cm_k0(C15_C110) , .Cm_k1(C15_C111) );

sum_c I8  ( .Ax(a[15]) , .Bx(b[15]) , .Co_Ci0(Co15_C140) , .Co_Ci1(Co15_C141),
            .Sub_Sum(S[15]) );

sum_c I9  ( .Ax(a[14]) , .Bx(b[14]) , .Co_Ci0(Co14_C130) , .Co_Ci1(Co14_C131),
            .Sub_Sum(S[14]) );

sum_c I10  ( .Ax(a[13]) , .Bx(b[13]) , .Co_Ci0(Co13_C120) , .Co_Ci1(Co13_C121),
             .Sub_Sum(S[13]) );

sum_c I11  ( .Ax(a[12]) , .Bx(b[12]) , .Co_Ci0(Co12_C110) , .Co_Ci1(Co12_C111),
             .Sub_Sum(S[12]) );

sum_c I12  ( .Ax(a[11]) , .Bx(b[11]) , .Co_Ci0(Co11_C100) , .Co_Ci1(Co11_C101),
             .Sub_Sum(S[11]) );

sum_c I13  ( .Ax(a[10]) , .Bx(b[10]) , .Co_Ci0(Co10_C90) , .Co_Ci1(Co10_C91),
             .Sub_Sum(S[10]) );

sum_c I14  ( .Ax(a[9]) , .Bx(b[9]) , .Co_Ci0(Co9_C80) , .Co_Ci1(Co9_C81),
             .Sub_Sum(S[9]) );

sum_c I15  ( .Ax(a[8]) , .Bx(b[8]) , .Co_Ci0(Co8_C70) , .Co_Ci1(Co8_C71),
             .Sub_Sum(S[8]) );

sum_c I16  ( .Ax(a[7]) , .Bx(b[7]) , .Co_Ci0(Co7_C60) , .Co_Ci1(Co7_C61),
             .Sub_Sum(S[7]) );

sum_c I17  ( .Ax(a[6]) , .Bx(b[6]) , .Co_Ci0(Co6_C50) , .Co_Ci1(Co6_C51),
             .Sub_Sum(S[6]) );

sum_c I18  ( .Ax(a[5]) , .Bx(b[5]) , .Co_Ci0(Co5_C40) , .Co_Ci1(Co5_C41),
             .Sub_Sum(S[5]) );

sum_c I19  ( .Ax(a[4]) , .Bx(b[4]) , .Co_Ci0(Co4_C30) , .Co_Ci1(Co4_C31),
             .Sub_Sum(S[4]) );

sum_c I20  ( .Ax(a[3]) , .Bx(b[3]) , .Co_Ci0(Co3_C20) , .Co_Ci1(Co3_C21),
             .Sub_Sum(S[3]) );

sum_c I21  ( .Ax(a[2]) , .Bx(b[2]) , .Co_Ci0(Co2_C10) , .Co_Ci1(Co2_C11),
             .Sub_Sum(S[2]) );

sum_c I22  ( .Ax(a[1]) , .Bx(b[1]) , .Co_Ci0(Co1_C00) , .Co_Ci1(Co1_C01),
             .Sub_Sum(S[1]) );


endmodule /* carry16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : carry0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef carry0
`else
`define carry0

module carry0 ( A , B, Cin, Cout )/* synthesis black_box */;

input A, B, Cin;
output Cout;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(B) , .TAB(Cin) , .TAS1(GND) , .TAS2(GND),
                       .TB1(B) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(Cout), .CZ(), .FZ(), .QZ() );


endmodule /* carry0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : borrow32 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef borrow32
`else
`define borrow32

module borrow32 ( a , b, Carry3, Carry3a, C11_C70, C11_C71, C19_C150, C19_C151,
                 C23_C190, C23_C191, C27_C230, C27_C231, C7_C30, C7_C31,
                 Carry15, Carry15a, Carry15b, Co, Co0_Ci0, Co0_Ci1, Co10_C90,
                 Co10_C91, Co12_C110, Co12_C111, Co13_C120, Co13_C121,
                 Co14_C130, Co14_C131, Co16_C150, Co16_C151, Co17_C160,
                 Co17_C161, Co18_C170, Co18_C171, Co1_C00, Co1_C01, Co20_C190,
                 Co20_C191, Co21_C200, Co21_C201, Co22_C210, Co22_C211,
                 Co24_C230, Co24_C231, Co25_C240, Co25_C241, Co26_C250,
                 Co26_C251, Co28_C270, Co28_C271, Co29_C280, Co29_C281,
                 Co2_C10, Co2_C11, Co30_C290, Co30_C291, Co3_C20, Co3_C21,
                 Co4_C30, Co4_C31, Co5_C40, Co5_C41, Co6_C50, Co6_C51,
                 Co8_C70, Co8_C71, Co9_C80, Co9_C81, S );

input [31:0] a;
input [31:0] b;
output C11_C70, C11_C71, C19_C150, C19_C151, C23_C190, C23_C191, C27_C230,C27_C231, C7_C30, C7_C31, Carry15, Carry15a, Carry15b;
input Carry3, Carry3a;
output Co, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111,Co13_C120, Co13_C121, Co14_C130, Co14_C131, Co16_C150, Co16_C151,Co17_C160, Co17_C161, Co18_C170, Co18_C171, Co1_C00, Co1_C01,Co20_C190, Co20_C191, Co21_C200, Co21_C201, Co22_C210, Co22_C211,Co24_C230, Co24_C231, Co25_C240, Co25_C241, Co26_C250, Co26_C251,Co28_C270, Co28_C271, Co29_C280, Co29_C281, Co2_C10, Co2_C11,Co30_C290, Co30_C291, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40,Co5_C41, Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
output [31:0] S;wire Co19_C180;
wire Co19_C181;
wire Co7_C60;
wire Co23_C220;
wire Co7_C61;
wire Co23_C221;
wire Co11_C100;
wire Co27_C260;
wire Co11_C101;
wire Co27_C261;
wire C15_C110;
wire C15_C111;
wire Co15_C140;
wire Co31_C300;
wire Co15_C141;
wire Co31_C301;
wire C31_C160;
wire C31_C161;
wire C31_C270;
wire C31_C271;


dif_b0 I53  ( .Ax(a[0]) , .Bo_Bi0(Co0_Ci0) , .Bo_Bi1(Co0_Ci1) , .Bx(b[0]) );

b_out I52  ( .Bo(Co) , .By_x0(Carry15) , .Bz_y0(C31_C160) , .Bz_y1(C31_C161) );

cary_gen I3  ( .C_i(Carry3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15b) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I2  ( .C_i(Carry3a) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15a) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I1  ( .C_i(Carry3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
               .Ck_j1(C11_C71) , .Cm_i(Carry15) , .Cm_k0(C15_C110),
               .Cm_k1(C15_C111) );

cary_gen I14  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
                .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C111),
                .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I15  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
                .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C110),
                .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I6  ( .C_i(Co28_C271) , .Cj_i0(Co29_C280) , .Cj_i1(Co29_C281),
               .Ck_j0(Co30_C290) , .Ck_j1(Co30_C291) , .Cm_i(C31_C271),
               .Cm_k0(Co31_C300) , .Cm_k1(Co31_C301) );

cary_gen I7  ( .C_i(Co28_C270) , .Cj_i0(Co29_C280) , .Cj_i1(Co29_C281),
               .Ck_j0(Co30_C290) , .Ck_j1(Co30_C291) , .Cm_i(C31_C270),
               .Cm_k0(Co31_C300) , .Cm_k1(Co31_C301) );

cary_gen I5  ( .C_i(C19_C151) , .Cj_i0(C23_C190) , .Cj_i1(C23_C191),
               .Ck_j0(C27_C230) , .Ck_j1(C27_C231) , .Cm_i(C31_C161),
               .Cm_k0(C31_C270) , .Cm_k1(C31_C271) );

cary_gen I4  ( .C_i(C19_C150) , .Cj_i0(C23_C190) , .Cj_i1(C23_C191),
               .Ck_j0(C27_C230) , .Ck_j1(C27_C231) , .Cm_i(C31_C160),
               .Cm_k0(C31_C270) , .Cm_k1(C31_C271) );

cary_gen I13  ( .C_i(Co16_C150) , .Cj_i0(Co17_C160) , .Cj_i1(Co17_C161),
                .Ck_j0(Co18_C170) , .Ck_j1(Co18_C171) , .Cm_i(C19_C150),
                .Cm_k0(Co19_C180) , .Cm_k1(Co19_C181) );

cary_gen I12  ( .C_i(Co16_C151) , .Cj_i0(Co17_C160) , .Cj_i1(Co17_C161),
                .Ck_j0(Co18_C170) , .Ck_j1(Co18_C171) , .Cm_i(C19_C151),
                .Cm_k0(Co19_C180) , .Cm_k1(Co19_C181) );

cary_gen I11  ( .C_i(Co20_C190) , .Cj_i0(Co21_C200) , .Cj_i1(Co21_C201),
                .Ck_j0(Co22_C210) , .Ck_j1(Co22_C211) , .Cm_i(C23_C190),
                .Cm_k0(Co23_C220) , .Cm_k1(Co23_C221) );

cary_gen I10  ( .C_i(Co20_C191) , .Cj_i0(Co21_C200) , .Cj_i1(Co21_C201),
                .Ck_j0(Co22_C210) , .Ck_j1(Co22_C211) , .Cm_i(C23_C191),
                .Cm_k0(Co23_C220) , .Cm_k1(Co23_C221) );

cary_gen I9  ( .C_i(Co24_C230) , .Cj_i0(Co25_C240) , .Cj_i1(Co25_C241),
               .Ck_j0(Co26_C250) , .Ck_j1(Co26_C251) , .Cm_i(C27_C230),
               .Cm_k0(Co27_C260) , .Cm_k1(Co27_C261) );

cary_gen I8  ( .C_i(Co24_C231) , .Cj_i0(Co25_C240) , .Cj_i1(Co25_C241),
               .Ck_j0(Co26_C250) , .Ck_j1(Co26_C251) , .Cm_i(C27_C231),
               .Cm_k0(Co27_C260) , .Cm_k1(Co27_C261) );

cary_gen I17  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
                .Ck_j1(Co10_C91) , .Cm_i(C11_C70) , .Cm_k0(Co11_C100),
                .Cm_k1(Co11_C101) );

cary_gen I16  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
                .Ck_j1(Co10_C91) , .Cm_i(C11_C71) , .Cm_k0(Co11_C100),
                .Cm_k1(Co11_C101) );

cary_gen I18  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
                .Ck_j1(Co6_C51) , .Cm_i(C7_C31) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

cary_gen I19  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
                .Ck_j1(Co6_C51) , .Cm_i(C7_C30) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

dif_b I36  ( .Ax(a[15]) , .Bo_Bi0(Co15_C140) , .Bo_Bi1(Co15_C141) , .Bx(b[15]),
             .Sub_Dif(S[15]) );

dif_b I37  ( .Ax(a[14]) , .Bo_Bi0(Co14_C130) , .Bo_Bi1(Co14_C131) , .Bx(b[14]),
             .Sub_Dif(S[14]) );

dif_b I38  ( .Ax(a[13]) , .Bo_Bi0(Co13_C120) , .Bo_Bi1(Co13_C121) , .Bx(b[13]),
             .Sub_Dif(S[13]) );

dif_b I39  ( .Ax(a[12]) , .Bo_Bi0(Co12_C110) , .Bo_Bi1(Co12_C111) , .Bx(b[12]),
             .Sub_Dif(S[12]) );

dif_b I35  ( .Ax(a[31]) , .Bo_Bi0(Co31_C300) , .Bo_Bi1(Co31_C301) , .Bx(b[31]),
             .Sub_Dif(S[31]) );

dif_b I34  ( .Ax(a[30]) , .Bo_Bi0(Co30_C290) , .Bo_Bi1(Co30_C291) , .Bx(b[30]),
             .Sub_Dif(S[30]) );

dif_b I33  ( .Ax(a[29]) , .Bo_Bi0(Co29_C280) , .Bo_Bi1(Co29_C281) , .Bx(b[29]),
             .Sub_Dif(S[29]) );

dif_b I32  ( .Ax(a[28]) , .Bo_Bi0(Co28_C270) , .Bo_Bi1(Co28_C271) , .Bx(b[28]),
             .Sub_Dif(S[28]) );

dif_b I27  ( .Ax(a[23]) , .Bo_Bi0(Co23_C220) , .Bo_Bi1(Co23_C221) , .Bx(b[23]),
             .Sub_Dif(S[23]) );

dif_b I26  ( .Ax(a[22]) , .Bo_Bi0(Co22_C210) , .Bo_Bi1(Co22_C211) , .Bx(b[22]),
             .Sub_Dif(S[22]) );

dif_b I25  ( .Ax(a[21]) , .Bo_Bi0(Co21_C200) , .Bo_Bi1(Co21_C201) , .Bx(b[21]),
             .Sub_Dif(S[21]) );

dif_b I24  ( .Ax(a[20]) , .Bo_Bi0(Co20_C190) , .Bo_Bi1(Co20_C191) , .Bx(b[20]),
             .Sub_Dif(S[20]) );

dif_b I23  ( .Ax(a[19]) , .Bo_Bi0(Co19_C180) , .Bo_Bi1(Co19_C181) , .Bx(b[19]),
             .Sub_Dif(S[19]) );

dif_b I22  ( .Ax(a[18]) , .Bo_Bi0(Co18_C170) , .Bo_Bi1(Co18_C171) , .Bx(b[18]),
             .Sub_Dif(S[18]) );

dif_b I21  ( .Ax(a[17]) , .Bo_Bi0(Co17_C160) , .Bo_Bi1(Co17_C161) , .Bx(b[17]),
             .Sub_Dif(S[17]) );

dif_b I20  ( .Ax(a[16]) , .Bo_Bi0(Co16_C150) , .Bo_Bi1(Co16_C151) , .Bx(b[16]),
             .Sub_Dif(S[16]) );

dif_b I31  ( .Ax(a[27]) , .Bo_Bi0(Co27_C260) , .Bo_Bi1(Co27_C261) , .Bx(b[27]),
             .Sub_Dif(S[27]) );

dif_b I30  ( .Ax(a[26]) , .Bo_Bi0(Co26_C250) , .Bo_Bi1(Co26_C251) , .Bx(b[26]),
             .Sub_Dif(S[26]) );

dif_b I29  ( .Ax(a[25]) , .Bo_Bi0(Co25_C240) , .Bo_Bi1(Co25_C241) , .Bx(b[25]),
             .Sub_Dif(S[25]) );

dif_b I28  ( .Ax(a[24]) , .Bo_Bi0(Co24_C230) , .Bo_Bi1(Co24_C231) , .Bx(b[24]),
             .Sub_Dif(S[24]) );

dif_b I40  ( .Ax(a[11]) , .Bo_Bi0(Co11_C100) , .Bo_Bi1(Co11_C101) , .Bx(b[11]),
             .Sub_Dif(S[11]) );

dif_b I41  ( .Ax(a[10]) , .Bo_Bi0(Co10_C90) , .Bo_Bi1(Co10_C91) , .Bx(b[10]),
             .Sub_Dif(S[10]) );

dif_b I42  ( .Ax(a[9]) , .Bo_Bi0(Co9_C80) , .Bo_Bi1(Co9_C81) , .Bx(b[9]),
             .Sub_Dif(S[9]) );

dif_b I43  ( .Ax(a[8]) , .Bo_Bi0(Co8_C70) , .Bo_Bi1(Co8_C71) , .Bx(b[8]),
             .Sub_Dif(S[8]) );

dif_b I44  ( .Ax(a[7]) , .Bo_Bi0(Co7_C60) , .Bo_Bi1(Co7_C61) , .Bx(b[7]),
             .Sub_Dif(S[7]) );

dif_b I45  ( .Ax(a[6]) , .Bo_Bi0(Co6_C50) , .Bo_Bi1(Co6_C51) , .Bx(b[6]),
             .Sub_Dif(S[6]) );

dif_b I46  ( .Ax(a[5]) , .Bo_Bi0(Co5_C40) , .Bo_Bi1(Co5_C41) , .Bx(b[5]),
             .Sub_Dif(S[5]) );

dif_b I47  ( .Ax(a[4]) , .Bo_Bi0(Co4_C30) , .Bo_Bi1(Co4_C31) , .Bx(b[4]),
             .Sub_Dif(S[4]) );

dif_b I48  ( .Ax(a[3]) , .Bo_Bi0(Co3_C20) , .Bo_Bi1(Co3_C21) , .Bx(b[3]),
             .Sub_Dif(S[3]) );

dif_b I49  ( .Ax(a[2]) , .Bo_Bi0(Co2_C10) , .Bo_Bi1(Co2_C11) , .Bx(b[2]),
             .Sub_Dif(S[2]) );

dif_b I50  ( .Ax(a[1]) , .Bo_Bi0(Co1_C00) , .Bo_Bi1(Co1_C01) , .Bx(b[1]),
             .Sub_Dif(S[1]) );


endmodule /* borrow32 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : borrow16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef borrow16
`else
`define borrow16

module borrow16 ( a , b, Borrow3, Bo, C11_C70, C11_C71, C7_C30, C7_C31, Co0_Ci0,
                 Co0_Ci1, Co10_C90, Co10_C91, Co12_C110, Co12_C111, Co13_C120,
                 Co13_C121, Co14_C130, Co14_C131, Co1_C00, Co1_C01, Co2_C10,
                 Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31, Co5_C40,
                 Co5_C41, Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80,
                 Co9_C81, D );

input [15:0] a;
input [15:0] b;
output Bo;
input Borrow3;
output C11_C70, C11_C71, C7_C30, C7_C31, Co0_Ci0, Co0_Ci1, Co10_C90, Co10_C91,Co12_C110, Co12_C111, Co13_C120, Co13_C121, Co14_C130, Co14_C131,Co1_C00, Co1_C01, Co2_C10, Co2_C11, Co3_C20, Co3_C21, Co4_C30, Co4_C31,Co5_C40, Co5_C41, Co6_C50, Co6_C51, Co8_C70, Co8_C71, Co9_C80, Co9_C81;
output [15:0] D;wire Co7_C60;
wire Co7_C61;
wire Co11_C100;
wire Co11_C101;
wire C15_C110;
wire C15_C111;
wire Co15_C140;
wire Co15_C141;


dif_b0 I23  ( .Ax(a[0]) , .Bo_Bi0(Co0_Ci0) , .Bo_Bi1(Co0_Ci1) , .Bx(b[0]) );

bo_gen I1  ( .C_i(Borrow3) , .Cj_i0(C7_C30) , .Cj_i1(C7_C31) , .Ck_j0(C11_C70),
             .Ck_j1(C11_C71) , .Cm_i(Bo) , .Cm_k0(C15_C110) , .Cm_k1(C15_C111) );

cary_gen I7  ( .C_i(Co12_C111) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C111),
               .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I6  ( .C_i(Co12_C110) , .Cj_i0(Co13_C120) , .Cj_i1(Co13_C121),
               .Ck_j0(Co14_C130) , .Ck_j1(Co14_C131) , .Cm_i(C15_C110),
               .Cm_k0(Co15_C140) , .Cm_k1(Co15_C141) );

cary_gen I5  ( .C_i(Co8_C71) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Cm_i(C11_C71) , .Cm_k0(Co11_C100),
               .Cm_k1(Co11_C101) );

cary_gen I4  ( .C_i(Co8_C70) , .Cj_i0(Co9_C80) , .Cj_i1(Co9_C81) , .Ck_j0(Co10_C90),
               .Ck_j1(Co10_C91) , .Cm_i(C11_C70) , .Cm_k0(Co11_C100),
               .Cm_k1(Co11_C101) );

cary_gen I3  ( .C_i(Co4_C31) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Cm_i(C7_C31) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

cary_gen I2  ( .C_i(Co4_C30) , .Cj_i0(Co5_C40) , .Cj_i1(Co5_C41) , .Ck_j0(Co6_C50),
               .Ck_j1(Co6_C51) , .Cm_i(C7_C30) , .Cm_k0(Co7_C60) , .Cm_k1(Co7_C61) );

dif_b I8  ( .Ax(a[15]) , .Bo_Bi0(Co15_C140) , .Bo_Bi1(Co15_C141) , .Bx(b[15]),
            .Sub_Dif(D[15]) );

dif_b I9  ( .Ax(a[14]) , .Bo_Bi0(Co14_C130) , .Bo_Bi1(Co14_C131) , .Bx(b[14]),
            .Sub_Dif(D[14]) );

dif_b I10  ( .Ax(a[13]) , .Bo_Bi0(Co13_C120) , .Bo_Bi1(Co13_C121) , .Bx(b[13]),
             .Sub_Dif(D[13]) );

dif_b I11  ( .Ax(a[12]) , .Bo_Bi0(Co12_C110) , .Bo_Bi1(Co12_C111) , .Bx(b[12]),
             .Sub_Dif(D[12]) );

dif_b I12  ( .Ax(a[11]) , .Bo_Bi0(Co11_C100) , .Bo_Bi1(Co11_C101) , .Bx(b[11]),
             .Sub_Dif(D[11]) );

dif_b I13  ( .Ax(a[10]) , .Bo_Bi0(Co10_C90) , .Bo_Bi1(Co10_C91) , .Bx(b[10]),
             .Sub_Dif(D[10]) );

dif_b I14  ( .Ax(a[9]) , .Bo_Bi0(Co9_C80) , .Bo_Bi1(Co9_C81) , .Bx(b[9]),
             .Sub_Dif(D[9]) );

dif_b I15  ( .Ax(a[8]) , .Bo_Bi0(Co8_C70) , .Bo_Bi1(Co8_C71) , .Bx(b[8]),
             .Sub_Dif(D[8]) );

dif_b I16  ( .Ax(a[7]) , .Bo_Bi0(Co7_C60) , .Bo_Bi1(Co7_C61) , .Bx(b[7]),
             .Sub_Dif(D[7]) );

dif_b I17  ( .Ax(a[6]) , .Bo_Bi0(Co6_C50) , .Bo_Bi1(Co6_C51) , .Bx(b[6]),
             .Sub_Dif(D[6]) );

dif_b I18  ( .Ax(a[5]) , .Bo_Bi0(Co5_C40) , .Bo_Bi1(Co5_C41) , .Bx(b[5]),
             .Sub_Dif(D[5]) );

dif_b I19  ( .Ax(a[4]) , .Bo_Bi0(Co4_C30) , .Bo_Bi1(Co4_C31) , .Bx(b[4]),
             .Sub_Dif(D[4]) );

dif_b I20  ( .Ax(a[3]) , .Bo_Bi0(Co3_C20) , .Bo_Bi1(Co3_C21) , .Bx(b[3]),
             .Sub_Dif(D[3]) );

dif_b I21  ( .Ax(a[2]) , .Bo_Bi0(Co2_C10) , .Bo_Bi1(Co2_C11) , .Bx(b[2]),
             .Sub_Dif(D[2]) );

dif_b I22  ( .Ax(a[1]) , .Bo_Bi0(Co1_C00) , .Bo_Bi1(Co1_C01) , .Bx(b[1]),
             .Sub_Dif(D[1]) );


endmodule /* borrow16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : borrow0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef borrow0
`else
`define borrow0

module borrow0 ( A , B, Bin, Bout )/* synthesis black_box */;

input A, B, Bin;
output Bout;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(A) , .TAB(Bin) , .TAS1(GND) , .TAS2(GND),
                       .TB1(A) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(B) , .TZ(Bout), .CZ(), .FZ(), .QZ() );


endmodule /* borrow0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bo_gen 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bo_gen
`else
`define bo_gen

module bo_gen ( C_i , Cj_i0, Cj_i1, Ck_j0, Ck_j1, Cm_k0, Cm_k1, Cm_i )/* synthesis black_box */;

input C_i, Cj_i0, Cj_i1, Ck_j0, Ck_j1;
output Cm_i;
input Cm_k0, Cm_k1;

supply0 GND;
supply1 VCC;
wire N_11;


logic_cell_macro I1  ( .BA1(Cm_k0) , .BA2(Cm_k0) , .BAB(Ck_j1) , .BAS1(VCC),
                       .BAS2(VCC) , .BB1(VCC) , .BB2(GND) , .BBS1(GND) , .BBS2(GND),
                       .BSL(Cm_k1) , .CZ(Cm_i) , .F1(Cj_i0) , .F2(Cj_i1) , .FS(C_i),
                       .FZ(N_11) , .QCK(GND) , .QCKS(VCC) , .QDI(GND) , .QDS(VCC),
                       .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(Cm_k0) , .TA2(Cm_k0),
                       .TAB(Ck_j0) , .TAS1(GND) , .TAS2(VCC) , .TB1(VCC) , .TB2(GND),
                       .TBS(N_11) , .TBS1(GND) , .TBS2(GND) , .TSL(Cm_k1), .QZ(), .TZ() );


endmodule /* bo_gen */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bank259 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bank259
`else
`define bank259

module bank259 ( CLRNN , D0, D1, D2, D3, D4, D5, D6, D7, DATA, GNN, Q0, Q1, Q2, Q3,
                Q4, Q5, Q6, Q7 )/* synthesis black_box */;

input CLRNN, D0, D1, D2, D3, D4, D5, D6, D7, DATA, GNN;
output Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;



ltch259 I9  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D7) , .GNN(GNN) , .Q(Q7) );

ltch259 I2  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D6) , .GNN(GNN) , .Q(Q6) );

ltch259 I3  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D5) , .GNN(GNN) , .Q(Q5) );

ltch259 I4  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D4) , .GNN(GNN) , .Q(Q4) );

ltch259 I5  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D3) , .GNN(GNN) , .Q(Q3) );

ltch259 I6  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D2) , .GNN(GNN) , .Q(Q2) );

ltch259 I7  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D1) , .GNN(GNN) , .Q(Q1) );

ltch259 I8  ( .CLRNN(CLRNN) , .DATA(DATA) , .DECIN(D0) , .GNN(GNN) , .Q(Q0) );


endmodule /* bank259 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : b169 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef b169
`else
`define b169

module b169 ( A , ANN, QC, OUTC )/* synthesis black_box */;

input A, ANN;
output OUTC;
input QC;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(ANN) , .TA2(ANN) , .TAB(QC) , .TAS1(VCC) , .TAS2(VCC),
                       .TB1(VCC) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(OUTC), .CZ(), .FZ(), .QZ() );


endmodule /* b169 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : b_out 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef b_out
`else
`define b_out

module b_out ( By_x0 , Bz_y0, Bz_y1, Bo )/* synthesis black_box */;

output Bo;
input By_x0, Bz_y0, Bz_y1;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Bz_y0) , .TA2(Bz_y0) , .TAB(By_x0) , .TAS1(VCC),
                       .TAS2(VCC) , .TB1(VCC) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(VCC) , .TSL(Bz_y1) , .TZ(Bo), .CZ(), .FZ(), .QZ() );


endmodule /* b_out */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : a169 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef a169
`else
`define a169

module a169 ( QA , QB, UPDWN, A, ANN, OUTB )/* synthesis black_box */;

output A, ANN, OUTB;
input QA, QB, UPDWN;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(ANN) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(A) , .TZ(OUTB), .CZ(), .FZ(), .QZ() );

logic_cell_macro I2  ( .BA1(GND) , .BA2(GND) , .BAB(QA) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(UPDWN) , .BBS1(GND) , .BBS2(GND) , .BSL(QB),
                       .CZ(A) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(UPDWN) , .TA2(GND) , .TAB(QA) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(QB) , .TZ(ANN), .FZ(), .QZ() );


endmodule /* a169 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : xor2p 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef xor2p
`else
`define xor2p

module xor2p ( A , B, Q )/* synthesis black_box */;

input A, B;
output Q;

supply1 VCC;
supply0 GND;


mux4x0 QL1  ( .A(GND) , .B(VCC) , .C(VCC) , .D(GND) , .Q(Q) , .S0(B) , .S1(A) );


endmodule /* xor2p */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipadoff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipadoff
`else
`define bipadoff

module bipadoff ( A2 , EN, FFCLK, FFCLR, O_FFEN, Q, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A2, EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, O_FFEN;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(GND) , .IQR(FFCLR),
                      .IZ(Q) , .OQE(O_FFEN) , .OQI(A2) , .OSEL(GND) , .WPD(GND), .IQZ() );


endmodule /* bipadoff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsle_apc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsle_apc
`else
`define dffsle_apc

module dffsle_apc ( ARST , ASET, CLK, D, DATA, EN, LD, Q )/* synthesis black_box */;

input ARST, ASET;
input CLK /* synthesis syn_isclock=1 */;
input D, DATA, EN, LD;
output Q;

supply1 VCC;
wire Q1;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(DATA) , .FS(LD) , .FZ(Q1) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(Q1) , .QDS(VCC) , .QEN(EN) , .QRT(ARST) , .QST(ASET),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsle_apc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsle 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsle
`else
`define dffsle

module dffsle ( CLK , D, DATA, EN, LD, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D, DATA, EN, LD;
output Q;

supply1 VCC;
wire Q1;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(DATA) , .FS(LD) , .FZ(Q1) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(Q1) , .QDS(VCC) , .QEN(EN) , .QRT(GND) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsle */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsep_apc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsep_apc
`else
`define dffsep_apc

module dffsep_apc ( ARST , ASET, CLK, D, EN, P, Q )/* synthesis black_box */;

input ARST, ASET;
input CLK /* synthesis syn_isclock=1 */;
input D, EN, P;
output Q;

supply1 VCC;
wire N_11;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(VCC) , .FS(P) , .FZ(N_11) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(N_11) , .QDS(VCC) , .QEN(EN) , .QRT(ARST) , .QST(ASET),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(GND) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsep_apc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsep 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsep
`else
`define dffsep

module dffsep ( CLK , D, EN, P, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D, EN, P;
output Q;

supply1 VCC;
wire N_11;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(VCC) , .FS(P) , .FZ(N_11) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(N_11) , .QDS(VCC) , .QEN(EN) , .QRT(GND) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(GND) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsep */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsec_apc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsec_apc
`else
`define dffsec_apc

module dffsec_apc ( ARST , ASET, CLK, CLR, D, EN, Q )/* synthesis black_box */;

input ARST, ASET;
input CLK /* synthesis syn_isclock=1 */;
input CLR, D, EN;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(GND) , .FS(CLR) , .FZ(N_11) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(N_11) , .QDS(VCC) , .QEN(EN) , .QRT(ARST) , .QST(ASET),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsec_apc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsec 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsec
`else
`define dffsec

module dffsec ( CLK , CLR, D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, EN;
output Q;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(D) , .F2(GND) , .FS(CLR) , .FZ(N_11) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(N_11) , .QDS(VCC) , .QEN(EN) , .QRT(GND) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .TZ() );


endmodule /* dffsec */
`endif




/*-------------------------------------------------------------------------------
 MODULE NAME : ckipad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ckipad
`else
`define ckipad

module ckipad ( P , Q0 )/* synthesis black_box black_box_pad_pin = "P" */;

input P;
output Q0;

wire N_11;


inv I3  ( .A(N_11) , .Q(Q0) );

ckpad I2  ( .P(P) , .Q(N_11) );


endmodule /* ckipad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ckdpad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ckdpad
`else
`define ckdpad

module ckdpad ( P , Q0, Q1 )/* synthesis black_box black_box_pad_pin = "P" */;

input P;
output Q0, Q1;



inv I6  ( .A(Q0) , .Q(Q1) );

ckpad I5  ( .P(P) , .Q(Q0) );


endmodule /* ckdpad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bpad8iff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bpad8iff
`else
`define bpad8iff

module bpad8iff ( A2 , EN, FFCLK, FFCLR, FFEN, FFQ, Q, P );

input [7:0] A2;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [7:0] FFQ;
inout [7:0] P;
output [7:0] Q;

bipadiff \I1[7]   ( .A2(A2[7]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[7]) , .P(P[7]) , .Q(Q[7]) );

bipadiff \I1[6]   ( .A2(A2[6]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[6]) , .P(P[6]) , .Q(Q[6]) );

bipadiff \I1[5]   ( .A2(A2[5]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[5]) , .P(P[5]) , .Q(Q[5]) );

bipadiff \I1[4]   ( .A2(A2[4]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[4]) , .P(P[4]) , .Q(Q[4]) );

bipadiff \I1[3]   ( .A2(A2[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[3]) , .P(P[3]) , .Q(Q[3]) );

bipadiff \I1[2]   ( .A2(A2[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[2]) , .P(P[2]) , .Q(Q[2]) );

bipadiff \I1[1]   ( .A2(A2[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[1]) , .P(P[1]) , .Q(Q[1]) );

bipadiff \I1[0]   ( .A2(A2[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[0]) , .P(P[0]) , .Q(Q[0]) );


endmodule /* bpad8iff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bpad4iff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bpad4iff
`else
`define bpad4iff

module bpad4iff ( A2 , EN, FFCLK, FFCLR, FFEN, FFQ, Q, P );

input [3:0] A2;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [3:0] FFQ;
inout [3:0] P;
output [3:0] Q;

bipadiff \I1[3]   ( .A2(A2[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[3]) , .P(P[3]) , .Q(Q[3]) );

bipadiff \I1[2]   ( .A2(A2[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[2]) , .P(P[2]) , .Q(Q[2]) );

bipadiff \I1[1]   ( .A2(A2[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[1]) , .P(P[1]) , .Q(Q[1]) );

bipadiff \I1[0]   ( .A2(A2[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[0]) , .P(P[0]) , .Q(Q[0]) );


endmodule /* bpad4iff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bpad16iff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bpad16iff
`else
`define bpad16iff

module bpad16iff ( A2 , EN, FFCLK, FFCLR, FFEN, FFQ, Q, P );

input [15:0] A2;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [15:0] FFQ;
inout [15:0] P;
output [15:0] Q;

bipadiff \I1[15]   ( .A2(A2[15]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[15]) , .P(P[15]) , .Q(Q[15]) );

bipadiff \I1[14]   ( .A2(A2[14]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[14]) , .P(P[14]) , .Q(Q[14]) );

bipadiff \I1[13]   ( .A2(A2[13]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[13]) , .P(P[13]) , .Q(Q[13]) );

bipadiff \I1[12]   ( .A2(A2[12]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[12]) , .P(P[12]) , .Q(Q[12]) );

bipadiff \I1[11]   ( .A2(A2[11]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[11]) , .P(P[11]) , .Q(Q[11]) );

bipadiff \I1[10]   ( .A2(A2[10]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                   .FFQ(FFQ[10]) , .P(P[10]) , .Q(Q[10]) );

bipadiff \I1[9]   ( .A2(A2[9]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[9]) , .P(P[9]) , .Q(Q[9]) );

bipadiff \I1[8]   ( .A2(A2[8]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[8]) , .P(P[8]) , .Q(Q[8]) );

bipadiff \I1[7]   ( .A2(A2[7]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[7]) , .P(P[7]) , .Q(Q[7]) );

bipadiff \I1[6]   ( .A2(A2[6]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[6]) , .P(P[6]) , .Q(Q[6]) );

bipadiff \I1[5]   ( .A2(A2[5]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[5]) , .P(P[5]) , .Q(Q[5]) );

bipadiff \I1[4]   ( .A2(A2[4]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[4]) , .P(P[4]) , .Q(Q[4]) );

bipadiff \I1[3]   ( .A2(A2[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[3]) , .P(P[3]) , .Q(Q[3]) );

bipadiff \I1[2]   ( .A2(A2[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[2]) , .P(P[2]) , .Q(Q[2]) );

bipadiff \I1[1]   ( .A2(A2[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[1]) , .P(P[1]) , .Q(Q[1]) );

bipadiff \I1[0]   ( .A2(A2[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .FFQ(FFQ[0]) , .P(P[0]) , .Q(Q[0]) );


endmodule /* bpad16iff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipadiff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipadiff
`else
`define bipadiff

module bipadiff ( A2 , EN, FFCLK, FFCLR, FFEN, FFQ, Q, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A2, EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output FFQ;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(GND) , .OQI(A2) , .OSEL(VCC) , .WPD(GND) );


endmodule /* bipadiff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : gpio_cell_macro 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef gpio_cell_macro
`else
`define gpio_cell_macro

module gpio_cell_macro ( DS , ESEL, FIXHOLD, IE, INEN, IQC, IQCS, IQE, IQR, OQE,
                        OQI, OSEL, WPD, IQZ, IZ, IP )/* synthesis black_box black_box_pad_pin = "IP" */;

input DS, ESEL, FIXHOLD, IE, INEN;
inout IP;
input IQC /* synthesis syn_isclock=1 */;
input IQCS, IQE, IQR;
output IQZ, IZ;
input OQE, OQI, OSEL, WPD;



gpio_cell I1  ( .DS(DS) , .ESEL(ESEL) , .FIXHOLD(FIXHOLD) , .IE(IE) , .INEN(INEN),
                .IP(IP) , .IQC(IQC) , .IQCS(IQCS) , .IQE(IQE) , .IQR(IQR) , .IQZ(IQZ),
                .IZ(IZ) , .OQE(OQE) , .OQI(OQI) , .OSEL(OSEL) , .WPD(WPD) );


endmodule /* gpio_cell_macro */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : logic_cell_macro 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef logic_cell_macro
`else
`define logic_cell_macro

module logic_cell_macro ( BA1 , BA2, BAB, BAS1, BAS2, BB1, BB2, BBS1, BBS2, BSL,
                         F1, F2, FS, QCK, QCKS, QDI, QDS, QEN, QRT, QST, TA1,
                         TA2, TAB, TAS1, TAS2, TB1, TB2, TBS, TBS1, TBS2, TSL,
                         CZ, FZ, QZ, TZ )/* synthesis black_box */;

input BA1, BA2, BAB, BAS1, BAS2, BB1, BB2, BBS1, BBS2, BSL;
output CZ;
input F1, F2, FS;
output FZ;
input QCK, QCKS, QDI, QDS, QEN, QRT, QST;
output QZ;
input TA1, TA2, TAB, TAS1, TAS2, TB1, TB2, TBS, TBS1, TBS2, TSL;
output TZ;



logic_cell I1  ( .BA1(BA1) , .BA2(BA2) , .BAB(BAB) , .BAS1(BAS1) , .BAS2(BAS2),
                 .BB1(BB1) , .BB2(BB2) , .BBS1(BBS1) , .BBS2(BBS2) , .BSL(BSL) , .CZ(CZ),
                 .F1(F1) , .F2(F2) , .FS(FS) , .FZ(FZ) , .QCK(QCK) , .QCKS(QCKS),
                 .QDI(QDI) , .QDS(QDS) , .QEN(QEN) , .QRT(QRT) , .QST(QST) , .QZ(QZ),
                 .TA1(TA1) , .TA2(TA2) , .TAB(TAB) , .TAS1(TAS1) , .TAS2(TAS2),
                 .TB1(TB1) , .TB2(TB2) , .TBS(TBS) , .TBS1(TBS1) , .TBS2(TBS2),
                 .TSL(TSL) , .TZ(TZ) );


endmodule /* logic_cell_macro */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : qhsckbuff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef qhsckbuff
`else
`define qhsckbuff

module qhsckbuff ( A , Z )/* synthesis black_box */;

input A;
output Z;

supply1 VCC;
supply0 GND;


qmux I1  ( .HSCKIN(A) , .IS0(VCC) , .IS1(VCC) , .IZ(Z) , .QCLKIN0(GND) , .QCLKIN1(GND),
           .QCLKIN2(GND) );


endmodule /* qhsckbuff */
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : qhsckibuff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
module qhsckibuff ( 
                     input A, 
                     output Z );

wire N_11;
supply1 VCC;
supply0 GND;


inv I2  ( .A(A) , .Q(N_11) );

qmux I1  ( .HSCKIN(N_11) , .IS0(VCC) , .IS1(VCC) , .IZ(Z) , .QCLKIN0(GND),
           .QCLKIN1(GND) , .QCLKIN2(GND) );


endmodule /* qhsckibuff */

/*-------------------------------------------------------------------------------
 MODULE NAME : cand 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef cand
`else
`define cand

module cand ( CLK , EN, Z )/* synthesis black_box */;

input CLK, EN;
output Z;



cand_cell I1  ( .EN(EN) , .IC(CLK) , .IZ(Z) );


endmodule /* cand */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux8x0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux8x0
`else
`define mux8x0

module mux8x0 ( A , B, C, D, E, F, G, H, S0, S1, S2, Q )/* synthesis black_box */;

input A, B, C, D, E, F, G, H;
output Q;
input S0, S1, S2;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(E) , .BA2(F) , .BAB(S1) , .BAS1(GND) , .BAS2(GND) , .BB1(G),
                       .BB2(H) , .BBS1(GND) , .BBS2(GND) , .BSL(S0) , .CZ(Q) , .F1(GND),
                       .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC) , .QDI(GND),
                       .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND) , .TA1(A) , .TA2(B),
                       .TAB(S1) , .TAS1(GND) , .TAS2(GND) , .TB1(C) , .TB2(D) , .TBS(S2),
                       .TBS1(GND) , .TBS2(GND) , .TSL(S0), .FZ(), .QZ(), .TZ() );


endmodule /* mux8x0 */
`endif



/*-------------------------------------------------------------------------------
 MODULE NAME : csblow 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csblow
`else
`define csblow

module csblow ( A0 , A1, B0, B1, A1T, C0_n, C1 )/* synthesis black_box */;

input A0, A1;
output A1T;
input B0, B1;
output C0_n, C1;

supply0 GND;
supply1 VCC;
wire N_11;
wire N_12;
wire N_13;


inv I1  ( .A(B1) , .Q(N_11) );

buff I2  ( .A(A1) , .Q(A1T) );

and2i1 I3  ( .A(B0) , .B(A0) , .Q(C0_n) );

mux2x0 I4  ( .A(N_13) , .B(N_12) , .Q(C1) , .S(C0_n) );

mux2dx0 I5  ( .A(N_11) , .B(VCC) , .C(GND) , .D(N_11) , .Q(N_13) , .R(N_12) , .S(A1T) );


endmodule /* csblow */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csbbitb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csbbitb
`else
`define csbbitb

module csbbitb ( A , B, C0, C1, S0 )/* synthesis black_box */;

input A, B;
output C0, C1, S0;

supply0 GND;
supply1 VCC;
wire N_12;


and2i1 I4  ( .A(B) , .B(A) , .Q(C1) );

and2i1 I5  ( .A(A) , .B(B) , .Q(C0) );

mux2x0 I3  ( .A(N_12) , .B(GND) , .Q(S0) , .S(C0) );

mux2x0 I6  ( .A(VCC) , .B(GND) , .Q(N_12) , .S(C1) );


endmodule /* csbbitb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : csamuxd 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef csamuxd
`else
`define csamuxd

module csamuxd ( A , S00, S01, S1, Q )/* synthesis black_box */;

input A;
output Q;
input S00, S01, S1;



mux4x6 QL1  ( .A(S00) , .B(S00) , .C(S01) , .D(S01) , .Q(Q) , .S0(A) , .S1(S1) );


endmodule /* csamuxd */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x7 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x7
`else
`define mux4x7

module mux4x7 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x7 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x6 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x6
`else
`define mux4x6

module mux4x6 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x6 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x5 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x5
`else
`define mux4x5

module mux4x5 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x5 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x3
`else
`define mux4x3

module mux4x3 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x9 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x9
`else
`define mux4x9

module mux4x9 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x9 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xa 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xa
`else
`define mux4xa

module mux4xa ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xa */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xb 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xb
`else
`define mux4xb

module mux4xb ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xb */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xc
`else
`define mux4xc

module mux4xc ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xd 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xd
`else
`define mux4xd

module mux4xd ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xd */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xe 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xe
`else
`define mux4xe

module mux4xe ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xe */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4xf 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4xf
`else
`define mux4xf

module mux4xf ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4xf */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tripados 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tripados
`else
`define tripados

module tripados ( EN , P )/* synthesis black_box */;

input EN;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(GND),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND),
                      .OQE(GND) , .OQI(VCC) , .OSEL(VCC) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* tripados */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tripadod 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tripadod
`else
`define tripadod

module tripadod ( EN , P )/* synthesis black_box */;

input EN;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(GND),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND),
                      .OQE(GND) , .OQI(GND) , .OSEL(VCC) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* tripadod */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tripadff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tripadff
`else
`define tripadff

module tripadff ( A , EN, FFCLK, FFCLR, FFEN, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A, EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(GND),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(GND) , .IQR(FFCLR),
                      .OQE(FFEN) , .OQI(A) , .OSEL(GND) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* tripadff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tripad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tripad
`else
`define tripad

module tripad ( A , EN, P )/* synthesis black_box */;

input A, EN;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(GND),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND),
                      .OQE(GND) , .OQI(A) , .OSEL(VCC) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* tripad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad8ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad8ff
`else
`define tpad8ff

module tpad8ff ( A , EN, FFCLK, FFCLR, FFEN, P );

input [7:0] A;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [7:0] P;

tripadff \I[7]   ( .A(A[7]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[7]) );

tripadff \I[6]   ( .A(A[6]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[6]) );

tripadff \I[5]   ( .A(A[5]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[5]) );

tripadff \I[4]   ( .A(A[4]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[4]) );

tripadff \I[3]   ( .A(A[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[3]) );

tripadff \I[2]   ( .A(A[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[2]) );

tripadff \I[1]   ( .A(A[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[1]) );

tripadff \I[0]   ( .A(A[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[0]) );


endmodule /* tpad8ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad8
`else
`define tpad8

module tpad8 ( A , EN, P );

input [7:0] A;
input EN;
output [7:0] P;

tripad \I[7]   ( .A(A[7]) , .EN(EN) , .P(P[7]) );

tripad \I[6]   ( .A(A[6]) , .EN(EN) , .P(P[6]) );

tripad \I[5]   ( .A(A[5]) , .EN(EN) , .P(P[5]) );

tripad \I[4]   ( .A(A[4]) , .EN(EN) , .P(P[4]) );

tripad \I[3]   ( .A(A[3]) , .EN(EN) , .P(P[3]) );

tripad \I[2]   ( .A(A[2]) , .EN(EN) , .P(P[2]) );

tripad \I[1]   ( .A(A[1]) , .EN(EN) , .P(P[1]) );

tripad \I[0]   ( .A(A[0]) , .EN(EN) , .P(P[0]) );


endmodule /* tpad8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad4ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad4ff
`else
`define tpad4ff

module tpad4ff ( A , EN, FFCLK, FFCLR, FFEN, P );

input [3:0] A;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [3:0] P;

tripadff \I[3]   ( .A(A[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[3]) );

tripadff \I[2]   ( .A(A[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[2]) );

tripadff \I[1]   ( .A(A[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[1]) );

tripadff \I[0]   ( .A(A[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[0]) );


endmodule /* tpad4ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad4
`else
`define tpad4

module tpad4 ( A , EN, P );

input [3:0] A;
input EN;
output [3:0] P;

tripad \I[3]   ( .A(A[3]) , .EN(EN) , .P(P[3]) );

tripad \I[2]   ( .A(A[2]) , .EN(EN) , .P(P[2]) );

tripad \I[1]   ( .A(A[1]) , .EN(EN) , .P(P[1]) );

tripad \I[0]   ( .A(A[0]) , .EN(EN) , .P(P[0]) );


endmodule /* tpad4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad16ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad16ff
`else
`define tpad16ff

module tpad16ff ( A , EN, FFCLK, FFCLR, FFEN, P );

input [15:0] A;
input EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [15:0] P;

tripadff \I[15]   ( .A(A[15]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[15]) );

tripadff \I[14]   ( .A(A[14]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[14]) );

tripadff \I[13]   ( .A(A[13]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[13]) );

tripadff \I[12]   ( .A(A[12]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[12]) );

tripadff \I[11]   ( .A(A[11]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[11]) );

tripadff \I[10]   ( .A(A[10]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                  .P(P[10]) );

tripadff \I[9]   ( .A(A[9]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[9]) );

tripadff \I[8]   ( .A(A[8]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[8]) );

tripadff \I[7]   ( .A(A[7]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[7]) );

tripadff \I[6]   ( .A(A[6]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[6]) );

tripadff \I[5]   ( .A(A[5]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[5]) );

tripadff \I[4]   ( .A(A[4]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[4]) );

tripadff \I[3]   ( .A(A[3]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[3]) );

tripadff \I[2]   ( .A(A[2]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[2]) );

tripadff \I[1]   ( .A(A[1]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[1]) );

tripadff \I[0]   ( .A(A[0]) , .EN(EN) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN),
                 .P(P[0]) );


endmodule /* tpad16ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tpad16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tpad16
`else
`define tpad16

module tpad16 ( A , EN, P );

input [15:0] A;
input EN;
output [15:0] P;

tripad \I[15]   ( .A(A[15]) , .EN(EN) , .P(P[15]) );

tripad \I[14]   ( .A(A[14]) , .EN(EN) , .P(P[14]) );

tripad \I[13]   ( .A(A[13]) , .EN(EN) , .P(P[13]) );

tripad \I[12]   ( .A(A[12]) , .EN(EN) , .P(P[12]) );

tripad \I[11]   ( .A(A[11]) , .EN(EN) , .P(P[11]) );

tripad \I[10]   ( .A(A[10]) , .EN(EN) , .P(P[10]) );

tripad \I[9]   ( .A(A[9]) , .EN(EN) , .P(P[9]) );

tripad \I[8]   ( .A(A[8]) , .EN(EN) , .P(P[8]) );

tripad \I[7]   ( .A(A[7]) , .EN(EN) , .P(P[7]) );

tripad \I[6]   ( .A(A[6]) , .EN(EN) , .P(P[6]) );

tripad \I[5]   ( .A(A[5]) , .EN(EN) , .P(P[5]) );

tripad \I[4]   ( .A(A[4]) , .EN(EN) , .P(P[4]) );

tripad \I[3]   ( .A(A[3]) , .EN(EN) , .P(P[3]) );

tripad \I[2]   ( .A(A[2]) , .EN(EN) , .P(P[2]) );

tripad \I[1]   ( .A(A[1]) , .EN(EN) , .P(P[1]) );

tripad \I[0]   ( .A(A[0]) , .EN(EN) , .P(P[0]) );


endmodule /* tpad16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : outpad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef outpad
`else
`define outpad

module outpad ( A , P )/* synthesis black_box */;

input A;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(VCC) , .INEN(GND),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND),
                      .OQE(GND) , .OQI(A) , .OSEL(VCC) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* outpad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : outpadff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef outpadff
`else
`define outpadff

module outpadff ( A , FFCLK, FFCLR, FFEN, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output P;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(VCC) , .INEN(GND),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(GND) , .IQR(FFCLR),
                      .OQE(FFEN) , .OQI(A) , .OSEL(GND) , .WPD(GND), .IQZ(), .IZ() );


endmodule /* outpadff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad8ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad8ff
`else
`define opad8ff

module opad8ff ( A , FFCLK, FFCLR, FFEN, P );

input [7:0] A;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [7:0] P;

outpadff \I[7]   ( .A(A[7]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[7]) );

outpadff \I[6]   ( .A(A[6]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[6]) );

outpadff \I[5]   ( .A(A[5]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[5]) );

outpadff \I[4]   ( .A(A[4]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[4]) );

outpadff \I[3]   ( .A(A[3]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[3]) );

outpadff \I[2]   ( .A(A[2]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[2]) );

outpadff \I[1]   ( .A(A[1]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[1]) );

outpadff \I[0]   ( .A(A[0]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[0]) );


endmodule /* opad8ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad8
`else
`define opad8

module opad8 ( A , P );

input [7:0] A;
output [7:0] P;

outpad \I[7]   ( .A(A[7]) , .P(P[7]) );

outpad \I[6]   ( .A(A[6]) , .P(P[6]) );

outpad \I[5]   ( .A(A[5]) , .P(P[5]) );

outpad \I[4]   ( .A(A[4]) , .P(P[4]) );

outpad \I[3]   ( .A(A[3]) , .P(P[3]) );

outpad \I[2]   ( .A(A[2]) , .P(P[2]) );

outpad \I[1]   ( .A(A[1]) , .P(P[1]) );

outpad \I[0]   ( .A(A[0]) , .P(P[0]) );


endmodule /* opad8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad4ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad4ff
`else
`define opad4ff

module opad4ff ( A , FFCLK, FFCLR, FFEN, P );

input [3:0] A;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [3:0] P;

outpadff \I[3]   ( .A(A[3]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[3]) );

outpadff \I[2]   ( .A(A[2]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[2]) );

outpadff \I[1]   ( .A(A[1]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[1]) );

outpadff \I[0]   ( .A(A[0]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[0]) );


endmodule /* opad4ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad4
`else
`define opad4

module opad4 ( A , P );

input [3:0] A;
output [3:0] P;

outpad \I[3]   ( .A(A[3]) , .P(P[3]) );

outpad \I[2]   ( .A(A[2]) , .P(P[2]) );

outpad \I[1]   ( .A(A[1]) , .P(P[1]) );

outpad \I[0]   ( .A(A[0]) , .P(P[0]) );


endmodule /* opad4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad16ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad16ff
`else
`define opad16ff

module opad16ff ( A , FFCLK, FFCLR, FFEN, P );

input [15:0] A;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [15:0] P;

outpadff \I[15]   ( .A(A[15]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[15]) );

outpadff \I[14]   ( .A(A[14]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[14]) );

outpadff \I[13]   ( .A(A[13]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[13]) );

outpadff \I[12]   ( .A(A[12]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[12]) );

outpadff \I[11]   ( .A(A[11]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[11]) );

outpadff \I[10]   ( .A(A[10]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[10]) );

outpadff \I[9]   ( .A(A[9]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[9]) );

outpadff \I[8]   ( .A(A[8]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[8]) );

outpadff \I[7]   ( .A(A[7]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[7]) );

outpadff \I[6]   ( .A(A[6]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[6]) );

outpadff \I[5]   ( .A(A[5]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[5]) );

outpadff \I[4]   ( .A(A[4]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[4]) );

outpadff \I[3]   ( .A(A[3]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[3]) );

outpadff \I[2]   ( .A(A[2]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[2]) );

outpadff \I[1]   ( .A(A[1]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[1]) );

outpadff \I[0]   ( .A(A[0]) , .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .P(P[0]) );


endmodule /* opad16ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : opad16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef opad16
`else
`define opad16

module opad16 ( A , P );

input [15:0] A;
output [15:0] P;

outpad \I[15]   ( .A(A[15]) , .P(P[15]) );

outpad \I[14]   ( .A(A[14]) , .P(P[14]) );

outpad \I[13]   ( .A(A[13]) , .P(P[13]) );

outpad \I[12]   ( .A(A[12]) , .P(P[12]) );

outpad \I[11]   ( .A(A[11]) , .P(P[11]) );

outpad \I[10]   ( .A(A[10]) , .P(P[10]) );

outpad \I[9]   ( .A(A[9]) , .P(P[9]) );

outpad \I[8]   ( .A(A[8]) , .P(P[8]) );

outpad \I[7]   ( .A(A[7]) , .P(P[7]) );

outpad \I[6]   ( .A(A[6]) , .P(P[6]) );

outpad \I[5]   ( .A(A[5]) , .P(P[5]) );

outpad \I[4]   ( .A(A[4]) , .P(P[4]) );

outpad \I[3]   ( .A(A[3]) , .P(P[3]) );

outpad \I[2]   ( .A(A[2]) , .P(P[2]) );

outpad \I[1]   ( .A(A[1]) , .P(P[1]) );

outpad \I[0]   ( .A(A[0]) , .P(P[0]) );


endmodule /* opad16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad8ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad8ff
`else
`define ipad8ff

module ipad8ff ( FFCLK , FFCLR, FFEN, P, FFQ, Q );

input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [7:0] FFQ;
input [7:0] P;
output [7:0] Q;

inpadff \I[7]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[7]) , .P(P[7]),
                .Q(Q[7]) );

inpadff \I[6]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[6]) , .P(P[6]),
                .Q(Q[6]) );

inpadff \I[5]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[5]) , .P(P[5]),
                .Q(Q[5]) );

inpadff \I[4]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[4]) , .P(P[4]),
                .Q(Q[4]) );

inpadff \I[3]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[3]) , .P(P[3]),
                .Q(Q[3]) );

inpadff \I[2]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[2]) , .P(P[2]),
                .Q(Q[2]) );

inpadff \I[1]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[1]) , .P(P[1]),
                .Q(Q[1]) );

inpadff \I[0]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[0]) , .P(P[0]),
                .Q(Q[0]) );


endmodule /* ipad8ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad8
`else
`define ipad8

module ipad8 ( P , Q );

input [7:0] P;
output [7:0] Q;

inpad \I[7]   ( .P(P[7]) , .Q(Q[7]) );

inpad \I[6]   ( .P(P[6]) , .Q(Q[6]) );

inpad \I[5]   ( .P(P[5]) , .Q(Q[5]) );

inpad \I[4]   ( .P(P[4]) , .Q(Q[4]) );

inpad \I[3]   ( .P(P[3]) , .Q(Q[3]) );

inpad \I[2]   ( .P(P[2]) , .Q(Q[2]) );

inpad \I[1]   ( .P(P[1]) , .Q(Q[1]) );

inpad \I[0]   ( .P(P[0]) , .Q(Q[0]) );


endmodule /* ipad8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad4ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad4ff
`else
`define ipad4ff

module ipad4ff ( FFCLK , FFCLR, FFEN, P, FFQ, Q );

input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [3:0] FFQ;
input [3:0] P;
output [3:0] Q;

inpadff \I[3]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[3]) , .P(P[3]),
                .Q(Q[3]) );

inpadff \I[2]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[2]) , .P(P[2]),
                .Q(Q[2]) );

inpadff \I[1]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[1]) , .P(P[1]),
                .Q(Q[1]) );

inpadff \I[0]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[0]) , .P(P[0]),
                .Q(Q[0]) );


endmodule /* ipad4ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad4
`else
`define ipad4

module ipad4 ( P , Q );

input [3:0] P;
output [3:0] Q;

inpad \I[3]   ( .P(P[3]) , .Q(Q[3]) );

inpad \I[2]   ( .P(P[2]) , .Q(Q[2]) );

inpad \I[1]   ( .P(P[1]) , .Q(Q[1]) );

inpad \I[0]   ( .P(P[0]) , .Q(Q[0]) );


endmodule /* ipad4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad16ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad16ff
`else
`define ipad16ff

module ipad16ff ( FFCLK , FFCLR, FFEN, P, FFQ, Q );

input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output [15:0] FFQ;
input [15:0] P;
output [15:0] Q;

inpadff \I[15]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[15]),
                 .P(P[15]) , .Q(Q[15]) );

inpadff \I[14]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[14]),
                 .P(P[14]) , .Q(Q[14]) );

inpadff \I[13]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[13]),
                 .P(P[13]) , .Q(Q[13]) );

inpadff \I[12]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[12]),
                 .P(P[12]) , .Q(Q[12]) );

inpadff \I[11]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[11]),
                 .P(P[11]) , .Q(Q[11]) );

inpadff \I[10]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[10]),
                 .P(P[10]) , .Q(Q[10]) );

inpadff \I[9]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[9]) , .P(P[9]),
                .Q(Q[9]) );

inpadff \I[8]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[8]) , .P(P[8]),
                .Q(Q[8]) );

inpadff \I[7]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[7]) , .P(P[7]),
                .Q(Q[7]) );

inpadff \I[6]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[6]) , .P(P[6]),
                .Q(Q[6]) );

inpadff \I[5]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[5]) , .P(P[5]),
                .Q(Q[5]) );

inpadff \I[4]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[4]) , .P(P[4]),
                .Q(Q[4]) );

inpadff \I[3]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[3]) , .P(P[3]),
                .Q(Q[3]) );

inpadff \I[2]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[2]) , .P(P[2]),
                .Q(Q[2]) );

inpadff \I[1]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[1]) , .P(P[1]),
                .Q(Q[1]) );

inpadff \I[0]   ( .FFCLK(FFCLK) , .FFCLR(FFCLR) , .FFEN(FFEN) , .FFQ(FFQ[0]) , .P(P[0]),
                .Q(Q[0]) );


endmodule /* ipad16ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : ipad16 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ipad16
`else
`define ipad16

module ipad16 ( P , Q );

input [15:0] P;
output [15:0] Q;

inpad \I[15]   ( .P(P[15]) , .Q(Q[15]) );

inpad \I[14]   ( .P(P[14]) , .Q(Q[14]) );

inpad \I[13]   ( .P(P[13]) , .Q(Q[13]) );

inpad \I[12]   ( .P(P[12]) , .Q(Q[12]) );

inpad \I[11]   ( .P(P[11]) , .Q(Q[11]) );

inpad \I[10]   ( .P(P[10]) , .Q(Q[10]) );

inpad \I[9]   ( .P(P[9]) , .Q(Q[9]) );

inpad \I[8]   ( .P(P[8]) , .Q(Q[8]) );

inpad \I[7]   ( .P(P[7]) , .Q(Q[7]) );

inpad \I[6]   ( .P(P[6]) , .Q(Q[6]) );

inpad \I[5]   ( .P(P[5]) , .Q(Q[5]) );

inpad \I[4]   ( .P(P[4]) , .Q(Q[4]) );

inpad \I[3]   ( .P(P[3]) , .Q(Q[3]) );

inpad \I[2]   ( .P(P[2]) , .Q(Q[2]) );

inpad \I[1]   ( .P(P[1]) , .Q(Q[1]) );

inpad \I[0]   ( .P(P[0]) , .Q(Q[0]) );


endmodule /* ipad16 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : inpadff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef inpadff
`else
`define inpadff

module inpadff ( FFCLK , FFCLR, FFEN, P, FFQ, Q )/* synthesis black_box black_box_pad_pin = "P" */;

input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR, FFEN;
output FFQ;
input P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(GND) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(GND) , .OQI(GND) , .OSEL(VCC),
                      .WPD(GND) );


endmodule /* inpadff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : inpad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef inpad
`else
`define inpad

module inpad ( P , Q )/* synthesis black_box */;

input P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(GND) , .INEN(VCC),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND) , .IZ(Q),
                      .OQE(GND) , .OQI(GND) , .OSEL(VCC) , .WPD(GND), .IQZ() );


endmodule /* inpad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bpad8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bpad8
`else
`define bpad8

module bpad8 ( A , EN, Q, P );

input [7:0] A;
input EN;
inout [7:0] P;
output [7:0] Q;

bipad \I[7]   ( .A(A[7]) , .EN(EN) , .P(P[7]) , .Q(Q[7]) );

bipad \I[6]   ( .A(A[6]) , .EN(EN) , .P(P[6]) , .Q(Q[6]) );

bipad \I[5]   ( .A(A[5]) , .EN(EN) , .P(P[5]) , .Q(Q[5]) );

bipad \I[4]   ( .A(A[4]) , .EN(EN) , .P(P[4]) , .Q(Q[4]) );

bipad \I[3]   ( .A(A[3]) , .EN(EN) , .P(P[3]) , .Q(Q[3]) );

bipad \I[2]   ( .A(A[2]) , .EN(EN) , .P(P[2]) , .Q(Q[2]) );

bipad \I[1]   ( .A(A[1]) , .EN(EN) , .P(P[1]) , .Q(Q[1]) );

bipad \I[0]   ( .A(A[0]) , .EN(EN) , .P(P[0]) , .Q(Q[0]) );


endmodule /* bpad8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bpad4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bpad4
`else
`define bpad4

module bpad4 ( A , EN, Q, P );

input [3:0] A;
input EN;
inout [3:0] P;
output [3:0] Q;

bipad \I[3]   ( .A(A[3]) , .EN(EN) , .P(P[3]) , .Q(Q[3]) );

bipad \I[2]   ( .A(A[2]) , .EN(EN) , .P(P[2]) , .Q(Q[2]) );

bipad \I[1]   ( .A(A[1]) , .EN(EN) , .P(P[1]) , .Q(Q[1]) );

bipad \I[0]   ( .A(A[0]) , .EN(EN) , .P(P[0]) , .Q(Q[0]) );


endmodule /* bpad4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlade 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlade
`else
`define dlade

module dlade ( D1 , D2, EN, G, Q1, Q2 )/* synthesis black_box ql_pack = 1 */;
//pragma attribute dlade hierarchy preserve

input D1, D2, EN, G;
output Q1, Q2;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q2) , .BA2(Q2) , .BAB(G) , .BAS1(GND) , .BAS2(GND),
                       .BB1(Q2) , .BB2(D2) , .BBS1(GND) , .BBS2(GND) , .BSL(EN),
                       .CZ(Q2) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q1) , .TA2(Q1) , .TAB(G) , .TAS1(GND) , .TAS2(GND),
                       .TB1(Q1) , .TB2(D1) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(EN) , .TZ(Q1), .FZ(), .QZ() );


endmodule /* dlade */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipados 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipados
`else
`define bipados

module bipados ( EN , Q, P )/* synthesis black_box black_box_pad_pin = "P" */;

input EN;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND) , .IZ(Q),
                      .OQE(GND) , .OQI(VCC) , .OSEL(VCC) , .WPD(GND), .IQZ() );


endmodule /* bipados */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipadod 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipadod
`else
`define bipadod

module bipadod ( EN , Q, P )/* synthesis black_box */;

input EN;
inout P;
output Q;

supply0 GND;
supply1 VCC;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND) , .IZ(Q),
                      .OQE(GND) , .OQI(GND) , .OSEL(VCC) , .WPD(GND), .IQZ() );


endmodule /* bipadod */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipadioff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipadioff
`else
`define bipadioff

module bipadioff ( A2 , EN, FFCLK, FFCLR, I_FFEN, O_FFEN, FFQ, Q, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A2, EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR;
output FFQ;
input I_FFEN, O_FFEN;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(I_FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(O_FFEN) , .OQI(A2) , .OSEL(GND),
                      .WPD(GND) );


endmodule /* bipadioff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipadeioff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipadeioff
`else
`define bipadeioff

module bipadeioff ( A2 , EN, FFCLK, FFCLR, I_FFEN, O_FFEN, FFQ, Q, P )/* synthesis black_box black_box_pad_pin = "P" */;

input A2, EN;
input FFCLK /* synthesis syn_isclock=1 */;
input FFCLR;
output FFQ;
input I_FFEN, O_FFEN;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(GND) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(FFCLK) , .IQCS(GND) , .IQE(I_FFEN) , .IQR(FFCLR),
                      .IQZ(FFQ) , .IZ(Q) , .OQE(O_FFEN) , .OQI(A2) , .OSEL(GND),
                      .WPD(GND) );


endmodule /* bipadeioff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bipad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipad
`else
`define bipad

module bipad ( A , EN, Q, P )/* synthesis black_box */;

input A, EN;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND) , .IZ(Q),
                      .OQE(GND) , .OQI(A) , .OSEL(VCC) , .WPD(GND), .IQZ() );


endmodule /* bipad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dladc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dladc
`else
`define dladc

module dladc ( C1NN , C2NN, CLR, D1, D2, Q1, Q2 )/* synthesis black_box */;

input C1NN, C2NN, CLR, D1, D2;
output Q1, Q2;

supply0 GND;
supply1 VCC;
wire N_1;


logic_cell_macro I1  ( .BA1(D2) , .BA2(Q2) , .BAB(CLR) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(N_1),
                       .CZ(Q2) , .F1(C2NN) , .F2(VCC) , .FS(C1NN) , .FZ(N_1) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(D1) , .TA2(Q1) , .TAB(CLR) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(N_1) , .TZ(Q1), .QZ() );


endmodule /* dladc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : shiftbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef shiftbit
`else
`define shiftbit

module shiftbit ( CLK , CLR, D, EN, LOAD, SI, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, EN, LOAD;
output Q;
input SI;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(SI) , .BAB(LOAD) , .BAS1(GND) , .BAS2(GND),
                       .BB1(D) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(EN) , .F1(GND),
                       .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(GND),
                       .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* shiftbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : bishbit 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bishbit
`else
`define bishbit

module bishbit ( CLK , CLR, D, LSI, RSI, S0, S1, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, LSI;
output Q;
input RSI, S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(RSI) , .BAB(S1) , .BAS1(GND) , .BAS2(GND),
                       .BB1(LSI) , .BB2(D) , .BBS1(GND) , .BBS2(GND) , .BSL(S0),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(GND) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* bishbit */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : maj3i0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef maj3i0
`else
`define maj3i0

module maj3i0 ( A , B, C, Q )/* synthesis black_box */;

input A, B, C;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(C) , .TAB(B) , .TAS1(GND) , .TAS2(GND) , .TB1(C),
                       .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(A),
                       .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* maj3i0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : inv 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef inv
`else
`define inv

module inv ( A , Q );

input A;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(VCC) , .F2(GND) , .FS(A) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* inv */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : buff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef buff
`else
`define buff

module buff ( A , Q );

input A;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(A) , .F2(GND) , .FS(GND) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .QZ(), .TZ() );


endmodule /* buff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x8 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x8
`else
`define mux4x8

module mux4x8 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x8 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x4 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x4
`else
`define mux4x4

module mux4x4 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(VCC) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x4 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x2
`else
`define mux4x2

module mux4x2 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(VCC) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x1
`else
`define mux4x1

module mux4x1 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(VCC) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux4x0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux4x0
`else
`define mux4x0

module mux4x0 ( A , B, C, D, S0, S1, Q );

input A, B, C, D;
output Q;
input S0, S1;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(S1) , .TAS1(GND) , .TAS2(GND) , .TB1(C),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S0) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux4x0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2x3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2x3
`else
`define mux2x3

module mux2x3 ( A , B, S, Q );

input A, B;
output Q;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(VCC) , .TAB(S) , .TB1(VCC) , .TB2(GND) , .TBS(VCC),
                       .TBS1(GND) , .TBS2(GND) , .TSL(B) , .TZ(Q), .CZ(), .FZ(), .QZ(), .TAS1(VCC), .TAS2(VCC) );


endmodule /* mux2x3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2x2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2x2
`else
`define mux2x2

module mux2x2 ( A , B, S, Q );

input A, B;
output Q;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux2x2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2x1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2x1
`else
`define mux2x1

module mux2x1 ( A , B, S, Q );

input A, B;
output Q;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(VCC) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux2x1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2x0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2x0
`else
`define mux2x0

module mux2x0 ( A , B, S, Q );

input A, B;
output Q;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* mux2x0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2ffx3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2ffx3
`else
`define mux2ffx3

module mux2ffx3 ( A , CLK, CLR, D, PRE, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2ffx3 hierarchy preserve

input A;
input CLK /* synthesis syn_isclock=1 */;
input CLR, D, PRE;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q) , .TA1(A),
                       .TA2(A) , .TAB(S) , .TAS1(VCC) , .TAS2(VCC) , .TB1(VCC),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(Q),
                       .TZ(R), .CZ(), .FZ() );


endmodule /* mux2ffx3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2ffx2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2ffx2
`else
`define mux2ffx2

module mux2ffx2 ( A , CLK, CLR, D, PRE, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2ffx2 hierarchy preserve

input A;
input CLK /* synthesis syn_isclock=1 */;
input CLR, D, PRE;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q) , .TA1(A),
                       .TA2(Q) , .TAB(GND) , .TAS1(GND) , .TAS2(VCC) , .TB1(GND),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S),
                       .TZ(R), .CZ(), .FZ() );


endmodule /* mux2ffx2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2ffx1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2ffx1
`else
`define mux2ffx1

module mux2ffx1 ( A , CLK, CLR, D, PRE, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2ffx1 hierarchy preserve

input A;
input CLK /* synthesis syn_isclock=1 */;
input CLR, D, PRE;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q) , .TA1(A),
                       .TA2(Q) , .TAB(GND) , .TAS1(VCC) , .TAS2(GND) , .TB1(GND),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S),
                       .TZ(R), .CZ(), .FZ() );


endmodule /* mux2ffx1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2ffx0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2ffx0
`else
`define mux2ffx0

module mux2ffx0 ( A , CLK, CLR, D, PRE, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2ffx0 hierarchy preserve

input A;
input CLK /* synthesis syn_isclock=1 */;
input CLR, D, PRE;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q) , .TA1(A),
                       .TA2(Q) , .TAB(GND) , .TAS1(GND) , .TAS2(GND) , .TB1(GND),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(S),
                       .TZ(R), .CZ(), .FZ() );


endmodule /* mux2ffx0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dx3 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dx3
`else
`define mux2dx3

module mux2dx3 ( A , B, C, D, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2dx3 hierarchy preserve

input A, B, C, D;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(S) , .BAS1(GND) , .BAS2(GND),
                       .BB1(D) , .BB2(D) , .BBS1(VCC) , .BBS2(VCC) , .BSL(C) , .CZ(R),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(VCC) , .TA2(GND) , .TAB(S) , .TAS1(GND) , .TAS2(GND),
                       .TB1(B) , .TB2(B) , .TBS(VCC) , .TBS1(VCC) , .TBS2(VCC) , .TSL(A),
                       .TZ(Q), .FZ(), .QZ() );


endmodule /* mux2dx3 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dx2 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dx2
`else
`define mux2dx2

module mux2dx2 ( A , B, C, D, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2dx2 hierarchy preserve

input A, B, C, D;
output Q, R;
input S;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(C) , .BA2(D) , .BAB(GND) , .BAS1(GND) , .BAS2(N_11),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(S),
                       .CZ(R) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(N_11),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(N_11),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .FZ(), .QZ() );


endmodule /* mux2dx2 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dx1 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dx1
`else
`define mux2dx1

module mux2dx1 ( A , B, C, D, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2dx1 hierarchy preserve

input A, B, C, D;
output Q, R;
input S;

wire N_11;
supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(C) , .BA2(D) , .BAB(GND) , .BAS1(N_11) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(S),
                       .CZ(R) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(N_11),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(N_11) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .FZ(), .QZ() );


endmodule /* mux2dx1 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : mux2dx0 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef mux2dx0
`else
`define mux2dx0

module mux2dx0 ( A , B, C, D, S, Q, R )/* synthesis black_box ql_pack = 1 */;
//pragma attribute mux2dx0 hierarchy preserve

input A, B, C, D;
output Q, R;
input S;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(C) , .BA2(D) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(S),
                       .CZ(R) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(A) , .TA2(B) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(S) , .TZ(Q), .FZ(), .QZ() );


endmodule /* mux2dx0 */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : s_r_latch 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef s_r_latch
`else
`define s_r_latch

module s_r_latch ( R , S1, S2, Q, QN )/* synthesis black_box */;

output Q, QN;
input R, S1, S2;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(R) , .F2(GND) , .FS(QN) , .FZ(Q) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(GND) , .TA2(GND) , .TAB(S2) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(Q) , .TBS(VCC) , .TBS1(GND) , .TBS2(VCC),
                       .TSL(S1) , .TZ(QN), .CZ(), .QZ() );


endmodule /* s_r_latch */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlap 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlap
`else
`define dlap

module dlap ( D , G, PRE, Q );

input D, G, PRE;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(D) , .TAB(PRE) , .TAS1(GND) , .TAS2(GND),
                       .TB1(VCC) , .TB2(VCC) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dlap */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlamux 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlamux
`else
`define dlamux

module dlamux ( D0 , D1, G, SEL, Q );

input D0, D1, G;
output Q;
input SEL;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(Q) , .TAB(G) , .TAS1(GND) , .TAS2(GND) , .TB1(D0),
                       .TB2(D1) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(SEL),
                       .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dlamux */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlaemux 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlaemux
`else
`define dlaemux

module dlaemux ( D0 , D1, EN, G, SEL, Q );

input D0, D1, EN, G;
output Q;
input SEL;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(G) , .BAS1(GND) , .BAS2(GND) , .BB1(D0),
                       .BB2(D1) , .BBS1(GND) , .BBS2(GND) , .BSL(SEL) , .CZ(Q),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(EN) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .FZ(), .QZ(), .TZ() );


endmodule /* dlaemux */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlaec 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlaec
`else
`define dlaec

module dlaec ( CLR , D, EN, G, Q );

input CLR, D, EN, G;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(Q) , .TAB(EN) , .TAS1(GND) , .TAS2(GND) , .TB1(Q),
                       .TB2(D) , .TBS(CLR) , .TBS1(GND) , .TBS2(GND) , .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dlaec */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlae 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlae
`else
`define dlae

module dlae ( D , EN, G, Q );

input D, EN, G;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(Q) , .TAB(EN) , .TAS1(GND) , .TAS2(GND) , .TB1(Q),
                       .TB2(D) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dlae */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dladinv 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dladinv
`else
`define dladinv

module dladinv ( DATA , G, Q, QNN )/* synthesis black_box */;

input DATA, G;
output Q, QNN;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(QNN) , .BA2(DATA) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(G),
                       .CZ(QNN) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND),
                       .QCKS(VCC) , .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND),
                       .QST(GND) , .TA1(Q) , .TA2(DATA) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(G) , .TZ(Q), .FZ(), .QZ() );


endmodule /* dladinv */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlad 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlad
`else
`define dlad

module dlad ( D1 , D2, G, Q1, Q2 )/* synthesis ql_pack = 1 */;
//pragma attribute dlad hierarchy preserve

input D1, D2, G;
output Q1, Q2;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Q2) , .BA2(GND) , .BAB(G) , .BAS1(GND) , .BAS2(GND),
                       .BB1(D2) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .CZ(Q2) , .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q1) , .TA2(GND) , .TAB(G) , .TAS1(GND) , .TAS2(GND),
                       .TB1(D1) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND) , .TZ(Q1), .FZ(), .QZ() );


endmodule /* dlad */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dlac 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dlac
`else
`define dlac

module dlac ( CLR , D, G, Q );

input CLR, D, G;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(D) , .TAB(CLR) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dlac */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dla 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dla
`else
`define dla

module dla ( D , G, Q );

input D, G;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(GND) , .QCKS(VCC),
                       .QDI(GND) , .QDS(VCC) , .QEN(GND) , .QRT(GND) , .QST(GND),
                       .TA1(Q) , .TA2(D) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(G) , .TZ(Q), .CZ(), .FZ(), .QZ() );


endmodule /* dla */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tffpc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tffpc
`else
`define tffpc

module tffpc ( CLK , CLR, PRE, T, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, PRE;
output Q;
input T;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(T),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(VCC) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(PRE),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* tffpc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tffepc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tffepc
`else
`define tffepc

module tffepc ( CLK , CLR, EN, PRE, T, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, EN, PRE;
output Q;
input T;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(T),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(VCC) , .QDS(GND) , .QEN(EN) , .QRT(CLR) , .QST(PRE) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* tffepc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tffe 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tffe
`else
`define tffe

module tffe ( CLK , EN, T, Q )/* synthesis black_box */;

input CLK, EN;
output Q;
input T;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(T),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(EN) , .QRT(GND) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* tffe */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : tff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef tff
`else
`define tff

module tff ( CLK , T, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
output Q;
input T;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Q) , .BA2(Q) , .BAB(GND) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(T),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(VCC) , .QDS(GND) , .QEN(VCC) , .QRT(GND) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* tff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : jknn_ff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef jknn_ff
`else
`define jknn_ff

module jknn_ff ( CLK , CLR, J, KNN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, J, KNN;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(Q) , .BAB(KNN) , .BAS1(GND) , .BAS2(VCC),
                       .BB1(Q) , .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(J),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* jknn_ff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : jknffpc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef jknffpc
`else
`define jknffpc

module jknffpc ( CLK , CLR, J, K, PRE, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, J, K, PRE;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(GND) , .BA2(Q) , .BAB(K) , .BAS1(GND) , .BAS2(VCC) , .BB1(Q),
                       .BB2(VCC) , .BBS1(GND) , .BBS2(GND) , .BSL(J) , .F1(GND),
                       .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(GND),
                       .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* jknffpc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : jkffpc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef jkffpc
`else
`define jkffpc

module jkffpc ( CLK , CLR, J, K, PRE, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, J, K, PRE;
output Q;

supply0 GND;
supply1 VCC;


logic_cell_macro I1  ( .BA1(Q) , .BA2(VCC) , .BAB(K) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(Q) , .BBS1(GND) , .BBS2(VCC) , .BSL(J),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(CLR) , .QST(PRE),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* jkffpc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : jkff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef jkff
`else
`define jkff

module jkff ( CLK , J, K, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input J, K;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(Q) , .BA2(VCC) , .BAB(K) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(Q) , .BBS1(GND) , .BBS2(VCC) , .BSL(J),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC),
                       .QDI(GND) , .QDS(GND) , .QEN(VCC) , .QRT(GND) , .QST(GND),
                       .QZ(Q) , .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND),
                       .TAS2(GND) , .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND),
                       .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* jkff */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffsc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffsc
`else
`define dffsc

module dffsc ( CLK , CLR, D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffsc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffpc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffpc
`else
`define dffpc

module dffpc ( CLK , CLR, D, PRE, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, PRE;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(PRE) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffpc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffp 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffp
`else
`define dffp

module dffp ( CLK , D, PRE, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D, PRE;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(GND) , .QST(PRE) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffp */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffepc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffepc
`else
`define dffepc

module dffepc ( CLK , CLR, D, EN, PRE, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D, EN, PRE;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(EN) , .QRT(CLR) , .QST(PRE) , .QZ(Q) , .TA1(GND),
                       .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND) , .TB1(GND),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffepc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffe 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffe
`else
`define dffe

module dffe ( CLK , D, EN, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D, EN;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(EN) , .QRT(GND) , .QST(GND) , .QZ(Q) , .TA1(GND),
                       .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND) , .TB1(GND),
                       .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND) , .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffe */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dffc 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dffc
`else
`define dffc

module dffc ( CLK , CLR, D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input CLR, D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(CLR) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dffc */
`endif


/*-------------------------------------------------------------------------------
 MODULE NAME : dff 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef dff
`else
`define dff

module dff ( CLK , D, Q )/* synthesis black_box */;

input CLK /* synthesis syn_isclock=1 */;
input D;
output Q;

supply1 VCC;
supply0 GND;


logic_cell_macro I1  ( .BA1(GND) , .BA2(GND) , .BAB(GND) , .BAS1(GND) , .BAS2(GND),
                       .BB1(GND) , .BB2(GND) , .BBS1(GND) , .BBS2(GND) , .BSL(GND),
                       .F1(GND) , .F2(GND) , .FS(GND) , .QCK(CLK) , .QCKS(VCC) , .QDI(D),
                       .QDS(VCC) , .QEN(VCC) , .QRT(GND) , .QST(GND) , .QZ(Q),
                       .TA1(GND) , .TA2(GND) , .TAB(GND) , .TAS1(GND) , .TAS2(GND),
                       .TB1(GND) , .TB2(GND) , .TBS(VCC) , .TBS1(GND) , .TBS2(GND),
                       .TSL(GND), .CZ(), .FZ(), .TZ() );


endmodule /* dff */
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : ckpad2_dyn_en 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef ckpad2_dyn_en
`else
`define ckpad2_dyn_en

module ckpad2_dyn_en ( 
                        input EN, P, 
                        output Q );

wire N_11;


ckpad I38  ( .P(P) , .Q(N_11) );

cand I27  ( .CLK(N_11) , .EN(EN) , .Z(Q) );


endmodule /* ckpad2_dyn_en */
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : qmux 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef qmux
`else
`define qmux

module qmux ( HSCKIN , IS0, IS1, QCLKIN0, QCLKIN1, QCLKIN2, IZ )/* synthesis black_box */;

input HSCKIN, IS0, IS1;
output IZ;
input QCLKIN0, QCLKIN1, QCLKIN2;



qmux_cell I1  ( .HSCKIN(HSCKIN) , .IS0(IS0) , .IS1(IS1) , .IZ(IZ) , .QCLKIN0(QCLKIN0),
                .QCLKIN1(QCLKIN1) , .QCLKIN2(QCLKIN2) );


endmodule /* qmux */
`endif




`ifdef qmux_cell
`else
`define qmux_cell
module qmux_cell( HSCKIN ,QCLKIN0, QCLKIN1, QCLKIN2,IS0,IS1, IZ );
input HSCKIN ,QCLKIN0, QCLKIN1, QCLKIN2, IS0, IS1;
output reg IZ;
//pragma synthesis_off
 always @ (HSCKIN ,QCLKIN0, QCLKIN1, QCLKIN2, IS0, IS1) 
 begin
	 if( IS1 == 1'b0 && IS0 == 1'b0)
		 IZ <= QCLKIN0; //clock net 0
	 else if( IS1 == 1'b1 && IS0 == 1'b0)
		 IZ <= QCLKIN1; //clock net 1
	 else if( IS1 == 1'b0 && IS0 == 1'b1)
		 IZ <= QCLKIN2; //clock net 2
	 else if( IS1 == 1'b1 && IS0 == 1'b1)
		 IZ <= HSCKIN; // HSCK signal
	 else
		 IZ <= 1'bX;
 end
 
//pragma synthesis_on
endmodule // qmux_cell

`endif

module cand_cell(IC,EN,IZ);
input IC,EN;
output reg IZ;
//pragma synthesis_off
 always @*
  begin
   if (EN == 1) 
       IZ <= IC;
   else if (EN == 0)
       IZ <= 1'b0;
       else
       IZ = 1'bX;
   end
   //pragma synthesis_on
 endmodule
/*-------------------------------------------------------------------------------
 MODULE NAME : bipad_with_wpd 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef bipad_with_wpd
`else
`define bipad_with_wpd

module bipad_with_wpd ( A , EN, Q, P , WPD)/* synthesis black_box black_box_pad_pin = "P" */;

input A, EN;
input WPD;
inout P;
output Q;

supply1 VCC;
supply0 GND;


gpio_cell_macro I1  ( .DS(GND) , .ESEL(VCC) , .FIXHOLD(GND) , .IE(EN) , .INEN(VCC),
                      .IP(P) , .IQC(GND) , .IQCS(GND) , .IQE(GND) , .IQR(GND) , .IZ(Q),
                      .OQE(GND) , .OQI(A) , .OSEL(VCC) , .WPD(WPD), .IQZ() );


endmodule /* bipad_with_wpd */
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : qlal4s3_mult_cell_macro 
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef qlal4s3_mult_cell_macro
`else
`define qlal4s3_mult_cell_macro

module qlal4s3_mult_cell_macro ( Amult, Bmult, Valid_mult, sel_mul_32x32, Cmult)/* synthesis black_box */;

input [31:0] Amult;
input [31:0] Bmult;
input [1:0] Valid_mult;
input sel_mul_32x32;
output [63:0] Cmult;

/*assign Cmult = Amult * Bmult;*/

endmodule
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : qlal4s3_32x32_mult_cell
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef qlal4s3_32x32_mult_cell
`else
`define qlal4s3_32x32_mult_cell

module qlal4s3_32x32_mult_cell ( Amult, Bmult, Valid_mult, Cmult);

input [31:0] Amult;
input [31:0] Bmult;
input [1:0] Valid_mult;
output [63:0] Cmult;

qlal4s3_mult_cell_macro I1 ( .Amult(Amult), .Bmult(Bmult), .Valid_mult(Valid_mult), 
							 .sel_mul_32x32(1'b1), .Cmult(Cmult));

endmodule
`endif

/*-------------------------------------------------------------------------------
 MODULE NAME : qlal4s3_16x16_mult_cell
 DESCRIPTION :						
--------------------------------------------------------------------------------*/
`ifdef qlal4s3_16x16_mult_cell
`else
`define qlal4s3_16x16_mult_cell

module qlal4s3_16x16_mult_cell ( Amult, Bmult, Valid_mult, Cmult);

input [15:0] Amult;
input [15:0] Bmult;
input [1:0] Valid_mult;
output [31:0] Cmult;

wire [63:0] Cmult_w;
wire [31:0] Amult_w;
wire [31:0] Bmult_w;

assign Amult_w = {16'd0,Amult};
assign Bmult_w = {16'd0,Bmult};
assign Cmult = Cmult_w[31:0];

qlal4s3_mult_cell_macro I1 ( .Amult(Amult_w), .Bmult(Bmult_w), .Valid_mult(Valid_mult), 
							 .sel_mul_32x32(1'b0), .Cmult(Cmult_w));

endmodule
`endif

//Added By Anand Wadke for FIR Decimation design
///*-------------------------------------------------------------------------------
// MODULE NAME : qlal4s3_16x16_mult_cell
// DESCRIPTION :						
//--------------------------------------------------------------------------------*/
`ifdef qlal4s3_mult_16x16_cell
`else
`define qlal4s3_mult_16x16_cell

//module qlal4s3_mult_16x16_cell ( Amult, Bmult, Valid_mult,sel_mul_32x32, Cmult);  
module qlal4s3_mult_16x16_cell ( Amult, Bmult, Valid_mult,Cmult);  

input [15:0] Amult;
input [15:0] Bmult;
input [1:0] Valid_mult;
//input       sel_mul_32x32;
output [31:0] Cmult;

wire [63:0] Cmult_w;
wire [31:0] Amult_w;
wire [31:0] Bmult_w;

assign Amult_w = {{16{Amult[15]}},Amult};//{16'd0,Amult};//Sign extension
assign Bmult_w = {{16{Bmult[15]}},Bmult};
assign Cmult = Cmult_w[31:0];

//qlal4s3_mult_cell_macro I1 ( .Amult(Amult_w), .Bmult(Bmult_w), .Valid_mult(Valid_mult), 
qlal4s3_mult_32x32_cell I1 ( .Amult(Amult_w), .Bmult(Bmult_w), .Valid_mult(Valid_mult), 
							 .sel_mul_32x32(1'b0),.Cmult(Cmult_w));
							 //.sel_mul_32x32(sel_mul_32x32),.Cmult(Cmult_w));

endmodule
`endif

//`ifdef qlal4s3_mult_32x32_cell
//`else
//`define qlal4s3_mult_32x32_cell
//(* synthesis, black_box  *)
//module qlal4s3_mult_32x32_cell ( Amult, Bmult, Valid_mult, Cmult);
//
//input [31:0] Amult;
//input [31:0] Bmult;
//input [1:0] Valid_mult;
//output [63:0] Cmult;
//
//
//endmodule
//`endif





//pragma synthesis_on 

`ifdef logic_0
`else
`define logic_0
module logic_0(a);
output a;
//pragma synthesis_off
 assign #1 a = 1'b0;
//pragma synthesis_on

endmodule // logic_0
`endif

`ifdef logic_1
`else
`define logic_1

module logic_1(a);
output a;
//pragma synthesis_off
 assign #1 a = 1'b1;
//pragma synthesis_on


endmodule // logic_1
`endif
