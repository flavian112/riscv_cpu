module testbench;

  reg reset = 0;
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);

    # 17 reset = 1;
    # 11 reset = 0;
    # 29 reset = 1;
    # 5  reset = 0;
    # 128 $finish;
  end

  reg clk = 0;
  always #1 clk = !clk;

  wire [5:0] led;
  wire reset_inv;
  assign reset_inv = ~reset;
  top blinky(.clk(clk), .key(reset_inv), .led(led));

  initial
     $monitor("At time %t, value = %h (%0d)", $time, led, led);

endmodule
