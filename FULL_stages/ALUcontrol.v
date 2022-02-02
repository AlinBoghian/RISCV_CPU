`timescale 1ns / 1ps


module ALUcontrol(input[1:0] ALUop,
                    input[6:0] funct7,
                    input[2:0] funct3,
                    output[3:0] ALUinput);

   reg[3:0] alu_input;
   always@(ALUop) begin
        casex({ALUop,funct7,funct3})
            {2'b00,{10{1'bx}}}        : alu_input <= 4'b0010; // load/store
            {2'b01,{7{1'bx}},3'b000}  : alu_input <= 4'b0110; // beq
            {2'b01,{7{1'bx}},3'b001}  : alu_input <= 4'b0110; // bneq
            {2'b01,{7{1'bx}},3'b100}  : alu_input <= 4'b1000; // blt
            {2'b01,{7{1'bx}},3'b101}  : alu_input <= 4'b1000; // bge
            {2'b01,{7{1'bx}},3'b110}  : alu_input <= 4'b0111; // bltu
            {2'b10,7'b0,3'b000}       : alu_input <= 4'b0010; // add
            {2'b10,7'b0100000,3'b000} : alu_input <= 4'b0110; // sub
            {2'b10,7'b0,3'b111}       : alu_input <= 4'b0000; // and
            {2'b10,7'b0,3'b110}       : alu_input <= 4'b0001; // or
            {2'b10,7'b0,3'b100}       : alu_input <= 4'b0011; // xor
            {2'b10,7'b0,3'b101}       : alu_input <= 4'b0101; // srl
            {2'b10,7'b0,3'b001}       : alu_input <= 4'b0100; // sll
            {2'b10,7'b0100000,3'b101} : alu_input <= 4'b1001; // sra
            {2'b10,7'b0,3'b011}       : alu_input <= 4'b0111; // sltu
            {2'b10,7'b0,3'b010}       : alu_input <= 4'b1000; // slt
            {2'b10,7'b0,3'b101}       : alu_input <= 4'b0101; // srli
            {2'b10,7'b0,3'b001}       : alu_input <= 4'b0100; // slli
            {2'b10,7'b0100000,3'b101} : alu_input <= 4'b1001; // srai

        endcase
   end
   assign ALUinput = alu_input;
    
endmodule
