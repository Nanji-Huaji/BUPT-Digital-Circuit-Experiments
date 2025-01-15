module breathe
  (clk,red,green,blue);
  input clk;
  output red,green,blue;

  reg [15:0] wheel_position;
  reg [7:0] wheel_position_buffer;
  reg [7:0] red_buffer,green_buffer,blue_buffer;
  reg [31:0] divide_buffer;

  wire clk;
  reg divide_clk;

  pwm pwm_red(red,red_buffer,clk);
  pwm pwm_green(green,green_buffer,clk);
  pwm pwm_blue(blue,blue_buffer,clk);

  always @ (posedge clk)
  begin
    if(divide_buffer < 50000)
    begin
      divide_buffer <= divide_buffer + 1;
    end
    else
    begin
      divide_clk <= ~divide_clk;
      divide_buffer <= 0;
    end
  end
  always @ (posedge divide_clk)
  begin
    if(wheel_position < 765)
      wheel_position <= wheel_position + 1;
    else
      wheel_position <= 0;
    if(wheel_position < 255)
    begin
      red_buffer <= 255 - wheel_position;
      green_buffer <= 0;
      blue_buffer <= wheel_position;
    end
    else if(wheel_position < 510)
    begin
      red_buffer <= 0;
      green_buffer <= wheel_position - 255;
      blue_buffer <= 255 - (wheel_position - 255);
    end
    else
    begin
      red_buffer <= wheel_position - 510;
      green_buffer <= 255 - (wheel_position - 510);
      blue_buffer <= 0;
    end
  end
endmodule
