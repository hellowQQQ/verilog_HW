module Ct (clk,rset,count);
	input clk;
	input rset;
	output  [2:0]count;
	reg 	[2:0]count;
	always@(posedge clk or negedge rset)
	begin
		if(rset == 0)
			count <= 3'b000;
		else
			count <= count + 3'b001;
	end
endmodule