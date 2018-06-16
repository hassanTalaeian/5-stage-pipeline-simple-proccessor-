

module hazardUnit (
output reg stalF,
output reg stalD,
output reg flushE,
input [4:0] RsD,
input [4:0] RtD,
//input [4:0] RsE,
input [4:0] RtE,
output reg [1:0] forwardAE,
output reg [1:0] forwardBE,
//input  MemtoRegE,
input  RegWriteM,
//input  MemtoRegW,
//input [4:0] WriteRegW,
input [4:0] WriteRegM,
input [4:0] WriteRegE,
input  LWE, 
input RegWriteE,
input tontbE, tontbM, clk
);

always @(posedge clk)
begin
////////////data hazards
	if((RegWriteM && (WriteRegM != 'd0)  && (WriteRegM == RsD)) && !(RegWriteE && (WriteRegE != 'd0) && (WriteRegE == RsD)))
		begin	forwardAE = 2'b01;end
	else if(RegWriteE && (WriteRegE != 'd0) && (WriteRegE == RsD))
		begin	forwardAE = 2'b10;end
	else	
		begin	forwardAE = 2'b00;end
			
	if((RegWriteM && (WriteRegM != 'd0)  && (WriteRegM == RtD)) && !(RegWriteE && (WriteRegE != 'd0) && (WriteRegE == RtD)))
			forwardBE = 2'b01;
	else if(RegWriteE && (WriteRegE != 'd0) && (WriteRegE == RtD))
			forwardBE = 2'b10;
	else	
			forwardBE= 2'b00;
			
///////////control hazards
//LW
end

always @ *
begin
if ((RtE == RsD || RtE == RtD) && LWE)
	begin
		stalD = 1'b1; 
		stalF = 1'b1;
	end
else begin
		stalD = 1'b0; 
		stalF = 1'b0;
	
end
//Branch ----- LW
if (tontbE || tontbM ||((RtE == RsD || RtE == RtD) && LWE)) 
	begin 
		flushE = 1'b1; 
	end
else begin
		flushE = 1'b0;
end

end

endmodule 