module N64DevCartMain(
  input         clock,
  input         reset,
  input  [15:0] io_n64adi,
  input         io_n64readn,
  input         io_n64ale_l,
  input         io_n64ale_h,
  output [15:0] io_n64ado,
  output [31:0] io_romAddr,
  input  [15:0] io_romData
);
  reg  prevAleH; // @[N64DevCartMain.scala 15:27]
  reg [31:0] _RAND_0;
  reg  prevAleL; // @[N64DevCartMain.scala 16:27]
  reg [31:0] _RAND_1;
  reg  prevReadN; // @[N64DevCartMain.scala 17:28]
  reg [31:0] _RAND_2;
  reg [31:0] addr; // @[N64DevCartMain.scala 18:23]
  reg [31:0] _RAND_3;
  wire  _T = ~io_n64ale_h; // @[N64DevCartMain.scala 19:11]
  wire  _T_1 = _T & prevAleH; // @[N64DevCartMain.scala 19:24]
  wire [31:0] _T_2 = addr & 32'hffff; // @[N64DevCartMain.scala 20:23]
  wire [31:0] _T_4 = {io_n64adi, 16'h0}; // @[N64DevCartMain.scala 20:63]
  wire [31:0] _T_5 = _T_2 | _T_4; // @[N64DevCartMain.scala 20:36]
  wire  _T_6 = ~io_n64ale_l; // @[N64DevCartMain.scala 21:17]
  wire  _T_7 = _T_6 & prevAleL; // @[N64DevCartMain.scala 21:30]
  wire [31:0] _T_8 = addr & 32'hffff0000; // @[N64DevCartMain.scala 22:23]
  wire [31:0] _GEN_3 = {{16'd0}, io_n64adi}; // @[N64DevCartMain.scala 22:40]
  wire [31:0] _T_10 = _T_8 | _GEN_3; // @[N64DevCartMain.scala 22:40]
  wire  _T_11 = ~prevReadN; // @[N64DevCartMain.scala 23:32]
  wire  _T_12 = io_n64readn & _T_11; // @[N64DevCartMain.scala 23:29]
  wire [31:0] _T_14 = addr + 32'h2; // @[N64DevCartMain.scala 24:22]
  assign io_n64ado = io_romData; // @[N64DevCartMain.scala 28:15]
  assign io_romAddr = addr; // @[N64DevCartMain.scala 27:16]
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
  prevAleH = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  prevAleL = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  prevReadN = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  addr = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    prevAleH <= reset | io_n64ale_h;
    prevAleL <= reset | io_n64ale_l;
    prevReadN <= reset | io_n64readn;
    if (reset) begin
      addr <= 32'h0;
    end else if (_T_1) begin
      addr <= _T_5;
    end else if (_T_7) begin
      addr <= _T_10;
    end else if (_T_12) begin
      addr <= _T_14;
    end
  end
endmodule
