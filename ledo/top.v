module top(clk,rstn,but_in,ledo);
	input       clk;
	input       rstn;
	input       but_in;
	output [3:0]ledo;
	wire        but_deb_o;
	reg         but_deb_o_1d;
	wire        but_deb_nedge;
	reg    [1:0]cs;
	reg    [1:0]ns;
	
	parameter S1 = 2'h0, S2 = 2'h1,
			  S3 = 2'h2, S4 = 2'h3;
	
	
	debounce debounce(
			.clk(clk),
			.rstn(rstn),
			.but_in(but_in),
			.but_deb_o(but_deb_o)
	);
	
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			but_deb_o_1d <= 1'b0;
		else
			but_deb_o_1d <= but_deb_o;
	end
	
	assign but_deb_nedge = (but_deb_o_1d && ~but_deb_o);
	
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cs <= S1;
		else
			cs <= ns;
	end
	
	always@(*)
	begin
		case(cs)
			S1: if(but_deb_nedge) ns = S2; else ns = S1; 
			S2:	if(but_deb_nedge) ns = S3; else ns = S2; 
			S3: if(but_deb_nedge) ns = S4; else ns = S3; 
			S4: if(but_deb_nedge) ns = S1; else ns = S4; 
		endcase
	end
	
	assign ledo = (cs == S1) ? 4'b0001:
				  (cs == S2) ? 4'b0010:
				  (cs == S3) ? 4'b0100:
				  (cs == S4) ? 4'b1000:
				  4'b0000;
endmodule