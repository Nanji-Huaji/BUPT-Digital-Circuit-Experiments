module shift_register
(
	input clk,DS,OE,MR,
	input wire ST_CP,
	output reg [7:0] out = 8'b1111_1111,
	output reg Q7 = 1'b1
);
 
	always @ (posedge clk)
		begin 
			if(!MR)
				begin 
					out = 8'b1111_1111;
					Q7 = 1'b1;
				end
			else if(OE)
				begin 
					out <= 8'bzzzz_zzzz;
					Q7 <= 1'bz;
				end
			else if(SH_CP)
				begin 
					out[0] <= !DS;
					out[7:1] <= out[6:0];
					Q7 <= out[7];
				end
		end
	debounce debounce_1
	(
		.clk(clk),
		.rst(MR),
		.key(ST_CP),
		.key_pulse(SH_CP)
	);
				
 
endmodule