module register_file_reg (
  input clk, rstn,
  input [31:0] rd1_in, rd2_in,
  output reg [31:0] rd1_buf, rd2_buf
);

always @ (posedge clk) begin
  if (!rstn) begin
    rd1_buf <= 32'b0;
    rd2_buf <= 32'b0;
  end else begin
    rd1_buf <= rd1_in;
    rd2_buf <= rd2_in;
  end
end

endmodule
