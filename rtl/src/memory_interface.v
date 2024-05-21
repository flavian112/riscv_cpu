module memory_interface (
  input clk,
  input rstn,

  input we,
  input [31:0] addr,
  input [31:0] wd,

  output reg [31:0] rd,

  input [31:0] io_in,
  output [31:0] io_out
);

`include "include/consts.vh"

reg ram_we;
reg io_we;
wire [31:0] ram_rd, rom_rd;
reg [31:0] rel_addr;

ram #(.N(32), .SIZE(1024)) ram(
  .clk(clk),
  .rstn(rstn),
  .we(ram_we),
  .addr(rel_addr),
  .data_read(ram_rd),
  .data_write(wd)
);

rom #(.N(32), .SIZE(1024), .ROM_FILE("../../build/rom.hex")) rom(
  .clk(clk),
  .addr(rel_addr),
  .data_read(rom_rd)
);

io io(
  .clk(clk),
  .rstn(rstn),
  .we(io_we),
  .addr(rel_addr),
  .rd(io_rd),
  .wd(wd),
  .io_in(io_in),
  .io_out(io_out)
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


always @ (*) begin
  rd       = 0;
  rel_addr = 0;
  ram_we   = 0;
  io_we    = 0;
  if (         addr >= ROM_BEGIN && addr <= ROM_END) begin
    rd = rom_rd;
    rel_addr = addr - ROM_BEGIN;
  end else if (addr >= RAM_BEGIN && addr <= RAM_END) begin
    ram_we = we;
    rd = ram_rd;
    rel_addr = addr - RAM_BEGIN;
  end else if (addr >= IO_BEGIN && addr <= IO_END) begin
    io_we = we;
    rd = io_rd;
    rel_addr = addr - IO_BEGIN;
  end else begin
    rd = 0;
    rel_addr = 0;
  end
end

endmodule
