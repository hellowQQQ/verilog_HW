`timescale 1ns/1ns
module tb_bulb();
	reg clk;
	reg rset;
	wire [3:0]lamp;
	
	always
	begin
		#10 clk = ~clk;
	end
	
	bulbb duv(
		.clk (clk),
		.rset(rset),
		.lamp(lamp)
	);
	
	initial
	begin
		clk  = 1'b0;
		rset = 1'b0;
		#100 rset = 1'b1;
		#345  rset = 1'b0;
		#500 $stop;
	end
	
	
endmodule