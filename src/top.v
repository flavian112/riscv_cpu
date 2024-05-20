module top (
	input clk,
	input key,
  output [5:0] led
);

wire rstn, clk_cpu;
assign rstn = key;

wire [31:0] io_in;
wire [31:0] io_out;

clock_divider #(.N(1)) clkdiv (
    .clk(clk),
    .rstn(rstn),
    .clk_div(clk_cpu)
);

assign led[0] = ~clk_cpu;
assign led[5:1] = ~io_out[4:0];


cpu cpu (
  .clk(clk_cpu),
  .rstn(rstn),
  .io_in(io_in),
  .io_out(io_out)
);

endmodule
