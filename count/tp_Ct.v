`timescale 1ns/1ns
module tp_Ct();
reg clk;
reg rset;
wire [2:0]count;

always
begin
	#10 clk = ~clk;
end

Ct duv(
	.clk(clk),
	.rset(rset),
	.count(count)
);

initial
begin
	clk = 1'b0;
	rset = 1'b0;
	#100 rset = 1'b1;
	#500 $stop;
	
end

endmodule