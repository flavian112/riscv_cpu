// data reg:
// Stores output of memory unit for one more cycle.

module data_reg (
  input             clk,
  input             rstn,

  input      [31:0] data_in,
  output reg [31:0] data_buf
);

always @ (posedge clk or negedge rstn) begin
  if (!rstn) data_buf <= 32'b0;
  else       data_buf <= data_in;
end

endmodule
