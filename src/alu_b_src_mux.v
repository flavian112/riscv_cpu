module alu_b_src_mux (
  input [31:0] src_rd2_buf,
  input [31:0] src_imm,

  input [1:0] alu_b_src,
  
  output reg [31:0] alu_b
);

`include "include/consts.vh"

always @(*) begin
  case (alu_b_src)
    ALU_B_SRC_RD2_BUF: alu_b = src_rd2_buf;
    ALU_B_SRC_IMM:     alu_b = src_imm;
    ALU_B_SRC_4:       alu_b = 32'h4;
    default:           alu_b = 32'b0;
  endcase
end

endmodule
