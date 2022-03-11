module MisterSdram32MBController #(
  parameter NOP_SLOTS = 5,
  parameter REFRESH_AT = 300
) (
  input             clock,
  input             reset,
  input      [15:0] sdram_dq_in,
  output reg [15:0] sdram_dq_out,
  output reg [12:0] sdram_a,
  output reg        sdram_we,
  output reg        sdram_cas,
  output reg        sdram_ras,
  output reg        sdram_cs1,
  output reg [1:0]  sdram_ba,
  output reg        sdram_clk,
  input             writeport_wr,
  input      [31:0] writeport_addr,
  input      [15:0] writeport_data,
  output reg        writeport_ack,
  input             readport_rd,
  input      [31:0] readport_addr,
  output reg [15:0] readport_data,
  input             readport_next,
  output reg        readport_ack
);
reg [3:0] refresh_state = 0;
reg [3:0] write_state = 0;
reg [3:0] read_state = 0;
reg [31:0] refresh_counter = 0;
reg [31:0] wait_counter = 0;
always @(posedge clock) begin
    if (refresh_state != 0) begin
    end else if (write_state != 0) begin
    end else if (read_state != 0) begin
    end else if (refresh_counter > REFRESH_AT) begin
        refresh_state <= 1;
        refresh_counter <= 0;
    end
    sdramClk <= ~sdramClk;
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
