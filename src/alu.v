module alu #(
  parameter N = 32
)(
  input [N-1:0] alu_src0, alu_src1,
  input [3:0] alu_op, // alu_op[3:2] 00: ARITHMETIC, 01: LOGIC, 10: SHIFT 
  output reg [N-1:0] alu_result,
  output alu_zero
);

wire [N-1:0] arithmetic_result, logic_result, shift_result;

arithmetic_unit #(.N(N)) au (
  .au_src0(alu_src0),
  .au_src1(alu_src1),
  .au_op(alu_op[1:0]),
  .au_result(arithmetic_result)
);

logic_unit #(.N(N)) lu (
  .lu_src0(alu_src0),
  .lu_src1(alu_src1),
  .lu_op(alu_op[1:0]),
  .lu_result(logic_result)
);

shift_unit #(.N(N)) su (
  .su_src0(alu_src0),
  .su_shamt(alu_src1),
  .su_op(alu_op[1:0]),
  .su_result(shift_result)
);

always @ (*) begin
  case (alu_op[3:2])
    2'b00: alu_result <= arithmetic_result;
    2'b01: alu_result <= logic_result;
    2'b10: alu_result <= shift_result;
  endcase
end

assign alu_zero = ~|alu_result;

endmodule
