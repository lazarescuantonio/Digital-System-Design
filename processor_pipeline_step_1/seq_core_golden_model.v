`include "defines.v"

module seq_core
#(
   parameter D_SIZE = 32,
   parameter A_SIZE = 10
)
(
   // general
   input                   rst_n      , // active 0
   input                   clk        ,
   // program memory
   output reg [A_SIZE-1:0] pc         ,
   input            [15:0] instruction,
   // data memory
   output reg              read       , // active 1
   output reg              write      , // active 1
   output     [A_SIZE-1:0] address    ,
   input      [D_SIZE-1:0] data_in    ,
   output     [D_SIZE-1:0] data_out
);


integer i;
reg  [D_SIZE-1:0] register[0:7]; // GENERAL PURPOSE REGISTERS
reg         [2:0] condition    ;
reg         [2:0] destination  ;
reg  [D_SIZE-1:0] operand1     ;
reg  [D_SIZE-1:0] operand2     ;
reg               pc_halt      ;
reg               pc_load      ;
reg               pc_loadr     ;
wire [A_SIZE-1:0] pc_target    ;
reg               write_en     ;
reg  [D_SIZE-1:0] result       ;
wire [D_SIZE-1:0] write_back   ;
reg               flag_N       ;
reg               flag_Z       ;


//******************************************************************************
// FETCH
//******************************************************************************


//------------------------------------------------------------------------------
// PROGRAM COUNTER
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if     (!rst_n  ) pc <= 0;
   else if(pc_halt ) pc <= pc;
   else if(pc_load ) pc <= pc_target;
   else if(pc_loadr) pc <= $signed(pc) + $signed(pc_target);
   else              pc <= pc + 1'b1;


//******************************************************************************
// READ
//******************************************************************************


//------------------------------------------------------------------------------
// DECODE
//------------------------------------------------------------------------------
always@(*)
begin
   condition   = 0;
   destination = 0;
   operand1    = 0;
   operand2    = 0;
   pc_halt     = 0;
   pc_load     = 0;
   pc_loadr    = 0;
   read        = 0;
   write       = 0;
   write_en    = 0;
   flag_N      = 0;
   flag_Z      = 0;
   
   casez(instruction[`OPCODE_CLASSIFICATION])
      `INSTRUCTIONS_SPECIAL:
      begin
         case(instruction[`OPCODE_SPECIAL])
//          `NOP     :
            `HALT    :  begin
                           pc_halt     = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_ARITHMETIC:
      begin
         case(instruction[`OPCODE_ARITHMETIC])
            `ADD     ,
            `ADDF    ,
            `SUB     ,
            `SUBF    :  begin
                           destination = instruction[8:6];
                           operand1    = register[instruction[5:3]];
                           operand2    = register[instruction[2:0]];
                           write_en    = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_LOGIC:
      begin
         case(instruction[`OPCODE_LOGIC])
            `AND     ,
            `OR      ,
            `XOR     ,
            `NAND    ,
            `NOR     ,
            `NXOR    :  begin
                           destination = instruction[8:6];
                           operand1    = register[instruction[5:3]];
                           operand2    = register[instruction[2:0]];
                           write_en    = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_SHIFT_ROTATE:
      begin
         case(instruction[`OPCODE_SHIFT_ROTATE])
            `SHIFTR  ,
            `SHIFTRA ,
            `SHIFTL  :  begin
                           destination = instruction[8:6];
                           operand1    = register[instruction[8:6]];
                           operand2    = instruction[5:0];
                           write_en    = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_DATA_TRANSFER:
      begin
         case(instruction[`OPCODE_DATA_TRANSFER])
            `LOAD    :  begin
                           destination = instruction[10:8];
                        // operand1    =
                           operand2    = register[instruction[2:0]];    // address
                           read        = 1'b1;
                           write_en    = 1'b1;
                        end
            `LOADC   :  begin
                           destination = instruction[10:8];
                           operand1    = register[instruction[10:8]];
                           operand2    = instruction[7:0];
                           write_en    = 1'b1;
                        end
            `STORE   :  begin
                        // destination =
                           operand1    = register[instruction[ 2:0]];   // data_out
                           operand2    = register[instruction[10:8]];   // address
                           write       = 1'b1;
                        end
         endcase
      end
      
      `INSTRUCTIONS_BRANCH_CONTROL:
      begin
         case(instruction[`OPCODE_BRANCH_CONTROL])
            `JMP     :  begin
                        // destination =
                        // operand1    =
                           operand2    = register[instruction[2:0]];
                           pc_load     = 1'b1;
                        end
            `JMPR    :  begin
                        // destination =
                        // operand1    =
                           operand2    = $signed(instruction[5:0]); // sign extension
                           pc_loadr    = 1'b1;
                        end
            `JMPcond :  begin
                           condition   = instruction[11:9];
                        // destination =
                           operand1    = register[instruction[8:6]];
                           operand2    = register[instruction[2:0]];
                           
                           flag_N      = operand1 <  0;
                           flag_Z      = operand1 == 0;
                           
                           pc_load     = (condition == `N ) ?  flag_N :
                                         (condition == `NN) ? ~flag_N :
                                         (condition == `Z ) ?  flag_Z :
                                         (condition == `NZ) ? ~flag_Z : 1'b0;
                        end
            `JMPRcond:  begin
                           condition   = instruction[11:9];
                        // destination =
                           operand1    = register[instruction[8:6]];
                           operand2    = $signed(instruction[5:0]); // sign extension
                           
                           flag_N      = operand1 <  0;
                           flag_Z      = operand1 == 0;
                           
                           pc_loadr    = (condition == `N ) ?  flag_N :
                                         (condition == `NN) ? ~flag_N :
                                         (condition == `Z ) ?  flag_Z :
                                         (condition == `NZ) ? ~flag_Z : 1'b0;
                        end
         endcase
      end
   endcase
end


//******************************************************************************
// EXECUTION
//******************************************************************************


//------------------------------------------------------------------------------
// ARITHMETIC LOGIC UNIT
//------------------------------------------------------------------------------
always@(*)
begin
   result = 0;
   
   casez(instruction[`OPCODE_CLASSIFICATION])
//    `INSTRUCTIONS_SPECIAL:
//    begin
//       case(instruction[`OPCODE_SPECIAL])
//          `NOP     :
//          `HALT    :
//       endcase
//    end
      
      `INSTRUCTIONS_ARITHMETIC:
      begin
         case(instruction[`OPCODE_ARITHMETIC])
            `ADD     : result = $signed(operand1) + $signed(operand2);
            `ADDF    : result = $signed(operand1) + $signed(operand2);
            `SUB     : result = $signed(operand1) - $signed(operand2);
            `SUBF    : result = $signed(operand1) - $signed(operand2);
         endcase
      end
      
      `INSTRUCTIONS_LOGIC:
      begin
         case(instruction[`OPCODE_LOGIC])
            `AND     : result =   operand1 & operand2;
            `OR      : result =   operand1 | operand2;
            `XOR     : result =   operand1 ^ operand2;
            `NAND    : result = ~(operand1 & operand2);
            `NOR     : result = ~(operand1 | operand2);
            `NXOR    : result = ~(operand1 ^ operand2);
         endcase
      end
      
      `INSTRUCTIONS_SHIFT_ROTATE:
      begin
         case(instruction[`OPCODE_SHIFT_ROTATE])
            `SHIFTR  : result = operand1 >>  operand2;
            `SHIFTRA : result = $signed(operand1) >>> $signed(operand2); // keep sign
            `SHIFTL  : result = operand1 <<  operand2;
         endcase
      end
      
      `INSTRUCTIONS_DATA_TRANSFER:
      begin
         case(instruction[`OPCODE_DATA_TRANSFER])
//          `LOAD    :
            `LOADC   : result = {operand1[D_SIZE-1:8], operand2[7:0]};
//          `STORE   :
         endcase
      end
      
//    `INSTRUCTIONS_BRANCH_CONTROL:
//    begin
//       case(instruction[`OPCODE_BRANCH_CONTROL])
//          `JMP     :
//          `JMPR    :
//          `JMPcond :
//          `JMPRcond:
//       endcase
//    end
   endcase
end


//******************************************************************************
// WRITE BACK
//******************************************************************************


assign pc_target  = operand2;
assign address    = operand2;
assign data_out   = operand1;
assign write_back = (read) ? data_in : result;


//------------------------------------------------------------------------------
// GENERAL PURPOSE REGISTERS
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if(!rst_n)
      for(i = 0; i <= 7; i = i + 1)
         register[i] <= 0;
   else if(write_en)
      register[destination] <= write_back;


endmodule