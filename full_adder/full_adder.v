module full_adder(sw,cal,key_confirm_1,key_confirm_2,seg_led1,seg_led2,clk,rst_n);
	input clk;
	input rst_n;
	input [3:0]sw;
	input cal;
	input key_confirm_1;
	input key_confirm_2;
	output reg [8:0] seg_led1;
	output reg [8:0] seg_led2;
	
	reg[8:0]seg[15:0];
	initial
	begin
		seg[0]=9'h3f;
		seg[1]=9'h06;
		seg[2]=9'h5b;
		seg[3]=9'h4f;
		seg[4]=9'h66;
		seg[5]=9'h6d;
		seg[6]=9'h7d;
		seg[7]=9'h07;
		seg[8]=9'h7f;
		seg[9]=9'h6f;
		seg[10]=9'h77;
		seg[11]=9'h7c;
		seg[12]=9'h39;
		seg[13]=9'h5e;
		seg[14]=9'h79;
		seg[15]=9'h71;
	end
	
	reg [3:0] a;
	reg [3:0] b;
	reg iscal;
	wire [3:0] ans;
	wire cout;
	wire ci;
	
	always@(*)
	begin
		if(rst_n==0)
			begin
				a=4'b0000;
				b=4'b0000;
				iscal=0;
			end
		if(key_confirm_1==0)
			begin
				a=sw;
			end
		if(key_confirm_2==0)
			begin
				b=sw;
			end
		if(cal==0)
			begin
				iscal=1;
			end
	 end
	four_adder u5(.a(a),.b(b),.s(ans),.ci(ci),.cout(cout));
	always@(posedge clk)
	begin
		if(iscal)
			begin
				seg_led1<=seg[ans];
				seg_led2<=seg[cout];
			end
		else
			begin
				seg_led1<=seg[a];
				seg_led2<=seg[b];
			end
	end
endmodule
				