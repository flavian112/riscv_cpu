// arithmetic unit:
// Arithmetic part of the alu.

module arithmetic_unit (
  input [31:0] a, 
  input [31:0] b,

  input [1:0] op,
  
  output reg [31:0] result
);

`include "include/consts.vh"

wire signed [31:0] a_signed, b_signed;

assign a_signed = a;
assign b_signed = b;

always @ (*) begin
  case (op)
    ARITHMETIC_OP_ADD:  result = a + b;                               // ADD
    ARITHMETIC_OP_SUB:  result = a - b;                               // SUB
    ARITHMETIC_OP_SLT:  result = { {31{1'b0}}, a_signed < b_signed }; // SLT
    ARITHMETIC_OP_SLTU: result = { {31{1'b0}}, a < b };               // SLTU
    default:            result = 32'b0;
  endcase
end

endmodule
