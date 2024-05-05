module rom #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input [log2(SIZE)-1:0] addr,
    output reg [N-1:0] data_read
);

`include "include/log2.vh"

reg [7:0] memory [SIZE-1:0];

initial begin
  $readmemh("rom/rom.hex", memory);
end

always @(posedge clk) begin
  data_read = memory[addr];
end



endmodule
