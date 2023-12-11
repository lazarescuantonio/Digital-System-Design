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
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   ADD     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // ADD
   //----------------------------------------------------------------------------------------------------------
   //   89AB_CDEF +
   //   FEDC_BA98
   //   ---------
   // 1_8888_8887
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0xFEDC_BA98
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hDC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h98           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8888_8887 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h87           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   ADD     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // ADDF
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 +
   // 7654_3210
   // ---------
   // 7777_7777
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   ADDF    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // ADDF
   //----------------------------------------------------------------------------------------------------------
   //   89AB_CDEF +
   //   FEDC_BA98
   //   ---------
   // 1_8888_8887
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0xFEDC_BA98
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hDC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h98           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8888_8887 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h87           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   ADDF    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
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
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8ACF_1357 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h8A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hCF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h13           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h57           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // SUB
   //----------------------------------------------------------------------------------------------------------
   // FEDC_BA98 -
   // 89AB_CDEF
   // ---------
   // 7530_ECA9
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0xFEDC_BA98
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hDC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h98           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7530_ECA9 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h75           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h30           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hEC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hA9           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // SUBF
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 -
   // 7654_3210
   // ---------
   // 8ACF_1357
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8ACF_1357 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h8A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hCF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h13           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h57           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SUBF    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // SUBF
   //----------------------------------------------------------------------------------------------------------
   // FEDC_BA98 -
   // 89AB_CDEF
   // ---------
   // 7530_ECA9
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0xFEDC_BA98
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hDC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h98           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7530_ECA9 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h75           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h30           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hEC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hA9           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SUBF    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
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
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0000_0000 = expected
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_32         };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   AND     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // AND
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 &
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // 0101_4545 = 0000_0001_0000_0001_0100_0101_0100_0101
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0101_4545 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   AND     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
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
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   OR      ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // OR
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 |
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // DDFF_DDFF = 1101_1101_1111_1111_1101_1101_1111_1111
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = DDFF_DDFF = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hDD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hDD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   OR      ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
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
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x7777_7777 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h77           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   XOR     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // XOR
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 ^
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // DCFE_98BA = 1101_1100_1111_1110_1001_1000_1011_1010
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = DCFE_98BA = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hDC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h98           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   XOR     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // NAND
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 &
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 0000_0000 = 0000_0000_0000_0000_0000_0000_0000_0000 ~
   // FFFF_FFFF = 1111_1111_1111_1111_1111_1111_1111_1111
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = FFFF_FFFF = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NAND    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // NAND
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 &
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // 0101_4545 = 0000_0001_0000_0001_0100_0101_0100_0101 ~
   // FEFE_BABA = 1111_1110_1111_1110_1011_1010_1011_1010
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0xFEFE_BABA = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFE           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hBA           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NAND    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // NOR
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 |
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 7777_7777 = 0111_0111_0111_0111_0111_0111_0111_0111 ~
   // 8888_8888 = 1000_1000_1000_1000_1000_1000_1000_1000
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8888_8888 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NOR     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // NOR
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 |
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // DDFF_DDFF = 1101_1101_1111_1111_1101_1101_1111_1111 ~
   // 2200_2200 = 0010_0010_0000_0000_0010_0010_0000_0000
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 2200_2200 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h22           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h22           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NOR     ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // NXOR
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 ^
   // 7654_3210 = 0111_0110_0101_0100_0011_0010_0001_0000
   // ---------   ---------------------------------------
   // 7777_7777 = 0111_0111_0111_0111_0111_0111_0111_0111 ~
   // 8888_8888 = 1000_1000_1000_1000_1000_1000_1000_1000
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x7654_3210
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h76           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h54           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h32           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x8888_8888 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h88           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NXOR    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // NXOR
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 ^
   // 5555_5555 = 0101_0101_0101_0101_0101_0101_0101_0101
   // ---------   ---------------------------------------
   // DCFE_98BA = 1101_1100_1111_1110_1001_1000_1011_1010 ~
   // 2301_6745 = 0010_0011_0000_0001_0110_0111_0100_0101
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R0   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x5555_5555
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R1   , 8'h55           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 2301_6789 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   NXOR    ,   R3   ,   R0   ,   R1   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTR
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 >> 5
   //           = XXXX_X000_0000_1001_0001_1010_0010_1011
   // 0009_1A2B = 0000_0000_0000_1001_0001_1010_0010_1011
   //----------------------------------------------------------------------------------------------------------
   
   // R0 = 0x0000_0000 (not used)
   dut.rom.memory[PC] = {   SHIFTL  ,   R0   , LEFT_32         };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R1 = 0x0000_0000 (not used)
   dut.rom.memory[PC] = {   SHIFTL  ,   R1   , LEFT_32         };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0009_1A2B = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h09           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h1A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h2B           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTR  ,   R3   , 6'd5            };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTR
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 >> 10
   //           = XXXX_XXXX_XX10_0010_0110_1010_1111_0011
   // 0022_6AF3 = 0000_0000_0010_0010_0110_1010_1111_0011
   //----------------------------------------------------------------------------------------------------------
   
   // R3 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0022_6AF3 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h22           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h6A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hF3           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTR  ,   R3   , 6'd10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTRA
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 >>> 5
   //           = XXXX_X000_0000_1001_0001_1010_0010_1011
   // 0009_1A2B = 0000_0000_0000_1001_0001_1010_0010_1011
   //----------------------------------------------------------------------------------------------------------
   
   // R3 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x0009_1A2B = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h09           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h1A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h2B           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTRA ,   R3   , 6'd5            };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTRA
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 >>> 10
   //           = XXXX_XXXX_XX10_0010_0110_1010_1111_0011
   // FFE2_6AF3 = 1111_1111_1110_0010_0110_1010_1111_0011
   //----------------------------------------------------------------------------------------------------------
   
   // R3 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0xFFE2_6AF3 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hFF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hE2           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h6A           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hF3           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTRA ,   R3   , 6'd10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //==========================================================================================================
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTL
   //----------------------------------------------------------------------------------------------------------
   // 0123_4567 = 0000_0001_0010_0011_0100_0101_0110_0111 << 5
   //           = 0010_0100_0110_1000_1010_1100_111X_XXXX
   // 2468_ACE0 = 0010_0100_0110_1000_1010_1100_1110_0000
   //----------------------------------------------------------------------------------------------------------
   
   // R3 = 0x0123_4567
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h01           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h23           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h45           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h67           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0x2468_ACE0 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h24           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h68           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hAC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hE0           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , 6'd5            };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   JMPR_Z  ,   R3   , SUCCESS_COUNT   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R5   ,   R5   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // error_count++
   dut.rom.memory[PC] = {   JMPR    ,          TEST_COUNT      };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   ADD     ,   R6   ,   R6   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // success_count++
   dut.rom.memory[PC] = {   ADD     ,   R7   ,   R7   ,   R2   };   PC = PC + 1'b1;   $display("PC = %0d", PC); // test_count++
   
   //----------------------------------------------------------------------------------------------------------
   // SHIFTL
   //----------------------------------------------------------------------------------------------------------
   // 89AB_CDEF = 1000_1001_1010_1011_1100_1101_1110_1111 << 10
   //           = 1010_1111_0011_0111_1011_11XX_XXXX_XXXX
   // AF37_BC00 = 1010_1111_0011_0111_1011_1100_0000_0000
   //----------------------------------------------------------------------------------------------------------
   
   // R3 = 0x89AB_CDEF
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'h89           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hAB           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hCD           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R3   , 8'hEF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R4 = 0xAF37_BC00 = expected
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hAF           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h37           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'hBC           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   SHIFTL  ,   R4   , LEFT_8          };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   dut.rom.memory[PC] = {   LOADC   ,   R4   , 8'h00           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // R3 = data
   dut.rom.memory[PC] = {   SHIFTL  ,   R3   , 6'd10           };   PC = PC + 1'b1;   $display("PC = %0d", PC);
   
   // check
   dut.rom.memory[PC] = {   SUB     ,   R3   ,   R3   ,   R4   };   PC = PC + 1'b1;   $display("PC = %0d", PC);
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