/************************************************************************
** File : r512x16_512x16.v
** Design Date: April 11 2006
** Creation Date: Thu Jul 06 15:56:34 2017

** Created By SpDE Version: SpDE 2016.1.1 Release
** Author: QuickLogic Corporation,
** Copyright (C) 1998, Customers of QuickLogic may copy and modify this
** file for use in designing QuickLogic devices only.
** Description : This file is autogenerated RTL code that describes the
** top level design for RAM using QuickLogic's
** RAM block resources.
************************************************************************/
module r512x16_512x16_deci_filter (WA,RA,WD,WD_SEL,RD_SEL,WClk,RClk,WClk_En,RClk_En,WEN,RD,LS,DS,SD,LS_RB1,DS_RB1,SD_RB1);


input [8:0] WA;
input [8:0] RA;
input WD_SEL,RD_SEL;
input WClk,RClk;
input WClk_En,RClk_En;
input [1:0] WEN;
input [15:0] WD;
input LS,DS,SD,LS_RB1,DS_RB1,SD_RB1;
output [15:0] RD;

//parameter [16383:0] INIT = 16384'b0;
parameter [16383:0] INIT = 0;
parameter INIT_FILE="";	

parameter addr_int = 9 ;
parameter data_depth_int = 512;
parameter data_width_int = 16;
parameter wr_enable_int = 2;
parameter reg_rd_int = 0;


supply0 GND;
supply1 VCC;

RAM_8K_BLK #(.addr_int(addr_int),.data_depth_int(data_depth_int),.data_width_int(data_width_int),.wr_enable_int(wr_enable_int),.reg_rd_int(reg_rd_int),
			  .INIT(INIT),.INIT_FILE(INIT_FILE)
			  )
RAM_INST (	.WA(WA),
			.RA(RA),
			.WD(WD),
			.WClk(WClk),
			.RClk(RClk),
			.WClk_En(WClk_En),
			.RClk_En(RClk_En),
			.WEN(WEN),
			.RD(RD)
			);

endmodule
