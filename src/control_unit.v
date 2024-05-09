module control_unit (
 input clk, rst,
 input [6:0] opcode,
 input [2:0] funct3,
 input [6:0] funct7,
 input alu_zero,
 output pc_we,
 output reg mem_addr_src,
 output reg mem_we,
 output reg instr_we,
 output reg [1:0] result_src,
 output [3:0] alu_op,
 output reg [1:0] alu_a_src,
 output reg [1:0] alu_b_src,
 output reg rf_we
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
          s10_jalr      = 4'ha,
          s11_br        = 4'hb;

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
      7'b1100111:  next_state <= s10_jalr;
      7'b1100011:  next_state <= s11_br;
      
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
    s10_jalr:      next_state <= s07_alu_wb;
    s11_br:       next_state <= s00_fetch;
  endcase
end

reg branch;
reg pc_update;
reg alu_ctrl;

assign pc_we = ((alu_zero ^ funct3[0] ^ funct3[2]) & branch) | pc_update;


always @ (*) begin
  branch = 1'b0;
  pc_update = 1'b0;
  mem_we = 1'b0;
  rf_we = 1'b0;
  instr_we = 1'b0;
  case(state)
    s00_fetch: begin
      mem_addr_src <= 1'b0;
      instr_we      = 1'b1;
      alu_a_src    <= 2'b00;
      alu_b_src    <= 2'b10;
      alu_ctrl     <= 1'b1;
      result_src   <= 2'b10;
      pc_update     = 1'b1;
    end
    s01_decode: begin
      alu_a_src <= 2'b01;
      alu_b_src <= 2'b01;
      alu_ctrl  <= 1'b1;
    end
    s02_mem_addr: begin
      alu_a_src <= 2'b10;
      alu_b_src <= 2'b01;
      alu_ctrl  <= 1'b1;
    end
    s03_mem_read: begin
      result_src   <= 2'b00;
      mem_addr_src <= 1'b1;
    end
    s04_mem_wb: begin
      result_src <= 2'b01;
      rf_we       = 1'b1;
    end
    s05_mem_write: begin
      result_src   <= 2'b00;
      mem_addr_src <= 1'b1;
      mem_we        = 1'b1;
    end
    s06_execute_r: begin
      alu_a_src <= 2'b10;
      alu_b_src <= 2'b00;
      alu_ctrl  <= 1'b0;
    end
    s07_alu_wb: begin
      result_src <= 2'b00;
      rf_we       = 1'b1;
    end
    s08_execute_i: begin
      alu_a_src <= 2'b10;
      alu_b_src <= 2'b01;
      alu_ctrl  <= 1'b0;
    end
    s09_jal: begin
      alu_a_src  <= 2'b01;
      alu_b_src  <= 2'b10;
      alu_ctrl   <= 1'b1;
      result_src <= 2'b00;
      pc_update   = 1'b1;
    end
    s10_jalr: begin
      alu_a_src  <= 2'b10;
      alu_b_src  <= 2'b01;
      alu_ctrl   <= 1'b1;
      result_src <= 2'b10;
      pc_update   = 1'b1;
    end
    s11_br: begin
      alu_a_src  <= 2'b10;
      alu_b_src  <= 2'b00;
      alu_ctrl   <= 1'b0;
      result_src <= 2'b00;
      branch      = 1'b1;
    end
  endcase
end

alu_op_decode aod (
  .opcode(opcode),
  .alu_ctrl(alu_ctrl),
  .funct3(funct3),
  .funct7(funct7),
  .alu_op(alu_op)
);

endmodule
