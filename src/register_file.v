module register_file #(
  parameter N = 32,
  parameter XLEN = 32
)(
  input clk, rst, we,
  input [log2(XLEN)-1:0] addr_read0, addr_read1, addr_write2,
  input [N-1:0] data_write2,
  output reg [N-1:0] data_read0, data_read1
);

`include "include/log2.vh"

reg [N-1:0] registers[XLEN-1:1];

integer i;
always @(posedge clk or rst) begin
  if (rst) begin
    for (i = 1; i < XLEN; i = i + 1)
      registers[i] <= 0;
  end else begin
    data_read0 = (addr_read0 == 0) ? 0 : registers[addr_read0];
    data_read1 = (addr_read1 == 0) ? 0 : registers[addr_read1];
    if (we && (addr_write2 != 0)) begin
      registers[addr_write2] <= data_write2;
    end
  end
end

endmodule
