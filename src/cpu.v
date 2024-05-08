module cpu (
  input clk,
  input rst
);


// Control Unit

wire mem_addr_src;
wire mem_we;
wire pc_we;
wire instr_we;
wire rf_we;
wire alu_zero;
wire alu_equal;
wire [3:0] alu_op;
wire [1:0] alu_a_src;
wire [1:0] alu_b_src;
wire [1:0] result_src;

control_unit cu (
  .clk(clk),
  .rst(rst),
  .opcode(opcode),
  .funct3(funct3),
  .funct7(funct7),
  .alu_zero(alu_zero),
  .alu_equal(alu_equal),
  .pc_we(pc_we),
  .mem_addr_src(mem_addr_src),
  .mem_we(mem_we),
  .instr_we(instr_we),
  .result_src(result_src),
  .alu_op(alu_op),
  .alu_a_src(alu_a_src),
  .alu_b_src(alu_b_src),
  .rf_we(rf_we)
);

// Fetch

reg [31:0] pc;

always @ (posedge clk or posedge rst) begin
  if (rst) pc <= 32'h0001_0000;
  else if (pc_we) pc <= result;
end

wire [31:0] mem_addr = mem_addr_src ? result : pc;

wire [31:0] mem_read_data;

memory_unit mu (
  .clk(clk),
  .rst(rst),
  .we(mem_we),
  .addr(mem_addr),
  .read_data(mem_read_data),
  .write_data(b_buf)
);

reg [31:0] instruction;
reg [31:0] pc_buf;

always @ (posedge clk or posedge rst) begin
  if (rst) begin
    pc_buf <= 32'b0;
    instruction <= 32'b0;
  end else begin
    if (instr_we) begin
      pc_buf <= pc;
      instruction <= mem_read_data; 
    end
  end
end

reg [31:0] data;

always @(posedge clk or posedge rst) begin
  if (rst) data <= 32'b0;
  else data <= mem_read_data;
end

// Instruction Decode

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [31:0] immediate;
wire [4:0] rs1, rs2, rd;

instruction_decode id (
  .instruction(instruction),
  .opcode(opcode),
  .funct3(funct3),
  .funct7(funct7),
  .immediate(immediate),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd)
);

// Register File

wire [31:0] rs1_data, rs2_data;

register_file rf (
  .clk(clk),
  .rst(rst),
  .we(rf_we),
  .rs1(rs1),
  .rs2(rs2),
  .rd(rd),
  .rs1_data(rs1_data),
  .rs2_data(rs2_data),
  .rd_data(result)
);

reg [31:0] a_buf, b_buf;

always @ (posedge clk or posedge rst) begin
  if (rst) begin
    a_buf <= 32'b0;
    b_buf <= 32'b0;
  end else begin
    a_buf <= rs1_data;
    b_buf <= rs2_data;
  end
end

// Execute

reg [31:0] a, b;
wire [31:0] alu_result;

always @ (*) begin
  case(alu_a_src)
    2'b00: a <= pc;
    2'b01: a <= pc_buf;
    2'b10: a <= a_buf;
    default: a <= 32'b0;
  endcase
end

always @ (*) begin
  case(alu_b_src)
    2'b00: b <= b_buf;
    2'b01: b <= immediate;
    2'b10: b <= 32'h4;
    default: b <= 32'b0;
  endcase
end

alu alu (
  .a(a),
  .b(b),
  .op(alu_op),
  .result(alu_result),
  .zero(alu_zero),
  .equal(alu_equal)
);

reg [31:0] result_buf;

always @ (posedge clk or posedge rst) begin
  if (rst) result_buf <= 32'b0;
  else result_buf <= alu_result;
end

// Writeback

reg [31:0] result;

always @ (*) begin
  case(result_src)
    2'b00: result <= result_buf;
    2'b01: result <= data;
    2'b10: result <= alu_result;
    default: result <= 32'b0;
  endcase
end

endmodule
