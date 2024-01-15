module ForwardingUnit (
  input logic [4:0] RS_1, // ID/EX.RegisterRs1
  input logic [4:0] RS_2, // ID/EX.RegisterRs2
  input logic [4:0] rdMem, // EX/MEM.Register Rd
  input logic [4:0] rdWb, // MEM/WB.RegisterRd
  input logic regWrite_Wb, // MEM/WB.RegWrite
  input logic regWrite_Mem, // EX/MEM.RegWrite
  output logic [1:0] Forward_A,
  output logic [1:0] Forward_B
);

  always_comb begin
    if ((rdMem == RS_1) && (regWrite_Mem != 0 && rdMem != 0))
      Forward_A = 2'b10;
    else begin
      // Not condition for MEM hazard
      if ((rdWb == RS_1) && (regWrite_Wb != 0 && rdWb != 0) && !((rdMem == RS_1) && (regWrite_Mem != 0 && rdMem != 0)))
        Forward_A = 2'b01;
      else
        Forward_A = 2'b00;
    end

    if ((rdMem == RS_2) && (regWrite_Mem != 0 && rdMem != 0))
      Forward_B = 2'b10;
    else begin
      // Not condition for MEM Hazard
      if ((rdWb == RS_2) && (regWrite_Wb != 0 && rdWb != 0) && !((regWrite_Mem != 0 && rdMem != 0) && (rdMem == RS_2)))
        Forward_B = 2'b01;
      else
        Forward_B = 2'b00;
    end
  end

endmodule
