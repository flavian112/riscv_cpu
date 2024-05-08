module top (
	input clk,
	input key
	//output [5:0] led
);

wire rst;
assign rst = ~key;

cpu cpu (
  .clk(clk),
  .rst(rst)
);

/*

reg [5:0] ctr_q;
wire [5:0] ctr_d;
wire clk_slow;
assign reset = ~key;

clock_divider #(.N(10000000)) clk_div (
  .clk(clk),
  .clk_out(clk_slow),
  .reset(reset)
);

always @(posedge clk_slow) begin
	if (key) ctr_q <= ctr_d;
	else ctr_q <= 6'b0;
end

assign ctr_d = ctr_q + 6'b1;
assign led = ~ctr_q;
*/
endmodule
