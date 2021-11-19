module generate_pc(
	input ctrl_jr, ctrl_bne, ctrl_blt,ctrl_j, ctrl_jal, ctrl_bex,
	input [31:0] data_readRegA, data_readRegB,
	input isNotEqual,
	input isLessThan,
	input [31:0] pc_1, pc_N,
	input [16:0] N,
	input [26:0] T,
	output reg [31:0] pc_in
	);
	
	always @ (ctrl_jr or ctrl_bne or ctrl_blt or ctrl_j or ctrl_jal or ctrl_bex) begin
	
		if(ctrl_j || ctrl_jal) begin
			pc_in[26:0] = T;
		end
		
		else if(ctrl_bne) begin
			if(isNotEqual)
				pc_in = pc_N;
		end
		
		else if(ctrl_jr) begin
			pc_in = data_readRegB;
		end
		
		else if(ctrl_blt) begin
			if(isNotEqual&&(!isLessThan))
				pc_in = pc_N;
		end
		
		else if(ctrl_bex) begin
			if(!isNotEqual)
				pc_in[26:0] = T;
		end
		
	end
endmodule
	
	