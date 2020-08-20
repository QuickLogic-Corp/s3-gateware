/* ----------------------------------------------------------------------------
clk_switch.v
A glitch-free clock mux.

Based on the design descirbed here:
https://www.eetimes.com/techniques-to-make-clock-switching-glitch-free/
---------------------------------------------------------------------------- */


module clk_switch (
    input   sel,
    input   clk_in0,
    input   clk_in1,
    output  clk_out
);

reg     dff_clk0p;
reg     dff_clk0n;
reg     dff_clk1p;
reg     dff_clk1n;

always @(posedge clk_in0)
    dff_clk0p <= (!sel && !dff_clk1n);

always @(negedge clk_in0)
    dff_clk0n <= dff_clk0p;

always @(posedge clk_in1)
    dff_clk1p <= (sel && !dff_clk0n);

always @(negedge clk_in1)
    dff_clk1n <= dff_clk1p;

assign clk_out = (dff_clk1n && clk_in1) || (dff_clk0n && clk_in0);

endmodule

