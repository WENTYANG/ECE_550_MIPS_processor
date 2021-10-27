module control(opcode, ctrl);
	//ctrl_rtype, ctrl_itype, ctrl_sw, ctrl_lw
	input [4:0] opcode;
	output reg [3:0] ctrl;
	
	always @(opcode)
		case(opcode)
			5'b00000: ctrl = 4'b1000; //add
			5'b00101: ctrl = 4'b0100; //addi
			5'b00111: ctrl = 4'b0010; //sw
			5'b01000: ctrl = 4'b0001; //lw
		endcase
endmodule
			
			