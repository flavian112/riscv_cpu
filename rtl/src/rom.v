// rom:
// Contains instructions of program.

module rom #(
  parameter           SIZE = 1024,
  parameter           ROM_FILE = "../../build/rom.hex"
)(
    input             clk,
    input      [31:0] addr,
    input       [2:0] size,
    output reg [31:0] rd
);

`include "include/consts.vh"



//(* RAM_STYLE="BLOCK" *)
reg [31:0] mem [0:SIZE-1];

reg [7:0] mem0, mem1, mem2, mem3;

reg [31:0] rd_reg;
reg [31:0] addr_reg;

initial begin
  $readmemh(ROM_FILE, mem, 0, SIZE - 1);
end

always @ (posedge clk) begin
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
