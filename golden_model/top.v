`include "defines.v"

module top
(
   input rst_n,
   input clk
);


wire [`A_SIZE-1:0] pc           ;
wire        [15:0] instruction  ;
wire               read         ;
wire               write        ;
wire [`A_SIZE-1:0] address      ;
wire [`D_SIZE-1:0] sram_data_in ;
wire [`D_SIZE-1:0] sram_data_out;


rom
#(
   .A_SIZE     (`A_SIZE      )
) rom
(
   .pc         (pc           ),
   .instruction(instruction  )
);


seq_core
#(
   .D_SIZE     (`D_SIZE      ),
   .A_SIZE     (`A_SIZE      )
) seq_core
(
   .rst_n      (rst_n        ),
   .clk        (clk          ),
   .pc         (pc           ),
   .instruction(instruction  ),
   .read       (read         ),
   .write      (write        ),
   .address    (address      ),
   .data_in    (sram_data_out),
   .data_out   (sram_data_in )
);


sram
#(
   .D_SIZE     (`D_SIZE      ),
   .A_SIZE     (`A_SIZE      )
) sram
(
   .rst_n      (rst_n        ),
   .clk        (clk          ),
   .read       (read         ),
   .write      (write        ),
   .address    (address      ),
   .data_in    (sram_data_in ),
   .data_out   (sram_data_out)
);


endmodule