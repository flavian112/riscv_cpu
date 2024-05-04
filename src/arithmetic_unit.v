module arithmetic_unit #(
  parameter N = 32
)(
  input [N-1:0] au_src0, au_src1,
  input [1:0] au_op, // 00: ADD, 01: SUB, 11: SLT
  output [N-1:0] au_result
);

wire [N-1:0] au_src1_inv, au_sum;
wire au_cin, au_src0_lt_src1, au_overflow;

assign au_src1_inv = au_op[0] ? ~au_src1 : au_src1;
assign au_cin = au_op[0];

assign au_sum = au_src0 + au_src1_inv + au_cin;

assign au_overflow = ~(au_src0[N-1] ^ au_src1[N-1] ^ au_op[0]) & (au_src0[N-1] ^ au_sum[N-1]);

assign au_src0_lt_src1 = au_overflow ^ au_sum[N-1];

assign au_result = au_op[1] ? {{(N-1){1'b0}}, au_src0_lt_src1} : au_sum;

endmodule
