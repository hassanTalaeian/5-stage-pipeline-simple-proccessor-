module Register_file (
input [4:0] Read_Reg1, //Read register 1
input [4:0] Read_Reg2, //Read register 2
input [4:0] WriteAdr_Reg, //write reg
input [31:0] WriteData, // WriteData
input clk,reset,  // clock
input RegWriteEn, // Register Write
output [31:0] Read_Data1,
output [31:0] Read_Data2 );


reg [31:0] RAM [(1<<5)-1 : 0];

assign Read_Data1 = RAM [Read_Reg1[4:0]];
assign Read_Data2 = RAM [Read_Reg2[4:0]];
integer i;

always @ (posedge clk)
begin
	if (reset)
	begin
		for (i=0; i<(1<<5); i=i+1)
			RAM[i] = 32'h00000000;
	end	
	
end

always @(negedge clk)
begin
	if (RegWriteEn)
		RAM[WriteAdr_Reg[4:0]] = WriteData;
	
end

endmodule


