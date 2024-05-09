module memory_unit (
  input clk,
  input rst,
  input we,
  input [31:0] addr,
  output reg [31:0] read_data,
  input [31:0] write_data
);

reg ram_we;
wire [31:0] ram_read_data, rom_read_data;

ram #(.N(32), .SIZE(1024)) ram(
  .clk(clk),
  .rst(rst),
  .we(ram_we),
  .addr(addr),
  .data_read(ram_read_data),
  .data_write(write_data)
);

rom #(.N(32), .SIZE(1024)) rom(
  .clk(clk),
  .addr(addr),
  .data_read(rom_read_data)
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
  ram_we = 0;
  if (addr[31:16] == 16'h0000) begin
    read_data <= 0;
  end else if (addr[31:16] >= 16'h0001 && addr[31:16] <= 16'h000F) begin
    read_data <= rom_read_data;
  end else if (addr[31:16] >= 16'h0010 && addr[31:16] <= 16'hFF0F) begin
    ram_we = we;
    read_data <= ram_read_data;
  end else if (addr[31:16] >= 16'hFF10 && addr[31:16] <= 16'hFFFF) begin
    read_data <= 0;
  end
end

endmodule
