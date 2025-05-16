module clock(clk,rset,sec,min,hour);
	input        clk;
	input        rset;
	output [7:0] sec;
	output [7:0] min;
	output [7:0] hour;
	reg    [32:0]bbit;
	reg    [7:0] sec, min, hour;
	wire 		 onesec, onemin, onehour, oneday;


	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			bbit <= 32'h0;
		else if (bbit == 32'd49999999)
			bbit <= 32'h0;
		else
			bbit <= bbit +1'b1;
	end
	assign onesec = (bbit == 32'd49999999) ? 1'b1 ; 1'b0;
	
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			sec <= 8'h0;
		else if(onesec)
			if (sec == 8'd59)
				sec <= 8'h0;
			else
				sec <= sec + 1'b1;
		else
			sec <= sec;
	end
	assign onemin = (sec == 8'd59 && (onesec)) ? 1'b1 ; 1'b0;
	
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			min <= 8'h0;
		else if(onemin)
			if (min == 8'd59)
				min <= 8'h0;
			else
				min <= min + 1'b1;
		else
			min <= min;
	end
	assign onehour = (min == 8'd59 && (onemin)) ? 1'b1 ; 1'b0;
	
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			hour <= 8'h0;
		else if(onehour)
			if(hour == 8'd23)
				hour <= 8'h0;
			else
				hour <= hour + 1'b1;
		else
			hour <= hour;
	end
	assign oneday = (hour == 8'd23 && (onehour)) ? 1'b1 : 1'b0;
	

endmodule