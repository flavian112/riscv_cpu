`timescale 1ns / 1ps

module testbench();

  reg reset = 0;
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
  end

  reg clk = 0;
  always #32 clk = !clk;


  reg [31:0] a, b, exp_result;
  reg [3:0] op;
  reg [3:0] exp_flags;
  wire [31:0] result;
  wire zero, exp_zero;

  assign exp_zero = exp_flags[0];

  reg [31:0] alu_test_count, alu_error_count;
  reg [103:0] alu_testvec [0:9999];

  initial begin
    $readmemh("alu_testvec.txt", alu_testvec);
    alu_test_count = 0;
    alu_error_count = 0;
  end
  
  always @ (posedge clk) begin
    #16;
    {op, a, b, exp_result, exp_flags} = alu_testvec[alu_test_count];
    #32;
    if ((result !== exp_result) | (zero !== exp_zero)) begin
      $display("ERROR (ALU) time: %5d, test: %d", $time, alu_test_count);
      $display("              op: %b, a: %h b: %h", op, a, b);
      $display("          result: %h (expected %h)", result, exp_result);
      $display("            zero: %b (expected %b)", zero, exp_zero);
      alu_error_count = alu_error_count + 1;
    end

    alu_test_count = alu_test_count + 1;

    if ((alu_test_count == 9027)) begin
      $display("FINISHED (ALU), %d tests completed with %d errors", alu_test_count, alu_error_count);
      #16;

      $finish;
    end
  end

  
  

  alu #(.N(32)) alu (
    .A(a),
    .B(b),
    .OP(op),
    .RESULT(result),
    .ZERO(zero)
  );

endmodule
