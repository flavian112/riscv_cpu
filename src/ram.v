module ram #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input rstn,
    input we,
    input [log2(SIZE/4)-1:0] addr,
    input [N-1:0] data_write,
    output reg [N-1:0] data_read
);

`include "include/log2.vh"

//(* RAM_STYLE="BLOCK" *)
reg [N-1:0] mem [SIZE-1:0];

always @(posedge clk) begin
  if (we) mem[addr >> 2] <= data_write; 
  data_read <= mem[addr >> 2];
end

endmodule
