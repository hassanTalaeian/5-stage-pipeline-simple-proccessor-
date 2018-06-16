module register(clk, flush, stall, datain, dataout);
parameter n = 32; // size of register
input clk, stall, flush;
input [n-1:0] datain;
output [n-1:0] dataout;

reg [n-1:0] register;

assign dataout = register;

always @(posedge clk)
begin
	if(stall == 1'b0 && flush == 1'b0)
		register <= datain;
	if (flush)
		register <= 'd0;
		
end
 
endmodule


