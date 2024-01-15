module adder (
  input logic [63:0] p,
  input logic [63:0] q,
  output logic [63:0] out
);

  assign out = p + q;

endmodule
