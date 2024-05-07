module register_file (
  input clk, rst, we,
  input [4:0] rs1, rs2, rd,
  input [31:0] rd_data,
  output reg [31:0] rs1_data, rs2_data
);


reg [31:0] registers[31:1];

integer i;
always @(posedge clk or rst) begin
  if (rst) begin
    for (i = 1; i < 32; i = i + 1)
      registers[i] <= 32'b0;
  end else begin
    rs1_data = (rs1 == 0) ? 32'b0 : registers[rs1];
    rs2_data = (rs2 == 0) ? 32'b0 : registers[rs2];
    if (we && (rd != 0)) begin
      registers[rd] <= rd_data;
    end
  end
end

endmodule
