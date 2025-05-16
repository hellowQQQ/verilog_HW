module top(
		input 		 clk,
		input 		 rstn,
		output [7:0] ledo
		);
		
		wire [3:0] led_1;
		wire [3:0] led_2;
		assign ledo = {led_1,led_2};
		



    pio u0 (
        .clk_clk       (clk),      //   clk.clk
        .led1_export   (led_1),   //  led1.export
        .reset_reset_n (rstn),    // reset.reset_n
        .led2_export   (led_2)    //  led2.export
    );


	

endmodule 