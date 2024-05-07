module control_unit (
 input clk, rst,
 input [6:0] opcode,
 input [2:0] funct3,
 input [6:0] funct7,
 input alu_zero,
 input alu_equal,
 output pc_we,
 output mem_addr_src,
 output mem_we,
 output instr_we,
 output [1:0] result_src,
 output [3:0] alu_op,
 output [1:0] alu_a_src,
 output [1:0] alu_b_src,
 output rf_we
);

parameter s00_fetch     = 4'h0,
          s01_decode    = 4'h1,
          s02_mem_addr  = 4'h2,
          s03_mem_read  = 4'h3,
          s04_mem_wb    = 4'h4,
          s05_mem_write = 4'h5,
          s06_execute_r = 4'h6,
          s07_alu_wb    = 4'h7,
          s08_execute_i = 4'h8,
          s09_jal       = 4'h9,
          s10_beq       = 4'ha;

reg [3:0] state, next_state;

always @ (posedge clk or posedge rst) begin
  if (rst) state <= s00_fetch;
  else state <= next_state;
end

always @ (*) begin
  case(state)
    s00_fetch:     next_state <= s01_decode;
    s01_decode: case(opcode)
      7'b0000011:  next_state <= s02_mem_addr;
      7'b0100011:  next_state <= s02_mem_addr;
      7'b0110011:  next_state <= s06_execute_r;
      7'b0010011:  next_state <= s08_execute_i;
      7'b1101111:  next_state <= s09_jal;
      7'b1100011:  next_state <= s10_beq;
      
    endcase
    s02_mem_addr:  case(opcode)
      7'b0000011:  next_state <= s03_mem_read;
      7'b0100011:  next_state <= s05_mem_write; 
    endcase
    s03_mem_read:  next_state <= s04_mem_wb;
    s04_mem_wb:    next_state <= s00_fetch;
    s05_mem_write: next_state <= s00_fetch;
    s06_execute_r: next_state <= s07_alu_wb;
    s07_alu_wb:    next_state <= s00_fetch;
    s08_execute_i: next_state <= s07_alu_wb;
    s09_jal:       next_state <= s07_alu_wb;
    s10_beq:       next_state <= s00_fetch;
  endcase
end

wire branch;
wire pc_update;

assign pc_we = (alu_zero & branch) | pc_update;

/*
always @ (*) begin
 case(state)
    s00_fetch:
    s01_decode:
    s02_mem_addr:
    s03_mem_read:
    s04_mem_wb:
    s05_mem_write:
    s06_execute_r:
    s07_alu_wb:
    s08_execute_i:
    s09_jal:
    s10_beq:
  endcase
end
*/

endmodule
