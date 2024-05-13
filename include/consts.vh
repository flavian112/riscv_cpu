parameter ALU_A_SRC_PC      = 2'b00;
parameter ALU_A_SRC_PC_BUF  = 2'b01;
parameter ALU_A_SRC_RD1_BUF = 2'b10;
parameter ALU_A_SRC_0       = 2'b11;

parameter ALU_B_SRC_RD2_BUF = 2'b00;
parameter ALU_B_SRC_IMM     = 2'b01;
parameter ALU_B_SRC_4       = 2'b10;

parameter RESULT_SRC_ALU_RESULT_BUF = 2'b00;
parameter RESULT_SRC_DATA_BUF       = 2'b01;
parameter RESULT_SRC_ALU_RESULT     = 2'b10;

parameter MEM_ADDR_SRC_PC     = 1'b0;
parameter MEM_ADDR_SRC_RESULT = 1'b1;

parameter ARITHMETIC_OP_ADD  = 2'b00;
parameter ARITHMETIC_OP_SUB  = 2'b01;
parameter ARITHMETIC_OP_SLT  = 2'b10;
parameter ARITHMETIC_OP_SLTU = 2'b11;

parameter LOGIC_OP_AND = 2'b00;
parameter LOGIC_OP_OR  = 2'b01;
parameter LOGIC_OP_XOR = 2'b10;

parameter SHIFT_OP_SLL = 2'b00;
parameter SHIFT_OP_SRL = 2'b01;
parameter SHIFT_OP_SRA = 2'b11;

parameter ALU_OP_ARITHMETIC = 2'b00;
parameter ALU_OP_LOGIC      = 2'b01;
parameter ALU_OP_SHIFT      = 2'b10;

parameter ALU_OP_ADD  = { ALU_OP_ARITHMETIC, ARITHMETIC_OP_ADD };
parameter ALU_OP_SUB  = { ALU_OP_ARITHMETIC, ARITHMETIC_OP_SUB };
parameter ALU_OP_SLT  = { ALU_OP_ARITHMETIC, ARITHMETIC_OP_SLT };
parameter ALU_OP_SLTU = { ALU_OP_ARITHMETIC, ARITHMETIC_OP_SLTU };
parameter ALU_OP_AND  = { ALU_OP_LOGIC, LOGIC_OP_AND };
parameter ALU_OP_OR   = { ALU_OP_LOGIC, LOGIC_OP_OR };
parameter ALU_OP_XOR  = { ALU_OP_LOGIC, LOGIC_OP_XOR };
parameter ALU_OP_SLL  = { ALU_OP_SHIFT, SHIFT_OP_SLL };
parameter ALU_OP_SRL  = { ALU_OP_SHIFT, SHIFT_OP_SRL };
parameter ALU_OP_SRA  = { ALU_OP_SHIFT, SHIFT_OP_SRA };

parameter STATE_FETCH     = 4'h0;
parameter STATE_DECODE    = 4'h1;
parameter STATE_MEM_ADDR  = 4'h2;
parameter STATE_MEM_LOAD  = 4'h3;
parameter STATE_MEM_STORE = 4'h4;
parameter STATE_MEM_WB    = 4'h5;
parameter STATE_EXECUTE_R = 4'h6;
parameter STATE_EXECUTE_I = 4'h7;
parameter STATE_JAL       = 4'h8;
parameter STATE_JALR      = 4'h9;
parameter STATE_LUI       = 4'ha;
parameter STATE_ALU_WB    = 4'hb;
parameter STATE_AUIPC     = 4'hc;
parameter STATE_BRANCH    = 4'hd;

parameter INSTR_FORMAT_UNKNOWN = 3'b000;
parameter INSTR_FORMAT_R       = 3'b001;
parameter INSTR_FORMAT_I       = 3'b010;
parameter INSTR_FORMAT_S       = 3'b011;
parameter INSTR_FORMAT_B       = 3'b100;
parameter INSTR_FORMAT_U       = 3'b101;
parameter INSTR_FORMAT_J       = 3'b110;

parameter OPCODE_LUI    = 7'b0110111;
parameter OPCODE_AUIPC  = 7'b0010111;
parameter OPCODE_JAL    = 7'b1101111;
parameter OPCODE_JALR   = 7'b1100111;
parameter OPCODE_BRANCH = 7'b1100011;
parameter OPCODE_LOAD   = 7'b0000011;
parameter OPCODE_STORE  = 7'b0100011;
parameter OPCODE_IMM    = 7'b0010011;
parameter OPCODE_REG    = 7'b0110011;
parameter OPCODE_SYNC   = 7'b0001111;
parameter OPCODE_SYS    = 7'b1110011;

parameter FUNCT3_LS_B  = 3'b000;
parameter FUNCT3_LS_H  = 3'b001;
parameter FUNCT3_LS_W  = 3'b010;
parameter FUNCT3_LS_BU = 3'b100;
parameter FUNCT3_LS_HU = 3'b101;

parameter FUNCT3_ALU_ADD_SUB = 3'b000;
parameter FUNCT3_ALU_SLT     = 3'b010;
parameter FUNCT3_ALU_SLTU    = 3'b011;
parameter FUNCT3_ALU_XOR     = 3'b100;
parameter FUNCT3_ALU_OR      = 3'b110;
parameter FUNCT3_ALU_AND     = 3'b111;
parameter FUNCT3_ALU_SLL     = 3'b001;
parameter FUNCT3_ALU_SR      = 3'b101;

parameter FUNCT3_BRANCH_BEQ  = 3'b000;
parameter FUNCT3_BRANCH_BNE  = 3'b001;
parameter FUNCT3_BRANCH_BLT  = 3'b100;
parameter FUNCT3_BRANCH_BGE  = 3'b101;
parameter FUNCT3_BRANCH_BLTU = 3'b110;
parameter FUNCT3_BRANCH_BGEU = 3'b111;

parameter FUNCT7_ALU_ADD = 7'b0000000;
parameter FUNCT7_ALU_SUB = 7'b0100000;
parameter FUNCT7_ALU_SRL = 7'b0000000;
parameter FUNCT7_ALU_SRA = 7'b0100000;

parameter ALU_CTRL_OP  = 1'b0;
parameter ALU_CTRL_ADD = 1'b1;

parameter MEM_WE_ENABLE     = 1'b1;
parameter MEM_WE_DISABLE    = 1'b0;
parameter RF_WE_ENABLE      = 1'b1;
parameter RF_WE_DISABLE     = 1'b0;
parameter INSTR_WE_ENABLE   = 1'b1;
parameter INSTR_WE_DISABLE  = 1'b0;
parameter PC_UPDATE_ENABLE  = 1'b1;
parameter PC_UPDATE_DISABLE = 1'b0;
parameter BRANCH_ENABLE     = 1'b1;
parameter BRANCH_DISABLE    = 1'b0;