module ram #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input rst,
    input we,
    input [log2(SIZE)-1:0] addr,
    input [N-1:0] data_write,
    output [N-1:0] data_read
);

`include "include/log2.vh"

reg [8:0] memory [SIZE-1:0];

assign data_read = { memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr + 0] };


always @(posedge clk) begin
  if (we) begin
    { memory[addr + 3], memory[addr + 2], memory[addr + 1], memory[addr + 0] } <= data_write;
  end
end

endmodule
