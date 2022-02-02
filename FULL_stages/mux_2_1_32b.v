module mux2_1_32b(ina,inb,sel,out);

    input [31:0] ina,inb;
    input sel;
    output reg [31:0] out;

    always@(*)begin
        case(sel)
            1'b0 : out <= ina;
            1'b1 : out <= inb;
        endcase
    end
endmodule