module logic_unit #(
  parameter N = 32
)(
  input [N-1:0] lu_src0, lu_src1,
  input [1:0] lu_op, // 00: AND, 01: OR, 10: XOR
  output reg [N-1:0] lu_result
);
  
  always @ (*) begin
    case (lu_op)
      2'b00: lu_result <= lu_src0 & lu_src1;
      2'b01: lu_result <= lu_src0 | lu_src1;
      2'b10: lu_result <= lu_src0 ^ lu_src1;
    endcase
  end

endmodule
