module registerFile (
  input logic clk,
  input logic reset,
  input logic [4:0] rs1,
  input logic [4:0] rs2,
  input logic [4:0] rd,
  input logic [63:0] writedata,
  input logic reg_write,
  output logic [63:0] readdata1,
  output logic [63:0] readdata2,
  output logic [63:0] r8,
  output logic [63:0] r18,
  output logic [63:0] r19,
  output logic [63:0] r20,
  output logic [63:0] r21,
  output logic [63:0] r22
);

  logic [63:0] registers [31:0];

  initial begin
    for (int i = 0; i < 32; i = i + 1)
      registers[i] = 64'd0;

    registers[11] = 64'd8;
  end

  assign r8 = registers[8];
  assign r19 = registers[19];
  assign r20 = registers[20];
  assign r21 = registers[26];
  assign r22 = registers[27];
  assign r18 = registers[18];

  always @(*) begin
    if (reset) begin
      readdata1 <= 64'd0;
      readdata2 <= 64'd0;
    end else begin
      readdata1 <= registers[rs1];
      readdata2 <= registers[rs2];
    end
  end

  always_ff @(negedge clk) begin
    if (reg_write)
      registers[rd] <= writedata;
  end

endmodule
