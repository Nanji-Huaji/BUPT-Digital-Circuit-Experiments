// 模块定义: pwm
// 该模块实现一个简单的脉宽调制（PWM）发生器。
module pwm(out,duty,clk);
  input [7:0] duty;   // 输入，表示占空比，范围从0到255
  input clk;         // 输入，时钟信号用于同步
  output reg out;     // 输出信号，表示PWM波形
  reg [7:0] buffer;      // 8位寄存器，用于存储当前计数值

  always @ (posedge clk)
  begin
    buffer <= buffer + 1;// 在每个时钟上升沿递增缓冲区值
    if (buffer < duty)// 将缓冲区值与占空比进行比较:如果缓冲区小于占空比，则将输出设置为0；否则，设置为1。
    begin
      out <= 0;
    end
    else
    begin
      out <= 1;
    end
  end
endmodule

