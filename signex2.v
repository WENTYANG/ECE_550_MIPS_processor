module signex2(imm27, imm32);
	input [26:0] imm27;
	output [31:0] imm32;
	
	assign imm32[26:0] = imm27[26:0];
	assign imm32[31:27] = {5{1'b0}};
endmodule