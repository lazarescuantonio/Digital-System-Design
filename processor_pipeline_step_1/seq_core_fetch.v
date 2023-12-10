module seq_core_fetch
#(
   parameter A_SIZE = 10
)
(
// general
   input                   rst_n       , // active 0
   input                   clk         ,
// program memory
   output reg [A_SIZE-1:0] pc          ,
   input            [15:0] instruction ,
// special
   input                   r2_pc_halt  ,
   input                   r2_pc_load  ,
   input                   r2_pc_loadr ,
   input      [A_SIZE-1:0] r2_pc_target,
   input                   r2_pc_flush ,
   output reg       [15:0] ir
);


//------------------------------------------------------------------------------
// PROGRAM COUNTER
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if     (!rst_n     ) pc <= 0;
   else if(r2_pc_halt ) pc <= pc;
   else if(r2_pc_load ) pc <= r2_pc_target;
   else if(r2_pc_loadr) pc <= $signed(pc) + $signed(r2_pc_target);
   else                 pc <= pc + 1'b1;


//------------------------------------------------------------------------------
// INSTRUCTION REGISTER
//------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
   if     (!rst_n     ) ir <= 0;
   else if(r2_pc_halt ) ir <= ir;
   else if(r2_pc_flush) ir <= 0;
   else                 ir <= instruction;


endmodule