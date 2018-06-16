
module instr_mem (Adr, RD);
	input [31:0] Adr; // address
	output reg [31:0] RD; // Read_Dat
	
	reg [31:0] RAM [(1<<10)- 1:0];
	
always @*
begin
	RD = RAM [Adr[11:2]];
end
	
initial $readmemh ("isort32.hex", RAM);
endmodule 
	




















