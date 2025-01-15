module JK_ff
(
	input j,k,clk,rst,set,
	output reg q_out
);
 
	always @ (negedge clk or negedge rst or negedge set)
		begin 
			if(!rst)
				begin q_out <= 0; end
			else if(!set)
				begin q_out <= 1; end 
			else 
				begin 
					case({j,k})
						2'b00:q_out <= q_out;
						2'b01:q_out <= 0;
						2'b10:q_out <= 1;
						2'b11:q_out <= ~q_out;
					endcase
				end
		end
		
endmodule