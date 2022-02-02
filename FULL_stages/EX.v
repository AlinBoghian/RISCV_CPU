module EX(input [31:0] IMM_EX,
            input [31:0] REG_DATA1_EX,
            input [31:0] REG_DATA2_EX,
            input [31:0] PC_EX,
            input [2:0] FUNCT3_EX,
            input [6:0] FUNCT7_EX,
            input [4:0] RD_EX,
            input [4:0] RS1_EX,
            input [4:0] RS2_EX,
            input RegWrite_EX,
            input MemtoReg_EX,
            input MemRead_EX,
            input MemWrite_EX,
            input [1:0] ALUop_EX,
            input ALUSrc_EX,
            input Branch_EX,
            input [1:0] forwardA,forwardB,
            
            input [31:0] ALU_DATA_WB,
            input [31:0] ALU_OUT_MEM,
            
            output ZERO_EX,
            output [31:0] ALU_OUT_EX,
            output [31:0] PC_Branch_EX,
            output [31:0] REG_DATA2_EX_FINAL);

    wire [31:0] alu_ina,alu_inb;
    wire [3:0] aluOP;

    mux3_1 forwardA_mux(REG_DATA1_Ex,ALU_DATA_WB,ALU_OUT_MEM,forwardA,alu_ina);

    mux3_1 forwardB_mux(REG_DATA2_Ex,ALU_DATA_WB,ALU_OUT_MEM,forwardB,REG_DATA2_EX_FINAL);
    
    mux2_1 mux_rs2_imm(REG_DATA2_EX_FINAL,IMM_EX,ALUsrc_EX,alu_inb);

    ALUcontrol alu_control(ALUop_EX,FUNCT7_EX,FUNCT3_EX,aluOP);

    ALU alu(aluOP,alu_ina,alu_inb,ZERO_EX,ALU_OUT_EX);

    adder pc_inc(PC_EX,IMM_EX,PC_Branch_EX);



endmodule