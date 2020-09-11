/* ----------------------------------------------------------------------------
FPGA_FIFO
FIFO block for the Interface module, implemented in the FPGA fabric in the S3B
device.

Push_flag:
4'b0000 = full
4'b0001 = empty
4'b0010 = room for more than 1/2
4'b0011 = room for more than 1/4
4'b0100 = room for less than 1/4 to 64
4'b1010 = room for 32 to 63
4'b1011 = room for 16 to 31
4'b1100 = room for 8 to 15
4'b1101 = room for 4 to 7
4'b1110 = room for at least 2
4'b1111 = room for at least 1
others  = reserved

Pop_flag:
4'b0000 = empty
4'b0001 = 1 entry in FIFO
4'b0010 = at least 2 entries
4'b0011 = at least 4 entries
4'b0100 = at least 8 entries
4'b0101 = at least 16 entries
4'b0110 = at least 32 entries
4'b1000 = less than 1/4 to 64 entries
4'b1101 = 1/4 or more full
4'b1110 = 1/2 or more full
4'b1111 = full
others  = reserved

almost_empty: 0 or 1 elements in the FIFO.
almost_full:  FIFO full, or full-1.


Supports a single 512x32 FIFO block for now. Future enhancements will support
variable sizes.
---------------------------------------------------------------------------- */

`timescale 1ns/1ps

module FPGA_FIFO (
    Async_Flush     ,
    Clk             ,
    Clk_En          ,

    // write port
    Push_Flush      ,
    Push            ,
    Din             ,
    Almost_Full     ,
    Full            ,
    Push_flag       ,

    // read port
    Pop_Flush       ,
    Pop             ,
    Dout            ,
    Almost_Empty    ,
    Empty           ,
    Pop_flag
);

input           Async_Flush     ;
input           Clk             ;
input           Clk_En          ;

input           Push_Flush      ;
input           Push            ;
input   [7:0]   Din             ;
output          Almost_Full     ;
output          Full            ;
output  [3:0]   Push_flag       ;

input           Pop_Flush       ;
input           Pop             ;
output  [7:0]   Dout            ;
output          Almost_Empty    ;
output          Empty           ;
output  [3:0]   Pop_flag        ;


f512x8_512x8 f512x8_512x8_0 (
    .Async_Flush        ( Async_Flush       ),
    .Fifo_Dir           ( 1'b0              ),
    .Clk                ( Clk               ),
    .Clk_En             ( Clk_En            ),
    .Fifo_Push_Flush    ( Push_Flush        ),
    .PUSH               ( Push              ),
    .DIN                ( Din               ),
    .PUSH_FLAG          ( Push_flag         ),
    .Almost_Full        ( Almost_Full       ),
    .Fifo_Pop_Flush     ( Pop_Flush         ),
    .POP                ( Pop               ),
    .DOUT               ( Dout              ),
    .POP_FLAG           ( Pop_flag          ),
    .Almost_Empty       ( Almost_Empty      )
);

assign Full = (Push_flag == 4'b0000);
assign Empty = (Pop_flag == 4'b0000);

endmodule


