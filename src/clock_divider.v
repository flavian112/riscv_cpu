module clock_divider #( 
    parameter N = 2
)(
    input clk,
    input reset,
    output reg clk_out
);

    reg [31:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (N-1)/2) begin
                clk_out <= ~clk_out;
                counter <= counter + 1;
            end else if (counter >= (N-1)) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
