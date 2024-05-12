module top (
	input clk,
	input key
);

wire rstn, clk_cpu;
assign rstn = key;

clock_divider #(.N(1024 * 1024)) clkdiv (
    .clk(clk),
    .reset(!rstn),
    .clk_out(clk_cpu)
);

cpu cpu (
  .clk(clk_cpu),
  .rstn(rstn)
);

endmodule
