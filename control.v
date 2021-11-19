module control(opcode, ctrl);
	//ctrl_rtype, ctrl_itype, ctrl_sw, ctrl_lw
	input [4:0] opcode;
	output reg [10:0] ctrl;
	
	always @(opcode)
		case(opcode)
			5'b00000: ctrl = 11'b00000001000; //add ctrl[3]
			5'b00101: ctrl = 11'b00000000100; //addi ctrl[2]
			5'b00111: ctrl = 11'b00000000010; //sw ctrl[1]
			5'b01000: ctrl = 11'b00000000001; //lw ctrl[0]
			5'b00001: ctrl = 11'b00000010000; //j ctrl[4]
			5'b00010: ctrl = 11'b00000100000; //bne ctrl[5]
			5'b00011: ctrl = 11'b00001000000; //jal ctrl[6]
			5'b00100: ctrl = 11'b00010000000; //jr ctrl[7]
			5'b00110: ctrl = 11'b00100000000; //blt ctrl[8]
			5'b10110: ctrl = 11'b01000000000; //bex ctrl[9]
			5'b10101: ctrl = 11'b10000000000; //setx ctrl[10]
		endcase
endmodule
			
			