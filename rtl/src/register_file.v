module register_file (
  input clk, 
  input rstn, 
  
  input we,
  input [4:0] ra1, 
  input [4:0] ra2, 
  input [4:0] wa3,

  input [31:0] wd3,

  output [31:0] rd1, 
  output [31:0] rd2
);

reg [31:0] regs[31:1];

// For debugging purposes:
wire [31:0] reg_x0_zero,
            reg_x1_ra,
            reg_x2_sp,
            reg_x3_gp,
            reg_x4_tp,
            reg_x5_t0,
            reg_x6_t1,
            reg_x7_t2,
            reg_x8_s0_fp,
            reg_x9_s1,
            reg_x10_a0,
            reg_x11_a1,
            reg_x12_a2,
            reg_x13_a3,
            reg_x14_a4,
            reg_x15_a5,
            reg_x16_a6,
            reg_x17_a7,
            reg_x18_s2,
            reg_x19_s3,
            reg_x20_s4,
            reg_x21_s5,
            reg_x22_s6,
            reg_x23_s7,
            reg_x24_s8,
            reg_x25_s9,
            reg_x26_s10,
            reg_x27_s11,
            reg_x28_t3,
            reg_x29_t4,
            reg_x30_t5,
            reg_x31_t6;

assign reg_x0_zero  = 32'b0;
assign reg_x1_ra    = regs[1];
assign reg_x2_sp    = regs[2];
assign reg_x3_gp    = regs[3];
assign reg_x4_tp    = regs[4];
assign reg_x5_t0    = regs[5];
assign reg_x6_t1    = regs[6];
assign reg_x7_t2    = regs[7];
assign reg_x8_s0_fp = regs[8];
assign reg_x9_s1    = regs[9];
assign reg_x10_a0   = regs[10];
assign reg_x11_a1   = regs[11];
assign reg_x12_a2   = regs[12];
assign reg_x13_a3   = regs[13];
assign reg_x14_a4   = regs[14];
assign reg_x15_a5   = regs[15];
assign reg_x16_a6   = regs[16];
assign reg_x17_a7   = regs[17];
assign reg_x18_s2   = regs[18];
assign reg_x19_s3   = regs[19];
assign reg_x20_s4   = regs[20];
assign reg_x21_s5   = regs[21];
assign reg_x22_s6   = regs[22];
assign reg_x23_s7   = regs[23];
assign reg_x24_s8   = regs[24];
assign reg_x25_s9   = regs[25];
assign reg_x26_s10  = regs[26];
assign reg_x27_s11  = regs[27];
assign reg_x28_t3   = regs[28];
assign reg_x29_t4   = regs[29];
assign reg_x30_t5   = regs[30];
assign reg_x31_t6   = regs[31];


assign rd1 = ra1 == 0 ? 32'b0 : regs[ra1];
assign rd2 = ra2 == 0 ? 32'b0 : regs[ra2];

always @ (posedge clk) begin
  if (we && (wa3 != 0)) regs[wa3] <= wd3;
end

endmodule
