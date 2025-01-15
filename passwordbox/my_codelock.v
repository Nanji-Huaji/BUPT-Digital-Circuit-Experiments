module my_codelock(clk,rst,key_confirm,key_set,sw_password,led,sega);
 
	input clk;							//时钟
	input rst;							//重置
	input key_confirm;				    //复位键
	input key_set;						//修改密码
	input [3:0] sw_password;		    //四位二进制密码
	output [1:0] led;					//是否解锁指示灯
	output [8:0] sega;				    //右数码管
	
	reg password =4'b0000;			    //初始密码
	
	reg [1:0] sgn;						//两位指示灯信号，对应两路指示灯
	reg [8:0] seg[3:0];				    //9位宽信号，用来储存数码管数字显示器
	reg [8:0] seg_data[1:0];		    //数码管显示信号寄存器
	reg [1:0] cnt;						//计数器，泳衣统计错误次数
	reg lock;							//程序锁，用于结束程序
	
	wire confirm_dbs;					//消抖后确认脉冲
	initial begin						//初始化
	seg[0]<=9'h3f;						//数码管显示数字0
	seg[1]<=9'h06;						//数字1
	seg[2]<=9'h5b;						//数字2
	seg[3]<=9'h4f;						//数字3
	seg_data[0]<=9'h3f;				    //右初始数字显示数字0
	cnt<=2'b10;							//计数器初始值2
	end
	
	always @ (posedge clk or negedge rst)	//时钟边沿触发或复位按键触发
	begin
	if(!rst)									//复位
		begin							
		sgn<=2'b11;								//亮灯均火
		seg_data[0]<=seg[2];					//右显示数字2
		cnt<=2'b10;								//计数器复位到2
		lock<=2'b11;							//程序锁默认状态1（正常）
		end
		
		else if (confirm_dbs && lock)		    //按下确认键，此处用的消抖后的脉冲信号，\
                                                //若程序已锁则不执行
		begin
			if(sw_password == password)	        //密码正确
				begin
				sgn<=2'b10;						//绿灯亮
				seg_data[0]<=9'h40;			    
				seg_data[1]<=9'h40;			    //密码输入正确后两根数码管显示两根横线
				lock=2'b10;					   	//程序锁进入状态2（可调密码）
				end
			else if(cnt==2'b11)
				begin
				sgn<=2'b01;						//红灯亮
				seg_data[0]<=seg[2];			//数码管显示数字2
				cnt<=2'b10;						//计数器移至2
				end
			else if(cnt==2'b10)
				begin
				sgn<=2'b01;						//红灯亮
				seg_data[0]<=seg[1];			//数码管显示数字1
				cnt<=2'b01;						//计数器移至1
				end
			else if(cnt==2'b01)
				begin
				sgn<=2'b00;						//绿灯和红灯同时亮
				seg_data[0]<=seg[0];			//数码管显示数字0
				lock=0;							//程序锁进入状态0（锁死）
				end
		end
	end
	
	assign led=sgn;							    //绿灯代表密码正确，红灯代表密码错误
	assign sega=seg_data[0];				    //右数码管随输入信号变化改变数值
	
	debounce key_confirm_dbs				    //消抖模块，用以消抖确认键
		(    
		.clk(clk),
		.rst(rst),
		.key(key_confirm),
		.key_pulse(confirm_dbs));
endmodule	
