module reset_synchronizer (
    input clk,
    input rstn_async,
    output rstn
);

reg [1:0] rstn_sync;

always @(posedge clk or negedge rstn_async) begin
  if (!rstn_async) rstn_sync <= 2'b00;
  else             rstn_sync <= {rstn_sync[0], 1'b1};
end

assign rstn = rstn_sync[1];

endmodule