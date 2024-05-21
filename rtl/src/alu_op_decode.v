module alu_op_decode (
  input [6:0] opcode,
  input [2:0] funct3,
  input [6:0] funct7,
  
  input alu_ctrl,
  
  output reg [3:0] alu_op
);

`include "include/consts.vh"

always @ (*) begin
  if (alu_ctrl == ALU_CTRL_ADD) begin
    alu_op = ALU_OP_ADD;
  end else if (opcode == OPCODE_REG || opcode == OPCODE_IMM) begin
    case (funct3)
      FUNCT3_ALU_ADD_SUB: alu_op = (opcode == OPCODE_REG && funct7 == FUNCT7_ALU_SUB) ? ALU_OP_SUB : ALU_OP_ADD;
      FUNCT3_ALU_SLL:     alu_op = ALU_OP_SLL;
      FUNCT3_ALU_SLT:     alu_op = ALU_OP_SLT;
      FUNCT3_ALU_SLTU:    alu_op = ALU_OP_SLTU;
      FUNCT3_ALU_XOR:     alu_op = ALU_OP_XOR;
      FUNCT3_ALU_SR:      alu_op = funct7 == FUNCT7_ALU_SRL ? ALU_OP_SRL : ALU_OP_SRA;
      FUNCT3_ALU_OR:      alu_op = ALU_OP_OR;
      FUNCT3_ALU_AND:     alu_op = ALU_OP_AND;
      default:            alu_op = ALU_OP_ADD;
    endcase
  end else if (opcode == OPCODE_BRANCH) begin
    case (funct3)
      FUNCT3_BRANCH_BEQ:  alu_op = ALU_OP_SUB;
      FUNCT3_BRANCH_BNE:  alu_op = ALU_OP_SUB;
      FUNCT3_BRANCH_BLT:  alu_op = ALU_OP_SLT;
      FUNCT3_BRANCH_BGE:  alu_op = ALU_OP_SLT;
      FUNCT3_BRANCH_BLTU: alu_op = ALU_OP_SLTU;
      FUNCT3_BRANCH_BGEU: alu_op = ALU_OP_SLTU;
      default:            alu_op = ALU_OP_ADD;
    endcase
  end else begin
    alu_op = ALU_OP_ADD;
  end
end

endmodule
