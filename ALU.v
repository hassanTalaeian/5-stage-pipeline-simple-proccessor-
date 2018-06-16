module ALU( A, B,ALUControl, Y, Zero);

	input   [2:0]   ALUControl; // control bits for ALU operation
	input   [31:0]  A, B;	    // inputs

	integer temp,i,x;
	reg [31:0] y;
	reg sign;
	output  reg [31:0]  Y;	// answer
	output  reg     Zero;	    // Zero=1 if ALUResult == 0

    /* Please fill in the implementation here... */


    always @(ALUControl,A,B)
    begin
		case (ALUControl)
			
			0: // ADD
				Y <= A + B;

			1: // SUB
				Y <= A + (~B + 1);

			2: // AND
				Y <= A & B;

			3: // OR
				Y <= A | B;

			4: // XOR
				Y <= A ^ B;

			5: // NOR
				Y <= ~(A | B);

			6: begin // SLT
				if (A[31] != B[31]) begin
					if (A[31] > B[31]) begin
						Y <= 1;
					end else begin
						Y <= 0;
					end
				end else begin
					if (A < B)
					begin
						Y <= 1;
					end
					else
					begin
						Y <= 0;
					end
				end
			end
			
			
			7: // SLTU
				Y <= A < B;
			
			
		endcase
	end


	always @(Y) begin
		if (Y == 0) begin
			Zero <= 1;
		end else begin
			Zero <= 0;
		end
	
	end

endmodule

