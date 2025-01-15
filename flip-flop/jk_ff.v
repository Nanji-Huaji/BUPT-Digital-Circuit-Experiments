module JK_ff (
    input clk, rst_n,
    input j,k,
    output reg q,
    output q_n
  );
  assign q_n = ~q;
  always@(posedge clk or negedge rst_n) // 异步复位
  begin
    if (!rst_n)
      q <= 0;
    else
    begin
      case({j,k})
        2'b00:
          q <= q;    // 不变
        2'b01:
          q <= 1'b0; // 复位
        2'b10:
          q <= 1'b1; // 置位
        2'b11:
          q <= ~q;   // 翻转
      endcase
    end
  end
  always@(posedge clk)
  begin // 同步复位
    if(!rst_n)
      q <= 0;
    else
    begin
      case({j,k})
        2'b00:
          q <= q;    // 不变
        2'b01:
          q <= 1'b0; // 复位
        2'b10:
          q <= 1'b1; // 置位
        2'b11:
          q <= ~q;   // 翻转
      endcase
    end
  end
endmodule
