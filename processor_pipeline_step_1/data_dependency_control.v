`include "defines.v"

module data_dependency_control
(
   input      [6:0] opcode        ,
   input      [2:0] source_1      ,
   input      [2:0] source_2      ,
   input      [2:0] r1_destination,
   input      [2:0] r2_destination,
   input            read          ,
   input            write_en      ,
   input            r2_write_en   ,
   output           bubble        ,
   output reg       forward1_r1   ,
   output reg       forward2_r1   ,
   output reg       forward1_r2   ,
   output reg       forward2_r2
);


//******************************************************************************
// bubble
//******************************************************************************
assign bubble = ((r1_destination == source_1) | (r1_destination == source_2)) & write_en & read;


//******************************************************************************
// forward1_r1
//******************************************************************************
always@(*)
begin
   forward1_r1 = 0;
   
   if((r1_destination == source_1) & write_en)
   begin
      casez(opcode[`OPCODE_CLASSIFICATION])
//       `INSTRUCTIONS_SPECIAL:
//       begin
//          case(opcode[`OPCODE_SPECIAL])
//             `NOP     :
//             `HALT    :
//          endcase
//       end
         
         `INSTRUCTIONS_ARITHMETIC:
         begin
            case(opcode[`OPCODE_ARITHMETIC])
               `ADD     ,
               `ADDF    ,
               `SUB     ,
               `SUBF    : forward1_r1 = 1'b1;
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
               `NXOR    : forward1_r1 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_SHIFT_ROTATE:
         begin
            case(opcode[`OPCODE_SHIFT_ROTATE])
               `SHIFTR  ,
               `SHIFTRA ,
               `SHIFTL  : forward1_r1 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_DATA_TRANSFER:
         begin
            case(opcode[`OPCODE_DATA_TRANSFER])
//             `LOAD    :
               `LOADC   ,
               `STORE   : forward1_r1 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_BRANCH_CONTROL:
         begin
            case(opcode[`OPCODE_BRANCH_CONTROL])
//             `JMP     :
//             `JMPR    :
               `JMPcond ,
               `JMPRcond: forward1_r1 = 1'b1;
            endcase
         end
      endcase
   end
end


//******************************************************************************
// forward2_r1
//******************************************************************************
always@(*)
begin
   forward2_r1 = 0;
   
   if((r1_destination == source_2) & write_en)
   begin
      casez(opcode[`OPCODE_CLASSIFICATION])
//       `INSTRUCTIONS_SPECIAL:
//       begin
//          case(opcode[`OPCODE_SPECIAL])
//             `NOP     :
//             `HALT    :
//          endcase
//       end
         
         `INSTRUCTIONS_ARITHMETIC:
         begin
            case(opcode[`OPCODE_ARITHMETIC])
               `ADD     ,
               `ADDF    ,
               `SUB     ,
               `SUBF    : forward2_r1 = 1'b1;
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
               `NXOR    : forward2_r1 = 1'b1;
            endcase
         end
         
//       `INSTRUCTIONS_SHIFT_ROTATE:
//       begin
//          case(opcode[`OPCODE_SHIFT_ROTATE])
//             `SHIFTR  :
//             `SHIFTRA :
//             `SHIFTL  :
//          endcase
//       end
         
         `INSTRUCTIONS_DATA_TRANSFER:
         begin
            case(opcode[`OPCODE_DATA_TRANSFER])
               `LOAD    : forward2_r1 = 1'b1;
//             `LOADC   :
               `STORE   : forward2_r1 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_BRANCH_CONTROL:
         begin
            case(opcode[`OPCODE_BRANCH_CONTROL])
               `JMP     : forward2_r1 = 1'b1;
//             `JMPR    :
               `JMPcond : forward2_r1 = 1'b1;
//             `JMPRcond:
          endcase
         end
      endcase
   end
end


//******************************************************************************
// forward1_r2
//******************************************************************************
always@(*)
begin
   forward1_r2 = 0;
   
   if((r2_destination == source_1) & r2_write_en)
   begin
      casez(opcode[`OPCODE_CLASSIFICATION])
//       `INSTRUCTIONS_SPECIAL:
//       begin
//          case(opcode[`OPCODE_SPECIAL])
//             `NOP     :
//             `HALT    :
//          endcase
//       end
         
         `INSTRUCTIONS_ARITHMETIC:
         begin
            case(opcode[`OPCODE_ARITHMETIC])
               `ADD     ,
               `ADDF    ,
               `SUB     ,
               `SUBF    : forward1_r2 = 1'b1;
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
               `NXOR    : forward1_r2 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_SHIFT_ROTATE:
         begin
            case(opcode[`OPCODE_SHIFT_ROTATE])
               `SHIFTR  ,
               `SHIFTRA ,
               `SHIFTL  : forward1_r2 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_DATA_TRANSFER:
         begin
            case(opcode[`OPCODE_DATA_TRANSFER])
//             `LOAD    :
               `LOADC   ,
               `STORE   : forward1_r2 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_BRANCH_CONTROL:
         begin
            case(opcode[`OPCODE_BRANCH_CONTROL])
//             `JMP     :
//             `JMPR    :
               `JMPcond ,
               `JMPRcond: forward1_r2 = 1'b1;
            endcase
         end
      endcase
   end
end


//******************************************************************************
// forward2_r2
//******************************************************************************
always@(*)
begin
   forward2_r2 = 0;
   
   if((r2_destination == source_2) & r2_write_en)
   begin
      casez(opcode[`OPCODE_CLASSIFICATION])
//       `INSTRUCTIONS_SPECIAL:
//       begin
//          case(opcode[`OPCODE_SPECIAL])
//             `NOP     :
//             `HALT    :
//          endcase
//       end
         
         `INSTRUCTIONS_ARITHMETIC:
         begin
            case(opcode[`OPCODE_ARITHMETIC])
               `ADD     ,
               `ADDF    ,
               `SUB     ,
               `SUBF    : forward2_r2 = 1'b1;
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
               `NXOR    : forward2_r2 = 1'b1;
            endcase
         end
         
//       `INSTRUCTIONS_SHIFT_ROTATE:
//       begin
//          case(opcode[`OPCODE_SHIFT_ROTATE])
//             `SHIFTR  :
//             `SHIFTRA :
//             `SHIFTL  :
//          endcase
//       end
         
         `INSTRUCTIONS_DATA_TRANSFER:
         begin
            case(opcode[`OPCODE_DATA_TRANSFER])
               `LOAD    : forward2_r2 = 1'b1;
//             `LOADC   :
               `STORE   : forward2_r2 = 1'b1;
            endcase
         end
         
         `INSTRUCTIONS_BRANCH_CONTROL:
         begin
            case(opcode[`OPCODE_BRANCH_CONTROL])
               `JMP     : forward2_r2 = 1'b1;
//             `JMPR    :
               `JMPcond : forward2_r2 = 1'b1;
//             `JMPRcond:
          endcase
         end
      endcase
   end
end


endmodule