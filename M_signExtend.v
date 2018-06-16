
module M_signExtend (
input [15:0] immd,
input signExtend,
output [31:0] extended
);

assign extended = (signExtend == 1) ? ({{16{immd[15]}}, immd}) : ({{16{1'b0}}, immd});
endmodule 


