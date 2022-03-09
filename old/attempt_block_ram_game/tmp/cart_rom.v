module CartRom(
  input clk,
  input  [31:0] addr,
  output [15:0] data
);
reg [15:0] data_reg = 0;
assign data = data_reg;
reg [15:0] rom_data[0:((2**18)-1)];
initial begin
  $readmemh("../src/rom/rom.hex.txt", rom_data);
end
always @(posedge clk)
begin
    data_reg <= rom_data[addr >> 1];
end
endmodule
