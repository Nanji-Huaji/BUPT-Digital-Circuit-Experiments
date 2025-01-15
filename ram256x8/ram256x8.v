module ram256x8(
    // 时钟
    input clk,
    // 写使能
    input we,
    // 地址总线输入
    input [7:0] addr,
    // 数据输入
    input [7:0] data_in,
    // 数据输出
    output [7:0] data_out
  );
  // 256 * 8 存储单元阵列
  reg [7:0] ram[255:0];
  always @(posedge clk)
  begin
    // 写使能信号有效，将data_in写入addr处的存储单元
    if (we)
      ram[addr] <= data_in;
  end
  // 读取操作，data_out输出addr处存储单元中的值
  assign data_out = ram[addr];
  //
endmodule
