// rom:
// Contains instructions of program.

module rom #(
  parameter           SIZE = 1024,
  parameter           ROM_FILE = "../../build/rom.hex"
)(
    input             clk,
    input      [31:0] addr,
    output reg [31:0] rd
);

`include "include/consts.vh"



//(* RAM_STYLE="BLOCK" *)
reg [31:0] mem [0:SIZE-1];

initial begin
  $readmemh(ROM_FILE, mem, 0, SIZE-1);
end

always @ (negedge clk) begin
    rd <= mem[addr >> 2];
end

endmodule
