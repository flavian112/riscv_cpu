module top (
	input clk,
	input key,
	output [5:0] led
);

reg [5:0] ctr_q;
wire [5:0] ctr_d;

always @(posedge clk) begin
	if (key) ctr_q <= ctr_d;
	else ctr_q <= 6'b0;
end

assign ctr_d = ctr_q + 6'b1;
assign led = ctr_q;

endmodule
