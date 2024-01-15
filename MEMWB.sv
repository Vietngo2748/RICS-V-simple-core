module MEMWB (
  input logic clk, reset,
  input logic [63:0] read_data_in,
  input logic [63:0] result_alu_in, // 2 bit 2by1 mux input b
  input logic [4:0] Rd_in, // EX MEM output
  input logic memtoreg_in, regwrite_in, // ex mem output as mem wb inputs
  output logic [63:0] readdata, // 1bit
  output logic [63:0] result_alu_out, // 1bit
  output logic [4:0] rd,
  output logic Memtoreg, Regwrite
);

  always_ff @(posedge clk)
    if (reset)
      begin
        readdata <= 64'b0;
        result_alu_out <= 64'b0;
        rd <= 5'b0;
        Memtoreg <= 1'b0;
        Regwrite <= 1'b0;
      end
    else
      begin
        readdata <= read_data_in;
        result_alu_out <= result_alu_in;
        rd <= Rd_in;
        Memtoreg <= memtoreg_in;
        Regwrite <= regwrite_in;
      end

endmodule
