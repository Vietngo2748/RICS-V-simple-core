module program_counter (
  input logic [63:0] PC_in,
  input logic clk,
  input logic reset,
  input logic stall,
  output logic [63:0] PC_out
);
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      PC_out <= 64'd0;
    else if (!stall)
      PC_out <= PC_in;

endmodule
