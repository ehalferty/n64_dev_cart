module BindsTo_0_N64DevCartMain(
  input         clock,
  input         reset,
  input  [15:0] io_n64adi,
  input         io_n64readn,
  input         io_n64alel,
  input         io_n64aleh,
  output [15:0] io_n64ado
);

initial begin
  $readmemh("/Users/ed/n64/dx-explo/explode/rom.hex.txt", N64DevCartMain._T);
end
                      endmodule

bind N64DevCartMain BindsTo_0_N64DevCartMain BindsTo_0_N64DevCartMain_Inst(.*);