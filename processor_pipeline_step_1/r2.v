module r2
#(
   parameter D_SIZE = 32,
   parameter A_SIZE = 10
)
(
// general
   input                   rst_n         , // active 0
   input                   clk           ,
// special
// input                   r2_pc_halt    ,
   input                   r2_pc_flush   ,
   input             [2:0] r1_destination,
   input                   pc_halt       ,
   input                   pc_load       ,
   input                   pc_loadr      ,
   input      [A_SIZE-1:0] pc_target     ,
   input                   read          ,
   input                   write_en      ,
   input      [D_SIZE-1:0] result        ,
   output reg        [2:0] r2_destination,
   output reg              r2_pc_halt    ,
   output reg              r2_pc_load    ,
   output reg              r2_pc_loadr   ,
   output reg [A_SIZE-1:0] r2_pc_target  ,
   output reg              r2_read       ,
   output reg              r2_write_en   ,
   output reg [D_SIZE-1:0] r2_result
);


always@(posedge clk or negedge rst_n)
begin
   if(!rst_n)
   begin
      r2_destination <= 0;
      r2_pc_halt     <= 0;
      r2_pc_load     <= 0;
      r2_pc_loadr    <= 0;
      r2_pc_target   <= 0;
      r2_read        <= 0;
      r2_write_en    <= 0;
      r2_result      <= 0;
   end
   else if(r2_pc_halt)
   begin
      r2_destination <= r2_destination;
      r2_pc_halt     <= r2_pc_halt;
      r2_pc_load     <= r2_pc_load;
      r2_pc_loadr    <= r2_pc_loadr;
      r2_pc_target   <= r2_pc_target;
      r2_read        <= r2_read;
      r2_write_en    <= r2_write_en;
      r2_result      <= r2_result;
   end
   else if(r2_pc_flush)
   begin
      r2_destination <= 0;
      r2_pc_halt     <= 0;
      r2_pc_load     <= 0;
      r2_pc_loadr    <= 0;
      r2_pc_target   <= 0;
      r2_read        <= 0;
      r2_write_en    <= 0;
      r2_result      <= 0;
   end
   else
   begin
      r2_destination <= r1_destination;
      r2_pc_halt     <= pc_halt;
      r2_pc_load     <= pc_load;
      r2_pc_loadr    <= pc_loadr;
      r2_pc_target   <= pc_target;
      r2_read        <= read;
      r2_write_en    <= write_en;
      r2_result      <= result;
   end
end


endmodule