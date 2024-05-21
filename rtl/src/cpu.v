// cpu:
// Connects the various bit and pieces together.

module cpu (
  input clk,
  input rstn,
  input [31:0] io_in,
  output [31:0] io_out
);


wire [31:0] pc, pc_buf;
wire pc_we;

wire [31:0] mem_addr;
wire mem_addr_src;
wire [31:0] mem_rd;
wire mem_we;

wire instr_we;
wire [31:0] instr;

wire [31:0] imm;
wire [2:0] imm_src;

wire [31:0] data_buf;

wire rf_we;
wire [4:0] ra1, ra2, wa3;
wire [31:0] rd1, rd2;
wire [31:0] rd1_buf, rd2_buf;

wire [31:0] alu_a, alu_b;
wire [2:0] alu_a_src;
wire [1:0] alu_b_src;
wire [3:0] alu_op;
wire [31:0] alu_result;
wire alu_zero;
wire [31:0] alu_result_buf;

wire [1:0] result_src;
wire [31:0] result;


control_unit control_unit (
  .clk(clk),
  .rstn(rstn),
  .instr(instr),
  .imm_src(imm_src),
  .alu_zero(alu_zero),
  .pc_we(pc_we),
  .mem_addr_src(mem_addr_src),
  .mem_we(mem_we),
  .instr_we(instr_we),
  .result_src(result_src),
  .alu_op(alu_op),
  .alu_a_src(alu_a_src),
  .alu_b_src(alu_b_src),
  .rf_we(rf_we),
  .ra1(ra1),
  .ra2(ra2),
  .wa3(wa3)
);


pc_reg pc_reg (
  .clk(clk),
  .rstn(rstn),
  .we(pc_we),
  .pc_in(result),
  .pc(pc)
);

mem_addr_src_mux mem_addr_src_mux (
  .src_pc(pc),
  .src_result(result),
  .mem_addr_src(mem_addr_src),
  .mem_addr(mem_addr)
);

memory_interface memory_interface (
  .clk(clk),
  .rstn(rstn),
  .we(mem_we),
  .addr(mem_addr),
  .rd(mem_rd),
  .wd(rd2_buf),
  .io_in(io_in),
  .io_out(io_out)
);

instruction_reg instruction_reg (
  .clk(clk),
  .rstn(rstn),
  .we(instr_we),
  .pc_in(pc),
  .instr_in(mem_rd),
  .pc_buf(pc_buf),
  .instr(instr)
);

data_reg data_reg (
  .clk(clk),
  .rstn(rstn),
  .data_in(mem_rd),
  .data_buf(data_buf)
);

immediate_extend immediate_extend (
  .instr(instr),
  .imm_src(imm_src),
  .imm(imm)
);

register_file register_file (
  .clk(clk),
  .rstn(rstn),
  .we(rf_we),
  .ra1(ra1),
  .ra2(ra2),
  .wa3(wa3),
  .rd1(rd1),
  .rd2(rd2),
  .wd3(result)
);

register_file_reg register_file_reg (
  .clk(clk),
  .rstn(rstn),
  .rd1_in(rd1),
  .rd2_in(rd2),
  .rd1_buf(rd1_buf),
  .rd2_buf(rd2_buf)
);

alu_a_src_mux alu_a_src_mux(
  .src_pc(pc),
  .src_pc_buf(pc_buf),
  .src_rd1(rd1),
  .src_rd1_buf(rd1_buf),
  .alu_a_src(alu_a_src),
  .alu_a(alu_a)
);

alu_b_src_mux alu_b_src_mux (
  .src_rd2_buf(rd2_buf),
  .src_imm(imm),
  .alu_b_src(alu_b_src),
  .alu_b(alu_b)
);

alu alu (
  .a(alu_a),
  .b(alu_b),
  .op(alu_op),
  .result(alu_result),
  .zero(alu_zero)
);

alu_result_reg alu_result_reg (
  .clk(clk),
  .rstn(rstn),
  .alu_result_in(alu_result),
  .alu_result_buf(alu_result_buf)
);

result_mux result_mux (
  .src_alu_result(alu_result),
  .src_alu_result_buf(alu_result_buf),
  .src_data_buf(data_buf),
  .result_src(result_src),
  .result(result)
);

endmodule
