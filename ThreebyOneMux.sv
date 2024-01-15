module ThreebyOneMux (
  input logic [63:0] a,
  input logic [63:0] b,
  input logic [63:0] c,
  input logic [1:0] sel,
  output logic [63:0] out
);

  always_comb begin
    case (sel)
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      default: out = 64'b0; // Add a default assignment for completeness
    endcase
  end

endmodule
