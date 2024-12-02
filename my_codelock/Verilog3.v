module debouncce(clk,rst,key,key_pulse);

  input clk;
  input rst;
  input [N-1:0]key;
  output [N-1:0]key_pulse;

  parameter N=2;

  reg [N-1:0] key_rst;
  reg [N-1:0] key_rst_pre;
  wire [N-1:0] key_edge;

  always@(posedge clk or negedge rst)
  begin
    if(!rst)
    begin
      key_rst={N{1'b1}};
      key_rst_pre={N{1'b1}};
    end
    else
    begin
      key_rst_pre=key_rst;
      key_rst=key;
    end
  end

  assign key_edge=key_rst_pre&(~key_rst);

  reg [17:0] cnt;
  reg [N-1:0] key_sec;
  reg [N-1:0] key_sec_pre;

  always@(posedge clk or negedge rst)
  begin
    if(!rst)
      cnt=0;
    else if(key_edge)
      cnt=0;
    else
      cnt=cnt+1;
  end

  always@(posedge clk or negedge rst)
  begin
    if(!rst)
    begin
      key_sec={N{1'b1}};
      key_sec_pre={N{1'b1}};
    end
    else if(cnt==240_000)
    begin
      key_sec_pre=key_sec;
      key_sec=key;
    end
    else
      key_sec_pre=key_sec;
  end

  assign key_pulse=key_sec_pre&(~key_sec);

endmodule
