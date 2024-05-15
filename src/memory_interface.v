module memory_interface (
  input clk,
  input rstn,

  input we,
  input [31:0] addr,
  input [31:0] wd,

  output reg [31:0] rd
);

reg ram_we;
wire [31:0] ram_read_data, rom_read_data;
reg [31:0] rel_addr;

ram #(.N(32), .SIZE(1024)) ram(
  .clk(clk),
  .rstn(rstn),
  .we(ram_we),
  .addr(rel_addr),
  .data_read(ram_read_data),
  .data_write(wd)
);

rom #(.N(32), .SIZE(1024)) rom(
  .clk(clk),
  .addr(rel_addr),
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
  if (         addr >= 32'h0001_0000 && addr <= 32'h000F_0000) begin
    ram_we = 0;
    rd = rom_read_data;
    rel_addr = addr - 32'h0001_0000;
  end else if (addr >= 32'h0010_0000 && addr <= 32'hFF0F_0000) begin
    ram_we = we;
    rd = ram_read_data;
    rel_addr = addr - 32'h0010_0000;
  end else begin
    ram_we = 0;
    rd = 0;
    rel_addr = 0;
  end
end

endmodule
