module data_memory(input clk,
                    input mem_read,
                    input mem_write,
                    input [31:0] address,
                    input [31:0] write_data,
                    output reg [31:0] read_data);
    
    reg [31:0] dataMemory [0:1023];
    
    always@(*) begin
        if(mem_read)
            read_data <= dataMemory[address];
    end

    always@(posedge clk) begin
        if(mem_write)
            dataMemory[address] <= write_data;
    end

endmodule
