module branching_unit (
   input logic [2:0] funct3,
   input logic [63:0] readData1,
   input logic [63:0] b,
   output logic addermuxselect
);

  always_comb begin
    case (funct3)
      3'b000:
        addermuxselect = (readData1 == b) ? 1'b1 : 1'b0;
		3'b001:
        addermuxselect = (readData1 != b) ? 1'b1 : 1'b0;
      3'b100:
        addermuxselect = (readData1 < b) ? 1'b1 : 1'b0;
      3'b101:
        addermuxselect = (readData1 > b) ? 1'b1 : 1'b0;
      default:
        addermuxselect = 1'b0;
    endcase
  end

endmodule
