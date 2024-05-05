`timescale 1ns / 1ps

module testbench_alu();

  reg reset = 0;

  reg [1023:0] testvec_filename;
  reg [1023:0] waveform_filename;

  initial begin
    if ($value$plusargs("testvec=%s", testvec_filename)) begin
      $display("Using test vector file: %s", testvec_filename);
    end else begin
      $display("Error: no test vector file specified.");
      $finish;
    end

    if ($value$plusargs("waveform=%s", waveform_filename)) begin
      $display("Using waveform file: %s", waveform_filename);
    end else begin
      $display("Error: no waveform file specified.");
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
  reg [103:0] alu_testvec [0:9999];

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

    if ((alu_test_count == 9027)) begin
      $display("FINISHED (ALU), %d tests completed with %d errors", alu_test_count, alu_error_count);
      #16;

      $finish;
    end
  end

  
  

  alu #(.N(32)) alu (
    .src0(a),
    .src1(b),
    .op(op),
    .result(result),
    .zero(zero)
  );

endmodule
