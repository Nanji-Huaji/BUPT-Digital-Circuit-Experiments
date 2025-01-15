`timescale 1ns/1ps

module ram_tb;

  reg clk;
  reg rst;
  reg we;
  reg [7:0] addr;
  reg [7:0] data_in;
  wire [7:0] data_out;

  ram ram_test (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
      );

  initial
  begin
    clk = 0;
    forever
      #5 clk = ~clk;
  end

  initial
  begin
    we = 0;
    addr = 0;
    data_in = 0;

    #10
     we = 1;
    addr = 8'b00000000;
    data_in = 8'h01;
    #10
     we = 1;
    addr = 8'b00000001;
    data_in = 8'h02;
    #10
     we = 1;
    addr = 8'b00000010;
    data_in = 8'h03;

    #10
     print(8'b00000000);
    #10
     print(8'b00000001);
    #10
     print(8'b00000010);

    #10;
    $stop;

  end
  task print;
    input [7:0] read_addr;
    begin
      we = 0;
      addr = read_addr;
      #10;
      $display("Read data from address %h: %h", read_addr,
               data_out);
    end
  endtask
endmodule
