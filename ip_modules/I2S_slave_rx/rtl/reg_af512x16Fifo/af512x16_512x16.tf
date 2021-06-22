`timescale 1ns/1ns

/************************************************************************
** File : af512x16_512x16.tf
** Design Date: April 11, 2005
** Creation Date : Wed Jan 31 13:45:44 2018

** Created By SpDE Version : SpDE 2016.1.1 Release
** Author: QuickLogic India Development Centre,
** Copyright (C) 1998, Customers of QuickLogic may copy and modify this
** file for use in designing QuickLogic devices only.
** Description: This is a sample test fixture for your Asynchronous FIFO.
************************************************************************/

module t;

integer i;

reg Push_Clk,Pop_Clk,Fifo_Push_Flush,Fifo_Pop_Flush;
reg PUSH,POP;
reg Push_Clk_En,Pop_Clk_En,Fifo_Dir,Async_Flush;
reg  [15:0] DIN;
wire [15:0] DOUT;
wire [3:0] PUSH_FLAG,POP_FLAG;
wire Almost_Full,Almost_Empty;

 af512x16_512x16 m(.DIN(DIN),.Fifo_Push_Flush(Fifo_Push_Flush),.Fifo_Pop_Flush(Fifo_Pop_Flush),
       .Push_Clk(Push_Clk),.Pop_Clk(Pop_Clk),.POP(POP),
       .Push_Clk_En(Push_Clk_En),.Pop_Clk_En(Pop_Clk_En),.Fifo_Dir(Fifo_Dir),.Async_Flush(Async_Flush),
       .PUSH(PUSH),.DOUT(DOUT),.PUSH_FLAG(PUSH_FLAG),.POP_FLAG(POP_FLAG),
       .Almost_Full(Almost_Full),.Almost_Empty(Almost_Empty));

parameter w_half_period = 10;
parameter r_half_period = 15;
initial
	begin
		Pop_Clk = 1'b1;
		forever #(r_half_period) Pop_Clk = ~Pop_Clk;
	end
initial
	begin
		Push_Clk = 1'b1;
		forever #(w_half_period) Push_Clk = ~Push_Clk;
	end
initial
	begin
	PUSH = 1'b0;
	Fifo_Push_Flush = 1'b0;
	POP = 1'b0;
	Fifo_Pop_Flush = 1'b0;
	DIN = 0;
	Push_Clk_En = 1'b1;
	Pop_Clk_En = 1'b1;
	Fifo_Dir = 1'b0;
	Async_Flush = 1'b0;
   #250;
	@(posedge Push_Clk);
	for(i=0;i<512;i=i+1) begin 
		fifo_write (i);
	end
	#642
   @(posedge Pop_Clk);
	for(i=0;i<512;i=i+1) begin
		fifo_read;
   end
   #500;
   $stop;
end
task fifo_write;
input    [15:0] data;
	begin
		#(w_half_period);
		DIN= data;
		PUSH = 1'b1;
		#(2*w_half_period);
		PUSH = 1'b0;
		#(w_half_period);
	end
endtask
task fifo_read;
	begin
		#(r_half_period);
		POP = 1'b1;
		#(2*r_half_period);
		POP = 1'b0;
		#r_half_period;
	end
endtask
endmodule
