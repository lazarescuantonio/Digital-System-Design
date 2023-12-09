module sram
#(
   parameter D_SIZE = 32,
   parameter A_SIZE = 10
)
(
   // general
   input               rst_n   , // active 0
   input               clk     ,
   // data memory
   input               read    , // active 1
   input               write   , // active 1
   input  [A_SIZE-1:0] address ,
   input  [D_SIZE-1:0] data_in ,
   output [D_SIZE-1:0] data_out
);


integer i;
reg [D_SIZE-1:0] memory[0:(1<<A_SIZE)-1];


always@(posedge clk or negedge rst_n)
   if(!rst_n)
      for(i = 0; i <= (1<<A_SIZE-1); i = i + 1)
         memory[i] <= 0;
   else if(write)
      memory[address] <= data_in;


assign data_out = (read) ? memory[address] : 0;


endmodule