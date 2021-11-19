/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                   // I: Data from port B of regfile
	 );
	 
	 // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 reg [31:0] pc_in;
	 wire [31:0] pc_out;
	 wire [31:0] insn;
	 wire ctrl_rtype, ctrl_itype, ctrl_sw, ctrl_lw;
	 wire [4:0] rs, rt, rd, rstatus, shamt, opcode, alu_opcode;
	 wire [16:0] N;
	 wire [26:0] T;
	 wire [10:0] ctrl;
	 reg [31:0] status;
	 
	 //internal wires
	 wire[31:0] pc_in1, pc_1, pc_N;

	 //Instruction fetch
	 pc pc1(.clk(clock), .rst(reset), .pc_in(pc_in), .pc_out(pc_out));
	 
	 alu alu2(.data_operandA(pc_out), .data_operandB(32'd1), .ctrl_ALUopcode(5'd0),
			.ctrl_shiftamt(5'd0), .data_result(pc_1));			//pc_in = pc_out + 1
	 alu alu3(.data_operandA(pc_1), .data_operandB(immediate), .ctrl_ALUopcode(5'd0),
			.ctrl_shiftamt(5'd0), .data_result(pc_N));
	 
//	 generate_pc gepc1(ctrl_jr, ctrl_bne, ctrl_blt,ctrl_j, ctrl_jal, ctrl_bex, data_readRegA, data_readRegB, isNotEqual,isLessThan, pc_1, pc_N, N, T, pc_in);

	always @(*) begin
		pc_in <= pc_1;
		if(ctrl_j||ctrl_jal)
			pc_in <= T_ex;
		else if(ctrl_bne && isNotEqual)
			pc_in <= pc_N;
		else if(ctrl_jr)
			pc_in <= data_readRegB;
		else if(ctrl_blt && (isNotEqual&&(!isLessThan)))
			pc_in <= pc_N;
		else if(ctrl_bex && (!isNotEqual))
			pc_in <= T_ex;
	 end
	 
//	 assign pc_in1 = ctrl_bne?(isNotEqual?pc_N:pc_1):((ctrl_j | ctrl_jal)?T_ex:pc_1);
//	 assign pc_in = ctrl_bex?(!isNotEqual?T_ex:pc_1):(ctrl_blt?((isNotEqual&&(!isLessThan))?pc_N:pc_1):(ctrl_jr?data_readRegB:pc_in1));

	 assign address_imem = pc_out[11:0];
	 assign insn = q_imem;
	 
	 //Divide the instruction
	 assign opcode = insn[31:27];
	 assign alu_opcode = insn[6:2];
	 assign rs = insn[21:17];
	 assign rt = insn[16:12];
	 assign rd = insn[26:22];
	 assign rstatus = 5'b11110;
	 assign shamt = insn[11:7];
	 assign N = insn[16:0];
	 assign T = insn[26:0];
	 wire [31:0] T_ex;
	 signex2 signextender(T, T_ex);
	 
	 //ctrl
	 //ctrl_rtype, ctrl_itype, ctrl_sw, ctrl_lw
	 control con1(.opcode(opcode), .ctrl(ctrl));
	 assign ctrl_rtype = ctrl[3];
	 assign ctrl_itype = ctrl[2];
	 assign ctrl_sw = ctrl[1];
	 assign ctrl_lw = ctrl[0];
	 assign ctrl_j = ctrl[4];
	 assign ctrl_bne = ctrl[5];
	 assign ctrl_jal = ctrl[6];
	 assign ctrl_jr = ctrl[7];
	 assign ctrl_blt = ctrl[8];
	 assign ctrl_bex = ctrl[9];
	 assign ctrl_setx = ctrl[10];
	 
	 //Read Regfile
	 always @(posedge overflow) begin
		 case(opcode)
			5'b00000: begin
				if(alu_opcode == 5'b00000)
					status = 31'd1;//add
				else 
					if(alu_opcode == 5'b00001)
						status = 31'd3;//sub
			end
			5'b00101: status = 31'd2; //addi
		endcase
	 end
	 
	 assign ctrl_readRegA = ctrl_bex?rstatus:rs;
	 assign ctrl_readRegB = ctrl_bex?5'b00000:((ctrl_bne|ctrl_jr|ctrl_blt|ctrl_sw)?rd:rt);
	 
	//ALU
	wire [31:0] data_operandA, data_operandB;
	wire [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	wire [31:0] data_result;
	wire isNotEqual, isLessThan, overflow;
	wire [31:0] immediate;
	
	signex signex1(.imm17(N), .imm32(immediate));
	assign data_operandB = ctrl_rtype?data_readRegB:immediate;
	
	alu alu1(.data_operandA(data_readRegA), .data_operandB(data_operandB), .ctrl_ALUopcode(ctrl_rtype?alu_opcode:5'd0),
		.ctrl_shiftamt(shamt), .data_result(data_result), .isNotEqual(isNotEqual), .isLessThan(isLessThan)
		, .overflow(overflow));
	
	//Write Regfile
	wire write_status;
	assign write_status = (ctrl_rtype && (alu_opcode == 5'b00000 || alu_opcode == 5'b00001)) || (opcode == 5'b00101);
	assign ctrl_writeReg = ctrl_setx?rstatus:(ctrl_jal?5'b11111:((overflow && write_status)?rstatus:rd));
	assign data_writeReg = ctrl_setx?T_ex:(ctrl_jal?pc_1:((overflow && write_status)?status:(ctrl_lw?q_dmem:data_result)));
	assign ctrl_writeEnable = ctrl_rtype + ctrl_itype + ctrl_lw + ctrl_jal + ctrl_setx;
	
	//DMem
	assign address_dmem = data_result[11:0];
	assign data = data_readRegB;
	assign wren = ctrl_sw;
	
endmodule
