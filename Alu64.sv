module Alu64 (
  input logic [63:0] a, b,
  input logic [3:0] ALuop,
  output logic [63:0] Result,
  output logic zero
);

  always_comb begin
    case (ALuop)
      4'b0000: Result = a & b;
      4'b0001: Result = a | b;
      4'b0010: Result = a + b;
      4'b0110: Result = a - b;
      4'b1100: Result = ~(a | b); // nor
      default: Result = 64'b0; // Add a default assignment for completeness
    endcase

    zero = (Result == 64'b0) ? 1 : 0;
  end

endmodule
