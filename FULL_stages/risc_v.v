//////////////////////////////////////////////RISC-V_MODULE///////////////////////////////////////////////////
module RISC_V(input clk,reset,
              
              output [31:0] PC_EX,
              output [31:0] ALU_OUT_EX,
              output [31:0] PC_MEM,
              output PCSrc,
              output [31:0] DATA_MEMORY_MEM,
              output [31:0] ALU_DATA_WB,
              output [1:0] forwardA,forwardB,
              output pipeline_stall);
              
  //////////////////////////////////////////IF signals////////////////////////////////////////////////////////
  wire [31:0] PC_IF;               //current PC
  wire [31:0] INSTRUCTION_IF;
  wire PC_write;
  wire [31:0] PC_Branch;
  wire IF_ID_write;
  wire [4:0] RS1_ID,RS2_ID,RD_ID,RD_EX;
  wire control_sel;
  wire MemRead_ID_updated;
  reg zero_reg;
  
  wire [4:0] RD_WB_ext;
  initial
    zero_reg = 0;
 assign PC_Branch = ALU_OUT_EX;  
 
 /////////////////////////////////////IF Module/////////////////////////////////////
 IF instruction_fetch(clk, reset, 
                      PCSrc, PC_write,
                      PC_Branch,
                      PC_IF,INSTRUCTION_IF);
  
  
 //////////////////////////////////////pipeline registers////////////////////////////////////////////////////
 IF_ID_reg IF_ID_REGISTER(clk,reset,
                          IF_ID_write,
                          PC_IF,INSTRUCTION_IF,
                          PC_ID,INSTRUCTION_ID);
  
  
 ////////////////////////////////////////ID Module//////////////////////////////////
 ID instruction_decode(clk,
                       PC_ID,INSTRUCTION_ID,
                       RegWrite_WB, 
                       ALU_DATA_WB,
                       RD_WB,
                       IMM_ID,
                       REG_DATA1_ID,REG_DATA2_ID,
                       RegWrite_ID,MemtoReg_ID,MemRead_ID,MemWrite_ID,
                       ALUop_ID,
                       ALUSrc_ID,
                       Branch_ID,
                       RS1_ID,
                       RS2_ID,
                       RD_ID);
                       
                       
 mux2_1_1b mux2_1MemRead_ID(MemRead_ID,zero_reg,control_sel,MemRead_ID_updated);                     
                        
ID_EX_reg ID_EX_REGISTER(clk,reset,
                IMM_ID,REG_DATA1_ID,REG_DATA2_ID,PC_ID,
                FUNCT3_ID,FUNCT7_ID,RD_ID,RS1_ID,RS2_ID,
                RegWrite_ID,MemtoReg_ID,MemRead_ID_updated,MemWrite_ID,
                ALUop_ID,ALUSrc_ID,Branch_ID,
                
                IMM_EX,REG_DATA1_EX,REG_DATA2_EX,PC_EX,
                FUNCT3_EX,FUNCT7_EX,RD_EX,RS1_EX,RS2_EX,
                RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX,
                ALUop_EX,ALUSrc_EX,Branch_EX);
                
EX execute(IMM_EX,REG_DATA1_EX,REG_DATA2_EX,PC_EX,
                FUNCT3_EX,FUNCT7_EX,RD_EX,RS1_EX,RS2_EX,
                RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX,
                ALUop_EX,ALUSrc_EX,Branch_EX,
                forwardA,forwardB,
                ALU_DATA_WB,
                ALU_OUT_MEM,
                ZERO_EX,
                ALU_OUT_EX,
                PC_EX,
                REG_DATA2_EX_FINAL);
                
 hazard_detection hazardunit(RD_EX,RS1_ID,RS2_ID,MemRead_EX,PC_write,IF_ID_write,control_sel);               
                
 forwarding forwardunit(RS1_EX,RS2_EX,
                        RD_MEM,RD_WB,
                        RegWrite_EX,RegWrite_WB,
                        forwardA,forwardB);
 
 EX_MEM_reg EX_MEM_REGISTER(clk,reset,
                            MemRead_EX,
                            MemWrite_EX,
                            RegWrite_EX,
                            MemtoReg_EX,
                            RD_EX,
                            ALU_OUT_EX,
                            REG2_DATA_EX,
                            MemRead_MEM,
                            MemWrite_MEM,
                            RegWrite_MEM,
                            MemtoReg_MEM,
                            RD_MEM,
                            ALU_OUT_MEM,
                            REG2_DATA_MEM);
                            
data_memory data_mem(clk,MemRead_EX,MemWrite_MEM,
                     ALU_OUT_MEM,REG2_DATA_EX,MEMORY_OUT_MEM);   
                                                                             
MEM_WB_reg MEM_WB_REGISTER(clk,reset,
                            ALU_OUT_MEM,MEMORY_OUT_MEM,RD_MEM,MemtoReg_MEM,RegWrite_MEM,
                            ALU_OUT_WB,MEMORY_OUT_WB,RD_WB,MemtoReg_WB,RegWrite_WB); 
                            
mux2_1_32b update_wb_mux(MEMORY_OUT_WB,ALU_OUT_WB,MemtoReg_WB,ALU_DATA_WB);                                           

               
endmodule      
