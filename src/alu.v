module alu (
  input [31:0] a, 
  input [31:0] b,

  input [3:0] op,
  
  output reg [31:0] result,
  output zero
);

wire [31:0] arithmetic_result, logic_result, shift_result;

arithmetic_unit au (
  .a(a),
  .b(b),
  .op(op[1:0]),
  .result(arithmetic_result)
);

logic_unit lu (
  .a(a),
  .b(b),
  .op(op[1:0]),
  .result(logic_result)
);

shift_unit su (
  .a(a),
  .b(b[4:0]),
  .op(op[1:0]),
  .result(shift_result)
);

`include "include/consts.vh"

always @ (*) begin
  case (op[3:2])
    ALU_OP_ARITHMETIC: result = arithmetic_result; // ARITHMETIC
    ALU_OP_LOGIC:      result = logic_result;      // LOGIC
    ALU_OP_SHIFT:      result = shift_result;      // SHIFT
    default:           result = 31'b0;
  endcase
end

assign zero = result == 32'b0;

endmodule
