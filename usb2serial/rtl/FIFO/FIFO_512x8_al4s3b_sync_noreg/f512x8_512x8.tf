`timescale 1ns/1ns

/************************************************************************
** File : f512x8_512x8.tf
** Design Date: July 18,2012
** Creation Date : Wed May 13 16:02:49 2020

** Created By SpDE Version : SpDE 2016.2 Release
** Author: QuickLogic Corporation,
** Copyright (C) 1998, Customers of QuickLogic may copy and modify this
** file for use in designing QuickLogic devices only.
** Description: This is a sample test fixture for your FIFO.
************************************************************************/

module t;

integer i;

reg Clk,Fifo_Push_Flush,Fifo_Pop_Flush;
reg PUSH,POP;
reg Clk_En,Fifo_Dir,Async_Flush;
reg  [7:0] DIN;
wire [7:0] DOUT;
wire [3:0] PUSH_FLAG,POP_FLAG;
wire Almost_Full,Almost_Empty;

 f512x8_512x8 m(.DIN(DIN),.Clk(Clk),.PUSH(PUSH),.POP(POP),.Fifo_Push_Flush(Fifo_Push_Flush),.Fifo_Pop_Flush(Fifo_Pop_Flush),.DOUT(DOUT),
       .Clk_En(Clk_En),.Fifo_Dir(Fifo_Dir),.Async_Flush(Async_Flush),
.PUSH_FLAG(PUSH_FLAG),.POP_FLAG(POP_FLAG),.Almost_Full(Almost_Full),.Almost_Empty(Almost_Empty));


initial
begin
  Clk = 0;
  forever begin
    #20
    Clk = ~ Clk;
  end
end
initial begin
   DIN = 0;
	Clk_En = 1'b1;
	Fifo_Dir = 1'b0;
	Async_Flush = 1'b0;
   i = 0;
   forever begin
      #40 DIN = i;
      i = i + 1;
   end
end
initial begin
  Fifo_Push_Flush = 0;
  PUSH = 1;
  POP = 0;
  Fifo_Pop_Flush = 0;
  #20520; 
  Fifo_Push_Flush = 0;
  PUSH = 0;
  Fifo_Pop_Flush = 0;
  POP = 1;
  #20480; 
  #100;
 $stop;
 $finish;
end

endmodule
