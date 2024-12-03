module seven_segment_decoder(in, seg_led);
  input [3:0] in;
  output reg [8:0] seg_led;
  always @(*)
  case(in)
    4'b0000:
      seg_led = 9'h3f; // 0
    4'b0001:
      seg_led = 9'h06; // 1
    4'b0010:
      seg_led = 9'h5b; // 2
    4'b0011:
      seg_led = 9'h4f; // 3
    4'b0100:
      seg_led = 9'h66; // 4
    4'b0101:
      seg_led = 9'h6d; // 5
    4'b0110:
      seg_led = 9'h7d; // 6
    4'b0111:
      seg_led = 9'h07; // 7
    4'b1000:
      seg_led = 9'h7f; // 8
    4'b1001:
      seg_led = 9'h6f; // 9
    default:
      seg_led = 9'h00; // default case for invalid BCD
  endcase
endmodule

module topmodule(bcd, seg);
  input [3:0] bcd;
  output [8:0] seg;
  seven_segment_decoder u1(
                          .in(bcd),
                          .seg_led(seg)
                        );
endmodule
