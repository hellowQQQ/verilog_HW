`timescale 1ns/1ns

module tb_sale();
	reg        clk;
	reg 	   rset;
	reg  [1:0] slif;
	wire [3:0] sl;
	wire [1:0] count;

	
	always
	begin
		#10 clk = ~clk;
	end
	
	sale duv(
		.clk(clk),
		.rset(rset),
		.sl(sl),
		.slif(slif),
		.count(count)
	);
	
	initial
	begin
		clk  = 1'b0;
		rset = 1'b0;
		slif = 2'b00;
		#1 rset = 1'b1;
		#16 slif[0] = 1'b1;
		#22 slif[0] = 1'b0;
		#33  slif[1] = 1'b1;
		#22 slif[1] = 1'b0;
		#250 $stop;
	end

endmodule