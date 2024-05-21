// control unit:
// This is a fsm that controls various signals of the cpu and
// manages its state.

module control_unit (
 input clk, 
 input rstn,

 input [31:0] instr,
 input alu_zero,

 output reg [2:0] imm_src,
 output pc_we,

 output reg mem_addr_src,
 output reg mem_we,

 output reg instr_we,

 output reg rf_we,
 output [4:0] ra1, ra2, wa3,

 output reg [2:0] alu_a_src,
 output reg [1:0] alu_b_src,
 output [3:0] alu_op,

 output reg [1:0] result_src
);

`include "include/consts.vh"

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

reg branch;
reg pc_update;
reg alu_ctrl;

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign ra1 = instr[19:15];
assign ra2 = instr[24:20];
assign wa3 = instr[11:7];

// controls if pc gets updated
// funct3[0] is 0 for BEQ, BLT, BLTU and 1 for BNE, BGE, BGEU
// funct3[2] is 0 for BEQ, BNE       and 1 for BLT, BLTU, BGE, BGEU
assign pc_we = ((alu_zero ^ funct3[0] ^ funct3[2]) & branch) | pc_update;

alu_op_decode alu_op_decode (
  .opcode(opcode),
  .alu_ctrl(alu_ctrl),
  .funct3(funct3),
  .funct7(funct7),
  .alu_op(alu_op)
);

always @ (*) begin
  case (opcode)
    OPCODE_REG:    imm_src = INSTR_FORMAT_R; // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
    OPCODE_IMM:    imm_src = INSTR_FORMAT_I; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    OPCODE_LOAD:   imm_src = INSTR_FORMAT_I; // LB, LH, LW, LBU, LHU
    OPCODE_JALR:   imm_src = INSTR_FORMAT_I; // JALR
    OPCODE_STORE:  imm_src = INSTR_FORMAT_S; // SB, SH, SW
    OPCODE_BRANCH: imm_src = INSTR_FORMAT_B; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    OPCODE_LUI:    imm_src = INSTR_FORMAT_U; // LUI
    OPCODE_AUIPC:  imm_src = INSTR_FORMAT_U; // AUIPC
    OPCODE_JAL:    imm_src = INSTR_FORMAT_J; // JAL
    OPCODE_SYNC:   imm_src = INSTR_FORMAT_I; // FENCE
    OPCODE_SYS:    imm_src = INSTR_FORMAT_I; // ECALL, EBREAK
    default:       imm_src = INSTR_FORMAT_UNKNOWN;
  endcase
end

// state register
reg [3:0] state, next_state;

always @ (posedge clk or negedge rstn) begin
  if (!rstn) state <= STATE_FETCH;
  else state <= next_state;
end

// next state logic
always @ (*) begin
  case(state)
    STATE_FETCH:     next_state = STATE_DECODE;
    STATE_DECODE: case(opcode)
      OPCODE_LOAD:   next_state = STATE_MEM_ADDR;
      OPCODE_STORE:  next_state = STATE_MEM_ADDR;
      OPCODE_REG:    next_state = STATE_EXECUTE_R;
      OPCODE_IMM:    next_state = STATE_EXECUTE_I;
      OPCODE_JAL:    next_state = STATE_JAL;
      OPCODE_JALR:   next_state = STATE_JALR;
      OPCODE_LUI:    next_state = STATE_LUI;
      OPCODE_AUIPC:  next_state = STATE_AUIPC;
      OPCODE_BRANCH: next_state = STATE_BRANCH;
      default:       next_state = STATE_FETCH;
    endcase
    STATE_MEM_ADDR:  case(opcode)
      OPCODE_LOAD:   next_state = STATE_MEM_LOAD;
      OPCODE_STORE:  next_state = STATE_MEM_STORE; 
      default:       next_state = STATE_FETCH;
    endcase
    STATE_MEM_LOAD:  next_state = STATE_MEM_WB;
    STATE_MEM_WB:    next_state = STATE_FETCH;
    STATE_MEM_STORE: next_state = STATE_FETCH;
    STATE_EXECUTE_R: next_state = STATE_ALU_WB;
    STATE_ALU_WB:    next_state = STATE_FETCH;
    STATE_EXECUTE_I: next_state = STATE_ALU_WB;
    STATE_JAL:       next_state = STATE_ALU_WB;
    STATE_JALR:      next_state = STATE_ALU_WB;
    STATE_LUI:       next_state = STATE_ALU_WB;
    STATE_AUIPC:     next_state = STATE_ALU_WB;
    STATE_BRANCH:    next_state = STATE_FETCH;
    default:         next_state = STATE_FETCH; 
  endcase
end


// output/control logic
always @ (*) begin
  mem_addr_src = MEM_ADDR_SRC_RESULT;
  alu_a_src    = ALU_A_SRC_RD1_BUF;
  alu_b_src    = ALU_B_SRC_RD2_BUF;
  alu_ctrl     = ALU_CTRL_OP;
  result_src   = RESULT_SRC_ALU_RESULT;
  mem_we       = MEM_WE_DISABLE;
  rf_we        = RF_WE_DISABLE;
  instr_we     = INSTR_WE_DISABLE;
  pc_update    = PC_UPDATE_DISABLE;
  branch       = BRANCH_DISABLE;
  case(state)
    STATE_FETCH: begin
      mem_addr_src = MEM_ADDR_SRC_PC;
      alu_a_src    = ALU_A_SRC_PC;
      alu_b_src    = ALU_B_SRC_4;
      alu_ctrl     = ALU_CTRL_ADD;
      result_src   = RESULT_SRC_ALU_RESULT;
      instr_we     = INSTR_WE_ENABLE;
      pc_update    = PC_UPDATE_ENABLE;
    end
    STATE_DECODE: begin
      alu_a_src    = (opcode == OPCODE_JALR) ? ALU_A_SRC_RD1 : ALU_A_SRC_PC_BUF;
      alu_b_src    = ALU_B_SRC_IMM;
      alu_ctrl     = ALU_CTRL_ADD;
    end
    STATE_MEM_ADDR: begin
      alu_a_src    = ALU_A_SRC_RD1_BUF;
      alu_b_src    = ALU_B_SRC_IMM;
      alu_ctrl     = ALU_CTRL_ADD;
    end
    STATE_MEM_LOAD: begin
      mem_addr_src = MEM_ADDR_SRC_RESULT;
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
    end
    STATE_MEM_WB: begin
      result_src   = RESULT_SRC_DATA_BUF;
      rf_we        = RF_WE_ENABLE;
    end
    STATE_MEM_STORE: begin
      mem_addr_src = MEM_ADDR_SRC_RESULT;
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
      mem_we       = MEM_WE_ENABLE;
    end
    STATE_EXECUTE_R: begin
      alu_a_src    = ALU_A_SRC_RD1_BUF;
      alu_b_src    = ALU_B_SRC_RD2_BUF;
      alu_ctrl     = ALU_CTRL_OP;
    end
    STATE_ALU_WB: begin
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
      rf_we        = RF_WE_ENABLE;
    end
    STATE_EXECUTE_I: begin
      alu_a_src    = ALU_A_SRC_RD1_BUF;
      alu_b_src    = ALU_B_SRC_IMM;
      alu_ctrl     = ALU_CTRL_OP;
    end
    STATE_JAL: begin
      alu_a_src    = ALU_A_SRC_PC_BUF;
      alu_b_src    = ALU_B_SRC_4;
      alu_ctrl     = ALU_CTRL_ADD;
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
      pc_update    = PC_UPDATE_ENABLE;
    end
    STATE_JALR: begin
      alu_a_src    = ALU_A_SRC_PC_BUF;
      alu_b_src    = ALU_B_SRC_4;
      alu_ctrl     = ALU_CTRL_ADD;
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
      pc_update    = PC_UPDATE_ENABLE;
    end
    STATE_LUI: begin
      alu_a_src    = ALU_A_SRC_0;
      alu_b_src    = ALU_B_SRC_IMM;
      alu_ctrl     = ALU_CTRL_ADD;
    end
    STATE_AUIPC: begin
      alu_a_src    = ALU_A_SRC_PC_BUF;
      alu_b_src    = ALU_B_SRC_IMM;
      alu_ctrl     = ALU_CTRL_ADD;
    end
    STATE_BRANCH: begin
      alu_a_src    = ALU_A_SRC_RD1_BUF;
      alu_b_src    = ALU_B_SRC_RD2_BUF;
      alu_ctrl     = ALU_CTRL_OP;
      result_src   = RESULT_SRC_ALU_RESULT_BUF;
      branch       = BRANCH_ENABLE;
    end
  endcase
end

endmodule
