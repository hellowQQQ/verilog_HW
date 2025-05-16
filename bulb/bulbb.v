module bulbb(clk,rset,lamp);
	input 		clk;
	input 		rset;
	output [3:0]lamp;
	reg    [3:0]lamp;
	reg    [2:0]count;

	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			count <= 3'b000;
		else if(count == 3'b100)
			count <= 3'b001; 
		else
			count <= count + 1'b1;
	end
	
	always@(*)
	begin
		case(count)
			3'b000 : lamp = 4'b0000;
			3'b001 : lamp = 4'b0001;
			3'b010 : lamp = 4'b0010;
			3'b011 : lamp = 4'b0100;
			3'b100 : lamp = 4'b1000;
			default: lamp = 4'b0000;
		endcase
	end
	
endmodule