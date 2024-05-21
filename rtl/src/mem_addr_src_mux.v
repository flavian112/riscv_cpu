// mem addr mux:
// Selects source mem addr.

module mem_addr_src_mux (
  input [31:0] src_pc, 
  input [31:0] src_result,

  input mem_addr_src,
  
  output reg [31:0] mem_addr
);

`include "include/consts.vh"

always @(*) begin
  case (mem_addr_src)
    MEM_ADDR_SRC_PC:     mem_addr = src_pc;
    MEM_ADDR_SRC_RESULT: mem_addr = src_result;
    default:             mem_addr = 32'b0;
  endcase
end

endmodule
