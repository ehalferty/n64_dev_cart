module N64DevCartMain(
  input         clock,
  input         reset,
  input  [15:0] io_n64adi,
  input         io_n64readn,
  input         io_n64alel,
  input         io_n64aleh,
  output [15:0] io_n64ado
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] memory [0:262143]; // @[N64DevCartMain.scala 13:21]
  wire [15:0] memory__T_24_data; // @[N64DevCartMain.scala 13:21]
  wire [17:0] memory__T_24_addr; // @[N64DevCartMain.scala 13:21]
  reg [31:0] addr; // @[N64DevCartMain.scala 15:23]
  wire  _T = ~io_n64aleh; // @[N64DevCartMain.scala 16:11]
  reg  _T_2; // @[N64DevCartMain.scala 16:34]
  wire  _T_3 = ~_T_2; // @[N64DevCartMain.scala 16:26]
  wire  _T_4 = _T & _T_3; // @[N64DevCartMain.scala 16:23]
  wire [31:0] _T_5 = addr & 32'hffff; // @[N64DevCartMain.scala 17:23]
  wire [31:0] _T_7 = {io_n64adi, 16'h0}; // @[N64DevCartMain.scala 17:63]
  wire [31:0] _T_8 = _T_5 | _T_7; // @[N64DevCartMain.scala 17:36]
  wire  _T_9 = ~io_n64alel; // @[N64DevCartMain.scala 18:17]
  reg  _T_11; // @[N64DevCartMain.scala 18:40]
  wire  _T_12 = ~_T_11; // @[N64DevCartMain.scala 18:32]
  wire  _T_13 = _T_9 & _T_12; // @[N64DevCartMain.scala 18:29]
  wire [31:0] _T_14 = addr & 32'hffff0000; // @[N64DevCartMain.scala 19:23]
  wire [31:0] _GEN_3 = {{16'd0}, io_n64adi}; // @[N64DevCartMain.scala 19:40]
  wire [31:0] _T_16 = _T_14 | _GEN_3; // @[N64DevCartMain.scala 19:40]
  reg  _T_18; // @[N64DevCartMain.scala 20:39]
  wire  _T_19 = io_n64readn & _T_18; // @[N64DevCartMain.scala 20:29]
  wire [31:0] _T_21 = addr + 32'h2; // @[N64DevCartMain.scala 21:22]
  assign memory__T_24_addr = addr[18:1];
  assign memory__T_24_data = memory[memory__T_24_addr]; // @[N64DevCartMain.scala 13:21]
  assign io_n64ado = memory__T_24_data; // @[N64DevCartMain.scala 23:15]
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
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
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
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 262144; initvar = initvar+1)
    memory[initvar] = _RAND_0[15:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  addr = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  _T_2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  _T_11 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  _T_18 = _RAND_4[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      addr <= 32'h0;
    end else if (_T_4) begin
      addr <= _T_8;
    end else if (_T_13) begin
      addr <= _T_16;
    end else if (_T_19) begin
      addr <= _T_21;
    end
    _T_2 <= ~io_n64aleh;
    _T_11 <= ~io_n64alel;
    _T_18 <= ~io_n64readn;
  end
endmodule
