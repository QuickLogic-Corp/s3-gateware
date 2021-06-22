`include "C:/QuickLogic/QuickWorks_2016.1.1_Release/spde/data/PolarPro-III/AL4S3B/rrw/ram_blk.v"
`ifdef r512x16_512x16
`else
`define r512x16_512x16
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
module r512x16_512x16 (WA,RA,WD,WD_SEL,RD_SEL,WClk,RClk,WClk_En,RClk_En,WEN,RD,LS,DS,SD,LS_RB1,DS_RB1,SD_RB1);


input [8:0] WA;
input [8:0] RA;
input WD_SEL,RD_SEL;
input WClk,RClk;
input WClk_En,RClk_En;
input [1:0] WEN;
input [15:0] WD;
input LS,DS,SD,LS_RB1,DS_RB1,SD_RB1;
output [15:0] RD;

parameter wr_addr_int = 9 ;
parameter rd_addr_int = 9;
parameter wr_depth_int = 512;
parameter rd_depth_int = 512;
parameter wr_width_int = 16;
parameter rd_width_int = 16;
parameter wr_enable_int = 2;
parameter reg_rd_int = 0;


supply0 GND;
supply1 VCC;
RAM_RW #(wr_addr_int,rd_addr_int, wr_depth_int,
        	rd_depth_int,wr_width_int,rd_width_int,wr_enable_int,reg_rd_int)
RAM_INST (.WA(WA),.RA(RA),.WD(WD),.WD_SEL(WD_SEL),.RD_SEL(RD_SEL),
          .WClk(WClk),.RClk(RClk),.WClk_En(WClk_En),.RClk_En(RClk_En),.WEN(WEN),.RD(RD),.WClk_Sel(GND),.RClk_Sel(GND),.LS(LS),.DS(DS),.SD(SD),.LS_RB1(LS_RB1),.DS_RB1(DS_RB1),.SD_RB1(SD_RB1));
endmodule
`endif
