/*
 * 模块: adc_controller
 * 
 * 描述:
 * 该模块实现了一个简单的ADC（模数转换器）控制器,用于控制AD7606 ADC芯片。
 * 通过管理片选（cs_n）和读取（rd_n）信号来控制ADC操作，
 * 并处理从ADC到输出寄存器的数据传输。
 * 
 * 端口:
 * - 输入线 clk: 系统时钟信号。
 * - 输入线 rst_n: 复位信号，低电平有效。
 * - 输入线 start: 启动信号，启动ADC转换。
 * - 输出寄存器 [15:0] data: 16位ADC数据输出。
 * - 输出寄存器 busy: ADC忙信号，表示ADC正在操作。
 * - 输出寄存器 cs_n: 片选信号，低电平有效。
 * - 输出寄存器 rd_n: 读取信号，低电平有效。
 * - 输入线 [15:0] adc_data: 16位ADC数据输入。
 * 
 * 内部信号:
 * - 寄存器 [3:0] state: 状态寄存器，用于保存状态机的当前状态。
 * 
 * 状态机:
 * - IDLE: 初始状态，等待启动信号。
 * - START: 断言cs_n和rd_n以启动ADC转换。
 * - READ: 读取ADC数据并存储在数据寄存器中。
 * - DONE: 取消断言cs_n和rd_n，并返回到IDLE状态。
 * 
 * 复位行为:
 * - 在复位时（rst_n为低电平），状态机设置为IDLE状态，数据清零，控制信号取消断言。
 * 
 * 时钟行为:
 * - 在每个时钟（clk）的上升沿，状态机根据当前状态和输入信号进行状态转换。
 */
module adc_controller (
    input wire clk,          // 系统时钟
    input wire rst_n,        // 复位信号，低电平有效
    input wire start,        // 启动信号
    output reg [15:0] data,  // ADC数据输出
    output reg busy,         // ADC忙信号
    output reg cs_n,         // 片选信号，低电平有效
    output reg rd_n,         // 读信号，低电平有效
    input wire [15:0] adc_data // ADC数据输入
  );

  reg [3:0] state;
  localparam IDLE = 4'd0,
             START = 4'd1,
             READ = 4'd2,
             DONE = 4'd3;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      state <= IDLE;
      data <= 16'd0;
      busy <= 1'b0;
      cs_n <= 1'b1;
      rd_n <= 1'b1;
    end
    else
    begin
      case (state)
        IDLE:
        begin
          busy <= 1'b0;
          if (start)
          begin
            state <= START;
            busy <= 1'b1;
          end
        end
        START:
        begin
          cs_n <= 1'b0;
          rd_n <= 1'b0;
          state <= READ;
        end
        READ:
        begin
          data <= adc_data;
          state <= DONE;
        end
        DONE:
        begin
          cs_n <= 1'b1;
          rd_n <= 1'b1;
          busy <= 1'b0;
          state <= IDLE;
        end
        default:
          state <= IDLE;
      endcase
    end
  end
endmodule
