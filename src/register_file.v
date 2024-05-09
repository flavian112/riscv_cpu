module register_file (
  input clk, rst, we,
  input [4:0] rs1, rs2, rd,
  input [31:0] rd_data,
  output reg [31:0] rs1_data, rs2_data
);


reg [31:0] registers[31:1];

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

assign reg_x0_zero = 32'b0;
assign reg_x1_ra = registers[1];
assign reg_x2_sp = registers[2];
assign reg_x3_gp = registers[3];
assign reg_x4_tp = registers[4];
assign reg_x5_t0 = registers[5];
assign reg_x6_t1 = registers[6];
assign reg_x7_t2 = registers[7];
assign reg_x8_s0_fp = registers[8];
assign reg_x9_s1 = registers[9];
assign reg_x10_a0 = registers[10];
assign reg_x11_a1 = registers[11];
assign reg_x12_a2 = registers[12];
assign reg_x13_a3 = registers[13];
assign reg_x14_a4 = registers[14];
assign reg_x15_a5 = registers[15];
assign reg_x16_a6 = registers[16];
assign reg_x17_a7 = registers[17];
assign reg_x18_s2 = registers[18];
assign reg_x19_s3 = registers[19];
assign reg_x20_s4 = registers[20];
assign reg_x21_s5 = registers[21];
assign reg_x22_s6 = registers[22];
assign reg_x23_s7 = registers[23];
assign reg_x24_s8 = registers[24];
assign reg_x25_s9 = registers[25];
assign reg_x26_s10 = registers[26];
assign reg_x27_s11 = registers[27];
assign reg_x28_t3 = registers[28];
assign reg_x29_t4 = registers[29];
assign reg_x30_t5 = registers[30];
assign reg_x31_t6 = registers[31];
  

// integer i;
always @(posedge clk /*or rst*/) begin
//    if (rst) begin
//    for (i = 1; i < 32; i = i + 1)
//      registers[i] <= 32'b0;
//  end else begin
    rs1_data = (rs1 == 0) ? 32'b0 : registers[rs1];
    rs2_data = (rs2 == 0) ? 32'b0 : registers[rs2];
    if (we && (rd != 0)) begin
      registers[rd] <= rd_data;
    end
//  end
end

endmodule
