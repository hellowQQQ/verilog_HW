module bulb(clk,rset,lamp);
	input 		clk;
	input 		rset;
	output [4:0]lamp;
	reg    [4:0]lamp;
	reg    [2:0]count;

	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			count <= 3'b000;
		else if(count == 3'b100)
			count <= 3'b001;
		else
			count <= count + 3'b001;
	end
	
	always@(posedge clk or negedge rset)
	begin
		if(count == 3'b001)
			lamp[1] = 1'b01;
		else
			lamp[1] = 1'b00;
	end
	
	always@(posedge clk or negedge rset)
	begin
		if(count == 3'b010)
			lamp[2] = 1'b01;
		else
			lamp[2] = 1'b00;
	end
	
	always@(posedge clk or negedge rset)
	begin
		if(count == 3'b011)
			lamp[3] = 1'b01;
		else
			lamp[3] = 1'b00;
	end
	
	always@(posedge clk or negedge rset)
	begin
		if(count == 3'b100)
			lamp[4] = 1'b01;
		else
			lamp[4] = 1'b00;
	end
	
endmodule