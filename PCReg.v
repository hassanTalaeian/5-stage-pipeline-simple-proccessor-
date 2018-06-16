module PCReg (

input CountEn, 
input [31:0] nextVal,
output [31:0] lastVal,
input clk, reset
);

reg [31:0] PC;

assign lastVal = PC;

always @(posedge clk)
begin
	if (CountEn == 1 )
		if(reset)
			PC = 0;	
		else
			PC = nextVal;
end
endmodule


