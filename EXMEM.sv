module EXMEM (
  input logic clk, reset,
  input logic [63:0] Adder_out,     // adder output
  input logic [63:0] Result_in_alu, // 64-bit alu output
  input logic Zero_in,              // 64-bit alu output
  input logic [63:0] writedata_in,   // 2-bit mux2by1 output
  input logic [4:0] Rd_in,           // IDEX output
  input logic branch_in, memread_in, memtoreg_in, memwrite_in, regwrite_in, // IDEXX outputs
  input logic flush, 
  input logic addermuxselect_in,
  output logic [63:0] Adderout,
  output logic zero,
  output logic [63:0] result_out_alu,
  output logic [63:0] writedata_out,
  output logic [4:0] rd,
  output logic Branch, Memread, Memtoreg, Memwrite, Regwrite,
  output logic addermuxselect
);

  always_ff @(posedge clk) begin
    if (reset || flush) begin
      Adderout <= 64'b0;
      zero <= 1'b0;
      result_out_alu <= 63'b0;
      writedata_out <= 64'b0;
      rd <= 5'b0;
      Branch <= 1'b0;
      Memread <= 1'b0;
      Memtoreg <= 1'b0;
      Memwrite <= 1'b0;
      Regwrite <= 1'b0;
      addermuxselect <= 1'b0;
    end else begin
      Adderout <= Adder_out;
      zero <= Zero_in;
      result_out_alu <= Result_in_alu;
      writedata_out <= writedata_in;
      rd <= Rd_in;
      Branch <= branch_in;
      Memread <= memread_in;
      Memtoreg <= memtoreg_in;
      Memwrite <= memwrite_in;
      Regwrite <= regwrite_in;
      addermuxselect <= addermuxselect_in;
    end
  end

endmodule
