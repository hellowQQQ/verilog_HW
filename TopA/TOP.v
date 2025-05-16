module TOP(clk,rset,DAT_O,CMP_O);
	input clk;
	input rset;
	output DAT_O;
	wire   [3:0]CNT_M11_O,CNT_M7_O;
	output CMP_O;
	
	
	count count_M7(
			.CLK(clk),
			.RSTN(rset),
			.CNT_O(CNT_M7_O),
			.DAT_O(DAT_O)
	);
	
	count2 count_M11(
			.clk(clk),
			.rset(rset),
			.CNT_O(CNT_M11_O)
	
	);
	
	assign CMP_O = (CNT_M11_O > CNT_M7_O) ? 1'b1:1'b0;
endmodule