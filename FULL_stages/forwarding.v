module forwarding(input [4:0] rs1,
                    input [4:0] rs2,
                    input [4:0] ex_mem_rd,
                    input [4:0] mem_wb_rd,
                    input ex_mem_regwrite,
                    input mem_wb_regwrite,
                    output reg [1:0] forwardA,forwardB);

    always@(rs1 or rs2 or ex_mem_rd or mem_wb_rd or ex_mem_regwrite or mem_wb_regwrite)begin
        if(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd == rs1))
            forwardA = 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 0) && (mem_wb_rd == rs1))
            forwardA=2'b01;
        else
            forwardA = 2'b00;

        if(ex_mem_regwrite && (ex_mem_rd != 0) && (ex_mem_rd == rs2))
            forwardB = 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 0) && (mem_wb_rd == rs2))
            forwardB=2'b01;
        else
            forwardB = 2'b00;

    end
endmodule
