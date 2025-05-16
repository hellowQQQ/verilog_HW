
module pio (
	clk_clk,
	led1_export,
	reset_reset_n,
	led2_export);	

	input		clk_clk;
	output	[3:0]	led1_export;
	input		reset_reset_n;
	output	[7:0]	led2_export;
endmodule
