module logic_unit #(
  parameter N = 32
)(
  input [N-1:0] src0, src1,
  input [1:0] op, // 00: AND, 01: OR, 10: XOR
  output reg [N-1:0] result
);
  
always @ (*) begin
  case (op)
  2'b00: result <= src0 & src1;
  2'b01: result <= src0 | src1;
  2'b10: result <= src0 ^ src1;
  endcase
end

endmodule
