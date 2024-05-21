`timescale 1ns / 1ps

module testbench_register_file();

reg clk;
reg rst;

reg [31:0] io_in;
wire [31:0] io_out;

cpu cpu (
  .clk(clk),
  .rstn(!rst),
  .io_in(io_in),
  .io_out(io_out)
);

integer file, r, eof;
reg [100*8:1] line;
reg [31:0] clk_cycle_count;


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
  
  clk_cycle_count = 0;

  @(negedge clk);
  rst = 1;
  @(negedge clk);
  rst = 0;


  while (1) begin
    @(posedge clk);
    clk_cycle_count = clk_cycle_count + 1;
    if (clk_cycle_count == 10000) $finish;
  end
end

endmodule

