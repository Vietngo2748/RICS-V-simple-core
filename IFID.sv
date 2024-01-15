module IFID (
  input logic clk,
  input logic reset,
  input logic [31:0] instruction,
  input logic [63:0] A, //a
  input logic flush,
  input logic IFIDWrite,
  output logic [31:0] inst, //instruction out,
  output logic [63:0] a_out
);

  always_ff @(posedge clk) begin
    if (reset || flush) begin
      inst <= 32'b0;
      a_out <= 64'b0;
    end else if (!IFIDWrite) begin
      inst <= instruction;
      a_out <= A;
    end
  end

endmodule
