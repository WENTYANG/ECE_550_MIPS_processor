module signex(imm17, imm32);
	input [16:0] imm17;
	output [31:0] imm32;
	
	assign imm32[16:0] = imm17[16:0];
	assign imm32[31:17] = {15{imm17[16]}};
endmodule