module instruction_decode(
  input [31:0] instruction,
  output [6:0] opcode,
  output [2:0] funct3,
  output [6:0] funct7,
  output reg [31:0] immediate,
  output [4:0] rs1, rs2, rd
);

parameter INSTRUCTION_FORMAT_UNKNOWN  = 3'b000,
          INSTRUCTION_FORMAT_R        = 3'b001,
          INSTRUCTION_FORMAT_I        = 3'b010,
          INSTRUCTION_FORMAT_S        = 3'b011,
          INSTRUCTION_FORMAT_B        = 3'b100,
          INSTRUCTION_FORMAT_U        = 3'b101,
          INSTRUCTION_FORMAT_J        = 3'b110;

reg [2:0] instruction_format;

always @ (*) begin
  case (opcode)
    7'b0110011: instruction_format <= INSTRUCTION_FORMAT_R; // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
    7'b0010011: instruction_format <= INSTRUCTION_FORMAT_I; // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    7'b0000011: instruction_format <= INSTRUCTION_FORMAT_I; // LB, LH, LW, LBU, LHU
    7'b1100111: instruction_format <= INSTRUCTION_FORMAT_I; // JALR
    7'b0100011: instruction_format <= INSTRUCTION_FORMAT_S; // SB, SH, SW
    7'b1100011: instruction_format <= INSTRUCTION_FORMAT_B; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    7'b0110111: instruction_format <= INSTRUCTION_FORMAT_U; // LUI
    7'b0010111: instruction_format <= INSTRUCTION_FORMAT_U; // AUIPC
    7'b1101111: instruction_format <= INSTRUCTION_FORMAT_J; // JAL
    7'b0001111: instruction_format <= INSTRUCTION_FORMAT_I; // FENCE, FENCE.I
    7'b1110011: instruction_format <= INSTRUCTION_FORMAT_I; // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
    default:    instruction_format <= INSTRUCTION_FORMAT_UNKNOWN;
  endcase
end

always @ (*) begin
  case (instruction_format)
    INSTRUCTION_FORMAT_I: immediate <= { {21{instruction[31]}}, instruction[30:20] };
    INSTRUCTION_FORMAT_S: immediate <= { {21{instruction[31]}}, instruction[30:25], instruction[11:8], instruction[7] };
    INSTRUCTION_FORMAT_B: immediate <= { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
    INSTRUCTION_FORMAT_U: immediate <= { instruction[31], instruction[30:12], 12'b0 };
    INSTRUCTION_FORMAT_J: immediate <= { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
    default: immediate <= 32'b0;
  endcase
end

assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
assign funct7 = instruction[31:25];
assign rs1    = instruction[19:15];
assign rs2    = instruction[24:20];
assign rd     = instruction[11:7];


endmodule
