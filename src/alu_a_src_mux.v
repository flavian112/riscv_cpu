module alu_a_src_mux (
  input [31:0] src_pc, 
  input [31:0] src_pc_buf, 
  input [31:0] src_rd1_buf,
  input [31:0] src_rd1,

  input [2:0] alu_a_src,

  output reg [31:0] alu_a
);

`include "include/consts.vh"

always @(*) begin
  case (alu_a_src)
    ALU_A_SRC_PC:      alu_a = src_pc;
    ALU_A_SRC_PC_BUF:  alu_a = src_pc_buf;
    ALU_A_SRC_RD1_BUF: alu_a = src_rd1_buf;
    ALU_A_SRC_RD1:     alu_a = src_rd1;
    ALU_A_SRC_0:       alu_a = 32'b0;
    default:           alu_a = 32'b0;
  endcase
end

endmodule
