module count2(clk,rset,CNT_O);
	input 		 clk;
	input        rset;
	output [3:0] CNT_O;
	reg    [3:0] CNT_O;
	
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			CNT_O <= 4'h0;
		else if(CNT_O == 4'hb)
			CNT_O <= 4'h0;
		else
			CNT_O <= CNT_O + 1'b1;
	end
endmodule