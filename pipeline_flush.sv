module pipeline_flush (
  input logic branch,
  output logic flush
);

  always_comb begin
    if (branch == 1'b1)
      flush = 1'b1;
    else
      flush = 1'b0;
  end

endmodule
