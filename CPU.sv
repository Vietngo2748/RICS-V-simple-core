module CPU(
	input logic clk,
	input logic reset,
	output logic [63:0] diachi,
   output logic [31:0] lenh,
	output logic [63:0] reg8, reg18, reg19, reg20, reg21, reg22
);

 //PC wires
  logic [63:0] pc_in;
  logic [63:0] pc_out;
  
  // adders
  logic [63:0] adderout1;
  logic [63:0] adderout2;
  
  // inst mem wire
  logic [31:0] instruction;
  logic [31:0] inst_ifid_out;
  
  //Parser
  logic [6:0] opcode;
  logic [4:0] rd, rs1, rs2;
  logic [2:0] funct3;
  logic [6:0] funct7;
  
  //ifid wires
  logic [63:0] random;
  
  // Immediate Data Extractor
  logic [63:0] imm_data;
  
  //regfile
  logic regwrite_memwb_out;
  logic [63:0] readdata1, readdata2;
  logic [63:0] r8, r19, r20, r21, r22;
  logic [63:0] write_data;
  
  // CU wires
  logic branch;
  logic memread;
  logic memtoreg;
  logic memwrite;
  logic ALUsrc;
  logic regwrite;
  logic [1:0] ALUop;
  
  //id ex wires
  logic [63:0] a1;
  logic [4:0] RS1;
  logic [4:0] RS2;
  logic [4:0] RD;
  logic [63:0] d, M1, M2;
  logic Branch;
  logic Memread;
  logic Memtoreg;
  logic Memwrite;
  logic Regwrite;
  logic Alusrc;
  logic [1:0] aluop;
  logic [3:0] funct4_out;
  
  //mux wires
  logic [63:0] threeby1_out1;
  logic [63:0] threeby1_out2;
  logic [63:0]  alu_64_b;
  
  // ALU 64
  logic [63:0] AluResult;
  logic zero;
  
  
  // ALU Control
  logic [3:0] operation;
  
  // Data Memory
  logic [63:0] readdata;
  
  //ex mem wires
  logic [63:0] write_Data;
  logic [63:0] exmem_out_adder;
  logic exmem_out_zero;
  logic [63:0] exmem_out_result;
  logic [4:0] exmemrd;
  logic BRANCH,MEMREAD,MEMTOREG,MEMEWRITE,REGWRITE;  
 
  //memwb wires
  logic[63:0] muxin1,muxin2;
  logic [4:0] memwbrd;
  logic memwb_memtoreg;
  logic memwb_regwrite; 
  
  // Branch
  logic addermuxselect;
  logic branch_final;
  
  //forwarding unit wires
  logic [1:0] forwardA;
  logic [1:0] forwardB;
  
  pipeline_flush p_flush
  (
    .branch(branch_final & BRANCH),
    .flush(flush)
  );
  
   hazard_detection_unit hu
  (
    .Memread(Memread),
    .inst(inst_ifid_out),
    .Rd(RD),
    .stall(stall)
  );
  
 program_counter pc 
  (
    .PC_in(pc_in),
    .stall(stall),
    .clk(clk),
    .reset(reset),
    .PC_out(pc_out)
  );
  
  instruction_memory im
  (
    .inst_address(pc_out),
    .instruction(instruction)
  );
  
  
  adder adder1
  (
    .p(pc_out),
    .q(64'd4),
    .out(adderout1)
  );
  
  twox1Mux mux2
  (
    .A(adderout1),.B(exmem_out_adder),.SEL(BRANCH & branch_final),.Y(pc_in) // ??
  );
  
  IFID i1 
  (
    .clk(clk),
    .reset(reset),
    .IFIDWrite(stall),
    .instruction(instruction),
    .A(pc_out),
    .inst(inst_ifid_out),
    .a_out(random),
    .flush(flush)
  );
  
   Parser ip
  (
    .instruction(inst_ifid_out),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
  
  data_extractor immextr
  (
    .instruction(inst_ifid_out),
    .imm_data(imm_data)
  );
  
  
  registerFile regfile 
  (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(memwbrd),
    .writedata(write_data),
    .reg_write(memwb_regwrite),
    .readdata1(readdata1),
    .readdata2(readdata2),
    .r8(r8),
	 .r18(r18),
    .r19(r19),
    .r20(r20),
    .r21(r21),
    .r22(r22)
  );
  
  CU cu
  (
    .opcode(opcode),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .aluSrc(ALUsrc),
    .regwrite(regwrite),
    .Aluop(ALUop),
    .stall(stall)
  );
  
  IDEX i2
  (
    .clk(clk),
    .flush(flush),
    .reset(reset),
    .funct4_in({inst_ifid_out[30],inst_ifid_out[14:12]}),
    .A_in(random),
    .readdata1_in(readdata1),
    .readdata2_in(readdata2),
    .imm_data_in(imm_data),
    .rs1_in(rs1),.rs2_in(rs2),.rd_in(rd),
    .branch_in(branch),.memread_in(memread),.memtoreg_in(memtoreg),
    .memwrite_in(memwrite),.aluSrc_in(ALUsrc),.regwrite_in(regwrite),.Aluop_in(ALUop),
    .a(a1),.rs1(RS1),.rs2(RS2),.rd(RD),.imm_data(d),.readdata1(M1),.readdata2(M2),
    .funct4_out(funct4_out),.Branch(Branch),.Memread(Memread),.Memtoreg(Memtoreg),
    .Memwrite(Memwrite),.Regwrite(Regwrite),.Alusrc(Alusrc),.aluop(aluop)
  );
  
  adder adder2
  (
    .p(a1),
    .q(d << 1),
    .out(adderout2)
  );
  
  ThreebyOneMux m1
  (
    .a(M1),.b(write_data),.c(exmem_out_result),.sel(forwardA),.out(threeby1_out1)
  );
  
  ThreebyOneMux m2
  (
    .a(M2),.b(write_data),.c(exmem_out_result),.sel(forwardB),.out(threeby1_out2)
  );
  
  twox1Mux mux1
  (
    .A(threeby1_out2),.B(d),.SEL(Alusrc),.Y(alu_64_b)
  );
  
  Alu64 alu
  (
    .a(threeby1_out1),
    .b(alu_64_b),
    .ALuop(operation),
    .Result(AluResult),
    .zero(zero)
  );
  
   alu_control ac
  (
    .Aluop(aluop),
    .funct(funct4_out),
    .operation(operation)
  );
  
   EXMEM i3
  (
    .clk(clk),.reset(reset),.Adder_out(adderout2),.Result_in_alu(AluResult),.Zero_in(zero),.flush(flush),
    .writedata_in(threeby1_out2),.Rd_in(RD), .addermuxselect_in(addermuxselect),
    .branch_in(Branch),.memread_in(Memread),.memtoreg_in(Memtoreg),.memwrite_in(Memwrite),.regwrite_in(Regwrite),
    .Adderout( exmem_out_adder),.zero(exmem_out_zero),.result_out_alu(exmem_out_result),.writedata_out(write_Data),
    .rd(exmemrd),.Branch(BRANCH),.Memread(MEMREAD),.Memtoreg(MEMTOREG),.Memwrite(MEMEWRITE),.Regwrite(REGWRITE), .addermuxselect(branch_final)
  );
 
 data_memory datamem
  (
    .write_data(write_Data),
    .address(exmem_out_result),
    .memorywrite(MEMEWRITE),
    .clk(clk),
    .memoryread(MEMREAD),
    .read_data(readdata),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8)
  );
  
  
   MEMWB i4
  
  (
    .clk(clk),.reset(reset),.read_data_in(readdata),
    .result_alu_in(exmem_out_result),.Rd_in(exmemrd),.memtoreg_in(MEMTOREG),.regwrite_in(REGWRITE),
    .readdata(muxin1),.result_alu_out(muxin2),.rd(memwbrd),.Memtoreg(memwb_memtoreg),.Regwrite(memwb_regwrite)
  );
  
   twox1Mux mux3
  (
    .A(muxin2),.B(muxin1),.SEL(memwb_memtoreg),.Y(write_data)
  );
  
   branching_unit branc
  (
    .funct3(funct4_out[2:0]),.readData1(M1),.b(alu_64_b),.addermuxselect(addermuxselect)
  );
  
  ForwardingUnit f1
  (
    .RS_1(RS1),.RS_2(RS2),.rdMem(exmemrd),
    .rdWb(memwbrd),.regWrite_Wb(memwb_regwrite),
    .regWrite_Mem(REGWRITE),
    .Forward_A(forwardA),.Forward_B(forwardB)
  );
  
  assign reg8 = r8;
  assign reg18 = r18;
  assign reg19 = r19;
  assign reg20 = r20;
  assign reg21 = r21;
  assign reg22 = r22;
  
  assign diachi = pc_out;
  assign lenh = instruction;
 endmodule 
 
 