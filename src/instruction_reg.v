module instruction_reg (
  input clk, rstn, we,
  input [31:0] pc_in, instr_in,
  output reg [31:0] pc_buf, instr
);

always @ (posedge clk) begin
  if (!rstn) begin
    pc_buf <= 32'b0;
    instr  <= 32'b0;
  end else if (we) begin
    pc_buf <= pc_in;
    instr  <= instr_in;
  end
end

endmodule
