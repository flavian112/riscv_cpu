// memory interface:
// Connects rom, ram and io to memory bus.

module memory_interface (
  input             clk,
  input             rstn,

  input             we,
  input      [31:0] addr,
  input      [31:0] wd,
  input       [2:0] size,

  output reg [31:0] rd,

  input      [31:0] io_in,
  output     [31:0] io_out
);

`include "include/consts.vh"

reg         ram_we;
reg         io_we;
wire [31:0] ram_rd, rom_rd;
reg  [31:0] rel_addr;

ram #(.SIZE(1024)) ram (
  .clk(clk),
  .rstn(rstn),
  .we(ram_we),
  .addr(rel_addr),
  .size(size),
  .rd(ram_rd),
  .wd(wd)
);

rom #(.SIZE(1024)) rom (
  .clk(clk),
  .addr(rel_addr),
  .size(size),
  .rd(rom_rd)
);

io io (
  .clk(clk),
  .rstn(rstn),
  .we(io_we),
  .addr(rel_addr),
  .size(size),
  .rd(io_rd),
  .wd(wd),
  .io_in(io_in),
  .io_out(io_out)
);

always @ (*) begin
    rd       = 0;
    rel_addr = 0;
    ram_we   = 0;
    io_we    = 0;
  if          (addr >= ROM_BEGIN && addr <= ROM_END) begin
    rd = rom_rd;
    rel_addr = addr - ROM_BEGIN;
  end else if (addr >= RAM_BEGIN && addr <= RAM_END) begin
    ram_we = we;
    rd = ram_rd;
    rel_addr = addr - RAM_BEGIN;
  end else if (addr >= IO_BEGIN  && addr <= IO_END) begin
    io_we = we;
    rd = io_rd;
    rel_addr = addr - IO_BEGIN;
  end else begin
    rd = 0;
    rel_addr = 0;
  end
end

endmodule
