// ram:
// Contains data section of program and is used for stack/heap, etc.

module ram #( 
  parameter           SIZE = 1024
)(
    input             clk,
    input             rstn,
    input             we,
    input      [31:0] addr,
    input       [2:0] size,
    input      [31:0] wd,
    output reg [31:0] rd
);

`include "include/consts.vh"

//(* RAM_STYLE="BLOCK" *)
reg [31:0] mem [0:SIZE-1];

wire [31:0] rd_w;
wire [15:0] rd_h;
wire  [7:0] rd_b;
assign rd_w =  mem[addr >> 2];
assign rd_h = (mem[addr >> 2] >> (addr[1]  * 16)) & 32'hFFFF;
assign rd_b = (mem[addr >> 2] >> (addr[1:0] * 8)) & 32'hFF;

always @(negedge clk) begin
  if (we) begin
    case (size)
      FUNCT3_LS_W: mem[addr >> 2] <= wd;
      FUNCT3_LS_H:
        case (addr[1])
          1'b0: mem[addr >> 2][15:0]  <= wd[15:0];
          1'b1: mem[addr >> 2][31:16] <= wd[15:0];
        endcase
      FUNCT3_LS_B:
        case (addr[1:0])
          2'b00: mem[addr >> 2][7:0]    <= wd[7:0];
          2'b01: mem[addr >> 2][15:8]   <= wd[7:0];
          2'b10: mem[addr >> 2][23:16]  <= wd[7:0];
          2'b11: mem[addr >> 2][32:24]  <= wd[7:0];
        endcase
    endcase
  end 
  case (size)
    FUNCT3_LS_W:  rd <= rd_w;
    FUNCT3_LS_H:  rd <= { {16{rd_h[15]}}, rd_h };
    FUNCT3_LS_B:  rd <= { {24{rd_b[7]}}, rd_b };
    FUNCT3_LS_HU: rd <= rd_b;
    FUNCT3_LS_BU: rd <= rd_h;
    default:      rd <= rd_w;
  endcase
end

endmodule
