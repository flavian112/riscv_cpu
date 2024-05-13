module alu_a_src_mux (
  input [31:0] src_pc, 
  input [31:0] src_pc_buf, 
  input [31:0] src_rd1_buf,

  input [1:0] alu_a_src,

  output reg [31:0] alu_a
);

always @(*) begin
  case (alu_a_src)
    2'b00:   alu_a <= src_pc;
    2'b01:   alu_a <= src_pc_buf;
    2'b10:   alu_a <= src_rd1_buf;
    default: alu_a <= 32'b0;
  endcase
end

endmodule
