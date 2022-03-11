module MisterSdram32MBController(
  input         clock,
  input         reset,
  input  [15:0] io_sdram_dq_in,
  output [15:0] io_sdram_dq_out,
  output [12:0] io_sdram_a,
  output        io_sdram_we,
  output        io_sdram_cas,
  output        io_sdram_ras,
  output        io_sdram_cs1,
  output [1:0]  io_sdram_ba,
  output        io_sdram_clk,
  input         io_writeport_wr,
  input  [31:0] io_writeport_addr,
  input  [15:0] io_writeport_data,
  output        io_writeport_ack,
  input         io_readport_rd,
  input  [31:0] io_readport_addr,
  output [15:0] io_readport_data,
  input         io_readport_next,
  output        io_readport_ack
);
  reg  sdramClk; // @[MisterSdram32MBController.scala 78:27]
  reg [31:0] _RAND_0;
  wire  _T = ~sdramClk; // @[MisterSdram32MBController.scala 117:17]
  assign io_sdram_dq_out = 16'h0; // @[MisterSdram32MBController.scala 104:21 MisterSdram32MBController.scala 97:25]
  assign io_sdram_a = 13'h0; // @[MisterSdram32MBController.scala 105:16 MisterSdram32MBController.scala 87:20 MisterSdram32MBController.scala 96:20 MisterSdram32MBController.scala 101:20 MisterSdram32MBController.scala 87:20 MisterSdram32MBController.scala 92:20 MisterSdram32MBController.scala 101:20]
  assign io_sdram_we = 1'h1; // @[MisterSdram32MBController.scala 106:17 MisterSdram32MBController.scala 83:37 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 85:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 95:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 100:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 85:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 90:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 100:21 MisterSdram32MBController.scala 82:33 MisterSdram32MBController.scala 82:33]
  assign io_sdram_cas = 1'h1; // @[MisterSdram32MBController.scala 107:18 MisterSdram32MBController.scala 83:61 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 85:45 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 95:46 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 100:46 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 85:45 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 90:45 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 100:46 MisterSdram32MBController.scala 82:57 MisterSdram32MBController.scala 82:57]
  assign io_sdram_ras = 1'h1; // @[MisterSdram32MBController.scala 108:18 MisterSdram32MBController.scala 83:87 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 85:70 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 95:72 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 100:71 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 85:70 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 90:71 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 100:71 MisterSdram32MBController.scala 82:82 MisterSdram32MBController.scala 82:82]
  assign io_sdram_cs1 = 1'h0; // @[MisterSdram32MBController.scala 109:18]
  assign io_sdram_ba = 2'h0; // @[MisterSdram32MBController.scala 110:17 MisterSdram32MBController.scala 86:21 MisterSdram32MBController.scala 86:21 MisterSdram32MBController.scala 91:21]
  assign io_sdram_clk = sdramClk; // @[MisterSdram32MBController.scala 118:18]
  assign io_writeport_ack = 1'h0; // @[MisterSdram32MBController.scala 112:22 MisterSdram32MBController.scala 159:38]
  assign io_readport_data = 16'h0; // @[MisterSdram32MBController.scala 113:22]
  assign io_readport_ack = 1'h0; // @[MisterSdram32MBController.scala 114:21 MisterSdram32MBController.scala 187:37]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  sdramClk = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      sdramClk <= 1'h0;
    end else begin
      sdramClk <= _T;
    end
  end
endmodule
