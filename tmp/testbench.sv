`timescale 1ns / 1ps
module MisterSdram32MBController_testbench;
    reg clk = 0;
    reg rst = 0;
    reg [15:0] sdram_dq_in = 0;
    wire [15:0] sdram_dq_out;
    wire [11:0] sdram_a;
    wire sdram_we;
    wire sdram_cas;
    wire sdram_ras;
    wire sdram_cs1;
    wire [1:0] sdram_ba;
    wire sdram_clk;
    reg writeport_wr;
    reg [31:0] writeport_addr = 0;
    reg [15:0] writeport_data = 0;
    wire writeport_ack;
    reg readport_rd = 0;
    reg [31:0] readport_addr = 0;
    wire [15:0] readport_data;
    // reg readport_next = 0;
    wire readport_ack;
    MisterSdram32MBController MisterSdram32MBController_0(
        .clk(clk),
        .rst(rst),
        .sdram_dq_in(sdram_dq_in),
        .sdram_dq_out(sdram_dq_out),
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
        // .readport_next(readport_next),
        .readport_ack(readport_ack)
    );
    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(5);
        #10
        // write = 1; // Set AD direction to write
        // N64_AD_o = 16'h0000; N64_ALE_H = 0; #10 // Clock in address high
        // N64_AD_o = 16'h0000; N64_ALE_L = 0; #10 // Clock in address low
        // write = 0; // Set AD direction to read
        // N64_READ_N = 0; #10 // Clock in read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        // N64_ALE_H = 1; N64_ALE_L = 1; N64_READ_N = 1; #10 // Reset for next burst
        // write = 1; // Set AD direction to write
        // N64_AD_o = 16'h0001; N64_ALE_H = 0; #10 // Clock in address high
        // N64_AD_o = 16'hB420; N64_ALE_L = 0; #10 // Clock in address low
        // write = 0; // Set AD direction to read
        // N64_READ_N = 0; #10 // Clock in read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        // N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        
        #1000;
        $finish();
    end
    always #1 begin
        clk = ~clk;
    end
endmodule


// `timescale 1ns / 1ps
// module MainWrapper_testbench;
//     reg clk = 0;
//     wire [15:0] N64_AD;
//     reg [15:0] N64_AD_o;
//     reg write = 0;
//     assign N64_AD = (write == 1) ? N64_AD_o : 16'bZ;
//     reg N64_READ_N = 1;
//     reg N64_ALE_H = 1;
//     reg N64_ALE_L = 1;
//     wire N64_INT;
//     Main Main_0(
//         .clk(clk),
//         .N64_AD(N64_AD),
//         .N64_READ_N(N64_READ_N),
//         .N64_ALE_H(N64_ALE_H),
//         .N64_ALE_L(N64_ALE_L),
//         .N64_INT4(N64_INT4)
//     );
//     initial
//     begin
//         $dumpfile("dump.vcd");
//         $dumpvars(5);
//         #10
//         write = 1; // Set AD direction to write
//         N64_AD_o = 16'h0000; N64_ALE_H = 0; #10 // Clock in address high
//         N64_AD_o = 16'h0000; N64_ALE_L = 0; #10 // Clock in address low
//         write = 0; // Set AD direction to read
//         N64_READ_N = 0; #10 // Clock in read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
//         N64_ALE_H = 1; N64_ALE_L = 1; N64_READ_N = 1; #10 // Reset for next burst
//         write = 1; // Set AD direction to write
//         N64_AD_o = 16'h0001; N64_ALE_H = 0; #10 // Clock in address high
//         N64_AD_o = 16'hB420; N64_ALE_L = 0; #10 // Clock in address low
//         write = 0; // Set AD direction to read
//         N64_READ_N = 0; #10 // Clock in read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
//         N64_READ_N = 1; #10 N64_READ_N = 0; #10 // Clock in next read
        
//         #1000;
//         $finish();
//     end
//     always #1 begin
//         clk = ~clk;
//     end
// endmodule










// `timescale 1ns / 1ps
// module FragmentProcessorWithSRAMInterface_testbench;
//   reg clock = 0;
//   reg reset = 0;
//   wire [31:0] io_bram_addr_a;
//   wire [31:0] io_bram_wrdata_a;
//   reg [31:0] io_bram_rddata_a = 0;
//   wire io_bram_en_a;
//   wire io_bram_we_a;
//   FragmentProcessorWithSRAMInterface FragmentProcessorWithSRAMInterface_inst(
//      .clock(clock)
//     ,.reset(reset)
//     ,.io_bram_addr_a(io_bram_addr_a)
//     ,.io_bram_wrdata_a(io_bram_wrdata_a)
//     ,.io_bram_rddata_a(io_bram_rddata_a)
//     ,.io_bram_en_a(io_bram_en_a)
//     ,.io_bram_we_a(io_bram_we_a)
//   );
//   reg [31:0] fake_bram1 [31:0];
//   reg [31:0] fake_bram2 [31:0];
//   reg which_bram = 0;
//   initial begin
//     $readmemh("fake_bram.list", fake_bram1);
//     $readmemh("fake_bram2.list", fake_bram2);
//     $dumpfile("dump.vcd");
//     $dumpvars(5);
//     reset = 1; #10 reset = 0;
//     $writememh("fake_bram_before.list", fake_bram1);
//     #1000;
//     $writememh("fake_bram_after1.list", fake_bram1);
//     which_bram = 1;
//     // $readmemh("fake_bram2.list", fake_bram);
//     #1000;
//     $writememh("fake_bram_after2.list", fake_bram2);
//     $finish();
//   end
//   always #1 begin
//     clock = ~clock;
//     if (io_bram_en_a) begin
//       if (io_bram_we_a) begin
//         if (which_bram) begin
//           fake_bram2[io_bram_addr_a >> 2] <= io_bram_wrdata_a;
//         end
//         else
//         begin
//           fake_bram1[io_bram_addr_a >> 2] <= io_bram_wrdata_a;
//         end
//       end
//       else begin
//         if (which_bram) begin
//           io_bram_rddata_a <= fake_bram2[io_bram_addr_a >> 2];
//         end
//         else
//         begin
//           io_bram_rddata_a <= fake_bram1[io_bram_addr_a >> 2];
//         end
//       end
//     end
//   end
// endmodule

  // input         clock,
  // input         reset,
  // output [31:0] io_bram_addr_a,
  // output [31:0] io_bram_wrdata_a,
  // input  [31:0] io_bram_rddata_a,
  // output        io_bram_en_a,
  // output        io_bram_we_a


// module spriteaccel_testbench;
//   reg clk = 0;
//   reg resetn = 0;
//   reg [31:0] awaddr = 0;
//   reg awvalid = 0;
//   wire awready;
//   reg [31:0] wdata = 0;
//   reg [3:0] wstrb = 0;
//   reg wvalid = 0;
//   wire wready;
//   reg [31:0] araddr = 0;
//   reg arvalid = 0;
//   wire arready;
//   wire [31:0] rdata;
//   wire [1:0] rresp;
//   wire rvalid;
//   reg rready = 0;
//   wire [1:0] bresp;
//   wire bvalid;
//   reg bready = 0;

//   axi4lite_top axi4lite_top_inst (
//     .S_AXI_ACLK(clk),
//     .S_AXI_ARESETN(resetn),
//     .S_AXI_AWADDR(awaddr),
//     .S_AXI_AWVALID(awvalid),
//     .S_AXI_AWREADY(awready),
//     .S_AXI_WDATA(wdata),
//     .S_AXI_WSTRB(wstrb),
//     .S_AXI_WVALID(wvalid),
//     .S_AXI_WREADY(wready),
//     .S_AXI_ARADDR(araddr),
//     .S_AXI_ARVALID(arvalid),
//     .S_AXI_ARREADY(arready),
//     .S_AXI_RDATA(rdata),
//     .S_AXI_RRESP(rresp),
//     .S_AXI_RVALID(rvalid),
//     .S_AXI_RREADY(rready),
//     .S_AXI_BRESP(bresp),
//     .S_AXI_BVALID(bvalid),
//     .S_AXI_BREADY(bready)
//   );

//   initial begin
//     $dumpfile("dump.vcd");
//     $dumpvars(1);
//   end

//   always #1 clk = ~clk;

//   initial begin
//     resetn = 0; #10 resetn = 1;
//     #10
//     awaddr <= 32'h000000;
//     wdata <= 32'h5a5a5a5a;
//     awvalid <= 1;
//     wvalid <= 1;
//     rready <= 1;
//     wstrb <= 4'hF;


//     //     #3 write_addr <= addr;  //Put write address on bus
//     // write_data <= data; //put write data on bus
//     // write_addr_valid <= 1'b1; //indicate address is valid
//     // write_data_valid <= 1'b1; //indicate data is valid
//     // write_resp_ready <= 1'b1; //indicate ready for a response
//     // write_strb <= 4'hF;   //writing all 4 bytes


//     #1000;
//     $finish();
//   end
// endmodule



// // `define NUM_SCANLINES 480
// // `define SCANLINE_SIZE 640
// // `define SPRITETABLE_SIZE 256
// // `define TILEDATA_SIZE 256
// // `define NUM_PALETTES 4
// // `define NUM_BACKGROUNDS 2

// // `define SPRITEACCEL memory_widener_inst.memory_merger_inst.spriteaccel_inst

// // `define BACKGROUND_MEM_SIZE `NUM_BACKGROUNDS * 64 * 64 * 2 + `NUM_BACKGROUNDS * 4

// // `define WRITE_MEM(address2, value) write_request = 1;\
// //   address = ``address2``;\
// //   write_data = ``value``;\
// //   #20\
// //   write_request = 0

// // `define ASSERT_MEM(address2, value) read_request = 1;\
// //   address = ``address2``;\
// //   #30\
// //   assert_temp = read_data;\
// //   read_request = 0;\
// //   #30\
// //   if (assert_temp != ``value``) $display("%H %H", assert_temp, ``value``)

// // `define WRITE_MEM_4(address2, value1, value2, value3, value4)\
// //   #10\
// //   `WRITE_MEM(``address2``, ``value1`` + (``value2`` << 8) + (``value3`` << 16) + (``value4`` << 24))

// // `define WRITE_SPRITE(index, x, y, width, height, tile_index, pallete_index)\
// //   `WRITE_MEM_4(\
// //     `SPRITETABLE_MEM_OFFSET + ``index`` * `SPRITETABLE_ITEM_SIZE + `SPRITETABLE_ITEM_X_OFFSET_LO,\
// //     ``x`` & 8'hFF,\
// //     (``x`` >> 8) & 8'hFF,\
// //     ``y`` & 8'hFF,\
// //     (``y`` >> 8) & 8'hFF\
// //   );\
// //   `WRITE_MEM_4(\
// //     `SPRITETABLE_MEM_OFFSET + ``index`` * `SPRITETABLE_ITEM_SIZE + `SPRITETABLE_ITEM_WIDTH_OFFSET,\
// //     ``width``,\
// //     ``height``,\
// //     ``tile_index`` & 8'hFF,\
// //     (``tile_index`` >> 8) & 8'hFF\
// //   );\
// //   `WRITE_MEM_4(\
// //     `SPRITETABLE_MEM_OFFSET + ``index`` * `SPRITETABLE_ITEM_SIZE + `SPRITETABLE_ITEM_WIDTH_OFFSET,\
// //     ``width``,\
// //     ``height``,\
// //     ``tile_index`` & 8'hFF,\
// //     (``tile_index`` >> 8) & 8'hFF\
// //   );\
// //   `WRITE_MEM_4(\
// //     `SPRITETABLE_MEM_OFFSET + ``index`` * `SPRITETABLE_ITEM_SIZE + `SPRITETABLE_ITEM_PALETTE_INDEX,\
// //     0,\
// //     0,\
// //     0,\
// //     ``pallete_index``\
// //   )

// // `define MEMORY_PORT(prefix, memory_size)\
// //   reg ``prefix``_read_request = 0;\
// //   reg ``prefix``_read_success;\
// //   reg ``prefix``_write_request = 0;\
// //   reg ``prefix``_write_success;\
// //   reg [$clog2(``memory_size``)-1:0] ``prefix``_address = 0;\
// //   reg [31:0] ``prefix``_read_data;\
// //   reg [31:0] ``prefix``_write_data = 0

// // `define MEMORY_CONNECTION(prefix)\
// //   .``prefix``_read_request(``prefix``_read_request),\
// //   .``prefix``_read_success(``prefix``_read_success),\
// //   .``prefix``_write_request(``prefix``_write_request),\
// //   .``prefix``_write_success(``prefix``_write_success),\
// //   .``prefix``_address(``prefix``_address),\
// //   .``prefix``_read_data(``prefix``_read_data),\
// //   .``prefix``_write_data(``prefix``_write_data)

// // module spriteaccel_testbench;
// //   string CURRENT_TEST_NAME;
// //   integer i;
// //   integer j;
// //   integer outfile;
  
// //   reg clock = 0;
// //   reg reset = 0;
// //   reg read_request = 0;
// //   reg write_request = 0;
// //   wire read_success;
// //   wire write_success;
// //   reg [31:0] address = 0;
// //   reg [31:0] write_data = 0;
// //   reg [3:0] write_strobe = 0;
// //   reg [31:0] read_data;

// //   wire [4:0] state = memory_widener_inst.state;
// //   wire [31:0] read_data_r = memory_widener_inst.read_data_r;
// //   wire [7:0] aaa = memory_widener_inst.mm_read_data;
// //   wire [7:0] bbb = memory_widener_inst.memory_merger_inst.read_data;
// //   wire [7:0] ccc = memory_widener_inst.memory_merger_inst.control_read_data;

// //   reg [31:0] assert_temp;

// //   memory_widener #(
// //     .num_scanlines(`NUM_SCANLINES),
// //     .scanline_size(`SCANLINE_SIZE),
// //     .spritetable_size(`SPRITETABLE_SIZE),
// //     .tiledata_size(`TILEDATA_SIZE),
// //     .num_palettes(`NUM_PALETTES),
// //     .num_backgrounds(`NUM_BACKGROUNDS)
// //   ) memory_widener_inst (
// //     .clock(clock),
// //     .reset(reset),
// //     .read_request(read_request),
// //     .read_success(read_success),
// //     .write_request(write_request),
// //     .write_success(write_success),
// //     .address(address),
// //     .write_data(write_data),
// //     .write_strobe(write_strobe),
// //     .read_data(read_data)
// //   );

// //   initial begin
// //     $dumpfile("dump.vcd");
// //     $dumpvars(1);
// //   end

// //   always #1 clock = ~clock;

// //   initial begin

// //     $display("scanline_memory size:", $size(`SPRITEACCEL.scanline_memory));
// //     $display("control_memory size:", $size(`SPRITEACCEL.control_memory));

// //     // Initialize memory to zeroes
// //     for(i = 0; i < `SCANLINE_SIZE * 3; i++) begin
// //       `SPRITEACCEL.scanline_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `SPRITETABLE_SIZE * `SPRITETABLE_ITEM_SIZE; i++) begin
// //       `SPRITEACCEL.spritetable_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `TILEDATA_SIZE * 8 * 8; i++) begin
// //       `SPRITEACCEL.tiledata_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `NUM_PALETTES * 256 * 2; i++) begin
// //       `SPRITEACCEL.palette_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `BACKGROUND_MEM_SIZE; i++) begin
// //       `SPRITEACCEL.background_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `SETTINGS_MEMORY_SIZE; i++) begin
// //       `SPRITEACCEL.settings_memory[i] = 8'h00;
// //     end
// //     for(i = 0; i < `CONTROL_MEMORY_SIZE; i++) begin
// //       `SPRITEACCEL.control_memory[i] = 8'h00;
// //     end

// //     reset = 1; #10 reset = 0;

// //     // Test read/write functionality
// //     `WRITE_MEM(`SCANLINE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`SCANLINE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `WRITE_MEM(`SPRITETABLE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`SPRITETABLE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `WRITE_MEM(`TILEDATA_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`TILEDATA_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `WRITE_MEM(`PALETTE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`PALETTE_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `WRITE_MEM(`BACKGROUND_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`BACKGROUND_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `WRITE_MEM(`SETTINGS_MEM_OFFSET + 4, 32'h11223344);
// //     #10
// //     `ASSERT_MEM(`SETTINGS_MEM_OFFSET + 4, 32'h11223344);
// //     #10

// //     // Load in data
// //     $readmemh("spritetable_rom.list", `SPRITEACCEL.spritetable_memory);
// //     $readmemh("sprite_rom.list", `SPRITEACCEL.tiledata_memory);
// //     $readmemh("palette_rom.list", `SPRITEACCEL.palette_memory);
// //     $readmemh("background_rom.list", `SPRITEACCEL.background_memory);
// //     #10

// //     outfile = $fopen("scanlines.output.list");

// //     for(i = 0; i < `NUM_SCANLINES; i++) begin
// //       // Set scanline number
// //       `WRITE_MEM(`CONTROL_MEM_OFFSET + `CONTROL_MEMORY_SCANLINE_NUMBER_HI, (i & 16'hff00) >> 8);
// //       #10
// //       `WRITE_MEM(`CONTROL_MEM_OFFSET + `CONTROL_MEMORY_SCANLINE_NUMBER_LO, i & 8'hff);
// //       #100
// //       // Kick off a run
// //       `WRITE_MEM(`CONTROL_MEM_OFFSET + `CONTROL_MEMORY_RUN_OFFSET, 8'hff);
// //       #8000
// //       for (j = 0; j < (`SCANLINE_SIZE * 3); j += 3) begin
// //         $fwrite(outfile, "%02x%02x%02x",
// //           `SPRITEACCEL.scanline_memory[j],
// //           `SPRITEACCEL.scanline_memory[j + 1],
// //           `SPRITEACCEL.scanline_memory[j + 2]
// //         );
// //         if (j != (`SCANLINE_SIZE * 3) - 1) $fwrite(outfile, " ");
// //       end
// //       $fwrite(outfile, "\n");
// //     end

// //     $finish();
// //   end
// // endmodule
