// 模块: my_codelock
// 描述: 该模块表示一个代码锁系统，具有用于控制LED和7段显示器的各种输入和输出。
// 
// 输入:
// - clk: 时钟信号输入。
// - sw: 4位开关输入。
// - key: 4位按键输入。
//
// 输出:
// - RGB_led_R: 用于控制右侧RGB LED的3位输出。
// - RGB_led_L: 用于控制左侧RGB LED的3位输出。
// - seg1: 用于控制第一个7段显示器的9位输出。
// - seg2: 用于控制第二个7段显示器的9位输出。
// - led: 用于控制其他LED的8位输出。
//
// 参数:
// - N: 表示确认信号数量的参数（默认值为2）。
//
// 内部连线:
// - confirm: 确认信号的连线数组，大小为N-1。

// 使用方法：
// 灯光说明：密码箱未启动时，LED显示为一红一绿；密码箱正确时，LED显示为两绿；密码箱错误时，LED显示为一红；密码箱锁死时，LED显示为两红。
// 初始密码为0000。
module my_codelock(clk,sw,key,RGB_led_L,RGB_led_R,led,seg1,seg2);

  input clk;
  input [3:0]sw;
  input [3:0]key;
  output reg [2:0]RGB_led_R;
  output reg [2:0]RGB_led_L;
  output reg [8:0]seg1;
  output reg [8:0]seg2;
  output reg [7:0]led;

  parameter N=2;

  wire [N-1:1]confirm;

  //key0:rst   key1:confirm
  //RGB:错误时亮一个红色，锁死时两个红，正确时两个绿，未启动一红一绿

  debouncce u1(
              .clk(clk),
              .rst(key[0]),
              .key(key[3:1]),
              .key_pulse(confirm)
            );
  // 实例化消抖模块

  reg password;
  reg [2:0]sgn_RGB_led_R;
  reg [2:0]sgn_RGB_led_L;
  reg [2:0]lock;
  reg [7:0]sgn_led;
  reg [6:0]seg[9:0];
  reg start;

  initial
  begin
    sgn_led=8'b00_000_000;
    sgn_RGB_led_L=3'b110;
    sgn_RGB_led_R=3'b101;
    password=4'b0000;//初始密码为0000
    lock=3'b100;
    start=0;
    cnt_ge=0;
    cnt_shi=0;
    res=2;
  end

  // 这个 always 块在时钟信号 (clk) 的上升沿触发。
  // 如果 start 信号为高或 sw 信号与密码匹配，它会继续执行。
  // 如果 cnt_ge 和 cnt_shi 的和为零，它会执行以下操作：
  // - 将 sgn_led 设置为 8'b0000_0000。
  // - 将 sgn_RGB_led_L 设置为 3'b110。
  // - 将 sgn_RGB_led_R 设置为 3'b101。
  // - 将 lock 设置为 3'b100。
  //   // - 将 start 信号重置为 0。
  // - 将 lock 设置为 3'b100。
  // - 将 start 信号重置为 0。
  always@(posedge clk)
  begin
    if(!key[0])
    begin
      if(start==1||sw==password)
      begin

        if(cnt_ge+cnt_shi==0)
        begin
          sgn_led=8'b0000_0000;
          sgn_RGB_led_L=3'b110;
          sgn_RGB_led_R=3'b101;
          lock=3'b100;
          start=0;
        end
      end
    end

   // 这个代码块处理密码锁系统的确认和锁定机制。
   // 当确认信号激活且锁定时，执行以下操作：
   // - 如果开关输入 (sw) 与密码匹配，锁定设置为 3'b111，RGB LED 设置为 3'b101，
   //   所有信号 LED 关闭，启动信号设置为 2。
   // - 如果锁定为 3'b100，锁定减 1，RGB LED 设置为 3'b111 和 3'b110，
   //   信号 LED 设置为 8'b1100_0000，启动信号设置为 2。
   // - 如果锁定为 3'b011，锁定减 1，RGB LED 设置为 3'b111 和 3'b110，
   //   信号 LED 设置为 8'b1111_0000，启动信号设置为 2。
   // - 如果锁定为 3'b010，锁定减 1，RGB LED 设置为 3'b111 和 3'b110，
   //   信号 LED 设置为 8'b1111_1100，启动信号设置为 2。
   // - 如果锁定为 3'b001，锁定减 1，RGB LED 设置为 3'b110，
   //   信号 LED 设置为 8'b0101_0101，启动信号设置为 1。
    else if(confirm[1]&&lock)
    begin
      if(sw==password)
      begin
        lock=3'b111;
        sgn_RGB_led_L=3'b101;
        sgn_RGB_led_R=3'b101;
        sgn_led=8'b0000_0000;
        start=2;
      end
      else if(lock==3'b100)
      begin
        lock=lock-3'b001;
        sgn_RGB_led_L=3'b111;
        sgn_RGB_led_R=3'b110;
        sgn_led=8'b1100_0000;
        start=2;
      end
      else if(lock==3'b011)
      begin
        lock=lock-3'b001;
        sgn_RGB_led_R=3'b111;
        sgn_RGB_led_L=3'b110;
        sgn_led=8'b1111_0000;
        start=2;
      end
      else if(lock==3'b010)
      begin
        lock=lock-3'b001;
        sgn_RGB_led_L=3'b111;
        sgn_RGB_led_R=3'b110;
        sgn_led=8'b1111_1100;
        start=2;
      end
      else if(lock==3'b001)
      begin
        lock=lock-3'b001;
        sgn_RGB_led_R=3'b110;
        sgn_RGB_led_L=3'b110;
        sgn_led=8'b0101_0101;
        start=1;
      end

    end

  end

  parameter PERIOD=6_000_000;

  reg [23:0]cnt;
  reg [3:0]cnt_ge;
  reg [3:0]cnt_shi;
  reg clk_divide;

  always @(posedge clk)
  begin
    if(key[0]==0)
    begin
      cnt=0;
      clk_divide=0;
    end
    else if(cnt<PERIOD-1)
      cnt=cnt+1;
    else
    begin
      cnt=0;
      clk_divide=~clk_divide;
    end
  end

  reg res;

  always@(posedge clk_divide)
  begin
    if(start==1)
    begin
      if(res==1)
      begin
        res=0;
        cnt_ge=0;
        cnt_shi=2;
      end

      else//res==0;
      begin
        if(cnt_ge==0)
        begin
          if(cnt_shi==0)
          begin
            cnt_ge=0;
            cnt_shi=0;
            res=2;
          end
          else
          begin
            cnt_ge=9;
            cnt_shi=cnt_shi-1;
          end
        end
        else
          cnt_ge=cnt_ge-1;
      end


    end

    else
    begin
      cnt_ge=0;
      cnt_shi=0;
      res=1;
    end
  end

  initial
  begin
    seg[0]=7'h3f;
    seg[1]=7'h06;
    seg[2]=7'h5b;
    seg[3]=7'h4f;
    seg[4]=7'h66;
    seg[5]=7'h6d;
    seg[6]=7'h7d;
    seg[7]=7'h07;
    seg[8]=7'h7f;
    seg[9]=7'h6f;

  end


  always@(sgn_RGB_led_R)
    RGB_led_R=sgn_RGB_led_R;
  always@(sgn_RGB_led_L)
    RGB_led_L=sgn_RGB_led_L;
  always@(sgn_led)
    led=sgn_led;

  always@(cnt_ge)
  begin
    seg2={2'b00,seg[cnt_ge]};
  end
  always@(cnt_shi)
  begin
    seg1={2'b00,seg[cnt_shi]};
  end

endmodule
