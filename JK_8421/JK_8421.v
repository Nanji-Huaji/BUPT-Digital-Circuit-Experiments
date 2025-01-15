module JK_8421
(
	input clk,rst,btn,set,
	output [3:0] Q,
	output [8:0] seg_led
);
 
	reg [8:0] seg [9:0];
	
	debounce debounce_1
	(
		.clk(clk),
		.rst(rst),
		.key(btn),
		.key_pulse(btn_dbs)
	);
	
	JK_ff JK1
	(
		.j(1),
		.k(1),
		.clk(btn_dbs),
		.rst(rst),
		.set(set),
		.q_out(Q[0])
	);
	
	JK_ff JK2
	(
		.j(~Q[3]),
		.k(~Q[3]),
		.clk(Q[0]),
		.rst(rst),
		.set(set),
		.q_out(Q[1])
	);
	
	JK_ff JK3
	(
		.j(1),
		.k(1),
		.clk(Q[1]),
		.rst(rst),
		.set(set),
		.q_out(Q[2])
	);
	
	JK_ff JK4
	(
		.j(Q[2]&Q[1]),
		.k(Q[3]),
		.clk(Q[0]),
		.rst(rst),
		.set(set),
		.q_out(Q[3])
	);
	initial
		begin 
			seg[0] = 9'h3f;
			seg[1] = 9'h06;
			seg[2] = 9'h5b;
			seg[3] = 9'h4f;
			seg[4] = 9'h66;
			seg[5] = 9'h6d;
			seg[6] = 9'h7d;
			seg[7] = 9'h07;
			seg[8] = 9'h7f;
			seg[9] = 9'h6f;
		end	
	assign seg_led = seg[Q];
	
endmodule	
	