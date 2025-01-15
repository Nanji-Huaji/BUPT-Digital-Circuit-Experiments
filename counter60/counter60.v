module counter60 (
    input wire clk, rst,
    input wire key, // 启动暂停按键
    output wire [8:0] segment_led_1, segment_led_2 // 数码管输出
  );

  wire clk1h;
  reg [7:0] cnt;
  reg flag;

  // 实例化分频器产生1秒时钟信号
  divide #(
           .WIDTH(24),
           .N(12_000_000)
         ) u1 (
           .clk(clk),
           .rst_n(rst),
           .clkout(clk1h)
         );

  // 产生标志信号
  always @(posedge clk)
    if (!rst)
      flag = 1'b0;
    else if (!key)
      flag = ~flag;
    else
      flag = flag;

  // 产生60进制计数器
  always @(posedge clk1h)
  begin
    // 数码管显示要按照十进制的方式显示
    if (!rst)
      cnt <= 8'h00; // 复位初值显示00
    else if (flag)
    begin
      // 启动暂停标志
      if (cnt[3:0] == 4'd9)
      begin
        // 个位满九？
        cnt[3:0] <= 4'd0; // 个位清零
        if (cnt[7:4] == 4'd5)
          // 十位满五？
          cnt[7:4] <= 4'd0; // 十位清零
        else
          cnt[7:4] <= cnt[7:4] + 1'b1; // 十位加一
      end
      else
        cnt[3:0] <= cnt[3:0] + 1'b1; // 个位加一
    end
    else
      cnt <= cnt;
  end

  // 实例化数码管显示模块
  segment u2 (
            .seg_data_1(cnt[7:4]), // seg_data input
            .seg_data_2(cnt[3:0]), // seg_data input
            .segment_led_1(segment_led_1), // MSB~LSB = SEG,DP,G,F,E,D,C,B,A
            .segment_led_2(segment_led_2)  // MSB~LSB = SEG,DP,G,F,E,D,C,B,A
          );
endmodule
