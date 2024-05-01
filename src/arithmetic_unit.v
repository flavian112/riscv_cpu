module arithmetic_unit #(
  parameter N = 32
)(
  input [N-1:0] A, B,
  input [1:0] OP, // 00: ADD, 01: SUB, 11: SLT
  output [N-1:0] RESULT,
  output OVERFLOW
);

wire [N-1:0] b, sum;
wire cin, altb;

assign b = OP[0] ? ~B : B;
assign cin = OP[0];

assign sum = A + b + cin;

assign OVERFLOW = ~(A[N-1] ^ B[N-1] ^ OP[0]) & (A[N-1] ^ sum[N-1]);

assign altb = OVERFLOW ^ sum[N-1];

assign RESULT = OP[1] ? {{(N-1){1'b0}}, altb} : sum;

endmodule
