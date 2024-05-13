module alu_result_reg (
  input clk, 
  input rstn,
  
  input [31:0] alu_result_in,
  output reg [31:0] alu_result_buf
);

always @ (posedge clk) begin
  if (!rstn) alu_result_buf <= 32'b0;
  else alu_result_buf <= alu_result_in;
end

endmodule
