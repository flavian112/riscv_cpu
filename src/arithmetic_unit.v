module arithmetic_unit (
  input [31:0] a, 
  input [31:0] b,

  input [1:0] op,
  
  output reg [31:0] result
);

wire signed [31:0] a_signed, b_signed;

assign a_signed = a;
assign b_signed = b;

always @ (*) begin
  case (op)
    2'b00: result <= a + b;                               // ADD
    2'b01: result <= a - b;                               // SUB
    2'b10: result <= { {31{1'b0}}, a_signed < b_signed }; // SLT
    2'b11: result <= { {31{1'b0}}, a < b };               // SLTU
  endcase
end

endmodule
