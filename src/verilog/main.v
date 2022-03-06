module Main(
  input clk,
  inout [15:0] N64_AD,
  input N64_READ_N,
  input N64_ALE_H,
  input N64_ALE_L,
  output N64_INT4
);
  reg n64DevCartMain_reset = 0;
  wire [15:0] n64DevCartMain_ado;
  wire [31:0] romAddr;
  wire [15:0] romData;

  assign N64_INT4 = 1;

  // Only output if read is asserted!
  assign N64_AD = N64_READ_N ? n64DevCartMain_ado : 16'bZ;

  CartRom CartRom_0(.clk(clk), .addr(romAddr), .data(romData));

  N64DevCartMain N64DevCartMain_0(
    .clock(clk),
    .reset(n64DevCartMain_reset),
    .io_n64adi(N64_AD),
    .io_n64readn(N64_READ_N),
    .io_n64ale_l(N64_ALE_L),
    .io_n64ale_h(N64_ALE_H),
    .io_n64ado(n64DevCartMain_ado),
    .io_romAddr(romAddr),
    .io_romData(romData)
  );
endmodule
