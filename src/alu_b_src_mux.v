module alu_b_src_mux (
  input [31:0] src_rd2_buf, src_imm,
  input [1:0] alu_b_src,
  output reg [31:0] alu_b
);

always @(*) begin
  case (alu_b_src)
    2'b00:   alu_b <= src_rd2_buf;
    2'b01:   alu_b <= src_imm;
    2'b10:   alu_b <= 32'h4;
    default: alu_b <= 32'b0;
  endcase
end

endmodule
