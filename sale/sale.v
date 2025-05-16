module sale(clk,rset,sl,slif,count);
	input 		clk;
	input 		rset;
	input  [1:0]slif;
	output [3:0]sl;
	output [1:0]count;
	reg    [3:0]sl;
	reg    [1:0]count;
	
	always@(posedge clk or negedge rset)
	begin
		if (~rset)
			count <= 2'b00;
		else if (count == 2'b00 )
			if (slif[0])
				count <= count + 2'b01;
			else
				count <= 2'b00;
		else if (count == 2'b01 )
			if (slif[1])
				count <= count + 2'b01;
			else
				count <= count;
		else
			count <= count + 2'b01;
	end
	
	always@(posedge clk )
	begin 
		if (~rset)
			sl[0] = 1'b0;
		else if (count == 2'b00 && slif[0] == 1'b1)
			sl[0] = 1'b1;
		else
			sl[0] = 1'b0;
	end

	always@(posedge clk )
	begin 
		if(count == 2'b01 && slif[1] == 1'b01)
			sl[1] = 1'b1;
		else
			sl[1] = 1'b0;
	end
	
	always@(posedge clk )
	begin
		if(count == 2'b10)
			sl[2] = 1'b1;
		else
			sl[2] = 1'b0;
	end
	
	always@(posedge clk )
	begin
		if(count == 2'b11)
			sl[3] = 1'b1;
		else
			sl[3] = 1'b0;
	end

endmodule