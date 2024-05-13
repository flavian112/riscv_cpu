module immediate_extend (
  input [31:0] instr,
  input [2:0] imm_src,
  
  output reg [31:0] imm
);


always @ (*) begin
  case (imm_src)
    3'b010:  imm <= { {21{instr[31]}}, instr[30:20] };                                // I
    3'b011:  imm <= { {21{instr[31]}}, instr[30:25], instr[11:7] };                   // S
    3'b100:  imm <= { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 };   // B
    3'b101:  imm <= { instr[31:12], 12'b0 };                                          // U
    3'b110:  imm <= { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 }; // J
    default: imm <= 32'b0;                                                            // Unknown
  endcase
end


endmodule
