module ram #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input rst,
    input we,
    input [log2(SIZE)-1:0] addr,
    input [N-1:0] data_write,
    output reg [N-1:0] data_read
);

`include "include/log2.vh"

reg [8:0] ram_block [SIZE-1:0];

integer i;
always @(posedge clk or posedge rst) begin
  if (rst) begin
    for (i = 0; i < SIZE; i = i + 1)
      ram_block[i] <= 0;
  end else begin
    if (we) begin
      ram_block[addr] = data_write;
    end
    data_read = ram_block[addr];      
  end

end

endmodule
