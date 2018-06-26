module Data_mem (
input [31:0] Adr,
input [31:0] WD,
input WE,
input clk, reset,
output reg [31:0] RD
);

 reg [31:0] RAM [(1<<10)-1 : 0];

integer i;
 	
always @*
	begin
	
		if (reset)
		begin
			for(i = 0; i < (1<<10); i=i+1)
			  	RAM [i] = 32'h00000000;
		end

		RD = (Adr[12:2] < (1<<10)) ? RAM[Adr[12:2]] : 32'hxxxxxxxx;
	end

always @(posedge clk)
begin
	if (WE)
		RAM[Adr[12:2]] <= WD;
end

endmodule











