module result_mux (
  input [31:0] src_alu_result_buf, src_alu_result, src_data_buf,
  input [1:0] result_src,
  output reg [31:0] result
);

always @(*) begin
  case (result_src)
    2'b00:   result <= src_alu_result_buf;
    2'b01:   result <= src_data_buf;
    2'b10:   result <= src_alu_result;
    default: result <= 32'b0;
  endcase
end

endmodule
