module i2c_master(clk,rstn,sda,data_o)
	
	input        clk;
	inout 		 scl;
	inout 		 sda;
	input 		 rstn;
	output       data_o;
	reg 	[7:0]cntbit;
	reg     [1:0]cntcase;
	wire		 cntbit_p;
	wire		 cntcase_p;
	reg			 scl_s;
	reg			 sda_s;
	
	reg     [7:0]devadr;
	reg     [7:0]crtadr;
	reg     [7:0]wrdata;
	
	reg		[7:0]cs;
	reg     [7:0]ns;
	reg     [3:0]count;
	
	tri1 scl = (scl_s) ? 1'bz : 1'b0;
	tri1 sda = (sda_s) ? 1'bz : 1'b0;
	
	wire 		 swrite;
	wire         sread;
	
	parameter  ini 		  = 8'h00,
			   start_w 	  = 8'h01,
			   w_adr      = 8'h02,
			   w_adr_a    = 8'h03,
			   w_ct_adr   = 8'h04,
			   w_ct_adr_a = 8'h05,
			   w_data	  = 8'h06,
			   w_data_a	  = 8'h07,
			   start_r    = 8'h08,
			   r_adr1	  = 8'h09,
			   r_adr1_a   = 8'h0A,
			   r_ct_adr   = 8'h0B,
			   r_ct_adr_a = 8'h0C,
			   restart    = 8'h0D,
			   r_adr2	  = 8'h0E,
			   r_adr2_a   = 8'h0F,
			   r_data	  = 8'h10,
			   r_data_a	  = 8'h11,
			   stop		  = 8'h12;
			   
	i2c_salve i2csalve(
			.clk(clk),
			.rstn(rstn),
			.scl(scl),
			.sda(sda),
			.swrite(swrite),
			.sread(sread)
	);
			   
	
	// 50Mhz -> 400kHz
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cntbit <= 0;
		else if(cntbit == 124)
			cntbit <= 'h0;
		else
			cntbit <= cntbit + 1'h1;
	end
	assign cntbit_p = (cntbit == 124) ? 1'b1 : 1'b0;
	
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cntcase <= 'h0;
		else if(cntbit_p)
			if (cntcase == 'h3)
				cntcase <= 'h0;
			else
				cntcase <= cntcase + 1'h1;
		else
			cntcase <= cntcase;
	end
	assign cntcase_p = ( cntbit_p && cntcase == 'h3) ? 1'b1:1'b0;
	
	always@(*)
	begin
		case(cs)
			ini  		: count <= 'h0;
		    start_w 	: count <= 'h1;
		    w_adr       : count <= count + 1;
		    w_adr_a     : count <= 'h1;
		    w_ct_adr    : count <= count + 1;
		    w_ct_adr_a  : count <= 'h1;
		    w_data	    : count <= count + 1;
			w_data_a	: count <= 'h1;
		    start_r     : count <= 'h1;
		    r_adr1	    : count <= count + 1;
		    r_adr1_a    : count <= 'h1;
		    r_ct_adr    : count <= count + 1;
		    r_ct_adr_a  : count <= 'h1;
		    restart     : count <= 'h1;
		    r_adr2	    : count <= count + 1;
		    r_adr2_a    : count <= 'h1;
		    r_data	    : count <= count + 1;
			r_data_a	: count <= 'h1;
		    stop        : count <= 'h0;
		
		endcase
	end
	
	
	
	always@(posedge clk or negedge rstn)
	begin
		if(~rstn)
			cs <= ini;
		else if(cntcase_p)
			cs <= ns;
		else
			cs <= cs;
	end
	
	always@(*)
	begin 
		case(cs)
			ini 	    :if(swrite)
						    ns <= start_w;
						 else if(sread)
						    ns <= start_r;
						 else
						    ns <= ini;
			//write
			start_w 	:									     ns <= w_adr;
			w_adr       :if(count == 'h8) ns <= w_adr_a   ; else ns <= w_adr;
			w_adr_a     : 									     ns <= w_ct_adr;
			w_ct_adr    :if(count == 'h8) ns <= w_ct_adr_a; else ns <= w_ct_adr;
			w_ct_adr_a  :										 ns <= w_data;
			w_data	    :if(count == 'h8) ns <= w_data_a  ; else ns <= w_data; 
			w_data_a	:										 ns <= stop; 
			
			//read
			start_r     :									     ns <= r_adr1; 
			r_adr1	    :if(count == 'h8) ns <= r_adr1_a  ; else ns <= r_adr1; 
			r_adr1_a    :									     ns <= r_ct_adr; 
			r_ct_adr    :if(count == 'h8) ns <= r_ct_adr_a; else ns <= r_ct_adr; 
			r_ct_adr_a  :										 ns <= restart; 
			restart     : 										 ns <= r_adr2;
			r_adr2	    :if(count == 'h8) ns <= r_adr2_a  ; else ns <= r_adr2; 
			r_adr2_a    :										 ns <= r_data; 
			r_data	    :if(count == 'h8) ns <= r_data_a  ; else ns <= r_data; 
			r_data_a	:										 ns <= stop;  
			stop        : 										 na <= ini;
		endcase
	end
	
	always@(*)
	begin
		if(~rstn)
			scl_s <= 1'b1;
		else
			case(*)
				ini       :  						   scl_s <= 1'b1;
				start_w   : if     (cntcase == 'h0)    scl_s <= 1'b1; 
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				start_r   : if     (cntcase == 'h0)    scl_s <= 1'b1; 
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_adr     : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_adr_a   : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_ct_adr  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_ct_adr_a: if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_data    : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				w_data_a  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				r_adr1    : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
				r_adr1_a  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_ct_adr  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_ct_adr_a: if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    restart   : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_adr2    : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_adr2_a  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_data    : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    r_data_a  : if     (cntcase == 'h1)	   scl_s <= 1'b1;
						    else if(cntcase == 'h3)    scl_s <= 1'b0;
			    stop      : if     (cntcase == 'h1)	   scl_s <= 1'b1;
				default:		   					   scl_s <= scl_s;
			endcase
	end
	
	always@(*)
	begin
		if(~rstn)
			sda_s <= 1'b1;
		else
			case(*)
				ini       :  						    sda_s <= 1'b1;
				start_w   : if     (cntcase == 'h0)     sda_s <= 1'b1; 
						    else if(cntcase == 'h2)     sda_s <= 1'b0;
				start_r   : if     (cntcase == 'h0)     sda_s <= 1'b1; 
						    else if(cntcase == 'h2)     sda_s <= 1'b0;
				w_adr     : if     (cntcase == 'h0)     sda_s <= devadr[7]; 
				w_adr_a   : 							sda_s <= 1'b1;
				w_ct_adr  : if     (cntcase == 'h0)     sda_s <= crtadr[7];
				w_ct_adr_a:								sda_s <= 1'b1;
				w_data    : if     (cntcase == 'h0)     sda_s <= wrdata[7]; 
				w_data_a  : 							sda_s <= 1'b1;
				
				start_r   : if     (cntcase == 'h0)     sda_s <= 1'b1; 
						    else if(cntcase == 'h2)     sda_s <= 1'b0;
				r_adr1    : if     (cntcase == 'h0)     sda_s <= devadr[7]; 
				r_adr1_a  :								sda_s <= 1'b1;
				r_ct_adr  : if     (cntcase == 'h0)     sda_s <= crtadr[7];
				r_ct_adr_a:								sda_s <= 1'b1;
				restart   : if     (cntcase == 'h0)     sda_s <= 1'b1;
							else if(cntcase == 'h2)     sda_s <= 1'b0;
				r_adr2    : if     (cntcase == 'h0)     sda_s <= devadr[7]; 
				r_adr2_a  :								sda_s <= 1'b1;
				stop      :	if     (cntcase == 'h0)		sda_s <= 1'b0;
							else   (cntcase == 'h2)     sda_s <= 1'b1;
						    default                     sda_s <= sda_s;
			endcase
	end
	
	

	


endmodule