module divide
  #(
     // parameter是verilog里参数定义
     parameter WIDTH = 24,
     parameter N = 12_000_000       // 分频系数
   )
   (
     input clk,                     // clk连接到FPGA的C1脚，频率为12MHz
     input rst_n,                   // 复位信号，低有效
     output clkout                  // 输出信号，可以连接到LED观察分频的时钟
   );
  reg [WIDTH-1:0] cnt_p, cnt_n;
  reg clk_p, clk_n;

  // 上升沿触发时计数器的控制
  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      cnt_p <= 1'b0;
    else if (cnt_p == (N-1))
      cnt_p <= 1'b0;
    else
      cnt_p <= cnt_p + 1'b1;
    // 计数器一直计数，当计数到N-1的时候清零，这是一个模N的计数器
  end

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
      clk_p <= 1'b0;
    else if (cnt_p < (N >> 1))
      // N >> 1表示右移一位，相当于除以2取商
      clk_p <= 1'b0;
    else
      clk_p <= 1'b1;
    // 得到的分频时钟正周期比负周期多一个clk时钟
  end

  // 下降沿触发时计数器的控制
  always @(negedge clk or negedge rst_n)
  begin
    if (!rst_n)
      cnt_n <= 1'b0;
    else if (cnt_n == (N-1))
      cnt_n <= 1'b0;
    else
      cnt_n <= cnt_n + 1'b1;
  end
  // 下降沿触发的分频时钟输出，和clk_p相差半个clk时钟
  always @(negedge clk or negedge rst_n)
  begin
    if (!rst_n)
      clk_n <= 1'b0;
    else if (cnt_n < (N >> 1))
      clk_n <= 1'b0;
    else
      clk_n <= 1'b1;
    // 得到的分频时钟正周期比负周期多一个clk时钟
  end
  wire clk1 = clk; // 当N=1时，直接输出clk
  wire clk2 = clk_p;
  // 当N为偶数也就是N的最低位为0，N[0]=0，输出clk_p
  wire clk3 = clk_p & clk_n;
  // 当N为奇数也就是N最低位为1，N[0]=1，输出clk_p & clk_n。正周期多所以是相与
  assign clkout = (N == 1) ? clk1 : (N[0] ? clk3 : clk2); // 条件判断表达式
endmodule
