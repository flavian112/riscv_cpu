module arithmetic_unit #(
  parameter N = 32
)(
  input [N-1:0] src0, src1,
  input [1:0] op, // 00: ADD, 01: SUB, 11: SLT
  output [N-1:0] result
);

wire [N-1:0] src1_inv, sum;
wire cin, src0_lt_src1, overflow;

assign src1_inv = op[0] ? ~src1 : src1;
assign cin = op[0];

assign sum = src0 + src1_inv + cin;

assign overflow = ~(src0[N-1] ^ src1[N-1] ^ op[0]) & (src0[N-1] ^ sum[N-1]);

assign src0_lt_src1 = overflow ^ sum[N-1];

assign result = op[1] ? {{(N-1){1'b0}}, src0_lt_src1} : sum;

endmodule
