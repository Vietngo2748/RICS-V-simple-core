module alu_control (
  input logic [1:0] Aluop,
  input logic [3:0] funct,
  output logic [3:0] operation
);

  always_comb begin
    case (Aluop)
      2'b01: operation = 4'b0110;
      2'b00: operation = 4'b0010;
      2'b10: begin
        case (funct)
          4'b0000: operation = 4'b0010;
          4'b0111: operation = 4'b0000;
          4'b1000: operation = 4'b0110;
          4'b0110: operation = 4'b0001;
          default: operation = 4'b0000; // Add a default assignment for completeness
        endcase
      end
      default: operation = 4'b0000; // Add a default assignment for completeness
    endcase
  end

endmodule
