`timescale 1ns / 1ps

module testbench_register_file();

reg clk;
reg rst;
reg we;
reg [4:0] addr_rs0, addr_rs1, addr_rd2;
reg [31:0] data_rd2;
wire [31:0] data_rs0, data_rs1;


register_file uut (
  .clk(clk),
  .rst(rst),
  .we(we),
  .addr_read0(addr_rs0),
  .addr_read1(addr_rs1),
  .addr_write2(addr_rd2),
  .data_read0(data_rs0),
  .data_read1(data_rs1),
  .data_write2(data_rd2)
);

integer file, r, eof;
reg [100*8:1] line;
reg [31:0] test_count, error_count;

reg [31:0] expected_data_rs0, expected_data_rs1;

always #5 clk = ~clk;

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
    $dumpvars(0,testbench_register_file);
  end


initial begin
  clk = 0;
  rst = 0;
  we = 0;
  addr_rs0 = 0;
  addr_rs1 = 0;
  addr_rd2 = 0;
  data_rd2 = 0;
  
  test_count = 0;
  error_count = 0;

  rst = 1;
  @(posedge clk);
  rst = 0;

  file = $fopen(testvec_filename, "r");
  if (file == 0) begin
    $display("ERROR: failed to open testvec");
    $finish;
  end

  while (!$feof(file)) begin
    eof = $fgets(line, file);
    eof = $sscanf(line, "%8h_%8h__%8h_%8h__%8h_%8h_%1h",
      addr_rs0, expected_data_rs0,
      addr_rs1, expected_data_rs1,
      addr_rd2, data_rd2, we);
    @(posedge clk);

    @(negedge clk);
    if (data_rs0 !== expected_data_rs0 || data_rs1 !== expected_data_rs1) begin
      $display("ERROR (register_file), test %d: addr_rs0: %08h, addr_rs1: %08h, addr_rd2: %08h, data_rd2: %08h, we: %b",
        test_count, addr_rs0, addr_rs1, addr_rd2, data_rd2, we);
      $display("      data_rs0: %08h (expected: %08h)", data_rs0, expected_data_rs0);
      $display("      data_rs1: %08h (expected: %08h)", data_rs1, expected_data_rs1);
      error_count = error_count + 1;
    end
    test_count = test_count + 1;
  end
  $display("FINISHED (register_file) with %d errors out of %d tests", error_count, test_count);
  $fclose(file);
  $finish;
end

endmodule

