module MEM_WB_reg(input clk,reset,
                        input [31:0] ALU_OUT_MEM,
                        input [31:0] MEMORY_OUT_MEM,
                        input [4:0] RD_MEM,
                        input MemtoReg_MEM,
                        input RegWrite_MEM,
                        output reg [31:0] ALU_OUT_WB,
                        output reg [31:0] MEMORY_OUT_WB,
                        output reg [4:0] RD_WB,
                        output reg MemtoReg_WB,
                        output reg RegWrite_WB);
                        
    always@(posedge clk)begin
        if(reset)begin
            ALU_OUT_WB <= 0;
            MEMORY_OUT_WB <= 0;
            RD_WB <= 0;
            MemtoReg_WB <= 0;
            RegWrite_WB <= 0;
        end 
        else begin
            ALU_OUT_WB <= ALU_OUT_MEM;
            MEMORY_OUT_WB <= MEMORY_OUT_MEM;
            RD_WB <= RD_MEM;
            MemtoReg_WB <= MemtoReg_MEM;
            RegWrite_WB <= RegWrite_MEM;
        end
     end   
endmodule