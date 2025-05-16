module tb_count();
	reg clk;
	reg rset;
	wire CMP_O;
	wire DAT_O;
	
	always
	begin
		#10 clk = ~clk;
	end
	
	TOP count(
			.clk(clk),
			.rset(rset),
			.DAT_O(DAT_O),
			.CMP_O(CMP_O)
	);
	

	
	
	initial
	begin
		clk  = 1'b0;
		rset = 1'b0;
		#100 rset = 1'b1;
		repeat(100) @(posedge clk)
		#1000 $stop;
	end
	
	
endmodule