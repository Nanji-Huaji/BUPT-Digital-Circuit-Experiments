module pattern(
	input clk,            // 时钟信号
	input rst,            // 复位信号
	output [7:0] row,     // 行输出
	output [7:0] colR,    // 红色列输出
	output [7:0] colG);   // 绿色列输出
	
	reg [7:0] r_row;      // 行寄存器
	reg [7:0] r_colR;     // 红色列寄存器
	reg [7:0] r_colG;     // 绿色列寄存器
	reg [11:0] cnt1;      // 计数器，用于计数系统函数，计数1k次更新
	
	// 计数器逻辑
	always@(posedge clk or negedge rst)
	begin
		if(~rst)
			cnt1 <= 0;    // 复位时计数器清零
		else if (cnt1 == 12'd4000) // 计数到4000时清零
			cnt1 <= 0;
		else
			cnt1 <= cnt1 + 1'b1; // 计数器加1
	end
	
	// 行和列的控制逻辑
	always@(posedge clk or negedge rst)
	begin
		if(~rst)
			begin
			r_row  <= 8'b00000000; // 复位时行寄存器清零
			r_colR <= 8'b00011000; // 复位时红色列寄存器初始化
			r_colG <= 8'b00011000; // 复位时绿色列寄存器初始化
			end
		else
			begin
				if(cnt1>12'd0 && cnt1<12'd1000)
					begin
					if( cnt1 % 2 == 0 )
						begin
						r_row  <= 8'b11100111; // 根据计数器值设置行寄存器
						r_colR <= 8'b00011000; // 根据计数器值设置红色列寄存器
						r_colG <= 8'b00011000; // 根据计数器值设置绿色列寄存器
						end
					else
						begin
						r_row  <= 8'b11011011;
						r_colR <= 8'b00100100;
						r_colG <= 8'b00100100;
						end
					end
				else if(cnt1>12'd1000 && cnt1<12'd2000)
					begin
					r_row  <= 8'b11000011;
					r_colR <= 8'b00111100;
					r_colG <= 8'b00111100;
					end
				else if(cnt1>12'd2000 && cnt1 <12'd3000)
					begin
					if(cnt1%2 == 1)
						begin
						r_row  <= 8'b11000011;
						r_colR <= 8'b00111100;
						r_colG <= 8'b00111100;
						end
					else
						begin
						r_row  <= 8'b10111101;
						r_colR <= 8'b01000010;
						r_colG <= 8'b01000010;
						end
					end
				else if(cnt1>12'd3000 && cnt1<12'd4000)
					begin
					r_row  <= 8'b10000001;
					r_colR <= 8'b01111110;
					r_colG <= 8'b01111110;
					end
				else
					begin
					r_row  <= 8'b00000000;
					r_colR <= 8'b00011000;
					r_colG <= 8'b00011000;
					end
			end
	end
	
	// 输出赋值
	assign row = r_row;
	assign colR = r_colR;
	assign colG = r_colG;
	
endmodule
