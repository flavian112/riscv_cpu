module logic_unit #(
  parameter N = 32
)(
  input [N-1:0] A, B,
  input [1:0] OP, // 00: AND, 01: OR, 10: XOR
  output reg [N-1:0] RESULT
);
  
  always @ (*) begin
    case (OP)
      2'b00: RESULT <= A & B;
      2'b01: RESULT <= A | B;
      2'b10: RESULT <= A ^ B;
    endcase
  end

endmodule
