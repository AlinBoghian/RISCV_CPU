module mux2_1_1b(ina,inb,sel,out);

    input ina,inb;
    input sel;
    output reg out;

    always@(*)begin
        case(sel)
            1'b0 : out <= ina;
            1'b1 : out <= inb;
        endcase
    end
endmodule


