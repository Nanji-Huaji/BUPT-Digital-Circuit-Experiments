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
