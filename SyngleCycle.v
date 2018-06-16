module SingleCycle (
input clk, reset
);

wire MemtoReg, MemWrite, PCSrc, ALUSrc, RegDst, RegWrite, SgnZero, ALUZero;
wire [2:0] ALUOP;
wire [5:0] OPcode, funct;

DataPath datapath (.MemtoReg(MemtoReg), .MemWrite(MemWrite),.PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite), .SgnZero(SgnZero), .clk(clk), .ALUZero(ALUZero), .ALUOP(ALUOP), .OPcode(OPcode), .funct(funct), .reset(reset));
Controler cntrl (.OP(OPcode), .func(funct), .Zero(ALUZero), .ALUOP(ALUOP), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .RegDst(RegDst), .RegWrite(RegWrite), .SgnZero(SgnZero));
endmodule



