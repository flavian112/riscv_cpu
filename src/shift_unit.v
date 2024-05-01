module shift_unit #(
  parameter N = 32
)(
  input [N-1:0] A,
  input [clog2(N):0] SHAMT,
  input [1:0] OP, // 00: SLL, 01: SRL, 11: SRA 
  output reg [N-1:0] RESULT
);

always @ (*) begin
  case (OP)
    2'b00: RESULT <= A << SHAMT;
    2'b01: RESULT <= A >> SHAMT;
    2'b11: RESULT <= A >>> SHAMT;
  endcase
end

endmodule