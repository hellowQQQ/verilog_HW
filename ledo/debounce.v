module debounce(clk,rstn,but_in,but_deb_o);
	input  clk;
	input  rstn;
	input  but_in;
	output but_deb_o;
	
	parameter S0 = 3'h0, S1 = 3'h1,
			  S2 = 3'h2, S3 = 3'h3,
			  S4 = 3'h4, S5 = 3'h5;
			  
	reg  [2:0] cs; //currwnt state
	reg  [2:0] ns; //next stste
	reg [31:0] cnt;//dalay counter
	
	//delay counter
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cnt <= 32'h0;
		else if(cnt == 32'd999999)
			cnt = 32'h0;
		else if(cs == S1)
			cnt <= cnt + 1'b1;
		else if(cs == S4)
			cnt <= cnt + 1'b1;
		else
			cnt <= cnt;
	end
	
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cs <= S0;
		else
			cs <= ns;
	end
	
	always@(*)
	begin
		case(cs)
			S0: if(but_in == 1'b0)    ns <= S1; else ns <= S0;
			S1: if(cnt == 32'd999999) ns <= S2;	else ns <= S1;
			S2: if(but_in == 1'b0)    ns <= S3; else ns <= S0;
			S3: if(but_in == 1'b1)    ns <= S4; else ns <= S3;
			S4: if(cnt == 32'd999999) ns <= S5; else ns <= S4;
			S5: if(but_in == 1'b1)    ns <= S0; else ns <= S3;
		endcase
	end
	
	assign but_deb_o = (cs == S0) ? 1'b1:
					   (cs == S1) ? 1'b1:
					   (cs == S2) ? 1'b1:
					   (cs == S3) ? 1'b0:
					   (cs == S4) ? 1'b0:
					   (cs == S5) ? 1'b0:
					   1'b0;
endmodule