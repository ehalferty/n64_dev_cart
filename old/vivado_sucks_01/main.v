`timescale 1ns / 1ps

module CartRom(
  input clk,
  input  [31:0] addr,
  output [15:0] data
);
reg [15:0] data_reg = 0;
assign data = data_reg;
reg [15:0] rom_data[0:1048575];
initial begin
  $readmemh("rom.hex.txt", rom_data);
end
always @(posedge clk)
begin
    data_reg <= rom_data[addr >> 1];
end
endmodule

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

module main(
  input CLK1,
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
  assign N64_INT4 = 1'bZ; // 1 for modified "IS VIEWER" console, Z for unmodified
  assign N64_AD = N64_READ_N ? 16'bZ : n64DevCartMain_ado; // Only output if read is asserted!
  CartRom CartRom_0(.clk(CLK1), .addr(romAddr), .data(romData));
  N64DevCartMain N64DevCartMain_0(
    .clock(CLK1),
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


// module rom(
//   input clk,
//   input [31:0] address,
//   input read,
//   input write,
//   inout [15:0] data
// );
//   reg [15:0] rom_data[(2**5)-1:0];
//   // reg [7:0] rom_data[(2**17)-1:0];
//   reg [7:0] data_out = 8'bZ;
//   assign data = data_out;
//   initial
//   begin
//     $readmemb("homebrew_rom.V64", rom_data);
//   end
//   always @ (posedge clk)
//   begin
//     if (write == 1)
//     begin
//       rom_data[address] <= data;
//     end
//     else if (read == 1)
//     begin
//       data_out <= rom_data[address >> 1];
//     end
//     else
//     begin
//       data_out <= 8'bZ;
//     end
//   end
// endmodule

// module real_main(
//   input clk,
//   inout [15:0] N64_AD,
//   input N64_READ_N,
//   input N64_WRITE_N,
//   input N64_COLD_RESTART,
//   input N64_ALE_H,
//   input N64_ALE_L,
//   input N64_NMI_N,
//   inout N64_EN,
//   inout N64_RST,
//   inout N64_INT4
// );
//   reg [15:0] ad = 16'bZ;
//   reg en = 1'bZ;
//   reg rst = 1'bZ;
//   reg int4 = 1'b1;

//   assign N64_AD = ad;
//   assign N64_EN = en;
//   assign N64_RST = rst;
//   assign N64_int4 = int4;

//   reg [31:0] rom_address = 32'b0;
//   reg rom_read = 0;
//   reg rom_write = 0;
//   wire [15:0] rom_data;
//   reg [15:0] rom_data_write = 0;
//   rom rom_0(.clk(clk), .address(rom_address), .read(rom_read), .write(rom_write), .data(rom_data));

//   reg [31:0] address = 32'b0;
//   reg [16:0] data = 16'b0;
//   reg inc_read_offset = 0;
//   reg [7:0] read_offset = 8'b0;

//   always @ (posedge clk)
//   begin
//     ad <= 16'bZ;
//     rom_address <= 0;
//     rom_read <= 0;
//     rom_write <= 0;
//     rom_data_write <= 0;
//     if (N64_ALE_L == 1 && N64_ALE_H == 1) // ALE_L = 1, ALE_H = 1: Set high word of address
//     begin
//       address[31:16] <= N64_AD;
//       read_offset <= 0;
//     end
//     else if (N64_ALE_L == 1 && N64_ALE_H == 0) // ALE_L = 1, ALE_H = 0: Set low word of address
//     begin
//       address[15:0] <= N64_AD;
//       read_offset <= 0;
//     end
//     else if (N64_ALE_L == 0 && N64_ALE_H == 0) // ALE_L = 0, ALE_H = 0: Can read from this state
//     begin
//       if (N64_READ_N == 0)
//       begin
//         rom_read <= 1;
//         rom_address <= address;
//         ad <= rom_data;
//         inc_read_offset <= 1;
//       end
//       else
//       begin
//         if (inc_read_offset == 1)
//         begin
//           read_offset <= read_offset + 1;
//         end
//       end
//     end
//   end

// endmodule

// module main(
//   input CLK1,
//   inout [15:0] N64_AD,
//   input N64_READ_N,
//   input N64_WRITE_N,
//   input N64_COLD_RESTART,
//   input N64_CLK,
//   input N64_ALE_H,
//   input N64_ALE_L,
//   input N64_NMI_N,
//   inout N64_EN,
//   inout N64_RST,
//   inout N64_INT4,
//   output [7:0] LED
//     );
//     reg prev_n64_clk = 0;
//     reg clk = 0;
//     real_main real_main_0(.clk(clk), .N64_AD(N64_AD), .N64_READ_N(N64_READ_N), .N64_WRITE_N(N64_WRITE_N), .N64_COLD_RESTART(N64_COLD_RESTART), .N64_ALE_H(N64_ALE_H), .N64_ALE_L(N64_ALE_L),
//       .N64_NMI_N(N64_NMI_N), .N64_EN(N64_EN), .N64_RST(N64_RST), .N64_INT4(N64_INT4));
//     always @ (posedge CLK1)
//     begin
//       if (prev_n64_clk != N64_CLK)
//       begin
//         clk <= N64_CLK;
//         prev_n64_clk <= N64_CLK;
//       end
//     end
// endmodule



        //   ad <= 16'bZ;
        //   if (N64_ALE_L == 1 && N64_ALE_H == 1) // ALE_L = 1, ALE_H = 1: Set high word of address
        //   begin
        //     address[31:16] <= N64_AD;
        //     read_offset <= 0;
        //   end
        //   else if (N64_ALE_L == 1 && N64_ALE_H == 0) // ALE_L = 1, ALE_H = 0: Set low word of address
        //   begin
        //     address[15:0] <= N64_AD;
        //     read_offset <= 0;
        //   end
        //   else if (N64_ALE_L == 0 && N64_ALE_H == 0) // ALE_L = 0, ALE_H = 0: Can read from this state
        //   begin
        //     if (N64_READ_N == 0)
        //     begin
        //       // ad <= rom_data[address + read_offset];
        //       inc_read_offset <= 1;
        //     end
        //     else
        //     begin
        //       if (inc_read_offset == 1)
        //       begin
        //         read_offset <= read_offset + 1;
        //       end
        //     end
        //   end
        //   else
        //   begin
        //   end
    // reg [15:0] ad = 16'bZ;
    // reg en = 1'bZ;
    // reg rst = 1'bZ;
    // reg int4 = 1'b1;

    // assign N64_AD = ad;
    // assign N64_EN = en;
    // assign N64_RST = rst;
    // assign N64_int4 = int4;

    // assign LED = 8'b10101001;

    // reg [31:0] address = 32'b0;
    // reg [16:0] data = 16'b0;

    // reg inc_read_offset = 0;
    // reg [7:0] read_offset = 8'b0;
    // reg [7:0] rom_data[(2**5)-1:0]; // ROM file: 195,688, buffer size: 262,144

    // initial
    // begin
    //   $readmemb("homebrew_rom.V64", rom_data);
    // end
        // if (N64_CLK == 1)
        // begin
        //   ad <= 16'bZ;
        //   if (N64_ALE_L == 1 && N64_ALE_H == 1) // ALE_L = 1, ALE_H = 1: Set high word of address
        //   begin
        //     address[31:16] <= N64_AD;
        //     read_offset <= 0;
        //   end
        //   else if (N64_ALE_L == 1 && N64_ALE_H == 0) // ALE_L = 1, ALE_H = 0: Set low word of address
        //   begin
        //     address[15:0] <= N64_AD;
        //     read_offset <= 0;
        //   end
        //   else if (N64_ALE_L == 0 && N64_ALE_H == 0) // ALE_L = 0, ALE_H = 0: Can read from this state
        //   begin
        //     if (N64_READ_N == 0)
        //     begin
        //       // ad <= rom_data[address + read_offset];
        //       inc_read_offset <= 1;
        //     end
        //     else
        //     begin
        //       if (inc_read_offset == 1)
        //       begin
        //         read_offset <= read_offset + 1;
        //       end
        //     end
        //   end
        //   else
        //   begin
        //   end
        // end

// module main(
// input CLK1,
// inout [15:0] N64_AD,
// input N64_READ_N,
// input N64_WRITE_N,
// input N64_COLD_RESTART,
// input N64_CLK,
// input N64_ALE_H,
// input N64_ALE_L,
// input N64_NMI_N,
// inout N64_EN,
// inout N64_RST,
// inout N64_INT4
//     );
//     reg [15:0] ad = 16'bZ;
//     reg en = 1'bZ;
//     reg rst = 1'bZ;
//     reg int4 = 1'b1;

//     assign N64_AD = ad;
//     assign N64_EN = en;
//     assign N64_RST = rst;
//     assign N64_int4 = int4;

//     reg [63:0] clockdivider = 64'b0;
//     reg [25:0] testpattern = 26'b0;
    
//     always @ (posedge N64_CLK) begin
//       if (clockdivider == 1600000)
//       begin
//         clockdivider <= 0;
//         if (testpattern == 26'b10000000000000000000000000)
//         begin
//           testpattern <= 26'b00000000000000000000000001;
//         end
//         else
//         begin
//           testpattern <= (testpattern << 1);
//         end
//         ad[0] <=
//       end
//       else
//       begin
//         clockdivider <= clockdivider + 1;
//       end
//     end
// endmodule


// `timescale 1ns / 1ps

// module main(
// input CLK1,
// output [15:0] N64_AD,
// output N64_READ_N,
// output N64_WRITE_N,
// output N64_COLD_RESTART,
// output N64_CLK,
// output N64_ALE_H,
// output N64_ALE_L,
// output N64_NMI_N,
// output N64_EN,
// output N64_RST,
// output N64_INT4,
// output [7:0] LED
//     );
//     assign N64_AD[15]       = (((testpattern >> 0) & 1) == 1);
//     assign N64_AD[14]       = (((testpattern >> 1) & 1) == 1);
//     assign N64_AD[13]       = (((testpattern >> 2) & 1) == 1);
//     assign N64_AD[12]       = (((testpattern >> 3) & 1) == 1);
//     assign N64_WRITE_N      = (((testpattern >> 4) & 1) == 1);
//     assign N64_READ_N       = (((testpattern >> 5) & 1) == 1);
//     assign N64_AD[11]       = (((testpattern >> 6) & 1) == 1);
//     assign N64_AD[10]       = (((testpattern >> 7) & 1) == 1);
//     assign N64_AD[9]        = (((testpattern >> 8) & 1) == 1);
//     assign N64_AD[8]        = (((testpattern >> 9) & 1) == 1);
//     assign N64_CLK          = (((testpattern >> 10) & 1) == 1);
//     assign N64_COLD_RESTART = (((testpattern >> 11) & 1) == 1);
//     assign N64_INT4         = (((testpattern >> 12) & 1) == 1);
//     assign N64_EN           = (((testpattern >> 13) & 1) == 1);
//     assign N64_RST          = (((testpattern >> 14) & 1) == 1);
//     assign N64_NMI_N        = (((testpattern >> 15) & 1) == 1);
//     assign N64_AD[7]        = (((testpattern >> 16) & 1) == 1);
//     assign N64_AD[6]        = (((testpattern >> 17) & 1) == 1);
//     assign N64_AD[5]        = (((testpattern >> 18) & 1) == 1);
//     assign N64_AD[4]        = (((testpattern >> 19) & 1) == 1);
//     assign N64_ALE_H        = (((testpattern >> 20) & 1) == 1);
//     assign N64_ALE_L        = (((testpattern >> 21) & 1) == 1);
//     assign N64_AD[3]        = (((testpattern >> 22) & 1) == 1);
//     assign N64_AD[2]        = (((testpattern >> 23) & 1) == 1);
//     assign N64_AD[1]        = (((testpattern >> 24) & 1) == 1);

//     assign LED[0]           = (((testpattern >> 0) & 1) == 1);
//     assign LED[1]           = (((testpattern >> 1) & 1) == 1);
//     assign LED[2]           = (((testpattern >> 2) & 1) == 1);
//     assign LED[3]           = (((testpattern >> 3) & 1) == 1);
//     assign LED[4]           = (((testpattern >> 4) & 1) == 1);
//     assign LED[5]           = (((testpattern >> 5) & 1) == 1);
//     assign LED[6]           = (((testpattern >> 6) & 1) == 1);
//     assign LED[7]           = (((testpattern >> 7) & 1) == 1);

//     reg [63:0] clockdivider = 64'b0;
//     reg [24:0] testpattern = 25'b0000000000000000000000001;
    
//     always @ (posedge CLK1) begin
//       if (clockdivider == 1000000000)
//       begin
//         clockdivider <= 0;
//         if (testpattern == 25'b1000000000000000000000000)
//         begin
//           testpattern <= 25'b0000000000000000000000001;
//         end
//         else
//         begin
//           testpattern <= (testpattern << 1);
//         end
//         clockdivider <= 0;
//       end
//       else
//       begin
//         clockdivider <= clockdivider + 1;
//       end
//     end
// endmodule


// module main(
// input CLK1,
// inout [15:0] N64_AD,
// input N64_READ_N,
// input N64_WRITE_N,
// input N64_COLD_RESTART,
// input N64_CLK,
// input N64_ALE_H,
// input N64_ALE_L,
// input N64_NMI_N,
// inout N64_EN,
// inout N64_RST,
// inout N64_INT4
//     );
//     reg [15:0] ad = 16'bZ;
//     reg en = 1'bZ;
//     reg rst = 1'bZ;
//     reg int4 = 1'b1;

//     assign N64_AD = ad;
//     assign N64_EN = en;
//     assign N64_RST = rst;
//     assign N64_int4 = int4;

//     reg [63:0] clockdivider = 64'b0;
//     reg [25:0] testpattern = 26'b0;
    
//     always @ (posedge N64_CLK) begin
//       if (clockdivider == 1600000)
//       begin
//         clockdivider <= 0;
//         if (testpattern == 26'b10000000000000000000000000)
//         begin
//           testpattern <= 26'b00000000000000000000000001;
//         end
//         else
//         begin
//           testpattern <= (testpattern << 1);
//         end
//         ad[0] <=
//       end
//       else
//       begin
//         clockdivider <= clockdivider + 1;
//       end
//     end
// endmodule
