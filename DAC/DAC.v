module DAC_Controller (
    input clk,             // 时钟信号
    input rst,             // 复位信号
    output reg [7:0] dac_out // 8位DAC输出
  );

  reg [7:0] sine_wave [0:255]; // 存储正弦波查找表
  reg [7:0] index;             // 查找表索引

  initial
  begin
    // 初始化正弦波查找表
    $readmemh("sine_wave.mem", sine_wave);
  end

  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      index <= 8'b0;
      dac_out <= 8'b0;
    end
    else
    begin
      dac_out <= sine_wave[index];
      index <= index + 1;
    end
  end

endmodule
