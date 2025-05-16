module f_bulbb(clk,rset,but_in,ledo);
	input 	 	 clk;
	input 	 	 rset;
	input 		 but_in;
	output [3:0] ledo;
	wire         but_deb_o;
	reg    [3:0] cs;
	reg    [3:0] ns;
	reg    [31:0]sec;	
	wire         onesec;
	reg          but_deb_o1d;	
	wire         but_deb_nedge;
	
	parameter  S0 = 4'h0,
			   S1 = 4'h1,
			   S2 = 4'h2,
			   S3 = 4'h3,
			   S4 = 4'h4;
	

	debounce debounce(
			.clk(clk),
			.rstn(rset),
			.but_in(but_in),
			.but_deb_o(but_deb_o)
	);
	
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			but_deb_o1d <= 1'b0;
		else 
			but_deb_o1d <= but_deb_o;
	end
	assign but_deb_nedge = (but_deb_o1d && ~but_deb_o);

    // onesec set
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			sec <= 'h0;
		else if (sec == 32'd49999999)
			sec <= 32'h0;
		else
			sec <= sec + 1'b1;
	end
	assign onesec = (sec == 32'd49999999) ? 1'b1 : 1'b0;
	
	//onesec change
	always@(posedge clk or negedge rset)
	begin
		if(~rset)
			cs <= S0;
		else if(cs == S0)
			cs <= ns;
		else if(onesec)
			cs <= ns;
		else
			cs <= cs;
	end
	

	//star or stop
	
	always@(*) 
	begin
		case(cs)
			S0 :  if(but_deb_nedge) ns = S1; else ns <= cs;
			S1 :  if(onesec)        ns = S2; else ns <= cs;
			S2 :  if(onesec)        ns = S3; else ns <= cs;
			S3 :  if(onesec)        ns = S4; else ns <= cs;
			S4 :  if(onesec)        ns = S1; else ns <= cs;
			default: ns = S0;
		endcase
	end 
	
	assign ledo = (cs == S0) ? 4'b0000 :
				  (cs == S1) ? 4'b0001 :
				  (cs == S2) ? 4'b0010 :
				  (cs == S3) ? 4'b0100 :
				  (cs == S4) ? 4'b1000 :
				  4'b0000;
endmodule

