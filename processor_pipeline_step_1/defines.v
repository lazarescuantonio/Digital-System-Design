`timescale 1ns / 1ps

//******************************************************************************
// BIT SIZE BUSES
//******************************************************************************
`define D_SIZE                      32
`define A_SIZE                      10

//******************************************************************************
// OPCODE CLASSIFICATION
//******************************************************************************
`define OPCODE_CLASSIFICATION       6:3
`define INSTRUCTIONS_SPECIAL        4'b0000
`define INSTRUCTIONS_ARITHMETIC     4'b0001
`define INSTRUCTIONS_LOGIC          4'b0010
`define INSTRUCTIONS_SHIFT_ROTATE   4'b0011
`define INSTRUCTIONS_DATA_TRANSFER  4'b01ZZ
`define INSTRUCTIONS_BRANCH_CONTROL 4'b1ZZZ

`define OPCODE_SPECIAL              2:0
`define NOP                         0
`define HALT                        `NOP     + 1

`define OPCODE_ARITHMETIC           2:0
`define ADD                         0
`define ADDF                        `ADD     + 1
`define SUB                         `ADDF    + 1
`define SUBF                        `SUB     + 1

`define OPCODE_LOGIC                2:0
`define AND                         0
`define OR                          `AND     + 1
`define XOR                         `OR      + 1
`define NAND                        `XOR     + 1
`define NOR                         `NAND    + 1
`define NXOR                        `NOR     + 1

`define OPCODE_SHIFT_ROTATE         2:0
`define SHIFTR                      0
`define SHIFTRA                     `SHIFTR  + 1
`define SHIFTL                      `SHIFTRA + 1

`define OPCODE_DATA_TRANSFER        4:2
`define LOAD                        0
`define LOADC                       `LOAD    + 1
`define STORE                       `LOADC   + 1

`define OPCODE_BRANCH_CONTROL       5:3
`define JMP                         0
`define JMPcond                     `JMP     + 1
`define JMPR                        `JMPcond + 1
`define JMPRcond                    `JMPR    + 1

`define N                           0
`define NN                          `N       + 1
`define Z                           `NN      + 1
`define NZ                          `Z       + 1