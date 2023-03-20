`ifndef VORTEX_MEM_SLAVE_DEFINE
`define VORTEX_MEM_SLAVE_DEFINE

// size of register file (128 Kb -> 16 KB -> 16*2^10 B -> 2^14 B -> 0x4000 B worth of byte address space)
`define REG_FILE_BYTE_WIDTH 14
`define REG_FILE_BYTE_SIZE 2**REG_FILE_BYTE_WIDTH

`define WORD_SIZE 32

`endif