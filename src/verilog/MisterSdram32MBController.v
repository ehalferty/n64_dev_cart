module MisterSdram32MBController #(
  parameter NOP_SLOTS = 5,
  parameter REFRESH_AT = 300
) (
  input             clk,
  input             rst,
  inout      [15:0] sdram_dq,
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
reg [15:0] sdram_dq_reg = 0;
reg writing = 0;
assign sdram_dq = writing ? sdram_dq_reg : 16'bZ;

`define INIT_WAIT wt_cnt <= 0;
`define WAIT_NOP_SLOTS(done) `ISSUE_NOP; if (wt_cnt == NOP_SLOTS) begin; done; end else begin; wt_cnt <= wt_cnt + 1; end
`define ISSUE_NOP sdram_we <= 1; sdram_cas <= 1; sdram_ras <= 1; writing <= 0;
`define ISSUE_REFRESH sdram_we <= 1; sdram_cas <= 0; sdram_ras <= 0;
`define ISSUE_BANK_ACTIVATE sdram_we <= 1; sdram_cas <= 1; sdram_ras <= 0; \
    sdram_ba <= latched_addr[24:23]; sdram_a <= latched_addr[22:13];
`define ISSUE_WRITE sdram_we <= 0; sdram_cas <= 0; sdram_ras <= 1; \
    sdram_a <= latched_addr[9:0]; sdram_dq_reg <= latched_data; writing <= 1;
`define ISSUE_READ sdram_we <= 1; sdram_cas <= 0; sdram_ras <= 1; \
    sdram_ba <= latched_addr[24:23]; sdram_a <= 12'h400 + latched_addr[9:0];
`define ISSUE_PRECHARGE_ALL sdram_we <= 0; sdram_cas <= 1; sdram_ras <= 0; sdram_a <= 12'h400;
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
        if (write_state == 1) begin // Activate
            `ISSUE_BANK_ACTIVATE
            write_state <= 2;
            `INIT_WAIT
        end else if (write_state == 2) begin
            `WAIT_NOP_SLOTS(write_state <= 3)
        end else if (write_state == 3) begin
            `ISSUE_WRITE
            write_state <= 4;
            `INIT_WAIT
        end else if (write_state == 4) begin
            `WAIT_NOP_SLOTS(write_state <= 5)
        end else if (write_state == 5) begin
            `ISSUE_PRECHARGE_ALL
            write_state <= 6;
            `INIT_WAIT
        end else if (write_state == 6) begin
            `WAIT_NOP_SLOTS(write_state <= 7)
        end else if (write_state == 7) begin
            if (!writeport_wr) begin
                writeport_ack <= 0;
                write_state <= 0;
            end else begin
                writeport_ack <= 1;
            end
        end
    end else if (read_state != 0) begin
        if (read_state == 1) begin // Activate
            `ISSUE_BANK_ACTIVATE
            read_state <= 2;
            `INIT_WAIT
        end else if (read_state == 2) begin
            `WAIT_NOP_SLOTS(read_state <= 3)
        end else if (read_state == 3) begin
            `ISSUE_READ
            read_state <= 4;
            `INIT_WAIT
        end else if (read_state == 4) begin
            `WAIT_NOP_SLOTS(read_state <= 5)
            readport_data <= sdram_dq;
        end else if (write_state == 5) begin
            `ISSUE_PRECHARGE_ALL
            read_state <= 6;
            `INIT_WAIT
        end else if (read_state == 6) begin
            `WAIT_NOP_SLOTS(read_state <= 7)
        end else if (read_state == 7) begin
            if (!readport_rd) begin
                readport_ack <= 0;
                read_state <= 0;
            end else begin
                readport_ack <= 1;
            end
        end
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
