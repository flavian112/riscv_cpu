module shift_unit (
  input signed [31:0] a,
  input  [4:0] b,

  input [1:0] op,
  
  output reg [31:0] result
);

`include "include/consts.vh"

always @ (*) begin
  case (op)
    SHIFT_OP_SLL: result <= a << b;   // SLL
    SHIFT_OP_SRL: result <= a >> b;   // SRL
    SHIFT_OP_SRA: result <= a >>> b;  // SRA
    default:      result <= 32'b0;
  endcase
end

endmodule
