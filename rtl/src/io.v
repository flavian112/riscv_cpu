// io:
// Input and output register, connected to pins of fpga.

module io (
  input             clk,
  input             rstn,

  input             we,
  input      [31:0] addr,
  input       [2:0] size,
  input      [31:0] wd,

  output reg [31:0] rd,

  input      [31:0] io_in,
  output reg [31:0] io_out
);

`include "include/consts.vh"

always @ (posedge clk or negedge rstn) begin
  if (!rstn) begin
    io_out <= 32'b0;
  end else if (we && addr == 32'h0000_0004) begin
    io_out <= wd;
  end
end

always @ (posedge clk) begin
  if      (addr == 32'h0000_0000) rd <= io_in;
  else if (addr == 32'h0000_0004) rd <= io_out;
  else                            rd <= 32'b0;
end
endmodule