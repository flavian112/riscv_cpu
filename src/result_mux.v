module result_mux (
  input [31:0] src_alu_result_buf, 
  input [31:0] src_alu_result, 
  input [31:0] src_data_buf,

  input [1:0] result_src,
  
  output reg [31:0] result
);

`include "include/consts.vh"

always @(*) begin
  case (result_src)
    RESULT_SRC_ALU_RESULT_BUF: result <= src_alu_result_buf;
    RESULT_SRC_DATA_BUF:       result <= src_data_buf;
    RESULT_SRC_ALU_RESULT:     result <= src_alu_result;
    default:                   result <= 32'b0;
  endcase
end

endmodule
