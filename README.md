# processor
Yang Wenting          wy77

Liu Mengqi            ml607

The processor is implemented with the following basic blocks.

        PC:
                PC is a 32-bit DFFE which outputs the address of next instruction at positive clock edge.

        Imem:
                1-port ROM, 12-bit address, 32-bit data.

        Regfile:
                2 reading port, 1 writilng port.

        ALU:
                Takes in two 32-bit operands, perform basic arithmetic and logical operations.

        Sign-extender:
                Takes in 17-bit immediate number, sign extend it to 32-bit.

        Dmem:
                2-port RAM, 12-bit address, 32-bit data.

We also have 4 control signals:

        ctrl_sw: 
                1 when the operation is sw, it controls when Dmem could be written.
        ctrl_lw: 
                1 when the operation is lw, it selects which signal goes into Regfile.
        ctrl_rtype:
                1 when the operation is r-type, it determines which input (data_readregB or sign-extended immediate) should go into data_operandB of alu.
        ctrl_itype:
                1 when the operation is i-type, when it is 1 the opcode of alu should be 00000, rather than coming from a portion of the instruction.
        
We've also devided the instruction properly into the following parts to enhance readability:

        rs, rt, rd, rstatus, shamt, opcode, alu_opcode, N



