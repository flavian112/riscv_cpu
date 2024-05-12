module pc_reg (
  input clk, 
  input rstn,
  input we,
  input [31:0] pc_in,
  output reg [31:0] pc
);


parameter PC_INITIAL = 32'h0001_0000;


always @ (posedge clk) begin
  if (!rstn) pc <= PC_INITIAL;
  else if (we) pc <= pc_in;
end

endmodule
