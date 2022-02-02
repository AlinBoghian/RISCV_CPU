module EX_MEM_reg(input clk,reset,
                        input MemRead_EX,
                        input MemWrite_EX,
                        input RegWrite_EX,
                        input MemtoReg_EX,
                        input [4:0] RD_EX,
                        input [31:0] ALU_OUT_EX,
                        input [31:0] REG2_DATA_EX,
                        output reg MemRead_MEM,
                        output reg MemWrite_MEM,
                        output reg RegWrite_MEM,
                        output reg MemtoReg_MEM,
                        output  reg [4:0] RD_MEM,
                        output reg [31:0] ALU_OUT_MEM,
                        output reg [31:0] REG2_DATA_MEM);

 always@(posedge clk)begin
        if(reset)begin
            MemRead_MEM <= 0;
            MemWrite_MEM <= 0;
            RegWrite_MEM <= 0;
            MemtoReg_MEM <= 0;
            RD_MEM <= 0;
            ALU_OUT_MEM <= 0;
            REG2_DATA_MEM <= 0;
        end
        else begin
            MemRead_MEM <= MemRead_EX;
            MemWrite_MEM <= MemWrite_EX;
            RegWrite_MEM <= RegWrite_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            RD_MEM <= RD_EX;
            ALU_OUT_MEM <= ALU_OUT_EX;
            REG2_DATA_MEM <= REG2_DATA_EX;
        end
    end

endmodule