module main(
  input CLK1,

  inout  [15:0] sdram_dq,
  output [11:0] sdram_a,
  output        sdram_we,
  output        sdram_cas,
  output        sdram_ras,
  output        sdram_cs1,
  output [1:0]  sdram_ba,
  output        sdram_clk
);

  reg writeport_wr = 1;
  reg [31:0] writeport_addr = 0;
  reg [15:0] writeport_data = 0;
  wire writeport_ack;
  reg readport_rd = 1;
  reg [31:0] readport_addr = 0;
  wire [15:0] readport_data;
  wire readport_ack;

  reg [32:0] counter = 0;

  MisterSdram32MBController MisterSdram32MBController_0(
    .clk(CLK1),
    .sdram_dq(sdram_dq),
    .sdram_a(sdram_a),
    .sdram_we(sdram_we),
    .sdram_cas(sdram_cas),
    .sdram_ras(sdram_ras),
    .sdram_cs1(sdram_cs1),
    .sdram_ba(sdram_ba),
    .sdram_clk(sdram_clk),
    .writeport_wr(writeport_wr),
    .writeport_addr(writeport_addr),
    .writeport_data(writeport_data),
    .writeport_ack(writeport_ack),
    .readport_rd(readport_rd),
    .readport_addr(readport_addr),
    .readport_data(readport_data),
    .readport_ack(readport_ack)
  );
endmodule
