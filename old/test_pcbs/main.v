`timescale 1ns / 1ps

module main(
input CLK1,
output [15:0] N64_AD,
output N64_READ_N,
output N64_WRITE_N,
output N64_COLD_RESTART,
output N64_CLK,
output N64_ALE_H,
output N64_ALE_L,
output N64_NMI_N,
output N64_EN,
output N64_RST,
output N64_INT4,
output [7:0] LED
    );
    assign N64_AD[15]       = (((testpattern >> 0) & 1) == 1);
    assign N64_AD[14]       = (((testpattern >> 1) & 1) == 1);
    assign N64_AD[13]       = (((testpattern >> 2) & 1) == 1);
    assign N64_AD[12]       = (((testpattern >> 3) & 1) == 1);
    assign N64_WRITE_N      = (((testpattern >> 4) & 1) == 1);
    assign N64_READ_N       = (((testpattern >> 5) & 1) == 1);
    assign N64_AD[11]       = (((testpattern >> 6) & 1) == 1);
    assign N64_AD[10]       = (((testpattern >> 7) & 1) == 1);
    assign N64_AD[9]        = (((testpattern >> 8) & 1) == 1);
    assign N64_AD[8]        = (((testpattern >> 9) & 1) == 1);
    assign N64_CLK          = (((testpattern >> 10) & 1) == 1);
    assign N64_COLD_RESTART = (((testpattern >> 11) & 1) == 1);
    assign N64_INT4         = (((testpattern >> 12) & 1) == 1);
    assign N64_EN           = (((testpattern >> 13) & 1) == 1);
    assign N64_RST          = (((testpattern >> 14) & 1) == 1);
    assign N64_NMI_N        = (((testpattern >> 15) & 1) == 1);
    assign N64_AD[7]        = (((testpattern >> 16) & 1) == 1);
    assign N64_AD[6]        = (((testpattern >> 17) & 1) == 1);
    assign N64_AD[5]        = (((testpattern >> 18) & 1) == 1);
    assign N64_AD[4]        = (((testpattern >> 19) & 1) == 1);
    assign N64_ALE_H        = (((testpattern >> 20) & 1) == 1);
    assign N64_ALE_L        = (((testpattern >> 21) & 1) == 1);
    assign N64_AD[3]        = (((testpattern >> 22) & 1) == 1);
    assign N64_AD[2]        = (((testpattern >> 23) & 1) == 1);
    assign N64_AD[1]        = (((testpattern >> 24) & 1) == 1);

    assign LED[0]           = (((testpattern >> 0) & 1) == 1);
    assign LED[1]           = (((testpattern >> 1) & 1) == 1);
    assign LED[2]           = (((testpattern >> 2) & 1) == 1);
    assign LED[3]           = (((testpattern >> 3) & 1) == 1);
    assign LED[4]           = (((testpattern >> 4) & 1) == 1);
    assign LED[5]           = (((testpattern >> 5) & 1) == 1);
    assign LED[6]           = (((testpattern >> 6) & 1) == 1);
    assign LED[7]           = (((testpattern >> 7) & 1) == 1);

    reg [63:0] clockdivider = 64'b0;
    reg [24:0] testpattern = 25'b0000000000000000000000001;
    
    always @ (posedge CLK1) begin
      if (clockdivider == 1000000000)
      begin
        clockdivider <= 0;
        if (testpattern == 25'b1000000000000000000000000)
        begin
          testpattern <= 25'b0000000000000000000000001;
        end
        else
        begin
          testpattern <= (testpattern << 1);
        end
        clockdivider <= 0;
      end
      else
      begin
        clockdivider <= clockdivider + 1;
      end
    end
endmodule
