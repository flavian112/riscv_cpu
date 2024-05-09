`timescale 1ns / 1ps

module testbench_alu();

  reg reset = 0;

  reg [1023:0] testvec_filename;
  reg [1023:0] waveform_filename;

  initial begin
    if ($value$plusargs("testvec=%s", testvec_filename)) begin
    end else begin
      $display("ERROR: testvec not specified");
      $finish;
    end

    if ($value$plusargs("waveform=%s", waveform_filename)) begin
    end else begin
      $display("ERROR: waveform not specified");
      $finish;
    end
  end
  
  initial begin
    $dumpfile(waveform_filename);
    $dumpvars(0,testbench_alu);
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
  reg [103:0] alu_testvec [0:20000];

  initial begin
    #5;
    $readmemh(testvec_filename, alu_testvec);
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

    if ((alu_test_count == 10027)) begin
      $display("FINISHED (ALU), with %d errors out of %d tests.", alu_error_count, alu_test_count);
      #16;

      $finish;
    end
  end

  
  

  alu alu (
    .a(a),
    .b(b),
    .op(op),
    .result(result),
    .zero(zero)
  );

endmodule
