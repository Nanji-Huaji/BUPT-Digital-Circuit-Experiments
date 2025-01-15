module stepfpga(clk, rst, key, seg_led_1, seg_led_2);
  input clk;
  input rst;
  input key;
  output [8:0] seg_led_1;
  output [8:0] seg_led_2;
  reg [8:0] seg[9:0];
  reg [7:0] counter;  //计数器，由于最高显示到99，所以只需要8位
  initial
  begin
    seg[0] = 9'h3f; //显示数字0
    seg[1] = 9'h06; //显示数字1
    seg[2] = 9'h5b; //显示数字2
    seg[3] = 9'h4f; //显示数字3
    seg[4] = 9'h66; //显示数字4
    seg[5] = 9'h6d; //显示数字5
    seg[6] = 9'h7d; //显示数字6
    seg[7] = 9'h07; //显示数字7
    seg[8] = 9'h7f; //显示数字8
    seg[9] = 9'h6f; //显示数字9
  end
  always @(posedge clk or negedge rst)
  begin
    if(!rst)
    begin
      counter <= 8'h00;
    end
    else
    begin
      if(key_pulse)
      begin
        if(counter < 100)
        begin
          counter <= counter + 1;
        end
        else
        begin
          counter <= 8'h00;
        end
      end
    end
  end
  assign seg_led_1 = seg[counter / 10];   //显示十位
  assign seg_led_2 = seg[counter % 10];   //显示个位
  debounce u1(.clk (clk), //实例化按键去抖模块
              .rst (rst),
              .key (key),
              .key_pulse (key_pulse));
endmodule
