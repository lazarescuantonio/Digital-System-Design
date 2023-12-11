module r1
#(
   parameter D_SIZE = 32
)
(
// general
   input                   rst_n         , // active 0
   input                   clk           ,
// special
   input                   r2_pc_halt    ,
   input                   r2_pc_flush   ,
   input                   bubble        ,
   input             [6:0] opcode        ,
   input             [2:0] destination   ,
   input      [D_SIZE-1:0] operand_a     ,
   input      [D_SIZE-1:0] operand_b     ,
   output reg        [6:0] r1_opcode     ,
   output reg        [2:0] r1_destination,
   output reg [D_SIZE-1:0] r1_operand_a  ,
   output reg [D_SIZE-1:0] r1_operand_b
);


always@(posedge clk or negedge rst_n)
begin
   if(!rst_n)
   begin
      r1_opcode      <= 0; // NOP
      r1_destination <= 0;
      r1_operand_a   <= 0;
      r1_operand_b   <= 0;
   end
   else if(r2_pc_halt)
   begin
      r1_opcode      <= r1_opcode;
      r1_destination <= r1_destination;
      r1_operand_a   <= r1_operand_a;
      r1_operand_b   <= r1_operand_b;
   end
   else if(r2_pc_flush | bubble)
   begin
      r1_opcode      <= 0; // NOP
      r1_destination <= 0;
      r1_operand_a   <= 0;
      r1_operand_b   <= 0;
   end
   else
   begin
      r1_opcode      <= opcode;
      r1_destination <= destination;
      r1_operand_a   <= operand_a;
      r1_operand_b   <= operand_b;
   end
end


endmodule