module clock_divider #( 
  parameter N = 2
)(
  input clk,
  input rstn,

  output reg clk_div
);

reg [31:0] counter = 0;

always @(posedge clk or negedge rstn) begin
  if (!rstn) begin
    counter <= 0;
    clk_div <= 0;
  end else begin
    if (counter == (N-1)/2) begin
      clk_div <= ~clk_div;
      counter <= counter + 1;
    end else if (counter >= (N-1)) begin
      clk_div <= ~clk_div;
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
end

endmodule
