module pipelineCpu(
input clk, reset
);

wire stalF, stalD, flushE, RegWriteM, RegWriteE, tontbE, tontbM;
wire [4:0] RsD, RtD, RtE;
wire [1:0] forwardAE, forwardBE;

wire [4:0] WriteRegM, WriteRegE;
wire  LWE;

hazardUnit A1 (.stalF(stalF), .stalD(stalD), .flushE(flushE), .RegWriteM(RegWriteM), .RegWriteE(RegWriteE), 
		.tontbE(tontbE), .tontbM(tontbM), .RsD(RsD), .RtD(RtD), .RtE(RtE), .forwardAE(forwardAE), 
		.forwardBE( forwardBE), .WriteRegM(WriteRegM), .WriteRegE(WriteRegE), .LWE(LWE), .clk(clk));

DataPath A2 (.stalF(stalF), .stalD(stalD), .flushE(flushE), .RegWriteM(RegWriteM), .RegWriteE(RegWriteE), 
		.tontbE(tontbE), .tontbM(tontbM), .RsD(RsD), .RtD(RtD), .RtE(RtE), .forwardAE(forwardAE), 
		.forwardBE( forwardBE), .WriteRegM(WriteRegM), .WriteRegE(WriteRegE), .LWE(LWE), .clk(clk), .reset(reset));




endmodule

