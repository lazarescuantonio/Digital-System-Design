module tb();


`include "assembly.v"


reg rst_n, clk;
reg [9:0] PC;


top dut
(
   .rst_n(rst_n),
   .clk  (clk  )
);


initial
begin
   clk = 0;
   forever #5 clk = ~clk;
end


initial
begin
   rst_n = 0;
   @(posedge clk);
   #5 rst_n = 1;
   
   repeat(5000) @(posedge clk);
   
   $display("TEST    COUNT = %0d", dut.seq_core.registers.registers[7]);
   $display("SUCCESS COUNT = %0d", dut.seq_core.registers.registers[6]);
   $display("ERROR   COUNT = %0d", dut.seq_core.registers.registers[5]);
   $stop();
end


initial
begin
   // R7 = test_count
   // R6 = success_count
   // R5 = error_count
   // R4 = expected
   // R3 = data
   // R2 = used to increment counters
   
   PC = 0;
   dut.rom.memory[PC] = {   LOADC   ,   R2   , 8'd1            };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // ADD
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 +
   // 7654_3210
   // ---------
   // 7777_7777
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   ADD     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // SUB
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 -
   // 7654_3210
   // ---------
   // 8ACF_1357
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8ACF_1357 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h8A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hCF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h13           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h57           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // AND
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 &
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 0000_0000 = 0000_0000_0000_0000_0000_0000_0000_0000
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0000_0000 = expected
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_32         };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   AND     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // OR
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 |
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 7777_7777 = 0111_0111_0111_0111_0111_0111_0111_0111
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   OR      ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // XOR
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 ^
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 7777_7777 = 0111_0111_0111_0111_0111_0111_0111_0111
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   XOR     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   NOP                                };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // HALT
   //----------------------------------------------------------------------------------------------------------
   dut.rom.memory[PC] = {   HALT                               };   PC = PC + 1'b1;   $display("PC = %0d", PC);
end


endmodule