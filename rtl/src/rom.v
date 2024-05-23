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

initial begin
  $readmemh(ROM_FILE, mem, 0, SIZE-1);
end

wire [31:0] rd_w;
wire [15:0] rd_h;
wire  [7:0] rd_b;
assign rd_w =  mem[addr >> 2];
assign rd_h = (mem[addr >> 2] >> (addr[1]  * 16)) & 32'hFFFF;
assign rd_b = (mem[addr >> 2] >> (addr[1:0] * 8)) & 32'hFF; 

always @ (negedge clk) begin
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
