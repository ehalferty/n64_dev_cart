`timescale 1ns / 1ps

module rom(
  input clk,
  input [31:0] address,
  input read,
  input write,
  inout [15:0] data
);
  reg [15:0] rom_data[(2**5)-1:0];
  // reg [7:0] rom_data[(2**17)-1:0];
  reg [7:0] data_out = 8'bZ;
  assign data = data_out;
  initial
  begin
    $readmemb("homebrew_rom.V64", rom_data);
  end
  always @ (posedge clk)
  begin
    if (write == 1)
    begin
      rom_data[address] <= data;
    end
    else if (read == 1)
    begin
      data_out <= rom_data[address >> 1];
    end
    else
    begin
      data_out <= 8'bZ;
    end
  end
endmodule

module real_main(
  input clk,
  inout [15:0] N64_AD,
  input N64_READ_N,
  input N64_WRITE_N,
  input N64_COLD_RESTART,
  input N64_ALE_H,
  input N64_ALE_L,
  input N64_NMI_N,
  inout N64_EN,
  inout N64_RST,
  inout N64_INT4
);
  reg [15:0] ad = 16'bZ;
  reg en = 1'bZ;
  reg rst = 1'bZ;
  reg int4 = 1'b1;

  assign N64_AD = ad;
  assign N64_EN = en;
  assign N64_RST = rst;
  assign N64_int4 = int4;

  reg [31:0] rom_address = 32'b0;
  reg rom_read = 0;
  reg rom_write = 0;
  wire [15:0] rom_data;
  reg [15:0] rom_data_write = 0;
  rom rom_0(.clk(clk), .address(rom_address), .read(rom_read), .write(rom_write), .data(rom_data));

  reg [31:0] address = 32'b0;
  reg [16:0] data = 16'b0;
  reg inc_read_offset = 0;
  reg [7:0] read_offset = 8'b0;

  always @ (posedge clk)
  begin
    ad <= 16'bZ;
    rom_address <= 0;
    rom_read <= 0;
    rom_write <= 0;
    rom_data_write <= 0;
    if (N64_ALE_L == 1 && N64_ALE_H == 1) // ALE_L = 1, ALE_H = 1: Set high word of address
    begin
      address[31:16] <= N64_AD;
      read_offset <= 0;
    end
    else if (N64_ALE_L == 1 && N64_ALE_H == 0) // ALE_L = 1, ALE_H = 0: Set low word of address
    begin
      address[15:0] <= N64_AD;
      read_offset <= 0;
    end
    else if (N64_ALE_L == 0 && N64_ALE_H == 0) // ALE_L = 0, ALE_H = 0: Can read from this state
    begin
      if (N64_READ_N == 0)
      begin
        rom_read <= 1;
        rom_address <= address;
        ad <= rom_data;
        inc_read_offset <= 1;
      end
      else
      begin
        if (inc_read_offset == 1)
        begin
          read_offset <= read_offset + 1;
        end
      end
    end
  end

endmodule

module main(
  input CLK1,
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
  output [7:0] LED
    );
    reg prev_n64_clk = 0;
    reg clk = 0;
    real_main real_main_0(.clk(clk), .N64_AD(N64_AD), .N64_READ_N(N64_READ_N), .N64_WRITE_N(N64_WRITE_N), .N64_COLD_RESTART(N64_COLD_RESTART), .N64_ALE_H(N64_ALE_H), .N64_ALE_L(N64_ALE_L),
      .N64_NMI_N(N64_NMI_N), .N64_EN(N64_EN), .N64_RST(N64_RST), .N64_INT4(N64_INT4));
    always @ (posedge CLK1)
    begin
      if (prev_n64_clk != N64_CLK)
      begin
        clk <= N64_CLK;
        prev_n64_clk <= N64_CLK;
      end
    end
endmodule



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
