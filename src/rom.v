module rom #(
  parameter N = 32, 
  parameter SIZE = 1024
)(
    input clk,
    input rst,
    input [log2(SIZE)-1:0] addr,
    output [N-1:0] data_read
);

`include "include/log2.vh"

endmodule
