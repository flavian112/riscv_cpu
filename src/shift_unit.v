module shift_unit #(
  parameter N = 32
)(
  input signed [N-1:0] su_src0,
  input  [N-1:0] su_shamt,
  input [1:0] su_op, // 00: SLL, 01: SRL, 11: SRA 
  output reg [N-1:0] su_result
);

always @ (*) begin
  case (su_op)
    2'b00: su_result <= su_src0 << su_shamt % N;
    2'b01: su_result <= su_src0 >> su_shamt % N;
    2'b11: su_result <= su_src0 >>> su_shamt % N;
  endcase
end

endmodule
