module shift_unit (
  input signed [31:0] a,
  input  [4:0] b,

  input [1:0] op,
  
  output reg [31:0] result
);

always @ (*) begin
  case (op)
    2'b00: result <= a << b;   // SLL
    2'b01: result <= a >> b;   // SRL
    2'b11: result <= a >>> b;  // SRA
    default: result <= 32'b0;
  endcase
end

endmodule
