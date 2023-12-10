`include "defines.v"

module seq_core_read
#(
   parameter D_SIZE = 32
)
(
// general
// input                   rst_n      , // active 0
// input                   clk        ,
// special
   input            [15:0] ir         ,
   output reg        [6:0] opcode     ,
   output reg        [2:0] destination,
   output reg        [2:0] source_1   ,
   output reg        [2:0] source_2   ,
   input      [D_SIZE-1:0] operand_1  ,
   input      [D_SIZE-1:0] operand_2  ,
   output reg [D_SIZE-1:0] operand_a  ,
   output reg [D_SIZE-1:0] operand_b
);


reg [5:0] value   ;
reg [7:0] constant;
reg [5:0] offset  ;


//------------------------------------------------------------------------------
// DECODE & READ
//------------------------------------------------------------------------------
always@(*)
begin
   opcode      = ir[15:9];
   destination = 0;
   source_1    = 0;
   source_2    = 0;
   value       = 0;
   constant    = 0;
   offset      = 0;
   operand_a   = 0;
   operand_b   = 0;
   
   casez(opcode[`OPCODE_CLASSIFICATION])
//    `INSTRUCTIONS_SPECIAL:
//    begin
//       case(opcode[`OPCODE_SPECIAL])
//          `NOP     :
//          `HALT    :
//       endcase
//    end
      
      `INSTRUCTIONS_ARITHMETIC:
      begin
         case(opcode[`OPCODE_ARITHMETIC])
            `ADD     ,
            `ADDF    ,
            `SUB     ,
            `SUBF    :  begin
                           destination = ir[8:6];
                           source_1    = ir[5:3];
                           source_2    = ir[2:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = operand_2; // registers[source_2]
                        end
         endcase
      end
      
      `INSTRUCTIONS_LOGIC:
      begin
         case(opcode[`OPCODE_LOGIC])
            `AND     ,
            `OR      ,
            `XOR     ,
            `NAND    ,
            `NOR     ,
            `NXOR    :  begin
                           destination = ir[8:6];
                           source_1    = ir[5:3];
                           source_2    = ir[2:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = operand_2; // registers[source_2]
                        end
         endcase
      end
      
      `INSTRUCTIONS_SHIFT_ROTATE:
      begin
         case(opcode[`OPCODE_SHIFT_ROTATE])
            `SHIFTR  ,
            `SHIFTRA ,
            `SHIFTL  :  begin
                           destination = ir[8:6];
                           source_1    = ir[8:6];
                           value       = ir[5:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = value;
                        end
         endcase
      end
      
      `INSTRUCTIONS_DATA_TRANSFER:
      begin
         case(opcode[`OPCODE_DATA_TRANSFER])
            `LOAD    :  begin
                           destination = ir[10:8];
                           source_2    = ir[ 2:0];
                           
                           operand_b   = operand_2; // registers[source_2] --> address
                        end
            `LOADC   :  begin
                           destination = ir[10:8];
                           source_1    = ir[10:8];
                           constant    = ir[ 7:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = constant;
                        end
            `STORE   :  begin
                           source_1    = ir[ 2:0];
                           source_2    = ir[10:8];
                           
                           operand_a   = operand_1; // registers[source_1] --> data_out
                           operand_b   = operand_2; // registers[source_2] --> address
                        end
         endcase
      end
      
      `INSTRUCTIONS_BRANCH_CONTROL:
      begin
         case(opcode[`OPCODE_BRANCH_CONTROL])
            `JMP     :  begin
                           source_2    = ir[2:0];
                           
                           operand_b   = operand_2; // registers[source_2]
                        end
            `JMPR    :  begin
                           offset      = ir[5:0];
                           
                           operand_b   = $signed(offset);
                        end
            `JMPcond :  begin
                           source_1    = ir[8:6];
                           source_2    = ir[2:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = operand_2; // registers[source_2]
                        end
            `JMPRcond:  begin
                           source_1    = ir[8:6];
                           offset      = ir[5:0];
                           
                           operand_a   = operand_1; // registers[source_1]
                           operand_b   = $signed(offset);
                        end
         endcase
      end
   endcase
end


endmodule