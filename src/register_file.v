module register_file #(
  parameter N = 32,
  parameter XLEN = 32
)(
  input [CLOG2(XLEN)-1:0] A1, A2, A3,
  input CLK,
  input RST,
  input WE3,
  input [N-1:0] WD3,
  output [N-1:0] RD1, RD2
);

  reg [N-1:0] registers[XLEN-1:0];

  assign RD1 = A1 == 0 ? 0 : registers[A1];
  assign RD2 = A2 == 0 ? 0 : registers[A2];

  always @ (posedge CLK or negedge RST) begin
    if (!RST) begin
      integer i;
      for (i = 0; i < XLEN; i = i + 1) begin
        registers[i] <= 0;
      end
    end else if (WE3 && (A3 != 0)) begin
      registers[A3] <= WD3;
    end
  end



  function integer CLOG2(input integer value);
    integer i;
    begin
      value = value - 1;
      for (i = 0; value > 0; i = i + 1)
        value = value >> 1;
      CLOG2 = i;
    end
  endfunction

endmodule
