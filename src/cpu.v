module cpu #(
  parameter N = 32,
  parameter XLEN = 32
)(
  input clk,
  input rst
);


wire pc_we;
wire mem_addr_src;
wire mem_we;
wire instr_we;
wire rf_we;
wire [1:0] imm_src;
wire [1:0] alu_src0_src;
wire [1:0] alu_src1_src;
wire [3:0] alu_op;
wire alu_zero;
wire [1:0] result_src;

reg [N-1:0] result;


// Fetch
reg [N-1:0] pc, pc_old, instr;


always @ (posedge clk or posedge rst) begin
 if (rst) pc <= 32'h0001_0000;
 else if (pc_we) pc <= result;
end

always @ (posedge clk) begin
  if (instr_we) begin
    pc_old <= pc;
    instr <= mem_data_read;
  end
end

// Memory
wire [N-1:0] mem_addr;
assign mem_addr = mem_addr_src ? pc : result;

wire [N-1:0] mem_data_write;
wire [N-1:0] mem_data_read;
reg [N-1:0] data;

memory_unit #(.N(N)) mu (
  .clk(clk),
  .rst(rst),
  .we(mem_we),
  .addr(mem_addr),
  .data_read(mem_data_read),
  .data_write(mem_data_write)
);

always @ (posedge clk) begin
  data <= mem_data_read;
end

// Register file

reg [N-1:0] rf_data0_old, rf_data1_old;
wire [N-1:0] rf_data0, rf_data1;

register_file #(.N(N), .XLEN(XLEN)) rf(
  .clk(clk),
  .rst(rst),
  .we(rf_we),
  .addr_read0(instr[19:15]),
  .addr_read1(instr[24:20]),
  .addr_write2(instr[11:7]),
  .data_read0(rf_data0),
  .data_read1(rf_data1),
  .data_write2(result)
);

always @ (posedge clk) begin
  rf_data0_old <= rf_data0;
  rf_data1_old <= rf_data1;
end

assign mem_data_write = rf_data1_old;

reg [N-1:0] imm;

always @ (*) begin
  case (imm_src)
    2'b00: imm <= {{20{instr[31]}}, instr[31:20]};
    2'b01: imm <= {{20{instr[31]}}, instr[31:25], instr[11:7]};
    2'b10: imm <= {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
  endcase
end

reg [N-1:0] alu_src0, alu_src1;

always @ (*) begin
  case(alu_src0_src)
    2'b00: alu_src0 <= pc;
    2'b01: alu_src0 <= pc_old;
    2'b10: alu_src0 <= rf_data0_old;
  endcase
end

always @ (*) begin
  case(alu_src1_src)
    2'b00: alu_src1 <= rf_data1_old;
    2'b01: alu_src1 <= imm;
    2'b10: alu_src1 <= {{(N-3){1'b0}}, 3'h4};
  endcase
end

// Execute

wire [N-1:0] alu_result;

alu #(.N(N)) alu (
  .src0(alu_src0),
  .src1(alu_src1),
  .op(alu_op),
  .result(alu_result),
  .zero(alu_zero)
);

reg [N-1:0] alu_out;

always @ (posedge clk) begin
  alu_out <= alu_result;
end

always @ (*) begin
  case (result_src)
    2'b00: result <= alu_out;
    2'b01: result <= data;
    2'b10: result <= alu_result;
  endcase
end



endmodule
