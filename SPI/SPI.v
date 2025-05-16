module SPI (sclk, rstn ,csn,mosi,miso);
	
	input  sclk;
	input  rstn;
	input  miso;
	input  csn;
	output mosi;
	reg [7:0] data;


	always@(posedge sclk or negedge strn)
	begin	
		if (~rstn)
			data = 8'h0;
		else if(csn == 1'b0)
			data = {data[6:0],miso}
		else	
			data <= data;
	end
		
		
endmodule