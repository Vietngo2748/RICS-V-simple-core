module data_memory
  #(parameter DATA_WIDTH = 64, ADDRESS_WIDTH = 6)
  (input logic [DATA_WIDTH-1:0] write_data,
   input logic [ADDRESS_WIDTH-1:0] address,
   input logic memorywrite, clk, memoryread,
	input logic [1:0] select,
	output logic unalign,
   output logic [DATA_WIDTH-1:0] read_data,
   output logic [DATA_WIDTH-1:0] element1,
   output logic [DATA_WIDTH-1:0] element2,
   output logic [DATA_WIDTH-1:0] element3,
   output logic [DATA_WIDTH-1:0] element4,
   output logic [DATA_WIDTH-1:0] element5,
   output logic [DATA_WIDTH-1:0] element6,
   output logic [DATA_WIDTH-1:0] element7,
   output logic [DATA_WIDTH-1:0] element8);
  
  logic [7:0] mem [2**ADDRESS_WIDTH - 1:0]; // memory array
  logic unalign_internal_rd,unalign_internal_wr;
  assign unalign = unalign_internal_rd || unalign_internal_wr ;a
  integer i;
  
  initial begin
    for (i=0; i<2**ADDRESS_WIDTH; i=i+1) begin
      mem[i] = 0;
    end
    mem[0] = 8'd1;
    mem[8] = 8'd2;
    mem[16] = 8'd3;
    mem[24] = 8'd4;
    mem[32] = 8'd5;
    mem[40] = 8'd6;
    mem[48] = 8'd7;
    mem[56] = 8'd8;
  end
  
  assign element1 = {mem[7], mem[6], mem[5], mem[4], mem[3], mem[2], mem[1], mem[0]};
  assign element2 = {mem[15], mem[14], mem[13], mem[12], mem[11], mem[10], mem[9], mem[8]};
  assign element3 = {mem[23], mem[22], mem[21], mem[20], mem[19], mem[18], mem[17], mem[16]};
  assign element4 = {mem[31], mem[30], mem[29], mem[28], mem[27], mem[26], mem[25], mem[24]};
  assign element5 = {mem[39], mem[38], mem[37], mem[36], mem[35], mem[34], mem[33], mem[32]};
  assign element6 = {mem[47], mem[46], mem[45], mem[44], mem[43], mem[42], mem[41], mem[40]};
  assign element7 = {mem[55], mem[54], mem[53], mem[52], mem[51], mem[50], mem[49], mem[48]};
  assign element8 = {mem[63], mem[62], mem[61], mem[60], mem[59], mem[58], mem[57], mem[56]};
  
  always @(*) begin
  unalign_internal_rd = 1'b0;
    if (memoryread) begin
		case(select)
			2'b00: begin // byte
					read_data[7:0] = mem[address+0];
					read_data[63:8] = 0;
				end
			2'b01: begin //half word
             if ((address[1:0] % 2) == 0) begin
					read_data[7:0] = mem[address+0];
					read_data[15:8] = mem[address+1];
					read_data[63:16] = 0;
				end
				else
					unalign_internal_rd = 1'b1;
			end
			2'b10: begin //word
				if ((address[1:0] % 4) == 0) begin
					read_data[7:0] = mem[address+0];
					read_data[15:8] = mem[address+1];
					read_data[23:16] = mem[address+2];
					read_data[31:24] = mem[address+3];
					read_data[63:32] = 0;
				end
				else
					unalign_internal_rd = 1'b1;
			end
			2'b11: begin //double word
				if ((address[1:0] % 8) == 0) begin
					read_data[7:0] = mem[address+0];
					read_data[15:8] = mem[address+1];
					read_data[23:16] = mem[address+2];
					read_data[31:24] = mem[address+3];
					read_data[39:32] = mem[address+4];
					read_data[47:40] = mem[address+5];
					read_data[55:48] = mem[address+6];
					read_data[63:56] = mem[address+7];
				end
				else
					unalign_internal_rd = 1'b1;
			end
		endcase
    end
  end
  
  always_ff @(posedge clk) begin
  unalign_internal_wr <= 1'b0;
    if (memorywrite) begin
		case(select)
			2'b00: mem[address] <= write_data[7:0]; //byte
         2'b01: begin //half word
				if ((address[1:0] % 2) == 0) begin 
					mem[address] <= write_data[7:0];
					mem[address+1] <= write_data[15:8];
				end
				else 
					unalign_internal_wr <= 1'b1;
					
			end
			2'b10: begin	// word
				if ((address[1:0] % 4) == 0) begin
					mem[address] <= write_data[7:0];
					mem[address+1] <= write_data[15:8];
					mem[address+2] <= write_data[23:16];
					mem[address+3] <= write_data[31:24];
				end
				else
					unalign_internal_wr <= 1'b1;
			end
			2'b11: begin	// double
				if ((address[1:0] % 8) == 0) begin
					mem[address] = write_data[7:0];
					mem[address+1] = write_data[15:8];
					mem[address+2] = write_data[23:16];
					mem[address+3] = write_data[31:24];
					mem[address+4] = write_data[39:32];
					mem[address+5] = write_data[47:40];
					mem[address+6] = write_data[55:48];
					mem[address+7] = write_data[63:56];
				end
				else
					unalign_internal_wr <= 1'b1;
			end
		endcase 
    end
  end
endmodule
