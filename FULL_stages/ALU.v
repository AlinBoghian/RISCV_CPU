module ALU(input [3:0] ALUop,
            input [31:0] ina,inb,
            output zero,
            output reg [31:0] out);
    wire signed [31:0] signed_ina,signed_inb; 
    reg zero_reg;
    always@(ALUop,ina,inb) begin
        case (ALUop)
            4'b0010 : out <= ina + inb;   //addition
            4'b0110 : out <= ina - inb;   //substraction
            4'b0000 : out <= ina & inb;   //AND
            4'b0001 : out <= ina | inb;   //OR
            4'b0011 : out <= ina ^ inb;   //XOR
            4'b0101 : out <= ina >> inb;  // logical right shift
            4'b0100 : out <= ina << inb;  // logical left shit
            4'b1001 : out <= ina >>> inb; //arithmetic right shift
            4'b0111 : out <= (ina < inb) ? inb : ina; //unsigned set less then
            4'b1000 : out <= (signed_ina < signed_inb) ? inb : ina; //signed set less then
        endcase
        zero_reg = (out == 31'b0);
    end
    assign signed_ina = ina;
    assign signed_inb = inb;
    assign zero = zero_reg;
endmodule