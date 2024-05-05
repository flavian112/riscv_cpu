function integer log2;
  input integer value;
  integer temp;
  begin
    log2 = 0;
    temp = value - 1;
    while (temp > 0) begin
      log2 = log2 + 1;
      temp = temp >> 1;
    end
  end
endfunction
