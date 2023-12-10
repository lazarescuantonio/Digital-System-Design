module seq_core_write_back
#(
   parameter D_SIZE = 32
)
(
// general
// input               rst_n      , // active 0
// input               clk        ,
// special
   input               r2_read    ,
   input               r2_write_en,
   input  [D_SIZE-1:0] data_in    ,
   input  [D_SIZE-1:0] r2_result  ,
   output [D_SIZE-1:0] write_back ,
   input               r2_pc_load ,
   input               r2_pc_loadr,
   output              r2_pc_flush
);


assign write_back = (r2_read    ) ? data_in   :
                    (r2_write_en) ? r2_result : 0;


assign r2_pc_flush = (r2_pc_load | r2_pc_loadr);


endmodule