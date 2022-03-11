module MisterSdram32MBController #(
  parameter NOP_SLOTS = 5,
  parameter REFRESH_AT = 300
) (
  input             clk,
  input             rst,
  input      [15:0] sdram_dq_in,
  output reg [15:0] sdram_dq_out = 0,
  output reg [11:0] sdram_a = 0,
  output reg        sdram_we = 1,
  output reg        sdram_cas = 1,
  output reg        sdram_ras = 1,
  output reg        sdram_cs1 = 0,
  output reg [1:0]  sdram_ba = 0,
  output reg        sdram_clk = 0,
  input             writeport_wr,
  input      [31:0] writeport_addr,
  input      [15:0] writeport_data,
  output reg        writeport_ack = 0,
  input             readport_rd,
  input      [31:0] readport_addr,
  output reg [15:0] readport_data = 0,
//   input             readport_next,
  output reg        readport_ack = 0
);
reg [3:0] refresh_state = 0;
reg [3:0] write_state = 0;
reg [3:0] read_state = 0;
reg [31:0] refresh_counter = 0;
reg [31:0] wt_cnt = 0;
reg [15:0] latched_addr = 0;
reg [31:0] latched_data = 0;
reg initial_state = 1;

`define INIT_WAIT wt_cnt <= 0;
`define WAIT_NOP_SLOTS(done) `ISSUE_NOP; if (wt_cnt == NOP_SLOTS) begin; refresh_state <= 0; end else begin; wt_cnt <= wt_cnt + 1; end
`define ISSUE_NOP sdram_we <= 1; sdram_cas <= 1; sdram_ras <= 1;
`define ISSUE_REFRESH sdram_we <= 1; sdram_cas <= 0; sdram_ras <= 0;
always @(posedge clk) begin
    if (initial_state) begin
        // TODO: Startup stuff
        initial_state <= 0;
    end else if (refresh_state != 0) begin
        if (refresh_state == 1) begin
            `ISSUE_REFRESH
            refresh_state <= 2;
            `INIT_WAIT
        end else begin
            `WAIT_NOP_SLOTS(refresh_state <= 0)
        end
    end else if (write_state != 0) begin
    end else if (read_state != 0) begin
    end else if (refresh_counter > REFRESH_AT) begin // QUESTION: Can a refresh squeeze in before a cart read in time???
        refresh_state <= 1;
        refresh_counter <= 0;
    end else if (writeport_wr) begin
        latched_addr <= writeport_addr;
        latched_data <= writeport_data;
        write_state <= 1;
    end else if (readport_rd) begin
        latched_addr <= writeport_addr;
        read_state <= 1;
    end else begin
        refresh_counter <= refresh_counter + 1;
    end
    sdram_clk <= ~sdram_clk;
end
endmodule

// reg [15:0] data_reg = 0;
// assign data = data_reg;
// reg [15:0] rom_data[0:((2**18)-1)];
// initial begin
//   $readmemh("../src/rom/rom.hex.txt", rom_data);
// end
// always @(posedge clk)
// begin
//     data_reg <= rom_data[addr >> 1];
// end
