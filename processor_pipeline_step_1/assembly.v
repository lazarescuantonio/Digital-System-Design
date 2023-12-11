`timescale 1ns / 1ps

//******************************************************************************
// MNEMONICS
//******************************************************************************
// INSTRUCTIONS_SPECIAL        =  4'b0000
parameter NOP                  = 16'b0000_0000_0000_0000;
parameter HALT                 = 16'b0000_0010_0000_0000;

// INSTRUCTIONS_ARITHMETIC     =  4'b0001
parameter ADD                  =  7'b0001_000;
parameter ADDF                 =  7'b0001_001;
parameter SUB                  =  7'b0001_010;
parameter SUBF                 =  7'b0001_011;

// INSTRUCTIONS_LOGIC          =  4'b0010
parameter AND                  =  7'b0010_000;
parameter OR                   =  7'b0010_001;
parameter XOR                  =  7'b0010_010;
parameter NAND                 =  7'b0010_011;
parameter NOR                  =  7'b0010_100;
parameter NXOR                 =  7'b0010_101;

// INSTRUCTIONS_SHIFT_ROTATE   =  4'b0011
parameter SHIFTR               =  7'b0011_000;
parameter SHIFTRA              =  7'b0011_001;
parameter SHIFTL               =  7'b0011_010;

// INSTRUCTIONS_DATA_TRANSFER  =  4'b01ZZ
parameter LOAD                 =  5'b0100_0;
parameter LOADC                =  5'b0100_1;
parameter STORE                =  5'b0101_0;

// INSTRUCTIONS_BRANCH_CONTROL =  4'b1ZZZ
parameter JMP                  =  4'b1000;
parameter JMPcond              =  4'b1001;
parameter JMP_N                =  7'b1001_000;
parameter JMP_NN               =  7'b1001_001;
parameter JMP_Z                =  7'b1001_010;
parameter JMP_NZ               =  7'b1001_011;
parameter JMPR                 =  4'b1010;
parameter JMPRcond             =  4'b1011;
parameter JMPR_N               =  7'b1011_000;
parameter JMPR_NN              =  7'b1011_001;
parameter JMPR_Z               =  7'b1011_010;
parameter JMPR_NZ              =  7'b1011_011;

parameter N                    =  3'b000;
parameter NN                   =  3'b001;
parameter Z                    =  3'b010;
parameter NZ                   =  3'b011;

parameter R0                   =  3'b000;
parameter R1                   =  3'b001;
parameter R2                   =  3'b010;
parameter R3                   =  3'b011;
parameter R4                   =  3'b100;
parameter R5                   =  3'b101;
parameter R6                   =  3'b110;
parameter R7                   =  3'b111;

parameter SUCCESS_COUNT        =  6'd0;
parameter TEST_COUNT           = {6'b0, 6'b11_1111}; //    -1   =>   00_0001   =>   11_1110 + 1   =>   11_1111

parameter JMP_LOAD             =  6'b11_1111;        //    -1   =>   00_0001   =>   11_1110 + 1   =>   11_1111
parameter JMP_STORE_AGAIN      = {6'b0, 6'b11_1000}; //    -8   =>   00_1000   =>   11_0111 + 1   =>   11_1000
parameter FINISH_LOAD          =  6'b11_1111;        //    -1   =>   00_0001   =>   11_1110 + 1   =>   11_1111
parameter JMP_LOAD_AGAIN       = {6'b0, 6'b11_0010}; //   -14   =>   00_1110   =>   11_0001 + 1   =>   11_0010


parameter LEFT_8               =  6'd8;
parameter LEFT_32              =  6'd32;