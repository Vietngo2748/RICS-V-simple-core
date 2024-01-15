module data_extractor (
  input logic [31:0] instruction,
  output logic [63:0] imm_data
);

  always @(*) begin
    case (instruction[6:5])
      2'b00:
        imm_data[11:0] = instruction[31:20];
      2'b01:
        imm_data[11:0] = {instruction[31:25], instruction[11:7]};
      2'b11:
        imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    endcase
    imm_data = {{52{imm_data[11]}}, {imm_data[11:0]}};
  end

endmodule
