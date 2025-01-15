// car_rearlight.v 汽车尾灯控制模块
module car_rearlight(
    input wire clk,
    input wire rst_n,
    // 输入状态
    input wire[3:0] state_in,
    // 左转指示灯
    output reg[2:0] led_left,
    
    // 右转指示灯
    output reg[2:0] led_right,
    output reg[2:0] led_right_white,
    // 流水显示
    output reg[7:0] led_flow
  );
  // 车辆行驶状态
  // STOP 停止
  // GO 行驶
  // LEFT 左转
  // RIGHT 右转
  // BACK 倒车
  localparam STOP = 4'b1111;
  localparam GO = 4'b1110;
  localparam LEFT = 4'b1101;
  localparam RIGHT = 4'b1011;
  localparam BACK = 4'b0111;
  // 车辆处于以上各状态时，LED的亮灭
  localparam stop = 8'b0000_0000;
  localparam left = 8'b1111_0000;
  localparam right = 8'b0000_1111;
  localparam on = 3'b101;
  localparam off = 3'b111;

  // 用于控制转向时的闪烁
  wire[2:0] blink;

  // 车辆前进
  reg[7:0] go = 8'b0111_1111;
  reg[7:0] back = 8'b1111_1110;

  // 现态与次态
  reg[3:0] current_state;
  reg[3:0] next_state;

  //
  parameter dp_1Hz = 5000_0000;
  parameter dp_8Hz =  625_0000;
  wire clkout_1Hz;

  // 分频产生频率为1Hz的时钟（divide模块代码已在之前章节给出）
  divide #(
           .WIDTH(30),
           .N(dp_1Hz)
         ) divide_1Hz(
           .clk(clk),
           .rst_n(rst_n),
           .clkout(clkout_1Hz)
         );

  // 通过计数，产生频率为8Hz的时钟，用于驱动LED流水显示
  reg[27:0] cnt_8Hz = 28'b0;
  always@(posedge clk)
  begin
    cnt_8Hz <= cnt_8Hz + 1;
    if(cnt_8Hz == dp_8Hz + 1)
    begin
      cnt_8Hz <= 0;
    end
  end


  // 每秒闪烁1次
  assign blink = {1'b1, clkout_1Hz, 1'b1};

  // GO状态时，LED向前流水显示
  always@(posedge clk)
  begin
    if (!rst_n)
    begin
      go <= 8'b0111_1111;
    end
    else
    begin
      if (cnt_8Hz == dp_8Hz)
      begin
        go <= {go[0], go[7:1]};
      end
      else
      begin
        go <= go;
      end
    end
  end

  // BACK状态时，LED向后流水显示
  always@(posedge clk)
  begin
    if (!rst_n)
    begin
      back <= 8'b0111_1111;
    end
    else
    begin
      if (cnt_8Hz == dp_8Hz)
      begin
        back <= {back[6:0], back[7]};
      end
      else
      begin
        back <= back;
      end
    end
  end

  // 接收输入的状态，作为次态
  always@(*)
  begin
    next_state <= state_in;
  end

  // 状态转换
  always@(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      // 若复位信号有效，状态变为STOP
      current_state <= STOP;
    end
    else
    begin
      // 正常情况下，现态被次态覆盖
      current_state <= next_state;
    end
  end

  // 输出
  always@(current_state)
  begin
    if (!rst_n)
    begin
      // 复位
      led_left <= blink;
      led_right <= blink;
      led_flow <= stop;
    end
    else
    begin
      // LED在各状态下的输出
      case(current_state)
        STOP:
        begin
          led_left <= blink;
          led_right <= blink;
          led_flow <= stop;
        end
        GO:
        begin
          led_left <= on;
          led_right <= on;
          led_flow <= go;
        end
        LEFT:
        begin
          led_left <= blink;
          led_right <= off;
          led_flow <= left;
        end
        RIGHT:
        begin
          led_left <= off;
          led_right <= blink;
          led_flow <= right;
        end
        BACK:
        begin
          led_left <= off;
          led_right <= off;
          led_flow <= back;
        end
        default:
        begin
          led_left <= blink;
          led_right <= blink;
          led_flow <= stop;
        end
      endcase
    end
  end
endmodule
