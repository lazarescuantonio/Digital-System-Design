`include "defines.v"

module seq_core
#(
   parameter D_SIZE = 32,
   parameter A_SIZE = 10
)
(
// general
   input               rst_n      , // active 0
   input               clk        ,
// program memory
   output [A_SIZE-1:0] pc         ,
   input        [15:0] instruction,
// data memory
   output              read       , // active 1
   output              write      , // active 1
   output [A_SIZE-1:0] address    ,
   input  [D_SIZE-1:0] data_in    ,
   output [D_SIZE-1:0] data_out
);


wire       [15:0] ir            ;
wire        [6:0] opcode        ;
wire        [2:0] destination   ;
wire        [2:0] source_1      ;
wire        [2:0] source_2      ;
wire [D_SIZE-1:0] operand_1     ;
wire [D_SIZE-1:0] operand_2     ;
wire [D_SIZE-1:0] operand_a     ;
wire [D_SIZE-1:0] operand_b     ;
wire        [6:0] r1_opcode     ;
wire        [2:0] r1_destination;
wire [D_SIZE-1:0] r1_operand_a  ;
wire [D_SIZE-1:0] r1_operand_b  ;
wire              pc_halt       ;
wire              pc_load       ;
wire              pc_loadr      ;
wire [A_SIZE-1:0] pc_target     ;
wire              write_en      ;
wire [D_SIZE-1:0] result        ;
wire        [2:0] r2_destination;
wire              r2_pc_halt    ;
wire              r2_pc_load    ;
wire              r2_pc_loadr   ;
wire [A_SIZE-1:0] r2_pc_target  ;
wire              r2_pc_flush   ;
wire              r2_read       ;
wire              r2_write_en   ;
wire [D_SIZE-1:0] r2_result     ;
wire [D_SIZE-1:0] write_back    ;


//******************************************************************************
// FETCH
//******************************************************************************
seq_core_fetch
#(
   .A_SIZE        (A_SIZE        )
) seq_core_fetch
(
   .rst_n         (rst_n         ),
   .clk           (clk           ),
   .pc            (pc            ),
   .instruction   (instruction   ),
   .r2_pc_halt    (r2_pc_halt    ),
   .r2_pc_load    (r2_pc_load    ),
   .r2_pc_loadr   (r2_pc_loadr   ),
   .r2_pc_target  (r2_pc_target  ),
   .r2_pc_flush   (r2_pc_flush   ),
   .ir            (ir            )
);


//******************************************************************************
// READ
//******************************************************************************
seq_core_read
#(
   .D_SIZE        (D_SIZE        )
) seq_core_read
(
// .rst_n         (rst_n         ),
// .clk           (clk           ),
   .ir            (ir            ),
   .opcode        (opcode        ),
   .destination   (destination   ),
   .source_1      (source_1      ),
   .source_2      (source_2      ),
   .operand_1     (operand_1     ),
   .operand_2     (operand_2     ),
   .operand_a     (operand_a     ),
   .operand_b     (operand_b     )
);


registers
#(
   .D_SIZE        (D_SIZE        )
) registers
(
   .rst_n         (rst_n         ),
   .clk           (clk           ),
   .r2_write_en   (r2_write_en   ),
   .r2_destination(r2_destination),
   .write_back    (write_back    ),
   .source_1      (source_1      ),
   .source_2      (source_2      ),
   .operand_1     (operand_1     ),
   .operand_2     (operand_2     )
);


//******************************************************************************
// PIPELINE REGISTER R1
//******************************************************************************
r1
#(
   .D_SIZE        (D_SIZE        )
) r1
(
   .rst_n         (rst_n         ),
   .clk           (clk           ),
   .r2_pc_halt    (r2_pc_halt    ),
   .r2_pc_flush   (r2_pc_flush   ),
   .opcode        (opcode        ),
   .destination   (destination   ),
   .operand_a     (operand_a     ),
   .operand_b     (operand_b     ),
   .r1_opcode     (r1_opcode     ),
   .r1_destination(r1_destination),
   .r1_operand_a  (r1_operand_a  ),
   .r1_operand_b  (r1_operand_b  )
);


//******************************************************************************
// EXECUTION
//******************************************************************************
seq_core_execute
#(
   .D_SIZE        (D_SIZE        ),
   .A_SIZE        (A_SIZE        )
) seq_core_execute
(
// .rst_n         (rst_n         ),
// .clk           (clk           ),
   .read          (read          ),
   .write         (write         ),
   .address       (address       ),
   .data_out      (data_out      ),
   .r1_opcode     (r1_opcode     ),
// .r1_destination(r1_destination),
   .r1_operand_a  (r1_operand_a  ),
   .r1_operand_b  (r1_operand_b  ),
   .pc_halt       (pc_halt       ),
   .pc_load       (pc_load       ),
   .pc_loadr      (pc_loadr      ),
   .pc_target     (pc_target     ), // FIXME (use result)
   .write_en      (write_en      ),
   .result        (result        )
);


//******************************************************************************
// PIPELINE REGISTER R2
//******************************************************************************
r2
#(
   .D_SIZE        (D_SIZE        ),
   .A_SIZE        (A_SIZE        )
) r2
(
   .rst_n         (rst_n         ),
   .clk           (clk           ),
// .r2_pc_halt    (r2_pc_halt    ),
   .r2_pc_flush   (r2_pc_flush   ),
   .r1_destination(r1_destination),
   .pc_halt       (pc_halt       ),
   .pc_load       (pc_load       ),
   .pc_loadr      (pc_loadr      ),
   .pc_target     (pc_target     ),
   .read          (read          ), // FIXME (output)
   .write_en      (write_en      ),
   .result        (result        ),
   .r2_destination(r2_destination),
   .r2_pc_halt    (r2_pc_halt    ),
   .r2_pc_load    (r2_pc_load    ),
   .r2_pc_loadr   (r2_pc_loadr   ),
   .r2_pc_target  (r2_pc_target  ),
   .r2_read       (r2_read       ),
   .r2_write_en   (r2_write_en   ),
   .r2_result     (r2_result     )
);


//******************************************************************************
// WRITE BACK
//******************************************************************************
seq_core_write_back
#(
   .D_SIZE        (D_SIZE        )
) seq_core_write_back
(
// .rst_n         (rst_n         ),
// .clk           (clk           ),
   .r2_read       (r2_read       ),
   .r2_write_en   (r2_write_en   ),
   .data_in       (data_in       ),
   .r2_result     (r2_result     ),
   .write_back    (write_back    ),
   .r2_pc_load    (r2_pc_load    ),
   .r2_pc_loadr   (r2_pc_loadr   ),
   .r2_pc_flush   (r2_pc_flush   )
);


endmodule