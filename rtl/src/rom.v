module rom #(
  parameter N = 32, 
  parameter SIZE = 1024,
  parameter ROM_FILE = "../../build/rom.hex"
)(
    input clk,
    input [N-1:0] addr,
    output reg [N-1:0] data_read
);

`include "include/log2.vh"


//(* RAM_STYLE="BLOCK" *)
reg [N-1:0] mem [0:SIZE-1];

initial begin
  $readmemh(ROM_FILE, mem, 0, SIZE-1);
end

always @(negedge clk) begin
  data_read <= mem[addr >> 2];
end

endmodule
