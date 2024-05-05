module memory_unit #(
  parameter N = 32
)(
  input clk,
  input rst,
  input we,
  input [N-1:0] addr,
  output reg [N-1:0] data_read,
  input [N-1:0] data_write
);

reg we_ram;
wire [N-1:0] data_read_ram, data_read_rom;

ram #(.N(N), .SIZE(1024)) ram(
  .clk(clk),
  .rst(rst),
  .we(we_ram),
  .addr(addr[N-17:0]),
  .data_read(data_read_ram),
  .data_write(data_write)
);

rom #(.N(N), .SIZE(1024)) rom(
  .clk(clk),
  .rst(rst),
  .addr(addr[N-17:0]),
  .data_read(data_read_rom)
);

// 0000 0000 Reserved
// 0000 FFFF
//
// 0001 0000 ROM
// 000F FFFF
//
// 0010 0000 RAM
// FF0F FFFF
//
// FF10 0000 Reserved
// FFFF FFFF


always @(*) begin
  we_ram = 0;
  if (addr[N-1:N-16] == 16'h0000) begin
    data_read <= 0;
  end else if (addr[N-1:N-16] >= 16'h0001 && addr[N-1:N-16] <= 16'h000F) begin
    data_read <= data_read_rom;
    we_ram = we;
  end else if (addr[N-1:N-16] >= 16'h0010 && addr[N-1:N-16] <= 16'hFF0F) begin
    data_read <= data_read_ram;
  end else if (addr[N-1:N-16] >= 16'hFF10 && addr[N-1:N-16] <= 16'hFFFF) begin
    data_read <= 0;
  end
end

endmodule
