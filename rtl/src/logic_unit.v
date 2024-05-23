// logic unit:
// Logic part of alu.

module logic_unit (
  input      [31:0] a, 
  input      [31:0] b,

  input       [1:0] op,
  
  output reg [31:0] result
);

`include "include/consts.vh"
  
always @ (*) begin
  case (op)
    LOGIC_OP_AND: result = a & b; // AND
    LOGIC_OP_OR:  result = a | b; // OR
    LOGIC_OP_XOR: result = a ^ b; // XOR
    default:      result = 32'b0;
  endcase
end

endmodule
