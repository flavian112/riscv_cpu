module shift_unit #(
  parameter N = 32
)(
  input signed [N-1:0] src0,
  input  [N-1:0] shamt,
  input [1:0] op, // 00: SLL, 01: SRL, 11: SRA
  output reg [N-1:0] result
);

always @ (*) begin
  case (op)
  2'b00: result <= src0 << shamt % N;
  2'b01: result <= src0 >> shamt % N;
  2'b11: result <= src0 >>> shamt % N;
  endcase
end

endmodule
