module alu #(
  parameter N = 32
)(
  input [N-1:0] src0, src1,
  input [3:0] op, // alu_op[3:2] 00: ARITHMETIC, 01: LOGIC, 10: SHIFT 
  output reg [N-1:0] result,
  output zero
);

wire [N-1:0] arithmetic_result, logic_result, shift_result;

arithmetic_unit #(.N(N)) au (
  .src0(src0),
  .src1(src1),
  .op(op[1:0]),
  .result(arithmetic_result)
);

logic_unit #(.N(N)) lu (
  .src0(src0),
  .src1(src1),
  .op(op[1:0]),
  .result(logic_result)
);

shift_unit #(.N(N)) su (
  .src0(src0),
  .shamt(src1),
  .op(op[1:0]),
  .result(shift_result)
);

always @ (*) begin
  case (op[3:2])
    2'b00: result <= arithmetic_result;
    2'b01: result <= logic_result;
    2'b10: result <= shift_result;
  endcase
end

assign zero = ~|result;

endmodule
