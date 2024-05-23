// pc reg:
// Stores current pc.

module pc_reg (
  input             clk, 
  input             rstn,

  input             we,
  input      [31:0] pc_in,

  output reg [31:0] pc
);

`include "include/consts.vh"

always @ (posedge clk or negedge rstn) begin
  if (!rstn)   pc <= PC_INITIAL;
  else if (we) pc <= pc_in;
end

endmodule
