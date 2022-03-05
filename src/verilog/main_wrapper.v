module real_main(
  input clk,
  inout [15:0] N64_AD,
  input N64_READ_N,
  input N64_WRITE_N,
  input N64_COLD_RESTART,
  input N64_CLK,
  input N64_ALE_H,
  input N64_ALE_L,
  input N64_NMI_N,
  inout N64_EN,
  inout N64_RST,
  inout N64_INT4,
);
  reg n64DevCartMain_reset = 0;
  wire [15:0] n64DevCartMain_ado;

  // Only output if read is asserted!
  assign N64_AD = N64_READ_N ? n64DevCartMain_ado : 16'bZ;

  N64DevCartMain N64DevCartMain_0(
    .clock(clk),
    .reset(n64DevCartMain_reset),
    .io_n64adi(N64_AD),
    .io_n64readn(N64_READ_N),
    .io_n64alel(N64_ALE_L),
    .io_n64aleh(N64_ALE_H),
    .io_n64ado(n64DevCartMain_ado)
  );
endmodule
