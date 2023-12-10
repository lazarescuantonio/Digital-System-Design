`include "defines.v"

module seq_core_execute
#(
   parameter D_SIZE = 32,
   parameter A_SIZE = 10
)
(
// general
// input                   rst_n         , // active 0
// input                   clk           ,
   // data memory
   output reg              read          , // active 1
   output reg              write         , // active 1
   output     [A_SIZE-1:0] address       ,
   output     [D_SIZE-1:0] data_out      ,
// special
   input             [6:0] r1_opcode     ,
// input             [2:0] r1_destination,
   input      [D_SIZE-1:0] r1_operand_a  ,
   input      [D_SIZE-1:0] r1_operand_b  ,
   output reg              pc_halt       ,
   output reg              pc_load       ,
   output reg              pc_loadr      ,
   output     [A_SIZE-1:0] pc_target     ,
   output reg              write_en      , // active 1
   output reg [D_SIZE-1:0] result
);


reg [2:0] condition;
reg       flag_N   ;
reg       flag_Z   ;


//------------------------------------------------------------------------------
// DECODE & EXECUTE (ARITHMETIC LOGIC UNIT)
//------------------------------------------------------------------------------
always@(*)
begin
   pc_halt     = 0;
   pc_load     = 0;
   pc_loadr    = 0;
   read        = 0;
   write       = 0;
   write_en    = 0;
   condition   = 0;
   flag_N      = 0;
   flag_Z      = 0;
   result      = 0;
   
   casez(r1_opcode[`OPCODE_CLASSIFICATION])
      `INSTRUCTIONS_SPECIAL:
      begin
         case(r1_opcode[`OPCODE_SPECIAL])
//          `NOP     :
            `HALT    :  begin
                           pc_halt   = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_ARITHMETIC:
      begin
         case(r1_opcode[`OPCODE_ARITHMETIC])
            `ADD     :  begin
                           result    = $signed(r1_operand_a) + $signed(r1_operand_b);
                           write_en  = 1'b1;
                        end
            `ADDF    :  begin
                           result    = $signed(r1_operand_a) + $signed(r1_operand_b);
                           write_en  = 1'b1;
                        end
            `SUB     :  begin
                           result    = $signed(r1_operand_a) - $signed(r1_operand_b);
                           write_en  = 1'b1;
                        end
            `SUBF    :  begin
                           result    = $signed(r1_operand_a) - $signed(r1_operand_b);
                           write_en  = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_LOGIC:
      begin
         case(r1_opcode[`OPCODE_LOGIC])
            `AND     :  begin
                           result    =   r1_operand_a & r1_operand_b;
                           write_en  = 1'b1;
                        end
            `OR      :  begin
                           result    =   r1_operand_a | r1_operand_b;
                           write_en  = 1'b1;
                        end
            `XOR     :  begin
                           result    =   r1_operand_a ^ r1_operand_b;
                           write_en  = 1'b1;
                        end
            `NAND    :  begin
                           result    = ~(r1_operand_a & r1_operand_b);
                           write_en  = 1'b1;
                        end
            `NOR     :  begin
                           result    = ~(r1_operand_a | r1_operand_b);
                           write_en  = 1'b1;
                        end
            `NXOR    :  begin
                           result    = ~(r1_operand_a ^ r1_operand_b);
                           write_en  = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_SHIFT_ROTATE:
      begin
         case(r1_opcode[`OPCODE_SHIFT_ROTATE])
            `SHIFTR  :  begin
                           result    = r1_operand_a >> r1_operand_b;
                           write_en  = 1'b1;
                        end
            `SHIFTRA :  begin
                           result    = $signed(r1_operand_a) >>> $signed(r1_operand_b); // keep sign
                           write_en  = 1'b1;
                        end
            `SHIFTL  :  begin
                           result    = r1_operand_a << r1_operand_b;
                           write_en  = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_DATA_TRANSFER:
      begin
         case(r1_opcode[`OPCODE_DATA_TRANSFER])
            `LOAD    :  begin
                           read      = 1'b1;
                           write_en  = 1'b1;
                        end
            `LOADC   :  begin
                           result    = {r1_operand_a[D_SIZE-1:8], r1_operand_b[7:0]};
                           write_en  = 1'b1;
                        end
            `STORE   :  begin
                           write     = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_BRANCH_CONTROL:
      begin
         case(r1_opcode[`OPCODE_BRANCH_CONTROL])
            `JMP     :  begin
                           pc_load   = 1'b1;
                        end
            `JMPR    :  begin
                           pc_loadr  = 1'b1;
                        end
            `JMPcond :  begin
                           condition = r1_opcode[2:0];
                           
                           flag_N    = r1_operand_a <  0;
                           flag_Z    = r1_operand_a == 0;
                           
                           pc_load   = (condition == `N ) ?  flag_N :
                                       (condition == `NN) ? ~flag_N :
                                       (condition == `Z ) ?  flag_Z :
                                       (condition == `NZ) ? ~flag_Z : 1'b0;
                        end
            `JMPRcond:  begin
                           condition = r1_opcode[2:0];
                           
                           flag_N    = r1_operand_a <  0;
                           flag_Z    = r1_operand_a == 0;
                           
                           pc_loadr  = (condition == `N ) ?  flag_N :
                                       (condition == `NN) ? ~flag_N :
                                       (condition == `Z ) ?  flag_Z :
                                       (condition == `NZ) ? ~flag_Z : 1'b0;
                        end
         endcase
      end
   endcase
end


assign address    = r1_operand_b;
assign data_out   = r1_operand_a;
assign pc_target  = r1_operand_b;


endmodule