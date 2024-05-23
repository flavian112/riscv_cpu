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

reg [31:0] rd_reg;
reg [31:0] addr_reg;


always @(posedge clk) begin
  if (we) begin
    case(size)
      FUNCT3_LS_W: mem[addr >> 2]       <= wd;
      FUNCT3_LS_H:
        case (addr[1])
          1'b0: mem[addr >> 2][15:0]    <= wd[15:0];
          1'b1: mem[addr >> 2][31:16]   <= wd[15:0];
        endcase
      FUNCT3_LS_B:
        case (addr[1:0])
          2'b00: mem[addr >> 2][7:0]    <= wd[7:0];
          2'b01: mem[addr >> 2][15:8]   <= wd[7:0];
          2'b10: mem[addr >> 2][23:16]  <= wd[7:0];
          2'b11: mem[addr >> 2][31:24]  <= wd[7:0];
        endcase
    endcase
  end
  rd_reg <= { mem[addr >> 2][31:24], mem[addr >> 2][23:16], mem[addr >> 2][15:8], mem[addr >> 2][7:0] };
  addr_reg <= addr;
end

always @ (*) begin
  case(size)
    FUNCT3_LS_W: rd = rd_reg;
    FUNCT3_LS_H:
      case (addr_reg[1])
        1'b0:  rd = { {16{rd_reg[15]}}, rd_reg[15:0] };
        1'b1:  rd = { {16{rd_reg[31]}}, rd_reg[31:16] };
      endcase
    FUNCT3_LS_B:
      case (addr_reg[1:0])
        2'b00: rd = { {24{rd_reg[7]}},  rd_reg[7:0] };
        2'b01: rd = { {24{rd_reg[15]}}, rd_reg[15:8] };
        2'b10: rd = { {24{rd_reg[23]}}, rd_reg[23:16] };
        2'b11: rd = { {24{rd_reg[31]}}, rd_reg[31:24] };
      endcase
    FUNCT3_LS_HU:
      case (addr_reg[1])
        1'b0:  rd = { {16{1'b0}}, rd_reg[15:0] };
        1'b1:  rd = { {16{1'b0}}, rd_reg[31:16] };
      endcase
    FUNCT3_LS_BU:
      case (addr_reg[1:0])
        2'b00: rd = { {24{1'b0}}, rd_reg[7:0] };
        2'b01: rd = { {24{1'b0}}, rd_reg[15:8] };
        2'b10: rd = { {24{1'b0}}, rd_reg[23:16] };
        2'b11: rd = { {24{1'b0}}, rd_reg[31:24] };
      endcase
    default:   rd = rd_reg;
  endcase
end

endmodule
