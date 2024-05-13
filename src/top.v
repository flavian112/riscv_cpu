module top (
	input clk,
	input key,
  output [5:0] led
);

wire rstn, clk_cpu;
assign rstn = key;
wire [31:0] dbg_t6;

clock_divider #(.N(1024 * 1024)) clkdiv (
    .clk(clk),
    .rstn(rstn),
    .clk_div(clk_cpu)
);

assign led[0] = ~clk_cpu;
assign led[5:1] = ~dbg_t6[4:0];


cpu cpu (
  .clk(clk_cpu),
  .rstn(rstn),
  .dbg_t6(dbg_t6)
);

endmodule
