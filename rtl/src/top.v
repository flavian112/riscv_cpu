module top (
	input clk,
	input key,
  input rst,
  output [5:0] led
);

wire rstn, rstn_async, clk_cpu;
assign rstn_async = rst;

wire [31:0] io_in;
wire [31:0] io_out;

reset_synchronizer reset_synchronizer (
  .clk(clk),
  .rstn_async(rstn_async),
  .rstn(rstn)
);

clock_divider #(.N(1)) clkdiv (
  .clk(clk),
  .rstn(rstn),
  .clk_div(clk_cpu)
);

assign led[0] = ~clk_cpu;
assign led[5:1] = ~io_out[4:0];
assign io_in[0] = key;


cpu cpu (
  .clk(clk_cpu),
  .rstn(rstn),
  .io_in(io_in),
  .io_out(io_out)
);

endmodule
