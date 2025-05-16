`timescale 1ps/1ps
module led_ctrl(
    input          csi_clk,                
    input          rsi_reset,              
	input		   avs_s0_chipselect,  
    input   [2:0]  avs_s0_address,     
    input          avs_s0_read,        
    input          avs_s0_write,       
    output  [31:0] avs_s0_readdata,    
    input   [31:0] avs_s0_writedata,   
    output  [7:0] coe_leds);
reg	[31:0]	addr0_reg,addr4_reg;
wire	addr0_wr_en,addr4_wr_en,addr0_rd_en,addr4_rd_en;
assign	addr0_wr_en = (avs_s0_address == 2'b00) && avs_s0_chipselect && avs_s0_write;
assign	addr4_wr_en = (avs_s0_address == 2'b01) && avs_s0_chipselect && avs_s0_write;
assign	addr0_rd_en = (avs_s0_address == 2'b00) && avs_s0_chipselect && avs_s0_read;
assign	addr4_rd_en = (avs_s0_address == 2'b01) && avs_s0_chipselect && avs_s0_read;
// addr0_reg proc
always@(posedge csi_clk or posedge rsi_reset)
begin
	if(rsi_reset) 
		addr0_reg <= #1 'h0;
	else if(addr0_wr_en)
		addr0_reg <= #1 avs_s0_writedata;
	else
		addr0_reg <= #1 addr0_reg;
end
// addr4_reg proc
always@(posedge csi_clk or posedge rsi_reset)
begin
	if(rsi_reset) 
		addr4_reg <= #1 'h0;
	else if(addr4_wr_en)
		addr4_reg <= #1 avs_s0_writedata;
	else
		addr4_reg <= #1 addr4_reg;
end
assign 	avs_s0_readdata = addr0_rd_en ? addr0_reg :
						  addr4_rd_en ? addr4_reg :
						  'h00;
assign	coe_leds = addr0_reg[7:0];
//assign 	coe_gpio = addr4_reg;
endmodule 
