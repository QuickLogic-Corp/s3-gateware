module strobe_out4(
			clk_in,
			clk_out,
			strobe_in,
			strobe_out,
			strobe_out_dup1,
			strobe_out_dup2,
			strobe_out_dup3,
			data_in,
			data_out
			);
			
parameter WIDTH = 1;
parameter DELAY = 2; // 2 for metastability, larger for testing
	
	
input clk_in;
input clk_out;
input strobe_in;
output strobe_out;
output strobe_out_dup1;
output strobe_out_dup2;
output strobe_out_dup3;
input [WIDTH-1:0] data_in;
output [WIDTH-1:0] data_out;

reg strobe_out;
reg strobe_out_dup1;
reg strobe_out_dup2;
reg strobe_out_dup3;

`define CLOCK_CROSS
`ifdef CLOCK_CROSS
	reg flag;
	reg prev_strobe;
	reg [DELAY:0] sync;
	reg [WIDTH-1:0] data;

	initial begin
		flag = 0;
		prev_strobe = 0;
		sync[DELAY:0] = 0;
		data[WIDTH-1:0] = 0;
	end

	// flip the flag and clock in the data when strobe is high
	always @(posedge clk_in) begin
		//if ((strobe_in && !prev_strobe)
		//|| (!strobe_in &&  prev_strobe))
		flag <= flag ^ strobe_in;

		if (strobe_in)
			data <= data_in;

		prev_strobe <= strobe_in;
	end

	// shift through a chain of flipflop to ensure stability
	always @(posedge clk_out)
		sync <= { sync[DELAY-1:0], flag };

	//assign strobe_out = sync[DELAY] ^ sync[DELAY-1];
    always @(posedge clk_out) begin
	    strobe_out <= sync[DELAY-1] ^ sync[DELAY-2];
	    strobe_out_dup1 <= sync[DELAY-1] ^ sync[DELAY-2];
	    strobe_out_dup2 <= sync[DELAY-1] ^ sync[DELAY-2];
	    strobe_out_dup3 <= sync[DELAY-1] ^ sync[DELAY-2];
	end

    //synthesis attribute strobe_out preserve_signal true
    //synthesis attribute strobe_out_dup1 preserve_signal true
    //synthesis attribute strobe_out_dup2 preserve_signal true
    //synthesis attribute strobe_out_dup3 preserve_signal true


    //assign strobe_out = strobe_out_reg;
	assign data_out = data;
`else
	assign strobe_out = strobe_in;
	assign data_out = data_in;
`endif
endmodule


module dflip(
	input clk,
	input in,
	output out
);
	reg [2:0] d;

	always @(posedge clk)
		d <= { d[1:0], in };
	assign out = d[2];
endmodule
