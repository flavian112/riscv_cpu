module logic_unit (
  input [31:0] a, b,
  input [1:0] op,
  output reg [31:0] result
);
  
always @ (*) begin
  case (op)
    2'b00: result <= a & b; // AND
    2'b01: result <= a | b; // OR
    2'b10: result <= a ^ b; // XOR
    default: result <= 32'b0;
  endcase
end

endmodule
