/* Empty Verilog model of QLAL4S3 Multiplier */

/*qlal4s3_mult_16x16_cell*/
(* synthesis, black_box  *)
module qlal4s3_mult_16x16_cell ( Amult, Bmult, Valid_mult, sel_mul_32x32, Cmult);

input [15:0] Amult;
input [15:0] Bmult;
input [1:0] Valid_mult;
input sel_mul_32x32;
output [31:0] Cmult;


endmodule