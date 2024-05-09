module alu_op_decode (
  input [6:0] opcode,
  input alu_ctrl,
  input [2:0] funct3,
  input [6:0] funct7,
  output reg [3:0] alu_op
);

parameter ALU_OP_ADD  = 4'b0000,
          ALU_OP_SUB  = 4'b0001,
          ALU_OP_SLT  = 4'b0010,
          ALU_OP_SLTU = 4'b0011,
          ALU_OP_AND  = 4'b0100,
          ALU_OP_OR   = 4'b0101,
          ALU_OP_XOR  = 4'b0110,
          ALU_OP_SLL  = 4'b1000,
          ALU_OP_SRL  = 4'b1001,
          ALU_OP_SRA  = 4'b1011;


always @ (*) begin
  if (alu_ctrl == 1'b1) alu_op <= ALU_OP_ADD;
  else case (opcode)
    7'b0110011: begin // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
      case (funct3)
        3'b000: alu_op <= funct7[5] ? ALU_OP_SUB : ALU_OP_ADD;
        3'b001: alu_op <= ALU_OP_SLL;
        3'b010: alu_op <= ALU_OP_SLT;
        3'b011: alu_op <= ALU_OP_SLTU;
        3'b100: alu_op <= ALU_OP_XOR;
        3'b101: alu_op <= funct7[5] ? ALU_OP_SRA : ALU_OP_SRL;
        3'b110: alu_op <= ALU_OP_OR;
        3'b111: alu_op <= ALU_OP_AND;
      endcase
    end
    7'b0010011: begin // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
      case (funct3)
        3'b000: alu_op <= ALU_OP_ADD;
        3'b001: alu_op <= ALU_OP_SLL;
        3'b010: alu_op <= ALU_OP_SLT;
        3'b011: alu_op <= ALU_OP_SLTU;
        3'b100: alu_op <= ALU_OP_XOR;
        3'b101: alu_op <= funct7[5] ? ALU_OP_SRA : ALU_OP_SRL;
        3'b110: alu_op <= ALU_OP_OR;
        3'b111: alu_op <= ALU_OP_AND;
      endcase
    end
    7'b0000011: begin // LB, LH, LW, LBU, LHU
    end
    7'b1100111: begin // JALR
    end
    7'b0100011: begin // SB, SH, SW
    end
    7'b1100011: begin // BEQ, BNE, BLT, BGE, BLTU, BGEU
      if ((funct3 == 3'b000) | (funct3 == 3'b001)) alu_op <= ALU_OP_SUB;
      else if ((funct3 == 3'b100) | (funct3 == 3'b101)) alu_op <= ALU_OP_SLT;
      else if ((funct3 == 3'b110) | (funct3 == 3'b111)) alu_op <= ALU_OP_SLTU; 
    end
    7'b0110111: begin // LUI
    end
    7'b0010111: begin // AUIPC
    end
    7'b1101111: begin // JAL
    end
    7'b0001111: begin // FENCE, FENCE.I
    end
    7'b1110011: begin // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
    end
  endcase
end

endmodule
