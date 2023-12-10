module rom
#(
   parameter A_SIZE = 10
)
(
// program memory
   input  [A_SIZE-1:0] pc         ,
   output       [15:0] instruction
);


reg [15:0] memory[0:(1<<A_SIZE)-1];


assign instruction = memory[pc];


endmodule