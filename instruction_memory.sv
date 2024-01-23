module instruction_memory (
  input logic [63:0] inst_address,
  output logic [31:0] instruction
);

  logic [7:0] inst_mem[87:0];
  
  initial
    begin
		{inst_mem[3], inst_mem[2], inst_mem[1], inst_mem[0]} = 32'h3E8D8D93;//1 addi x27,x27,1000
      {inst_mem[7], inst_mem[6], inst_mem[5], inst_mem[4]} = 32'h00843A03;//2, ld x20, 8(x8), x8 = 0, x20 = memory[0+8] = 2
      {inst_mem[11], inst_mem[10], inst_mem[9], inst_mem[8]} = 32'h00043903;//3 ld x18, 0(x8), x18 = mem[0+0] = 1
      {inst_mem[15], inst_mem[14], inst_mem[13], inst_mem[12]} = 32'h012A69B3;//4, or x19,x20,x18
      {inst_mem[19], inst_mem[18], inst_mem[17], inst_mem[16]} = 32'h012A79B3;//5, and x19,x20,x18	
      {inst_mem[23], inst_mem[22], inst_mem[21], inst_mem[20]} = 32'h012A0A33;//6 add x20,x20,x18 
      {inst_mem[27], inst_mem[26], inst_mem[25], inst_mem[24]} = 32'h014A0A33;//7, add  x20,x20,x20
      {inst_mem[31], inst_mem[30], inst_mem[29], inst_mem[28]} = 32'h01443023;//8, sd x20,0(x8)
      {inst_mem[35], inst_mem[34], inst_mem[33], inst_mem[32]} = 32'h412A0A33;// 9, outerlop: sub x20,x20,x18
      {inst_mem[39], inst_mem[38], inst_mem[37], inst_mem[36]} = 32'h02000A63;//10 beq x0, x0, outerexit 
      {inst_mem[43], inst_mem[42], inst_mem[41], inst_mem[40]} = 32'h00898993;//11 addi x19, x19, 8
      {inst_mem[47], inst_mem[46], inst_mem[45], inst_mem[44]} = 32'h00093d03;//12 ld x26, 0x0(x18)
      {inst_mem[51], inst_mem[50], inst_mem[49], inst_mem[48]} = 32'h0009bd83;//13 ld x27, 0x0(x19)
      {inst_mem[55], inst_mem[54], inst_mem[53], inst_mem[52]} = 32'h01bd4463;//14 blt x26, x27, bubblesort # if a[i] < a[j], dont restart loop but bubble sort
      {inst_mem[59], inst_mem[58], inst_mem[57], inst_mem[56]} = 32'hfe0004e3;//15 beq x0,x0, outerlop # unconditional loop
      {inst_mem[63], inst_mem[62], inst_mem[61], inst_mem[60]} = 32'h01a002b3;//16 bubblesort: add x5, x0, x26 # int temp = a[i]
      {inst_mem[67], inst_mem[66], inst_mem[65], inst_mem[64]} = 32'h01b93023;//17 sd x27, 0(x18) # a[i] = a[j]
      {inst_mem[71], inst_mem[70], inst_mem[69], inst_mem[68]} = 32'h0059b023;//18 sd x5, 0(x19) # a[j] = temp
      {inst_mem[75], inst_mem[74], inst_mem[73], inst_mem[72]} = 32'hfc000ce3;//19 beq x0, x0, outerloop # restart j
      {inst_mem[79], inst_mem[78], inst_mem[77], inst_mem[76]} = 32'h00140413;//20 addi x8, x8, 1 #increment i
      {inst_mem[83], inst_mem[82], inst_mem[81], inst_mem[80]} = 32'h00890913;//21 addi, x18, x18, 8 # increment i offset
      {inst_mem[87], inst_mem[86], inst_mem[85], inst_mem[84]} = 32'hfa000ae3;//22 beq x0, x0, outerloop
		//outerexit:
    end
  always @ (inst_address)
    begin
      instruction[7:0] = inst_mem[inst_address+0];
      instruction[15:8] = inst_mem[inst_address+1];
      instruction[23:16] = inst_mem[inst_address+2];
      instruction[31:24] = inst_mem[inst_address+3];
    end
endmodule
