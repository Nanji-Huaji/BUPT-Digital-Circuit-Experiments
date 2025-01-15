`timescale 1ns / 1ps

module hc595_tb;

  // Inputs
  reg sclr_n;
  reg si;
  reg sck;
  reg rck;
  reg g_n;

  // Outputs
  wire qh;
  wire qg;
  wire qf;
  wire qe;
  wire qd;
  wire qc;
  wire qb;
  wire qa;
  wire qh_qout;

  // Instantiate the Unit Under Test (UUT)
  hc595 uut (
          .sclr_n(sclr_n),
          .si(si),
          .sck(sck),
          .rck(rck),
          .g_n(g_n),
          .qh(qh),
          .qg(qg),
          .qf(qf),
          .qe(qe),
          .qd(qd),
          .qc(qc),
          .qb(qb),
          .qa(qa),
          .qh_qout(qh_qout)
        );

  initial
  begin
    // Initialize Inputs
    sclr_n = 0;
    si = 0;
    sck = 0;
    rck = 0;
    g_n = 1;

    // Wait for global reset
    #100;

    // Clear shift register
    sclr_n = 0;
    #10;
    sclr_n = 1;
    #10;

    // Load data into shift register
    si = 1;
    #10 sck = 1;
    #10 sck = 0;
    si = 0;
    #10 sck = 1;
    #10 sck = 0;
    si = 1;
    #10 sck = 1;
    #10 sck = 0;
    si = 1;
    #10 sck = 1;
    #10 sck = 0;
    si = 0;
    #10 sck = 1;
    #10 sck = 0;
    si = 1;
    #10 sck = 1;
    #10 sck = 0;
    si = 0;
    #10 sck = 1;
    #10 sck = 0;
    si = 1;
    #10 sck = 1;
    #10 sck = 0;

    // Latch data into storage register
    #10 rck = 1;
    #10 rck = 0;

    // Enable output
    g_n = 0;

    // Add stimulus here
    #100;

    // Disable output
    g_n = 1;

    // Finish simulation
    #100;
    $finish;
  end

endmodule
