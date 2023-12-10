module registers
#(
   parameter D_SIZE = 32
)
(
// general
   input               rst_n         , // active 0
   input               clk           ,
// special
   input               r2_write_en   , // active 1
   input         [2:0] r2_destination,
   input  [D_SIZE-1:0] write_back    ,
   input         [2:0] source_1      ,
   input         [2:0] source_2      ,
   output [D_SIZE-1:0] operand_1     ,
   output [D_SIZE-1:0] operand_2
);


integer i;
reg [D_SIZE-1:0] registers[0:7]; // GENERAL PURPOSE REGISTERS


always@(posedge clk or negedge rst_n)
   if(!rst_n)
      for(i = 0; i <= 7; i = i + 1)
         registers[i] <= 0;
   else if(r2_write_en)
      registers[r2_destination] <= write_back;


assign operand_1 = registers[source_1];
assign operand_2 = registers[source_2];


endmodule