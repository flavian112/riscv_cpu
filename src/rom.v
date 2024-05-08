module rom #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input [log2(SIZE)-1:0] addr,
    output reg [N-1:0] data_read
);

`include "include/log2.vh"

reg [7:0] memory [0:SIZE-1];

initial begin
  $readmemh("build/rom.hex", memory, 0, SIZE-1);
end

always @(posedge clk) begin
  data_read <= {memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr + 0] };
end



endmodule
