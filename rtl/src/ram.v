// ram:
// Contains data section of program and is used for stack/heap, etc.

module ram #( 
  parameter           SIZE = 1024
)(
    input             clk,
    input             rstn,
    input             we,
    input      [31:0] addr,
    input       [2:0] size,
    input      [31:0] wd,
    output reg [31:0] rd
);

`include "include/consts.vh"

//(* RAM_STYLE="BLOCK" *)
reg [31:0] mem [0:SIZE-1];


always @(posedge clk) begin
  if (we) mem[addr >> 2] <= wd;
  rd <= mem[addr >> 2];
end

endmodule
