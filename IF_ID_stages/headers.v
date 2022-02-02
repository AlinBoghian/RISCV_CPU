//////////////////////////////////////////MUX_2_1_MODULE/////////////////////////////////////////////////////
module mux2_1(input[31:0] ina,inb, input sel, 
              output [31:0] out);
   reg[31:0] outval;
   always@(*) begin
          case(sel)
               'b0 : outval <= ina;
               'b1 : outval <= inb;
          endcase
   end
   assign out = outval;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////PC_MODULE///////////////////////////////////////////////////////////////
module PC(input clk,res,write, 
          input [31:0] in, 
          output reg [31:0] out);
          
   always@(clk)begin
        if(res)
           out <= 32'b0;
        else if(write)
           out <= in;
   end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////INSTRUCTION_MEMORY/////////////////////////////////////////////////////
module instruction_memory(input [9:0] address, 
                          output reg[31:0] instruction);
  reg [31:0] codeMemory [0:1023];
  reg[7:0] index;
  initial begin
        $readmemb("code.mem", codeMemory);
  end
  always@(address)begin
    index = address[9:2];
    instruction = codeMemory[index];
  end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////ADDER_MODULE//////////////////////////////////////////////////////
module adder(input [31:0] ina,inb, 
             output reg[31:0] out);
      always@(*)
        out = ina + inb;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////IF//////////////////////////////////////////////////////////////
module IF (input clk,reset,PCSrc,PC_write, 
           input [31:0] PC_Branch, 
           output [31:0] PC_IF, INSTRUCTION_IF);
    wire [31:0] mux_out;
    wire[31:0] PC_ADDR;
    
          
    mux2_1 mux(PC_ADDR,PC_Branch,PCSrc,mux_out);
    PC pc(clk,reset,PC_write,mux_out,PC_IF);
    adder add(PC_IF,4,PC_ADDR);       
    instruction_memory in_mem(PC_IF[9:0],INSTRUCTION_IF);
       
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////REGISTER_FILE_MODULE///////////////////////////////////////////////////////
module registers(input clk,reg_write,
                 input [4:0] read_reg1,read_reg2,write_reg,
                 input [31:0] write_data,
                 output [31:0] read_data1,read_data2);
      
      reg[31:0] registers[31:0];
      reg[31:0] read1,read2;
      integer i;         
      initial begin
          for(i = 0; i < 32; i=i+1) begin
              registers[i] = i;
          end
      end
      
      always@(posedge clk) begin
            if(reg_write && (write_reg != 0))
               registers[write_reg] = write_data;
      end
      
      always@(read_reg1) begin
             read1 <= registers[read_reg1];
      end
      always@(read_reg2) begin 
             read2 <= registers[read_reg2];
      end
      
      assign read_data1 = read1;
      assign read_data2 = read2;             

endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////IMM_GEN_MODULE/////////////////////////////////////////////////////
module imm_gen(input [31:0] in,
               output reg [31:0] out);
       always@(*) begin
          case(in[6:0]) 
                 7'b1100011 : //branch instructions
                 begin 
                    out[31:12] <= in[31];
                    out[11] <= in[7];
                    out[10:5]  <= in[30:25];
                    out[4:1]   <= in[11:8];
                    out[0]     <= 0;               
                 end            
                 7'b0100011 : //sw
                 begin
                    out[31:11] <= in[31];
                    out[10:5]  <= in[30:25];
                    out[4:1]   <= in[11:8];
                    out[0]     <= in[7];        
                 end         
                 7'b0000011:   //I type
                 begin
                    out[31:11] <= in[31];
                    out[10:5]  <= in[30:25];
                    out[4:1]   <= in[24:21];
                    out[0]     <= in[20]; 
                 end
                 7'b0010011:
                 begin
                    out[31:11] <= in[31];
                    out[10:5]  <= in[30:25];
                    out[4:1]   <= in[24:21];
                    out[0]     <= in[20]; 
                 end
                 default : out <= 32'b0;
          endcase
       end
  
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////ID_MODULE////////////////////////////////////////////////////////
module ID(input clk,
          input [31:0] PC_ID,INSTRUCTION_ID,
          input RegWrite_WB,
          input [31:0] ALU_DATA_WB,
          input [4:0] RD_WB,
          output [31:0] IMM_ID,
          output [31:0] REG_DATA1_ID,REG_DATA2_ID,
          output [2:0] FUNCT3_ID,
          output [6:0] FUNCT7_ID,
          output [6:0] OPCODE_ID,
          output [4:0] RD_ID,
          output [4:0] RS1_ID,
          output [4:0] RS2_ID);
          
          
     assign OPCODE_ID = INSTRUCTION_ID[6:0];
     assign RD_ID = INSTRUCTION_ID[11:7];
     assign FUNCT3_ID = INSTRUCTION_ID[14:12];
     assign RS1_ID = INSTRUCTION_ID[19:15];
     assign RS2_ID = INSTRUCTION_ID[24:20];
     assign FUNCT7_ID = INSTRUCTION_ID[31:25];
     
     registers reg_file(clk, RegWrite_WB,
                RS1_ID, RS2_ID, RD_WB,
                ALU_DATA_WB, REG_DATA1_ID, REG_DATA2_ID);
     
     imm_gen imm(INSTRUCTION_ID,IMM_ID);           
 
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////PIPELINE_REG_MODULES///////////////////////////////////////////////////
module IF_ID_reg(input clk,reset,write,
                 input [31:0] pc_in,instruction_in,
                 output reg [31:0] pc_out,instruction_out);
                 
        always@(clk)begin
            if(reset)begin
                pc_out <= 32'b0;
                instruction_out <= 32'b0;
            end
            else if(write) begin
                 pc_out <= pc_in;
                 instruction_out <= instruction_in;
            end
         end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////RISC_V_IF_ID/////////////////////////////////////////////////////
module RISC_V_IF_ID(input clk,reset,
                    input IF_ID_write, PCSrc, PC_write,
                    input [31:0] PC_Branch,
                    input RegWrite_WB,
                    input [31:0] ALU_DATA_WB,
                    input [4:0] RD_WB,
                    output [31:0] PC_ID, INSTRUCTION_ID, IMM_ID, REG_DATA1_ID, REG_DATA2_ID,
                    output [2:0] FUNCT3_ID,
                    output [6:0] FUNCT7_ID, OPCODE_ID,
                    output [4:0] RD_ID, RS1_ID, RS2_ID);
      wire[31:0] PC_IF, INSTRUCTION_IF;
      
      IF fetch(clk,reset,PCSrc,PC_write,PC_Branch, 
             PC_IF, INSTRUCTION_IF);
         
      IF_ID_reg pipe_if_id(clk,reset,IF_ID_write,
                PC_IF,INSTRUCTION_IF,
                PC_ID,INSTRUCTION_ID);
                
      ID decode( clk,
          PC_ID,INSTRUCTION_ID,
          RegWrite_WB,
          ALU_DATA_WB,
          RD_WB,
          IMM_ID,
          REG_DATA1_ID,REG_DATA2_ID,
          FUNCT3_ID,
          FUNCT7_ID,
          OPCODE_ID,
          RD_ID,
          RS1_ID,
          RS2_ID);


endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
