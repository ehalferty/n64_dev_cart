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
  reg [15:0] _T [0:262143]; // @[N64DevCartMain.scala 31:25]
  wire [15:0] _T__T_26_data; // @[N64DevCartMain.scala 31:25]
  wire [17:0] _T__T_26_addr; // @[N64DevCartMain.scala 31:25]
  reg [31:0] _T_1; // @[N64DevCartMain.scala 33:27]
  wire  _T_2 = ~io_n64aleh; // @[N64DevCartMain.scala 34:15]
  reg  _T_4; // @[N64DevCartMain.scala 34:38]
  wire  _T_5 = ~_T_4; // @[N64DevCartMain.scala 34:30]
  wire  _T_6 = _T_2 & _T_5; // @[N64DevCartMain.scala 34:27]
  wire [31:0] _T_7 = _T_1 & 32'hffff; // @[N64DevCartMain.scala 35:27]
  wire [31:0] _T_9 = {io_n64adi, 16'h0}; // @[N64DevCartMain.scala 35:67]
  wire [31:0] _T_10 = _T_7 | _T_9; // @[N64DevCartMain.scala 35:40]
  wire  _T_11 = ~io_n64alel; // @[N64DevCartMain.scala 36:21]
  reg  _T_13; // @[N64DevCartMain.scala 36:44]
  wire  _T_14 = ~_T_13; // @[N64DevCartMain.scala 36:36]
  wire  _T_15 = _T_11 & _T_14; // @[N64DevCartMain.scala 36:33]
  wire [31:0] _T_16 = _T_1 & 32'hffff0000; // @[N64DevCartMain.scala 37:27]
  wire [31:0] _GEN_3 = {{16'd0}, io_n64adi}; // @[N64DevCartMain.scala 37:44]
  wire [31:0] _T_18 = _T_16 | _GEN_3; // @[N64DevCartMain.scala 37:44]
  reg  _T_20; // @[N64DevCartMain.scala 38:43]
  wire  _T_21 = io_n64readn & _T_20; // @[N64DevCartMain.scala 38:33]
  wire [31:0] _T_23 = _T_1 + 32'h2; // @[N64DevCartMain.scala 39:26]
  assign _T__T_26_addr = _T_1[18:1];
  assign _T__T_26_data = _T[_T__T_26_addr]; // @[N64DevCartMain.scala 31:25]
  assign io_n64ado = _T__T_26_data; // @[N64DevCartMain.scala 41:19]
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
    _T[initvar] = _RAND_0[15:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  _T_4 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  _T_13 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  _T_20 = _RAND_4[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      _T_1 <= 32'h0;
    end else if (_T_6) begin
      _T_1 <= _T_10;
    end else if (_T_15) begin
      _T_1 <= _T_18;
    end else if (_T_21) begin
      _T_1 <= _T_23;
    end
    _T_4 <= ~io_n64aleh;
    _T_13 <= ~io_n64alel;
    _T_20 <= ~io_n64readn;
  end
endmodule
