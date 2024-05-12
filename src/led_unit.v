module led_unit (
  input clk,
  input rst,
  input we,
  output reg [31:0] data_read,
  input [31:0] data_write,
  output [5:0] led_output
);

assign led_output = ~data_read[5:0];

always @(posedge clk or posedge rst) begin
  if (rst) data_read <= 32'b0;
  else if (we) data_read <= data_write;
  else data_read <= data_read;
end

endmodule
