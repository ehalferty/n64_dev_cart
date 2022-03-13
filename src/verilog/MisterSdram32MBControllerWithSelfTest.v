module MisterSdram32MBControllerWithSelfTest (
  input         clk,
  inout  [15:0] sdram_dq,
  output [11:0] sdram_a,
  output        sdram_we,
  output        sdram_cas,
  output        sdram_ras,
  output        sdram_cs1,
  output [1:0]  sdram_ba,
  output        sdram_clk,
  input         writeport_wr,
  input  [31:0] writeport_addr,
  input  [15:0] writeport_data,
  output        writeport_ack,
  input         readport_rd,
  input  [31:0] readport_addr,
  output [15:0] readport_data,
  output        readport_ack,
  output reg    selftest_pass = 0,
  output reg    selftest_fail = 0,
);
  reg [64:0] counter = 0;
  reg [3:0] state = 0;
  always @(posedge clk) begin
      if (state == 0) begin // Wait for a second
        if (counter > (100*1000*1000)) begin
            counter <= 0;
            state <= 1;
        end else begin
            counter <= counter + 1;
        end
      end else if (state == 1) begin // Issue a write
      end else if (state == 2) begin // Wait for ack
      end else if (state == 3) begin // Wait for awhile
      end else if (state == 4) begin // Issue a read
      end else if (state == 5) begin // Wait for ack
      end else if (state == 6) begin // Wait for awhile
      // TODO: Loop back to state 1 and do this a few more times? fibonacci increase addr each time? check usable mem space?
      end
  end
  MisterSdram32MBController MisterSdram32MBController_0(
    .clk(clk),
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
