module alu #(
  parameter N = 32
)(
  input [N-1:0] A, B,
  input [3:0] OP, // OP[3:2] 00: ARITHMETIC, 01: LOGIC, 10: SHIFT 
  output reg [N-1:0] RESULT,
  output ZERO,
  output OVERFLOW
);

wire [N-1:0] arithmetic_result, logic_result, shift_result;

arithmetic_unit #(.N(N)) au (
  .A(A),
  .B(B),
  .OP(OP[1:0]),
  .RESULT(arithmetic_result),
  .OVERFLOW(overflow)
);

logic_unit #(.N(N)) lu (
  .A(A),
  .B(B),
  .OP(OP[1:0]),
  .RESULT(logic_result)
);

shift_unit #(.N(N)) su (
  .A(A),
  .SHAMT(B[clog2(N):0]),
  .OP(OP[1:0]),
  .RESULT(shift_result)
);

always @ (*) begin
  case (OP[3:2])
    2'b00: RESULT <= arithmetic_result;
    2'b01: RESULT <= logic_result;
    2'b10: RESULT <= shift_result;
  endcase
end

assign OVERFLOW = OP[3:2] == 2'b00 ? overflow : 0;

assign ZERO = ~|RESULT;

endmodule
