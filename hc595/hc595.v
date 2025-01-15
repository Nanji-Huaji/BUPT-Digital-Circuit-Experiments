module hc595(
    input sclr_n, si, sck, rck, g_n,
    output qh, qg, qf, qe, qd, qc, qb, qa, qh_qout
  );
  reg [7:0] shift_dffs;
  reg [7:0] storge_dffs;
  always @(posedge sck or negedge sclr_n)
  begin
    if (~sclr_n)
      shift_dffs[7:0] <= 8'h00;
    else
      shift_dffs[7:0] <= {shift_dffs[6:0], si};
  end
  always @(posedge rck)
  begin
    storge_dffs[7:0] <= shift_dffs[7:0];
  end
  assign gh_qout = shift_dffs[7];
  assign {qh,qg,qf,qe,qd,qc,qb,qa}=g_n? 8'bzzzzzzzz:storge_dffs[7:0];
endmodule
