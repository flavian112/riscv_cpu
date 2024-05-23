// immediate extend:
// Extracts immediate value from various instruction formats.

module immediate_extend (
  input      [31:0] instr,
  input       [2:0] imm_src,
  
  output reg [31:0] imm
);

`include "include/consts.vh"

always @ (*) begin
  case (imm_src)
    INSTR_FORMAT_I:  imm = { {21{instr[31]}}, instr[30:20] };                                // I
    INSTR_FORMAT_S:  imm = { {21{instr[31]}}, instr[30:25], instr[11:7] };                   // S
    INSTR_FORMAT_B:  imm = { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 };   // B
    INSTR_FORMAT_U:  imm = { instr[31:12], 12'b0 };                                          // U
    INSTR_FORMAT_J:  imm = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 }; // J
    default:         imm = 32'b0;                                                            // Unknown
  endcase
end


endmodule
