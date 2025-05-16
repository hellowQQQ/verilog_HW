module count(CLK,RSTN,CNT_O,DAT_O);
	input       RSTN;
	input       CLK;
	output [3:0]CNT_O;
	output      DAT_O;
	reg    [3:0]CNT_O;
	
	always@(posedge CLK or negedge RSTN)
	begin
		if (~RSTN)
			CNT_O <= 4'b0000;
		else if ( CNT_O == 4'b0111)
			CNT_O <= 4'b0000;
		else
			CNT_O <= CNT_O + 1'b1;
	end
	
	assign DAT_O = (CNT_O >= 4'b0010 && CNT_O <= 4'b0101) ? 1'b1 :1'b0;

endmodule