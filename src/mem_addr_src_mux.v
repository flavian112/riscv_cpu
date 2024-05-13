module mem_addr_src_mux (
  input [31:0] src_pc, 
  input [31:0] src_result,

  input mem_addr_src,
  
  output reg [31:0] mem_addr
);

always @(*) begin
  case (mem_addr_src)
    1'b0:    mem_addr <= src_pc;
    1'b1:    mem_addr <= src_result;
    default: mem_addr <= 32'b0;
  endcase
end

endmodule
