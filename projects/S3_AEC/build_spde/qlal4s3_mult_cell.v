/* Empty Verilog model of QLAL4S3 Multiplier */

/*qlal4s3_mult_cell*/
(* synthesis, black_box  *)
module qlal4s3_mult_cell_macro ( Amult, Bmult, Valid_mult, sel_mul_32x32, Cmult);

input [31:0] Amult;
input [31:0] Bmult;
input [1:0] Valid_mult;
input sel_mul_32x32;
output [63:0] Cmult;

endmodule