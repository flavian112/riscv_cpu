module register_file #(
  parameter N = 32,
  parameter XLEN = 32
)(
  input clk, rst, we,
  input [log2(N)-1:0] addr_rs0, addr_rs1, addr_rd2,
  input [N-1:0] data_rd2,
  output reg [N-1:0] data_rs0, data_rs1
);

`include "include/log2.vh"

reg [N-1:0] registers[XLEN-1:1];

integer i;
always @(posedge clk or rst) begin
  if (rst) begin
    for (i = 1; i < XLEN; i = i + 1)
      registers[i] <= 0;
  end else begin
    data_rs0 = (addr_rs0 == 0) ? 0 : registers[addr_rs0];
    data_rs1 = (addr_rs1 == 0) ? 0 : registers[addr_rs1];
    if (we && (addr_rd2 != 0)) begin
      registers[addr_rd2] = data_rd2;
    end
  end
end

endmodule
