module DataPath (
input stalF,
input stalD,
input flushE,
output [4:0] RsD,
output [4:0] RtD,
//output [4:0] RsE,
output [4:0] RtE,
input [1:0] forwardAE,
input [1:0] forwardBE,
//output  MemtoRegE,
output  RegWriteM,
output  RegWriteE,
//output  MemtoRegW,
//output [4:0] WriteRegW,
output [4:0] WriteRegM,
output [4:0] WriteRegE,
output [5:0] OPE,
output tontbE, tontbM,
input clk, reset
);
wire [4:0] RsE, WriteRegW;
wire MemtoRegE, MemtoRegW;

wire PCSrcE;
assign tontbE = PCSrcE;
wire [31:0] PCBranchM, PCPlus4F, PCp;
////////////////////////////////////////////////////////////////
assign PCp = PCSrcE ? PCBranchM : PCPlus4F;

wire [31:0] PCF; 
//////////////// next stage from mux
register #(32)PC (.stall(1'b0), .datain(PCp), .dataout(PCF), .clk(clk), .flush(reset));
////////////////
assign PCPlus4F = PCF + 3'b100;
///////////////////////////////////////////////////////////////valuate 2 output OPcode and funct
wire [31:0] instructionF; 

instr_mem insructionMemory ( .Adr(PCF), .RD(instructionF));
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////2-stage
wire [31:0] instructionD, PCPlus4D;

register #(64) stage2 (.clk(clk), .stall(stalD), .flush(reset), .datain({instructionF, PCPlus4F}), .dataout({instructionD, PCPlus4D}));
//////////////////////////////////////

wire [31:0] ResultW, RD1D, RD2D;
wire RegWriteW;

Register_file RegisterFile (.reset(reset), .Read_Reg1(instructionD[25:21]), .Read_Reg2(instructionD[20:16]), .WriteAdr_Reg(WriteRegW), .clk(clk), .WriteData(ResultW), .RegWriteEn(RegWriteW), .Read_Data1(RD1D), .Read_Data2(RD2D));

wire [31:0] SignImmD;
wire [2:0] ALUControlD;
wire  MemWriteD, ALUSrcD, RegDstD, RegWriteD, sgnZeroD, MemtoRegD, BranchD;
//wire [4:0] RsD, RtD, RdD;
wire [4:0] RdD;
assign RsD = instructionD[25:21];
assign RtD = instructionD[20:16];
assign RdD = instructionD[15:11];


 M_signExtend signExtend (.immd(instructionD[15:0]), .signExtend(~sgnZeroD), .extended(SignImmD));
 Controler cntrl (.Branch(BranchD),.OP(instructionD[31:26]), .func(instructionD[5:0]), .Zero(), .ALUOP(ALUControlD), .MemWrite(MemWriteD), .MemtoReg(MemtoRegD), .PCSrc(), .ALUSrc(ALUSrcD), .RegDst(RegDstD), .RegWrite(RegWriteD), .SgnZero(sgnZeroD));

 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////3-satge
 wire [31:0] SignImmE;
wire [2:0] ALUControlE;
wire  MemWriteE, ALUSrcE, RegDstE, BranchE;
wire [31:0] RD1E, RD2E, PCPlus4E;
//wire [4:0] RsE, RtE,
wire [4:0] RdE;

 register #(158) stage3(.clk(clk), .stall(1'b0), .flush(flushE || reset),
						.datain({instructionD[31:26],RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, BranchD, RD1D, RD2D, RsD, RtD, RdD, SignImmD, PCPlus4D}), 
						.dataout({OPE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, BranchE, RD1E, RD2E, RsE, RtE, RdE, SignImmE, PCPlus4E}));
						
 ////////////////////////////////////////////////////////////////////

wire [31:0] SrcAE, SrcBE, WriteDataE, ALUOutE, ALUOutM;
wire ALUZero;

assign PCBranchM = (SignImmE << 2) + PCPlus4E;
assign WriteRegE = (RegDstE == 1) ? RdE : RtE;
assign SrcAE = (forwardAE == 2'b00) ? RD1E :
			  (forwardAE == 2'b01) ? ResultW :
			  (forwardAE == 2'b10) ? ALUOutM: 'dx;
assign WriteDataE = (forwardBE == 2'b00) ? RD2E :
			  (forwardBE == 2'b01) ? ResultW :
			  (forwardBE == 2'b10) ? ALUOutM: 'dx;
assign SrcBE = (ALUSrcE == 1'b0) ?  WriteDataE : SignImmE;			  			  
assign PCSrcE = (BranchE & ALUZero);
ALU alu32 (.A(SrcAE), .B(SrcBE), .ALUControl(ALUControlE), .Zero(ALUZero), .Y(ALUOutE));
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////4-stage
wire  MemtoRegM, MemWriteM;
wire [31:0] WriteDataM;

register #(73) stage4 (.clk(clk), .stall(1'b0), .flush(reset), .datain({tontbE, RegWriteE, MemtoRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE}), 
						.dataout({tontbM, RegWriteM, MemtoRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM}));


////////////////////////////////////////////////////////////////
wire [31:0] ReadDataM;
Data_mem MemoryData (.Adr(ALUOutM), .WD(WriteDataM), .clk(clk), .RD(ReadDataM), .WE(MemWriteM), .reset());
 /////////////////////////////////////////////////////////////////////////////////////////////////5-stage
 wire [31:0] ReadDataW, ALUOutW;
 
register #(71) stage5 (.clk(clk), .stall(1'b0), .flush(reset), .datain({RegWriteM, MemtoRegM, ReadDataM, ALUOutM, WriteRegM}), 
						.dataout({RegWriteW, MemtoRegW, ReadDataW, ALUOutW, WriteRegW}));
 
assign ResultW = MemtoRegW ? ReadDataW : ALUOutW;
 
endmodule 


