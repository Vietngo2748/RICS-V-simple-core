module twox1Mux (
  input logic [63:0] A, B,
  input logic SEL,
  output logic [63:0] Y
);

  always_comb begin
    if (SEL == 0)
      Y = A;
    else
      Y = B;
  end

endmodule
