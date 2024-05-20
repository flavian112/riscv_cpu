module reset_synchronizer (
    input clk,
    input rstn_async,
    output rstn
);

reg rstn_meta;
reg rstn_sync_reg;

always @(posedge clk or negedge rstn_async) begin
  if (!rstn_async) begin
    rstn_meta <= 1'b0;
    rstn_sync_reg <= 1'b0;
  end else begin
    rstn_meta <= 1'b1;
    rstn_sync_reg <= rstn_meta;
  end
end

assign rstn = rstn_sync_reg;

endmodule